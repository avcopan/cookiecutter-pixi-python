# Pixi Python Cookiecutter

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Pixi Badge](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/prefix-dev/pixi/main/assets/badge/v0.json)](https://pixi.sh)
[![Code style: ruff](https://img.shields.io/badge/code%20style-ruff-000000.svg)](https://github.com/astral-sh/ruff)
[![Typing: ty](https://img.shields.io/badge/typing-ty-EFC621.svg)](https://github.com/astral-sh/ty)

A [cookiecutter](https://github.com/audreyr/cookiecutter) for setting up [Pixi](https://pixi.sh/) projects for pure Python development, based on [this project from @jevandezande](https://github.com/jevandezande/pixi-cookiecutter).
This is primarily for my own devlopment.
For those interested in something similar, I would recommend the cookiecutter from @jevandezande as a more user-friendly and customizable alternative.

## Features

- Packaging and release for Conda with [Pixi](https://prefix.dev/)
- Packaging and release for PyPI with [UV](https://docs.astral.sh/uv/)
- Formatting and linting with [Ruff](https://github.com/charliermarsh/ruff)
- Import linting with [Lint-Imports](https://import-linter.readthedocs.io/en/stable/)
- Static typing with [Ty](https://github.com/astral-sh/ty)
- Testing with [PyTest](https://docs.pytest.org/en/latest/)
- Code coverage with [PyTest-Cov](https://pytest-cov.readthedocs.io/en/latest/)
- Git hooks with [LeftHook](https://lefthook.dev/)
- Versioning and release triggering with [tbump](https://github.com/your-tools/tbump)
- Markdown-based documentation with [Sphinx](https://www.sphinx-doc.org/en/master/) and [MyST Markdown](https://mystmd.org/)
- Documentation hosting on [GitHub Pages](https://docs.github.com/en/pages)
- Auto-generatd API documentation with [Sphinx-Autodoc2](https://sphinx-autodoc2.readthedocs.io/en/latest/)
- Continuous integration with [GitHub Actions](https://github.com/features/actions), including:
    - Linting, formatting, testing, etc.
    - Deploying documentation site
    - Publishing Conda and PyPI packages
    - Creating releases


## Instructions

### Install

First, install Pixi using the command shown [here](https://pixi.prefix.dev/latest/installation/).
Then install Cookiecutter as follows.
```sh
pixi global install cookiecutter
```
Optionally, you can also install `direnv` to automatically load your environment for you.

### Setup

#### Create Local Repository

Use the following command to create a new project from this cookiecutter.
```sh
cookiecutter gh:avcopan/cookiecutter-pixi-python
```

#### Prepare Remote GitHub Repository

Follow [these instructions](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository) to create an empty remote repository on GitHub using the same package name as above.
Then complete the following configurations, which are needed by some of the GitHub Actions workflows.

**Documentation.**
To enable building and deploying your documentation site, navigate to navigate
to `Settings > Pages` on your GitHub repository site and set the `Source` for
your GitHub Pages deployment to "GitHub Actions".

**Conda publication.**
On [Anaconda.org](https://anaconda.org/), log in or set up an account,navigate to `Settings > Access`, and create an API token.
Save the API token somewhere secure, such as a password manager.
Then follow
[these instructions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets#creating-secrets-for-a-repository)
to add the API token as a secret on your GitHub repository, giving it the name
"ANACONDA_API_KEY".

**PyPI publication.**
On both [PyPI](https://pypi.org/) and [Test PyPI](https://test.pypi.org/), log in or set up an account, navigate to `Account settings` and scroll down to `API tokens` to add an API token for each.
Save each of these API tokens somewhere secure, such as a password manager.
Then follow
[these instructions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets#creating-secrets-for-a-repository)
to add the API token for Test PyPI as a secret on your GitHub repository, giving
it the name "UV_PUBLISH_TOKEN".
(For releases, you will replace this with your API token for the actual PyPI.)

#### Initialize Local Repository

You are now ready to initialize your local repository by running the following.
```sh
pixi run init
```
This will add your GitHub repository as a remote and push your project to it as
an initial commit.

Finally, navigate to your GitHub repository site and click the gear icon next to `About`.
Check the box under `Website` that says "Use your GitHub pages website".
This makes it easy to navigate to your documentation site from GitHub.


### Usage

#### Manage Run Dependencies

Run dependencies can be added or removed as follows.
```sh
pixi run add <dependencies...>
pixi run remove <dependencies...>
```
Under the hood, these tasks use UV to
[manage dependencies](https://docs.astral.sh/uv/guides/projects/#managing-dependencies)
in the
[`pyproject.toml` file]({{cookiecutter.package_name}}/pyproject.toml).
These dependencies are then
[mapped into Conda packages](https://pixi.prefix.dev/latest/build/backends/pixi-build-python/#automatic-pypi-dependency-mapping)
by Pixi.

#### Manage Dev Dependencies

Development dependencies can be added or removed from the Pixi `dev` environment as follows.
```sh
pixi add -f dev <development dependencies...>
pixi remove -f dev <development dependencies...>
```
You can also add tasks to the development environment as described
[here](https://pixi.prefix.dev/latest/workspace/advanced_tasks/).
These configurations go in the
[`pixi.toml` file]({{cookiecutter.package_name}}/pixi.toml).

#### Manage Local Dependencies

To test against live changes to one or more of your other packages that this
package depends on, you can add `# local:true/false` markers to your `pixi.toml`
file as follows.
```toml
package-name = "==0.0.8"  # local:false
# package-name = { path = "/path/to/repository" }  # local:true
```
You can then use the following to toggle between the published and local versions of these packages.
```sh
pixi run local start    # use local dependencies
pixi run local stop     # use published dependencies
```
To allow toggling back and forth without needing to repeatedly solve
dependencies, the lockfile and `.pixi/` folder are stashed as
`.pixi_local_true.lock` and `.pixi_local_true/` and reused.
Once you are satisfied with the changes, you must update the published version
of the dependency and bump the version in `pixi.toml` in order for the
pre-commit hooks to pass.
The first pre-commit hook below toggles off local dependencies to ensure that you are
testing against the published versions.

#### Run Pre-Commit Hooks

If you have initialized with `pixi run init`, the pre-commit hooks should run with every commit.
You can also run them directly as follows.
```sh
pixi run pre-commit         # run pre-commit hooks
pixi run local-pre-commit   # run pre-commit hooks with local dependencies
```
These pre-commit hooks are [configured and run](https://lefthook.dev/configuration/run.html) using LeftHook.

#### Configure Import Contracts

Import contracts are handled by Lint-Imports.
A basic
[module layering contract](https://import-linter.readthedocs.io/en/stable/contract_types/layers/#__tabbed_1_2)
is currently configured as a placeholder example.
This contract can be modified in `pyproject.toml`.
See [here](https://import-linter.readthedocs.io/en/stable/contract_types/) for other contract types.

#### Edit Documentation

The documentation can be built and locally previewed as follows.
```sh
pixi run docs-view
```
This site is built using Sphinx and MyST Markdown.
You can design your site by creating, removing, and editing `.md` files in
[`docs/source/`]({{cookiecutter.package_name}}/docs/source/) using Markdown syntax, and then updating the table
of contents in the
[`index.md` file]({{cookiecutter.package_name}}/docs/source/index.md) accordingly.
Reference API documentation is auto-generated by the
[Autodoc2
extension](https://sphinx-autodoc2.readthedocs.io/en/latest/quickstart.html),
which in this cookiecutter is specially configured to read docstrings in the
[NumPy format](https://numpydoc.readthedocs.io/en/latest/format.html#docstring-standard)
using the
[Napoleon](https://www.sphinx-doc.org/en/master/usage/extensions/napoleon.html)
parser.

#### Release New Versions

The following command shows the current version number.
```sh
pixi run version
```
Once you decide the appropriate next version number according to
[SemVer](https://semver.org/)
semantics, you can trigger a release by running this command.
```sh
pixi run release <new version number>
```
This creates a release commit tagged with the new version number and pushes both
the commit and the tag to GitHub.
When the tag is pushed, it triggers the
[release workflow]({{cookiecutter.package_name}}/.github/workflows/release.yml)
on GitHub Actions, which builds and publishes Conda and PyPI packages for your
project and posts the new release on GitHub.

#### Publish to PyPI

The
[release workflow]
is initially configured to publish to Test PyPI for testing purposes.
When you are ready to publish to the actual PyPI, you will need to edit the
[`release.yml` workflow file]({{cookiecutter.package_name}}/.github/workflows/release.yml)
as follows:
```sh
pixi run publish-pypi  #      <-- uncomment for actual release
# pixi run publish-test-pypi  <-- comment out for actual release
```
You will also need change the value of the "UV_PUBLISH_TOKEN" to your PyPI API token instead of your Test PyPI one.
See [these instructions](#prepare-remote-github-repository) above.


### Updating Against Cookiecutter Changes

The template generated from this cookiecutter is stored in a separate branch
named `template`, which is created upon initialization.

This is used to update against changes to this cookiecutter via the following command:
```sh
pixi run cookiecutter-update
```
This command executes the following sequence:

1. Switch to the `template` branch
2. Update the `template` branch by re-generating from the current cookiecutter
3. Switch back to the original branch
4. Cherry-pick the template update

If the cherry-pick completes without issues, it will automatically commit the change.
You may want to do a diff to check the reults.
```sh
git diff HEAD~1
```

If the cherry-pick results in merge conflicts, you can resolve them using the mergetool:
```sh
git mergetool
```
If you haven't already, you will need to first configure the merge tool you want
to use, for example `vimdiff`.
```sh
git config --global merge.tool vimdiff
```
If the changes are significant, you may also want to view them line-by-line as follows.
```sh
git restore --staged .
git add --patch
```
You can then complete the cherry-pick as follows.
```sh
git add --all
git cherry-pick --continue
```

### Using Pixi on an HPC Cluster

Home directories on an HPC cluster typically use a network filesystem, which can
make Pixi very slow.
This can be mitigated as follows.

1. In your your shell configuration file, `.bashrc`, set the `PIXI_CACHE_DIR`
environment variable to a faster global filesystem location, such as the global
scratch space.
```
export PIXI_CACHE_DIR=/scratch/$USER/pixi-cache
mkdir -p $PIXI_CACHE_DIR
```

2. In the project configuration file, `.pixi/config.toml`, use Pixi's
[detached-environments](https://pixi.prefix.dev/v0.39.0/reference/pixi_configuration/#detached-environments)
configuration to store your environment files on a faster filesystem.
```sh
mkdir -p .pixi
echo "detached-environments = \"/lscratch/$USER\"" >> .pixi/config.toml
```

If you are using local dependencies
[as described above](#manage-local-dependencies),
then, assuming you are starting from the `local:false` state, you will also want
to set this configuration in your `.pixi_local_true` directory.
```sh
mkdir -p .pixi_local_true
echo "detached-environments = \"/lscratch/$USER/local\"" >> .pixi_local_true/config.toml
```

## License

This project is licensed under the [MIT License](LICENSE).
