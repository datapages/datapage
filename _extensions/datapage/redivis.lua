local function isEmpty(s)
  return s == nil or s == ''
end

local function checkArg(kwargs, key, default)
  value = pandoc.utils.stringify(kwargs[key])
  if not isEmpty(value) then
    return value
  else
    return default
  end
end

local function makeURL(id, etype)
  return 'https://redivis.com/embed/' .. etype .. '/' .. id .. '#cells'
end

local function makeEmbed(id, etype, kwargs)
  local width = checkArg(kwargs, 'width', "100%")
  local height = checkArg(kwargs, 'height', 800)
  local url = makeURL(id, etype)
  
  return pandoc.RawBlock(
      'html',
      '<iframe width="' .. width .. '" height="' .. height .. '" allow="fullscreen" src="' .. url ..'"></iframe>'
    )
end

-- fetch a url, returning its contents or nil (with a warning) on failure
local function fetch(url)
  local ok, mime, contents = pcall(pandoc.mediabag.fetch, url)
  if ok then
    return contents
  else
    quarto.log.warning('Could not fetch ' .. url)
  end
end

-- dataset metadata from redivis and citation metadata for its DOI from
-- datacite, each fetched once per document
local dataset
local doi_cache = {}

local function getDataset(meta)
  if dataset == nil then
    dataset = {}
    local redivis = meta['redivis']
    if redivis and redivis['user'] and redivis['dataset'] then
      local ref = pandoc.utils.stringify(redivis['user']) .. '.' ..
        pandoc.utils.stringify(redivis['dataset'])
      local contents = fetch('https://redivis.com/api/v1/datasets/' .. ref)
      if contents then dataset = pandoc.json.decode(contents, false) end
    end
  end
  return dataset
end

local function getDOI(meta, format, query)
  if doi_cache[format] == nil then
    local doi = getDataset(meta).doi
    if doi and doi ~= pandoc.json.null then
      doi_cache[format] = fetch('https://data.crosscite.org/' .. format .. '/' .. doi .. (query or '')) or ''
    else
      doi_cache[format] = ''
    end
  end
  return doi_cache[format]
end

-- look up a field by path (e.g. "owner.fullName")
local function getField(data, path)
  local value = data
  for key in string.gmatch(path, '[^.]+') do
    if type(value) ~= 'table' then return nil end
    value = value[key]
  end
  return value
end

local function formatDate(ms)
  local secs = math.floor(ms / 1000)
  return os.date('%B ', secs) .. tonumber(os.date('%d', secs)) .. os.date(', %Y', secs)
end

-- format a field of the redivis dataset's metadata as pandoc elements
local function formatField(field, meta)
  -- citation metadata from datacite
  if field == 'citation' then
    local html = getDOI(meta, 'text/x-bibliography', '?style=apa')
    local citation = pandoc.utils.blocks_to_inlines(pandoc.read(html, 'html').blocks)
    -- make urls into links
    return citation:walk({
      Str = function(s)
        if s.text:match('^https?://') then return pandoc.Link(s.text, s.text) end
      end
    })
  elseif field == 'bibtex' then
    local bibtex = getDOI(meta, 'application/x-bibtex')
    if isEmpty(bibtex) then return pandoc.Inlines({}) end
    return pandoc.Blocks({pandoc.CodeBlock(bibtex, {class = 'bibtex'})})
  elseif field == 'license' then
    local csl = getDOI(meta, 'application/vnd.citationstyles.csl+json')
    if isEmpty(csl) then return pandoc.Inlines({}) end
    return pandoc.Str(pandoc.json.decode(csl, false).copyright or '')
  end

  -- metadata from redivis
  local value = getField(getDataset(meta), field)
  if value == nil or value == pandoc.json.null then
    return pandoc.Inlines({})
  elseif field == 'links' then
    -- list of {title, url}
    local items = pandoc.List()
    for _, link in ipairs(value) do
      local url = link.url:gsub('^%s+', ''):gsub('%s+$', '')
      items:insert(pandoc.Plain(pandoc.Link(link.title, url)))
    end
    return pandoc.Blocks({pandoc.BulletList(items)})
  elseif field == 'createdAt' or field == 'updatedAt' then
    return pandoc.Str(formatDate(value))
  elseif type(value) == 'string' and field:match('Markdown$') then
    return pandoc.read(value, 'markdown').blocks
  else
    return pandoc.Str(tostring(value))
  end
end

return {
  -- show a field of the redivis dataset's metadata, given as first argument
  ['redivis-dataset'] = function(args, kwargs, meta)
    return formatField(pandoc.utils.stringify(args[1]), meta)
  end,

  -- list the dataset metadata fields specified in yaml by field, label, and
  -- (bootstrap) icon, skipping any fields that are empty
  ['redivis-metadata'] = function(args, kwargs, meta)
    local items = pandoc.List()
    for _, entry in ipairs(meta['redivis-metadata'] or {}) do
      local field = pandoc.utils.stringify(entry.field)
      local value = formatField(field, meta)
      if pandoc.utils.type(value) == 'Blocks' then
        -- separate list items with commas
        value = value:walk({
          BulletList = function(list)
            local inlines = pandoc.Inlines({})
            for i, item in ipairs(list.content) do
              if i > 1 then inlines:extend({pandoc.Str(','), pandoc.Space()}) end
              inlines:extend(pandoc.utils.blocks_to_inlines(item))
            end
            return pandoc.Plain(inlines)
          end
        })
        value = pandoc.utils.blocks_to_inlines(value)
      else
        value = pandoc.Inlines(value)
      end
      if #value > 0 then
        -- link url and doi fields
        if field == 'url' then
          value = pandoc.Inlines({pandoc.Link(value, pandoc.utils.stringify(value))})
        elseif field == 'doi' then
          value = pandoc.Inlines({pandoc.Link(value, 'https://doi.org/' .. pandoc.utils.stringify(value))})
        end
        -- icon and label styled like about page links
        local label = pandoc.Inlines({})
        if entry.icon then
          label:insert(pandoc.RawInline('html', '<i class="bi bi-' .. pandoc.utils.stringify(entry.icon) .. '"></i>'))
        end
        if entry.label then
          if #label > 0 then label:insert(pandoc.Space()) end
          label:insert(pandoc.Str(pandoc.utils.stringify(entry.label)))
        end
        items:insert(pandoc.Plain({
          pandoc.Span(label, {class = 'redivis-metadata-label'}),
          pandoc.Span(value, {class = 'redivis-metadata-value'})
        }))
      end
    end
    if #items == 0 then return pandoc.Inlines({}) end
    return pandoc.Div(pandoc.BulletList(items), {class = 'redivis-metadata'})
  end,

  -- embed a redivis table, id given as first argument
  ['redivis-table'] = function(args, kwargs, meta)
    local embed_id
    if #args > 0 then
      embed_id = pandoc.utils.stringify(args[1])
      
    -- if no table given, default to redivis key in metadata
    else
      local redivis = meta['redivis']
      local user = pandoc.utils.stringify(redivis['user'])
      local ds
      if redivis['workflow'] then
        ds = pandoc.utils.stringify(redivis['workflow'])
      end
      if redivis['dataset'] then
        ds = pandoc.utils.stringify(redivis['dataset'])
      end
      local tbl = pandoc.utils.stringify(redivis['table'])
      embed_id = user .. '.' .. ds .. '.' .. tbl
    end
    return makeEmbed(embed_id, 'tables', kwargs)
  end
}
