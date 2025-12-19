# Introducing YAML

Our focus in this class will be configuring GitHub Actions to run your code, not how to write the code itself.

So, we won’t be covering how to use Python, JavaScript or another programming language to develop an automation tailored to a specific goal. Instead, we will show you broad patterns you can use to automate tasks within Actions, which you can adapt to fit the scripts you write in the programming language of your choice.

However, to work with Actions, you need to know one crucial tool that may be new to you: the YAML programming language.

[YAML](https://en.wikipedia.org/wiki/YAML) is a data structuring system designed to store information in a way that is easy for people to read and write. It stands for "YAML Ain't Markup Language" because it does not wrap data in tags like HTML or XML, a technique known as markup.

Programmers often choose YAML for configuration files and lightweight data storage. Here is a simple example of how it stores different types of data:

```yaml
# This is a comment

# This is a string
name: Alice

# This is an integer
age: 25

# This is a list
colors:
  - red
  - green
  - blue

# This is a nested object
address:
  street: 123 Main St.
  city: Anytown
  state: CA
  zip: 99999
```

In the case of Actions, YAML is used in the configuration files to tell the system what to do. These files are known as workflows. You can store them in a directory called `.github/workflows` at the root of GitHub code repositories with a .yml or .yaml file extension.

In the case of our example, the social media bot that posts new jobs at Reuters, [the Actions YAML file](https://github.com/palewire/reuters-jobs/blob/main/.github/workflows/etl.yaml) is as follows. Don't worry if you don't understand it yet. In our next chapter, we'll start with the basics and, gradually, you'll learn how to craft your own YAML files to harness the power of Actions and accomplish your goals.

```yaml
name: "Extract, transform and alert"

on:
  workflow_dispatch:
  schedule:
    - cron: "30 */6 * * *"

permissions:
  contents: write
  pages: write
  id-token: write

jobs:
  run:
    name: Run
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v6

      - id: setup-python
        name: Setup Python
        uses: actions/setup-python@v6
        with:
          python-version: '3.13'
          cache: 'pipenv'

      - name: Install pipenv
        run: curl https://raw.githubusercontent.com/pypa/pipenv/master/get-pipenv.py | python

      - name: Install Python dependencies
        run: |
          pipenv sync
          pipenv run shot-scraper install

      - name: Download
        run: make download

      - name: Transform
        run: make transform

      - name: Flag
        run: make flag

      - name: Start Flask server
        run: pipenv run python -m reutersjobs.app &

      - name: Screenshot
        run: pipenv run python -m reutersjobs.screenshot

      - name: Update RSS
        run: make rss

      - id: commit
        name: Commit
        run: |
          git config --global user.name "GitHub Actions"
          git config --global user.email "actions@github.com"
          git config pull.rebase false
          git pull origin $GITHUB_REF
          git add ./
          git commit -m "Added latest ETL" --author="palewire <palewire@users.noreply.github.com>" && git push || true
        shell: bash

      - name: Send toots
        run: make toot
        env:
          MASTODON_CLIENT_KEY: ${{ secrets.MASTODON_CLIENT_KEY }}
          MASTODON_CLIENT_SECRET: ${{ secrets.MASTODON_CLIENT_SECRET }}
          MASTODON_ACCESS_TOKEN: ${{ secrets.MASTODON_ACCESS_TOKEN }}

      - name: Setup Pages
        uses: actions/configure-pages@v5

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v4
        with:
          path: data

      - id: deployment
        name: Deploy to GitHub Pages
        uses: actions/deploy-pages@v4
```
