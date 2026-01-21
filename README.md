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
- Markdown-based documentation with [Sphinx](https://www.sphinx-doc.org/en/master/) and [MyST Markdown](https://mystmd.org/)
- Auto-generatd API documentation with [Sphinx-Autodoc2](https://sphinx-autodoc2.readthedocs.io/en/latest/)
- Continuous integration with [GitHub Actions](https://github.com/features/actions)


## Installation

First, install pixi using the command shown [here](https://pixi.prefix.dev/latest/installation/).
Then install cookiecutter as follows.
```sh
pixi global install cookiecutter
```
Optionally, you can install `direnv` to automatically load your environment for you.


## Usage

Use the following command to create a new project from this cookiecutter.
```sh
cookiecutter gh:avcopan/cookiecutter-pixi-python
```
Follow the prompts to setup your project.

Next, enter the project directory and run the pixi `init` task to initialize the Git repository and install your Git hooks.
```sh
cd <package-name>
pixi run init
```
Finally, create an empty repository on GitHub and add it as the remote for this one.
```sh
# 1. On GitHub: Create an empty repository called <package-name>
# 2. Copy the SSH address for your new repository
git remote add origin <ssh address>
```

## License

This project is licensed under the [MIT License](LICENSE).
