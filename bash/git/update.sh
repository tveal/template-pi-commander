#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/../utils.sh

function main() {
  local trunk="main"
  setAliases

  test -f "$LAST_COMMIT_FILE" && cp "$LAST_COMMIT_FILE" "$PREV_COMMIT_FILE"

  # don't halt all update scripts if network breaks on git pull
  set +e
  pullLatestIfClean
  set -e

  echo "$(cd $THIS_DIR/../../ && git log --format="%H" -n 1)" > "$LAST_COMMIT_FILE"

  cleanGitIfChanged
}

function setAliases() {
  if [[ "$(git config -l)" != *"alias.co="* ]]; then
    git config --global alias.co checkout
  fi
  if [[ "$(git config -l)" != *"alias.br="* ]]; then
    git config --global alias.br branch
  fi
  if [[ "$(git config -l)" != *"alias.ci="* ]]; then
    git config --global alias.ci commit
  fi
  if [[ "$(git config -l)" != *"alias.st="* ]]; then
    git config --global alias.st status
  fi
}

function pullLatestIfClean() {
  local cwd="$(pwd)"
  cd "$THIS_DIR/../../"

  local activeBranch="$(git rev-parse --abbrev-ref HEAD)"
  local gitDiff="$(git status --porcelain)"
  if [ -z "$gitDiff" ]; then
    if [[ "$activeBranch" == "$trunk" ]]; then
      git pull origin "$trunk"
    else
      echo "WARN git not on trunk: $trunk, active: $activeBranch; skipping pull"
    fi
  else
    echo "WARN git diff not clean; skipping pull"
    git status --porcelain
  fi

  cd "$cwd"
}

function cleanGitIfChanged() {
  local cwd="$(pwd)"
  cd "$THIS_DIR/../../"

  local activeBranch="$(git rev-parse --abbrev-ref HEAD)"
  local gitDiff="$(git status --porcelain)"

  if [ -z "$gitDiff" ] && [ "$activeBranch" == "$trunk" ] && hasGitChanges; then
    echo "Cleaning git workspace because changes after pull (git clean -fd)"
    git clean -fd
  fi

  cd "$cwd"
}

runMain "$@"
