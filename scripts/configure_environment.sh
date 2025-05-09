#!/bin/bash

echo "Installing dotfiles and configuring system."

if [ ! -d "$HOME/.dotfiles_public/" ]; then
  echo ".dotfiles_public not found, exiting"
  exit 1
fi

# location of repository
DOTFILES="$HOME/.dotfiles_public"
source "$DOTFILES/zsh/.zshenv"

## zsh ##
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -sf "$DOTFILES/zsh/.zshenv" "$HOME"
mkdir -p "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"

## neovim ##
ln -sf "$DOTFILES/nvim" "$XDG_CONFIG_HOME"

## diff-so-fancy ##
git config --global core.pager "command -v diff-so-fancy >/dev/null 2>&1 && diff-so-fancy | less --tabs=4 -RF || less"
git config interactive.diffFilter "$XDG_CONFIG_HOME/diff-so-fancy/dsf-filter"

git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.func       "146 bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

mkdir -p "$XDG_CONFIG_HOME/diff-so-fancy"
ln -sf "$DOTFILES/diff-so-fancy/dsf-filter" "$XDG_CONFIG_HOME/diff-so-fancy"

echo "Configuration complete."
