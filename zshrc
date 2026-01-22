# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # Version control & package managers
  git                       # Git aliases and completions (gst, gco, etc.)
  npm                       # npm completions and aliases
  node                      # Node.js utilities and completions
  nvm                       # Better nvm integration (auto-use .nvmrc files)
  python                    # Python aliases and completions
  
  # Navigation & directory jumping
	z  # Jump to frecent directories (tracks most-used paths)
	wd # Warp directory - bookmark dirs and jump to them

	# Editor integration
	vscode # VS Code helpers (open files/folders in vscode)

	# Shell enhancements
	fzf                      # Fuzzy finder integration (Ctrl+R for history search)
	command-not-found        # Suggests package to install when command not found
	alias-finder             # Reminds you of existing aliases when typing full commands
	history-substring-search # Search history with up/down arrows (type then arrow)

	# File utilities
	extract  # Universal archive extractor - just type 'extract filename.zip'
	copyfile # Copy file contents to clipboard with 'copyfile <file>'
	copypath # Copy current/specified path to clipboard with 'copypath'

	# Visual enhancements
	colored-man-pages # Prettier man pages with syntax highlighting
	emoji             # Emoji support in terminal uwu

	# Safety
  safe-paste                # Prevents executing pasted commands immediately
)

# macOS-specific plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
  plugins+=(brew macos)
fi

source $ZSH/oh-my-zsh.sh

# Starship prompt - load appropriate config based on terminal type
# NOTE: We load starship AFTER oh-my-zsh to override the ZSH_THEME
# The default config (~/.config/starship.toml) uses nerd fonts
# We only override for linux console (tty) to use pure text
if command -v starship &>/dev/null; then
	if [[ "$TERM" == "linux" ]]; then
		# Linux console (tty) - use text-only config
		export STARSHIP_CONFIG="$HOME/.config/starship-text.toml"
	fi
	# Otherwise use default ~/.config/starship.toml (nerd fonts)

	eval "$(starship init zsh)"
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='micro'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Homebrew setup (if installed)
if command -v brew &>/dev/null; then
  eval "$(brew shellenv)"
  # Turn off homebrew hints (annoying!)
  export HOMEBREW_NO_ENV_HINTS=1
fi

# put /sbin back??? (why was it missing in the first place wtf)
export PATH=$PATH:/sbin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# macOS-specific: Daisy Seed microcontroller tooling
if [[ "$OSTYPE" == "darwin"* ]] && [[ -d "/Applications/STMicroelectronics" ]]; then
  export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
fi

export PATH="$HOME/.local/bin:$PATH"

# Machine-specific overrides (not tracked in git)
# Create ~/.zshrc.local for machine-specific config that shouldn't be in dotfiles
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
