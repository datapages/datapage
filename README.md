# datapage

A datapage is a website for your data, showing users interactive visualizations, documentation, and the data itself. And whatever other content you want! [See the live example here](https://datapages.github.io/datapage/)

This repo contains a [Quarto](https://quarto.org/) extension that provides a custom Quarto project type and format, some handy Lua filters, and a GitHub action that automatically renders your datapage and publishes it on GitHub pages.

<img width="3024" height="2668" alt="datapages.github.io/datapage" src="https://github.com/user-attachments/assets/2dbd4760-5a95-49e9-9b6b-5802aeb48b09" />

## Getting started

### Step 1: Upload data

To make a datapage for your dataset, you'll need to first [create an account](https://redivis.com/) on Redivis, an online data platform for research.
An individual account is [free](https://redivis.com/pricing) and comes with 10 GB of storage.

Then upload your data to Redivis ([see here for more detailed guide](https://docs.redivis.com/guides/create-and-manage-datasets/create-and-populate-a-dataset)).

First create a new dataset from [your workspace](https://redivis.com/workspace/datasets):

<img width="800" alt="new dataset" src="https://github.com/user-attachments/assets/f7c48136-0948-4558-99c7-e224849c4917" />

Datapages show the full contents of your table, so set your dataset's public access level to "Data" so that your datapage can read it without authentication.

Then upload your tabular data to a new table:

<img width="800" alt="new table" src="https://github.com/user-attachments/assets/89fa06fc-6704-48b1-88f9-84bd4feabad3" />

### Step 2: Create repo

Create a GitHub repo for your datapage from this template repo: click on the "Use this template" button at the top of this page or just [go here](https://github.com/new?template_name=datapage&template_owner=datapages). Keep visibility set to public. This repo has a GPL copyleft license, which your repo will inherit.

<img width="800" alt="new repo" src="https://github.com/user-attachments/assets/71b9d158-4227-4d6f-94af-8000164c0502" />

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
