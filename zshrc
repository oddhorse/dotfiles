

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/bear/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

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
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # Version control & package managers
  git                       # Git aliases and completions (gst, gco, etc.)
  brew                      # Homebrew completions
  npm                       # npm completions and aliases
  node                      # Node.js utilities and completions
  nvm                       # Better nvm integration (auto-use .nvmrc files)
  python                    # Python aliases and completions
  
  # macOS specific utilities
  macos                     # macOS-specific commands (tab, pfd, ofd, etc.)
  
  # Navigation & directory jumping
  z                         # Jump to frecent directories (tracks most-used paths)
  wd                        # Warp directory - bookmark dirs and jump to them
  
  # Editor integration
  vscode                    # VS Code helpers (open files/folders in vscode)
  
  # Shell enhancements
  fzf                       # Fuzzy finder integration (Ctrl+R for history search)
  command-not-found         # Suggests package to install when command not found
  alias-finder              # Reminds you of existing aliases when typing full commands
  sudo                      # Press ESC twice to prepend sudo to previous command
  history-substring-search  # Search history with up/down arrows (type then arrow)
  
  # File utilities
  extract                   # Universal archive extractor - just type 'extract filename.zip'
  copyfile                  # Copy file contents to clipboard with 'copyfile <file>'
  copypath                  # Copy current/specified path to clipboard with 'copypath'
  
  # Visual enhancements
  colored-man-pages         # Prettier man pages with syntax highlighting
  emoji                     # Emoji support in terminal uwu
  
  # Safety
  safe-paste                # Prevents executing pasted commands immediately
)

source $ZSH/oh-my-zsh.sh

# Starship prompt - load appropriate config based on terminal type
# NOTE: We load starship AFTER oh-my-zsh to override the ZSH_THEME
# The default config (~/.config/starship.toml) uses nerd fonts
# We only override for linux console (tty) to use pure text
if command -v starship &> /dev/null; then
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

# Fix homebrew
eval $(/usr/local/bin/brew shellenv)

# put /sbin back??? (why was it missing in the first place wtf)
export PATH=$PATH:/sbin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# for daisy seed microcontroller
export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin

# turn off homebrew hints (annoying!)
export HOMEBREW_NO_ENV_HINTS=1

export PATH="$HOME/.local/bin:$PATH"

