# Sphinx configuration file.
from importlib import metadata

# 1. Project information
project = "{{cookiecutter.project_name}}"
copyright = "{% now 'utc', '%Y' %} {{cookiecutter.author_name}}"
author = "{{cookiecutter.author_name}}"
release = metadata.version("{{cookiecutter.package_name}}")

# 2. General configuration
extensions = [
    "myst_parser",
]
templates_path = []
exclude_patterns = []

# 3. Options for HTML output
html_theme = "pydata_sphinx_theme"
html_static_path = []