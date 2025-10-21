#!/usr/bin/env bash

set -Eeuo pipefail

if [ $# -ne 1 ]; then
        echo "Usage: $0 <url>"
        exit 1
fi

dirname=$(basename "$1" .git)
mkdir -p "${dirname}"
cd "${dirname}"

git clone --bare "$1" .bare
echo "gitdir: ./.bare" >.git
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git fetch
git for-each-ref --format='%(refname:short)' refs/heads | xargs -n1 -I{} git branch --set-upstream-to=origin/{} {}

git worktree add main
