# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Don't ask before updating oh-my-zsh
DISABLE_UPDATE_PROMPT="true"

# History timestamp format
HIST_STAMPS="mm/dd/yyyy"

# Plugins (universal - work across all machines)
plugins=(git npm node nvm python z wd vscode fzf command-not-found alias-finder history-substring-search extract copyfile copypath colored-man-pages emoji safe-paste)

# macOS-specific plugins (added conditionally)
if [[ "$OSTYPE" == "darwin"* ]]; then
  plugins+=(brew macos)
fi

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Starship prompt with terminal detection
if command -v starship &>/dev/null; then
  # Use plain text config for Linux console (no nerd fonts)
  if [[ "$TERM" == "linux" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship-text.toml"
  fi
  eval "$(starship init zsh)"
fi

# Default editor
export EDITOR='micro'

# Add /sbin to PATH (some systems need this)
export PATH=$PATH:/sbin

# Add user bin directory
export PATH="$HOME/.local/bin:$PATH"
