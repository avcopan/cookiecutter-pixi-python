# Pixi Python Cookiecutter

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Pixi Badge](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/prefix-dev/pixi/main/assets/badge/v0.json)](https://pixi.sh)
[![Code style: ruff](https://img.shields.io/badge/code%20style-ruff-000000.svg)](https://github.com/astral-sh/ruff)
[![Typing: ty](https://img.shields.io/badge/typing-ty-EFC621.svg)](https://github.com/astral-sh/ty)

A [cookiecutter](https://github.com/audreyr/cookiecutter) for setting up [pixi](https://pixi.sh/) projects for pure python development, based on [this project from @jevandezande](https://github.com/jevandezande/pixi-cookiecutter).
This is primarily for my own devlopment.
For those interested in something similar, I would recommend the cookiecutter from @jevandezande as a more user-friendly and customizable alternative.

## Features

- Packaging with [pixi](https://prefix.dev/)
- Formatting and linting with [ruff](https://github.com/charliermarsh/ruff)
- Import linting with [lint-imports](https://import-linter.readthedocs.io/en/stable/)
- Static typing with [ty](https://github.com/astral-sh/ty)
- Testing with [pytest](https://docs.pytest.org/en/latest/)
- Code coverage with [codecov](https://docs.codecov.com/docs)
- Git hooks with [lefthook](https://lefthook.dev/)
- Versioning with [BumpVer](https://github.com/mbarkhau/bumpver)
- Markdown-based documentation with [Sphinx](https://www.sphinx-doc.org/en/master/) and [MyST Markdown](https://mystmd.org/)
- Documentation hosting on [GitHub Pages](https://docs.github.com/en/pages)
- Auto-generatd API documentation with [Sphinx-Autodoc2](https://sphinx-autodoc2.readthedocs.io/en/latest/)
- Continuous integration with [GitHub Actions](https://github.com/features/actions), including:
    - Linting, formatting, testing, etc.
    - Deploying documentation site
    - Creating releases


## Instructions

### Dependencies

First, install pixi using the command shown [here](https://pixi.prefix.dev/latest/installation/).
Then install cookiecutter as follows.
```sh
pixi global install cookiecutter
```
Optionally, you can install `direnv` to automatically load your environment for you.

### Setup

Use the following command to create a new project from this cookiecutter.
```sh
cookiecutter gh:avcopan/cookiecutter-pixi-python
```
Follow the prompts to setup your project.

Then follow these steps to finalize your setup.
1. On [GitHub](https://github.com/), click `New` or `+ > New repository` and create a new repository with the same package name used above, leaving everything else blank.
2. On the GitHub site for your remote repository, navigate to `Settings > Pages` and set the `Source` for your GitHub Pages deployment to "GitHub Actions".
3. On [CodeCov.io](https://about.codecov.io/), log in or set up an account, navigate to `Settings > Global Upload Token`, and select "Not required".
4. In your terminal, navigate into the local repository created by cookiecutter and run `pixi run init`.
5. Refresh the GitHub site for your remote repository, click `About`, and check the box to "Use your GitHub pages website" for the URL.

### Usage

Usage instructions...

## License

This project is licensed under the [MIT License](LICENSE).
