#!/usr/bin/env bash

set -e

# Set up remote repository
read -p "Set up a remove repository for {{cookiecutter.package_name}} GitHub, then press enter to continue."

DEFAULT_USERNAME=$(git config --global user.name)
read -p "  Git username (${DEFAULT_USERNAME} [default] or enter alternative): " INPUT
USERNAME=${INPUT:-$DEFAULT_USERNAME}
git remote add origin git@github.com:$USERNAME/{{cookiecutter.package_name}}.git
git push -u origin main
