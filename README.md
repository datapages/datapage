# datapage

A datapage is a website for your data, showing users interactive visualizations, documentation, and the data itself. And whatever other content you want! [See the live example here](https://datapages.github.io/datapage/)

<img width="1711" alt="Screenshot 2024-05-10 at 16 32 28" src="https://github.com/datapages/datapage/assets/1414971/48279b22-571a-47d8-ab8d-2454e9a7e0b5">

This repo contains a [quarto](https://quarto.org/) extension that provides a custom quarto project type, format, and some handy lua filters, as well as a GitHub action that automatically renders your datapage and publishes it on GitHub pages.

## Getting started

To make a datapage for your dataset, first [put your dataset in Redivis](https://redivis.com/workspace/datasets) ([see here for more information on Redivis datasets](https://docs.redivis.com/guides/create-and-manage-datasets/create-and-populate-a-dataset)). Datapages show the full contents of your table, so set your dataset's public access level to "Data" so that your datapage can read it without authentication.
<img width="800" alt="0_redivis_dataset" src="https://github.com/datapages/datapage/assets/1414971/e5b98a9e-6ba3-4161-b67c-63ac3a15c89d">

Then make a GitHub repo for your datapage from this template repo. You can click on the "Use this template" button up top to create your repository.
<img width="800" alt="1_template_repo" src="https://github.com/datapages/datapage/assets/1414971/2860d5cb-5171-4225-8ebf-d14dccf5bb96">
<img width="800" alt="2_create_repo" src="https://github.com/datapages/datapage/assets/1414971/0660b9d8-da28-4d0c-9300-f808d5b5c5f2">

You also need to let GitHub Actions publish your site. Go into your repository's Settings > Pages and under "Build and deployment", set the Source to "GitHub Actions".

Now you can customize your datapage! In the `_quarto.yml` file, set your project title and your Redivis table information:
```
redivis:
  user: datapages
  dataset: palmerpenguins
  table: penguins
```

In `index.qmd`, edit the title, subtitle, description, and images for your homepage. In `about.qmd`, edit the images, links, and citation. The other pages update automatically.

### Non-public data

If your dataset isn't publicly accessible, your repo needs a Redivis API token to read it. Go into your Redivis account settings and [create a Redivis API token](https://redivis.com/workspace/settings/tokens) ([see here for more information](https://docs.redivis.com/api/rest-api/authorization)), checking the box for "Data" to give the token sufficient scope.
<img width="800" alt="1_redivis_token" src="https://github.com/datapages/datapage/assets/1414971/63ac1d12-6b4a-4318-9828-8c120627d794">

Then add the token as a repository secret: go into your repository's Settings > Secrets and variables > Actions, click on "New repository secret", and give it the name `REDIVIS_API_TOKEN`.
<img width="800" alt="4_add_secret" src="https://github.com/datapages/datapage/assets/1414971/9dd2abc0-336d-41c2-8b49-5e14ff46db2b">
<img width="800" alt="5_new_secret" src="https://github.com/datapages/datapage/assets/1414971/b36911f4-22c5-411f-8217-fac4e14ce8bd">

## Local developement

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
