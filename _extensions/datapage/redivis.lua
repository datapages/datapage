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
  return 'https://redivis.com/embed/' .. etype .. '/' .. id
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

return {
  -- embed a redivis table, id given as first argument
  ['redivis-table'] = function(args, kwargs, meta)
    local embed_id = pandoc.utils.stringify(args[1])
    return makeEmbed(embed_id, 'tables', kwargs)
  end,
  
  -- embed all redivis elements specified in yaml by type and id
  ['redivis-embeds'] = function(args, kwargs, meta)
    local embeds = meta['embeds']
    local embedsOutput = pandoc.List()
    
    -- if no embeds in metadata, fall back to default redivis table
    if isEmpty(embeds) then
      embed_id = meta['redivis.id']
      if not isEmpty(embed_id) then
        local embed = makeEmbed(pandoc.utils.stringify(embed_id), 'tables', kwargs)
        embedsOutput:insert(embed)
      end
    
    else
      for key,value in pairs(embeds) do
        local embed_type = value.type
        
        -- default type to 'tables' if not specified
        if isEmpty(embed_type) then
          etype = 'tables'
        else
          etype = pandoc.utils.stringify(embed_type)
        end
        
        local embed_id = pandoc.utils.stringify(value.id)
        local embed = makeEmbed(embed_id, etype, kwargs)
        embedsOutput:insert(embed)
      end
    
    end
    return embedsOutput
  end
}
