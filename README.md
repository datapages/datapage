# datapage

A datapage is a website for your data, showing users interactive visualizations, documentation, and the data itself. And whatever other content you want!

This takes the form of a [quarto](https://quarto.org/) extension that provides a custom quarto project type and format.

## Getting started

To make a datapage for your dataset, first [put your dataset in Redivis](https://redivis.com/workspace/datasets) ([see here for more information on Redivis datasets](https://docs.redivis.com/guides/create-and-manage-datasets/create-and-populate-a-dataset)).
<img width="800" alt="0_redivis_dataset" src="https://github.com/datapages/datapage/assets/1414971/e5b98a9e-6ba3-4161-b67c-63ac3a15c89d">

You'll also need to go into your Redivis account settings and [create a Redivis API token](https://redivis.com/workspace/settings/tokens) ([see here for more information](https://apidocs.redivis.com/rest-api/authorization)).
<img width="800" alt="1_redivis_token" src="https://github.com/datapages/datapage/assets/1414971/9c898b1d-8c35-4300-9e8d-267e3c35d19f">

Then make a GitHub repo for your datapage from this template repo. You can click on the "Use this template" button up top to create your repository (and make sure you check "Include all branches" on the next screen).
<img width="800" alt="1_template_repo" src="https://github.com/datapages/datapage/assets/1414971/2860d5cb-5171-4225-8ebf-d14dccf5bb96">
<img width="800" alt="2_create_repo" src="https://github.com/datapages/datapage/assets/1414971/0660b9d8-da28-4d0c-9300-f808d5b5c5f2">

To link up your repo with Redivis, you need to provide add your Redivis API token as a repository secret. You can go into your repository's Settings > Secrets and variables > Actions and click on "New repository secret" and give it the name `REDIVIS_API_TOKEN`.
<img width="800" alt="4_add_secret" src="https://github.com/datapages/datapage/assets/1414971/9dd2abc0-336d-41c2-8b49-5e14ff46db2b">
<img width="800" alt="5_new_secret" src="https://github.com/datapages/datapage/assets/1414971/b36911f4-22c5-411f-8217-fac4e14ce8bd">

Now you can customize your datapage! In the `_quarto.yml` file, set your project title and your Redivis table information:
```
redivis:
  user: datapages
  dataset: palmerpenguins
  table: penguins
```

In `index.qmd`, edit the title, subtitle, and description for your homepage. In `about.qmd`, edit the images, links, and citation. The other pages update automatically.

## Local developement

For local development, create a file at the root of the repo called `.Renviron` with the contents (replacing `12345` accordingly):
```
REDIVIS_API_TOKEN=12345
```

For local development, run `quarto preview` to see the site output. Once you push to GitHub, a GitHub action automatically renders the site and deploys it to GitHub pages.
