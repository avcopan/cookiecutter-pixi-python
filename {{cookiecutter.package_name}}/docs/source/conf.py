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
    "autodoc2"
]
templates_path = []
exclude_patterns = []

# 3. Options for HTML output
html_theme = "pydata_sphinx_theme"
html_static_path = []
html_theme_options = {
    "github_url": "https://github.com/{{cookiecutter.github_org_name}}/{{cookiecutter.package_name}}",
}

# 4. Configure extensions
myst_enable_extensions = [
    "colon_fence",
    "deflist",
    "fieldlist",
]

# 5. Autodoc2 configuration
autodoc2_packages = [
    "../../src/{{cookiecutter.package_name}}",
]