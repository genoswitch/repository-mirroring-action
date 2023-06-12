#!/usr/bin/env sh
set -eu

# Git 2.30.23+ will not exec commands until the directory is "trusted"
# https://github.com/git/git/commit/8959555cee7ec045958f9b6dd62e541affb7e7d9
git config --global --add safe.directory $(pwd)

/setup-ssh.sh

export GIT_SSH_COMMAND="ssh -v -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -l $INPUT_SSH_USERNAME"
git remote add mirror "$INPUT_TARGET_REPO_URL"
git push --tags --force --prune mirror "refs/remotes/origin/*:refs/heads/*"

# NOTE: Since `post` execution is not supported for local action from './' for now, we need to
# run the command by hand.
/cleanup.sh mirror
