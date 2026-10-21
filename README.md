# datapage

A datapage is a website for your data, showing users interactive visualizations, documentation, and the data itself. And whatever other content you want! [See the live example here](https://datapages.github.io/datapage/){target="_blank"}

<img width="1711" alt="Screenshot 2024-05-10 at 16 32 28" src="https://github.com/datapages/datapage/assets/1414971/48279b22-571a-47d8-ab8d-2454e9a7e0b5">

This repo contains a [Quarto](https://quarto.org/){target="_blank"} extension that provides a custom quarto project type, format, and some handy lua filters, as well as a GitHub action that automatically renders your datapage and publishes it on GitHub pages.

## Getting started

### Step 1: Upload data

To make a datapage for your dataset, you'll need to first [create an account](https://redivis.com/){target="_blank"} on Redivis, an online data platform for research.
An individual account is [free](https://redivis.com/pricing){target="_blank"} and comes with 10 GB of storage.

Then [create a new dataset on Redivis](https://redivis.com/workspace/datasets){target="_blank"} and upload your tabular data to a new table ([see here for more detailed guide](https://docs.redivis.com/guides/create-and-manage-datasets/create-and-populate-a-dataset){target="_blank"}).
Datapages show the full contents of your table, so set your dataset's public access level to "Data" so that your datapage can read it without authentication.

<img width="800" alt="0_redivis_dataset" src="https://github.com/datapages/datapage/assets/1414971/e5b98a9e-6ba3-4161-b67c-63ac3a15c89d">

### Step 2: Create repo

Then make a GitHub repo for your datapage from this template repo. You can click on the "Use this template" button up top to create your repository.
<img width="800" alt="1_template_repo" src="https://github.com/datapages/datapage/assets/1414971/2860d5cb-5171-4225-8ebf-d14dccf5bb96">

This repo has a GPL copyleft license, which your repo will inherit.

You also need to let GitHub Actions publish your site. Go into your repository's Settings > Pages and under "Build and deployment", set the Source to "GitHub Actions".

### Step 3: Customize

Now you can customize your datapage! In the `_quarto.yml` file, set your project title and your Redivis table information:

```
redivis:
  user: datapages
  dataset: palmerpenguins
  table: penguins
```

In `index.qmd`, edit the title, subtitle, description, and images for your homepage. In `about.qmd`, edit the images, links, and citation. The other pages update automatically.

The About page also lists metadata from your dataset on Redivis, set by the `redivis-metadata` key in `about.qmd` (see [Shortcodes](#shortcodes) below). To change this information, edit it on Redivis.

## Shortcodes

The datapage extension provides these shortcodes for use in any page:

- `{{< redivis-table >}}` embeds the Redivis table set in `_quarto.yml`. You can instead give a table as `user.dataset.table`, e.g. `{{< redivis-table datapages.palmerpenguins.penguins >}}`. Optionally set `width` (default `100%`) and `height` (default `800`).

- `{{< redivis-dataset field >}}` shows one field of the dataset's metadata, e.g. `{{< redivis-dataset doi >}}`. The field can be any field of the [dataset's metadata](https://docs.redivis.com/api/resource-definitions/dataset) (use dots for nested fields, e.g. `version.tag`), or `citation`, `bibtex`, or `license` from the dataset's DOI.

- `{{< redivis-metadata >}}` shows a list of dataset metadata fields, set by the page's `redivis-metadata` key. Each entry has a [Bootstrap icon](https://icons.getbootstrap.com/), a `label`, and a `field` as in `redivis-dataset`. Fields that aren't filled in on Redivis are left out.
  ```yaml
  redivis-metadata:
    - icon: archive
      label: DOI
      field: doi
  ```

## Data size

Note that the automatically created scatter plot can get slow if the data has a large number of rows. Up to about 100,000 rows it stays responsive on a laptop. To also work well on phones, aim for 30,000 rows or fewer.

The whole table is also embedded in the page, so wide tables are limited by total size. Keep it under about 1 million cells (rows × columns), which loads in about 2 seconds. If your data is too large, consider first aggregating or subsetting it.

## Local development

Clone your GitHub repo locally, then open the `datapage.Rproj` file in RStudio.

Run `renv::restore()` to install R package dependencies. Then run `quarto preview` to see the site output (if your dataset isn't public, you'll be prompted to log in to Redivis). Once you push to GitHub, a GitHub action automatically renders the site and deploys it to GitHub pages.

R packages are installed from a dated snapshot of CRAN (set in `renv.lock`), so the GitHub action can install prebuilt binaries of every package. To update packages, pick a new snapshot date and run:
```r
options(repos = c(
  CRAN = "https://packagemanager.posit.co/cran/YYYY-MM-DD",
  langcog = "https://langcog.r-universe.dev"
))
renv::update()
renv::snapshot()
```
