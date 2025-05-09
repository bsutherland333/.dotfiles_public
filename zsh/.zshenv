# zshenv, always sourced and sourced first. Place environment variables here.

## Define XDG locations

# Currently just uses defaults, be cautious when departing from defaults as
# unexpected things may break.

# User specific configuration files
export XDG_CONFIG_HOME="$HOME/.config"

# User specific non-essential data files
export XDG_CACHE_HOME="$HOME/.cache"

# User specific data files
export XDG_DATA_HOME="$HOME/.local/share"

# User specific state files
export XDG_STATE_HOME="$HOME/.local/state"

# User specific runtime files
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# System wide configuration files
export XDG_CONFIG_DIRS="/etc/xdg"

# System wide data files
export XDG_DATA_DIRS="/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/export/share"

## Misc definitions

# Alternate zsh dotfile location
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Add user bin directory to path
export PATH="$PATH:$HOME/.local/bin"
