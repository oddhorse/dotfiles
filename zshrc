# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Don't ask before updating oh-my-zsh
DISABLE_UPDATE_PROMPT="true"

# History timestamp format
HIST_STAMPS="mm/dd/yyyy"

# Base plugins (useful everywhere)
plugins=(git z wd fzf command-not-found history-substring-search extract colored-man-pages safe-paste)

# Dev tools (only if installed)
command -v npm &>/dev/null && plugins+=(npm node nvm)
command -v python &>/dev/null && plugins+=(python)

# Desktop-only plugins (GUI environment detection)
if [[ -n "$DISPLAY" ]] || [[ -n "$WAYLAND_DISPLAY" ]] || [[ "$OSTYPE" == "darwin"* ]]; then
	command -v code &>/dev/null && plugins+=(vscode)
	plugins+=(copyfile copypath emoji)
fi

# macOS-specific plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
	plugins+=(brew macos)
fi

zstyle ':omz:plugins:nvm' autoload yes

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Disable history expansion (!! in strings causes issues)
setopt NO_BANG_HIST

# Starship prompt with terminal detection
if command -v starship &>/dev/null; then
	# Use plain text config for Linux console (no nerd fonts)
	if [[ "$TERM" == "linux" ]]; then
		export STARSHIP_CONFIG="$HOME/.config/starship-text.toml"
	fi
	eval "$(starship init zsh)"
fi

# Homebrew setup (if installed)
if command -v brew &>/dev/null; then
	eval "$(brew shellenv)"
	# Turn off homebrew hints (annoying!)
	export HOMEBREW_NO_ENV_HINTS=1
fi

# Default editor (fallback to nano if micro not installed)
if command -v micro &>/dev/null; then
	export EDITOR='micro'
else
	export EDITOR='nano'
fi

# Force block cursor (interactive shells only)
if [[ $- == *i* ]]; then
	echo -ne '\e[1 q' # blinking block cursor
fi

# Add /sbin to PATH (some systems need this)
export PATH=$PATH:/sbin

# Add user bin directory
export PATH="$HOME/.local/bin:$PATH"

# Topgrade auto-reminder - checks every 7 days (interactive shells only)
if command -v topgrade &>/dev/null && [[ $- == *i* ]]; then
	_check_topgrade_reminder() {
		local data_dir="$HOME/.local/share/dotfiles"
		local last_run_file="$data_dir/last-topgrade"
		local current_time=$(date +%s)
		local seven_days=604800  # 7 days in seconds
		
		# Create data directory if it doesn't exist
		mkdir -p "$data_dir"
		
		# If file doesn't exist, create it with current time (first run)
		if [ ! -f "$last_run_file" ]; then
			echo "$current_time" > "$last_run_file"
			return
		fi
		
		# Read last run timestamp
		local last_run=$(cat "$last_run_file")
		local elapsed=$((current_time - last_run))
		
		# Check if 7 days have passed
		if [ $elapsed -ge $seven_days ]; then
			echo -n "It's been 7 days since last topgrade run! Run it now? [Y/n]: "
			read -k 1 -r response
			echo  # newline after single char input
			if [[ ! $response =~ ^[Nn]$ ]]; then
				topgrade
				# Update timestamp after run
				echo "$(date +%s)" > "$last_run_file"
			fi
		fi
	}
	
	# Run the check on shell load
	_check_topgrade_reminder
fi
