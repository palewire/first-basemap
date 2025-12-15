# Contributing

How to propose changes to this repository.

## Installation

Fork the repository and clone it:

```bash
gh repo clone your-name/first-basemap
```

Change into the project directory:

```bash
cd first-basemap
```

Install the dependencies using uv:

```bash
uv sync
```

## Contributing

To start a test server the previews the site, use the following command:

```bash
make serve
```

Once it starts, visit [localhost:8000](http://localhost:8000) in your browser. Edits made in the `docs/` folder will appear immediately. Commit your changes to a branch and then submit a pull request to the source repository.
