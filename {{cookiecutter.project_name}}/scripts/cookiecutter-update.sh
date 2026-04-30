#!/usr/bin/env bash

original_branch=$(git branch --show-current)

# Update the template branch from cookiecutter
git switch template
rm -rf ~/.cookiecutters/cookiecutter-pixi-python
cookiecutter gh:avcopan/cookiecutter-pixi-python --replay-file .template.json
rsync -av --remove-source-files {{cookiecutter.project_name}}/ ./
rm -r {{cookiecutter.project_name}}/
git add --all
git commit --no-verify -m "Update template"
git push origin template
commit_hash=$(git rev-parse --short HEAD)

# Update the current branch by cherry-picking the template update commit
git switch "$original_branch"
git cherry-pick "$commit_hash" -x
