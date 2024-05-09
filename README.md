# datapage

## Getting started

To make a datapage for your dataset, first [put your dataset in Redivis](https://docs.redivis.com/guides/create-and-manage-datasets/create-and-populate-a-dataset).

You'll also need create a [Redivis API token](https://apidocs.redivis.com/rest-api/authorization).

Then make a GitHub repo for your datapage from this template repo. You can click on the "Use this template" button up top to create your repository (and make sure you check "Include all branches" on the next screen). Alternatively, you can run (replacing `my-project-name` accordingly):
```
gh repo create my-project-name --template datapages/datapage --include-all-branches --public --clone
```

To link up your repo with Redivis, you need to provide your Redivis API token. For local development, create a file at the root of the repo called `.Renviron` with the contents (replacing `12345` accordingly):
```
REDIVIS_API_TOKEN=12345
```
For deployment on GitHub actions, add the token as a repository secret. You can go into your repository's Settings > Secrets and variables > Actions and click on "New repository secret". Alternatively, you can run:
```
gh secret set -f .Renviron
```

Now you can customize your datapage! In the `_quarto.yml` file, set your project title and your Redivis table information:
```
redivis:
  user: datapages
  dataset: palmerpenguins
  table: penguins
```

In `index.qmd`, edit the title, subtitle, and description for your homepage. In `about.qmd`, edit the images, links, and citation. The other pages update automatically.

For local development, run `quarto preview` to see the site output. Once you push to GitHub, a GitHub action automatically renders the site and deploys it to GitHub pages.
