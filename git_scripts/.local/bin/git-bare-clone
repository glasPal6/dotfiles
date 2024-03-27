#!/usr/bin/env bash
set -e

# Examples of call:
# git-clone-bare-for-worktrees git@github.com:name/repo.git
# => Clones to a /repo directory
#
# git-clone-bare-for-worktrees git@github.com:name/repo.git my-repo
# => Clones to a /my-repo directory

url=$1
basename=${url##*/}
name=${2:-${basename%.*}}

echo "-------------------------Making directory $name-------------------------"
mkdir $name
cd "$name"

# Moves all the administrative git files (a.k.a $GIT_DIR) under .bare directory.
#
# Plan is to create worktrees as siblings of this directory.
# Example targeted structure:
# .bare
# main
# new-awesome-feature
# hotfix-bug-12
# ...
echo "Cloning $url into .bare"
git clone --bare "$url" .bare

echo "-------------------------Setting up git config-------------------------"
echo "gitdir: ./.bare" > .git

# Explicitly sets the remote origin fetch so we can fetch remote branches
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

# Gets all branches from origin
git fetch origin

# Sets upstreams of git brashes with upstreams, which all of them since we are cloning the repo
# echo "-------------------------Setting up upstreams-------------------------"
# git for-each-ref --format='%(refname:short)' refs/heads | xargs -I{} git branch --set-upstream-to=origin/{}

# Make 'main' worktree
echo "-------------------------Creating main worktree-------------------------"
git worktree add main
git branch --set-upstream-to=origin/main
