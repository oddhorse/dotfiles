#!/bin/bash

# here's what you'll want to do:
# 1. create install.sh in ~/dotfiles/
#    - check if oh-my-zsh is installed (if not, install it)
#    - check if starship is installed (if not, install it)
#    - backup existing configs
#    - create symlinks
#    - install fzf if needed
#    - reload shell
# 2. make it idempotent (safe to run multiple times)
# 3. handle different OSes if you want (macOS vs Linux for your pi)
# then you can run it like:
# curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh | bash
# or safer (so you can inspect it first):
# curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh -o install.sh
# chmod +x install.sh
# ./install.sh
# things to think about:
# - should it auto-install brew if missing?
# - should it ask before installing stuff or just do it?
# - error handling if things fail?
# - color output to make it pretty? uwu

# colors
RED='\033[0;31m'
RED_BOLD='\033[1;31m' # bold RED_BOLD for errors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
YELLOW_BOLD='\033[1;33m' # bold YELLOW_BOLD for warnings
BLUE='\033[0;34m'
BLUE_BOLD='\033[1;34m' # bold BLUE_BOLD for keywords
PURPLE='\033[0;35m'
PURPLE_BOLD='\033[1;35m' # bold PURPLE_BOLD for headers
CYAN='\033[0;36m'
NC='\033[0m' # no color

#========[CHECK SYSTEM]========

echo -e "${PURPLE_BOLD}checking system${NC}"
# check which os:
case "$(uname -s)" in
Darwin)
	OS="macOS"
	;;
Linux)
	OS="Linux"
	;;
esac

# check which package manager:
# (we check brew last since it can be on both macOS and Linux, but we want to prefer the native ones)
if command -v apt &>/dev/null; then
	PM="apt"
	# check for sudo access if using apt
	if ! sudo -v; then
		echo -e "${RED_BOLD}this script requires sudo access for apt installations!!${NC}"
		exit 1
	fi
elif command -v brew &>/dev/null; then
	PM="brew"
else # if no package manager...
	echo -e "${RED_BOLD}hey hey hey hey tugs on your sleeve you don't have a supported package manager!!!!!!${NC}"
	echo -e "${YELLOW_BOLD}right now this script only supports ${BLUE_BOLD}apt${YELLOW_BOLD} and ${BLUE_BOLD}homebrew${NC}"
	# if on macos suggest homebrew
	if [ "$OS" = "macOS" ]; then
		echo -e "${YELLOW_BOLD}since you're on ${BLUE_BOLD}macOS${YELLOW_BOLD} get ${BLUE_BOLD}homebrew${YELLOW_BOLD}!!${NC}"
		echo -e "${CYAN}run the following:${NC}"
		echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
	fi
	exit 1
fi

CWD=$(pwd)

echo -e "detected OS: ${BLUE_BOLD}$OS${NC}"
echo -e "using package manager: ${BLUE_BOLD}$PM${NC}"

#========[INSTALL PACKAGES]========
echo
echo -e "${PURPLE_BOLD}installing required packages${NC}"
# check if oh-my-zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
	echo -e "${GREEN}${BLUE_BOLD}oh-my-zsh${NC}${GREEN} is already installed! continuing${NC}"
else
	echo -e "${YELLOW}${BLUE_BOLD}oh-my-zsh${NC}${YELLOW} not found! installing...${NC}"
	RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# check if starship is installed
if command -v starship &>/dev/null; then
	echo -e "${GREEN}${BLUE_BOLD}starship${NC}${GREEN} is already installed! continuing${NC}"
else
	echo -e "${YELLOW}${BLUE_BOLD}starship${NC}${YELLOW} not found! installing${NC}"
	if [ "$PM" = "apt" ]; then
		sudo apt install -y starship
	else
		brew install starship
	fi
fi

# check if fzf is installed
if command -v fzf &>/dev/null; then
	echo -e "${GREEN}${BLUE_BOLD}fzf${NC}${GREEN} is already installed! continuing${NC}"
else
	echo -e "${YELLOW}${BLUE_BOLD}fzf${NC}${YELLOW} not found! installing${NC}"
	if [ "$PM" = "apt" ]; then
		sudo apt install -y fzf
	else
		brew install fzf
	fi
fi

# check if micro is installed
if command -v micro &>/dev/null; then
	echo -e "${GREEN}${BLUE_BOLD}micro${NC}${GREEN} is already installed! continuing${NC}"
else
	echo -e "${YELLOW}${BLUE_BOLD}micro${NC}${YELLOW} not found! installing${NC}"
	if [ "$PM" = "apt" ]; then
		sudo apt install -y micro
	else
		brew install micro
	fi
fi

# check if topgrade is installed
if command -v topgrade &>/dev/null; then
	echo -e "${GREEN}${BLUE_BOLD}topgrade${NC}${GREEN} is already installed! continuing${NC}"
else
	echo -e "${YELLOW}${BLUE_BOLD}topgrade${NC}${YELLOW} not found!${NC}"
	# Try brew first (works on both macOS and Linux if brew is installed)
	if command -v brew &>/dev/null; then
		echo -e "${YELLOW}installing via ${BLUE_BOLD}brew${NC}${YELLOW}...${NC}"
		brew install topgrade
	# On Linux without brew, install from GitHub releases
	elif [[ "$OS" == "Linux" ]] && command -v curl &>/dev/null; then
		echo -e "${YELLOW}installing via ${BLUE_BOLD}GitHub releases${NC}${YELLOW}...${NC}"
		# Create ~/.local/bin if it doesn't exist (already in PATH via zshrc)
		mkdir -p "$HOME/.local/bin"
		# Get latest version and download
		TOPGRADE_VERSION=$(curl -s https://api.github.com/repos/topgrade-rs/topgrade/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
		echo -e "${CYAN}downloading topgrade v${TOPGRADE_VERSION}...${NC}"
		curl -Lo /tmp/topgrade.tar.gz "https://github.com/topgrade-rs/topgrade/releases/download/v${TOPGRADE_VERSION}/topgrade-v${TOPGRADE_VERSION}-x86_64-unknown-linux-musl.tar.gz"
		# Extract and install
		tar -xzf /tmp/topgrade.tar.gz -C /tmp
		mv /tmp/topgrade "$HOME/.local/bin/"
		chmod +x "$HOME/.local/bin/topgrade"
		rm /tmp/topgrade.tar.gz
		echo -e "${GREEN}topgrade installed to ${BLUE_BOLD}~/.local/bin/topgrade${NC}"
	else
		echo -e "${YELLOW}no ${BLUE_BOLD}brew${NC}${YELLOW} or ${BLUE_BOLD}curl${NC}${YELLOW} available - skipping ${BLUE_BOLD}topgrade${NC}${YELLOW} installation${NC}"
		echo -e "${CYAN}to install ${BLUE_BOLD}topgrade${NC}${CYAN} manually, see: ${BLUE}https://github.com/topgrade-rs/topgrade${NC}"
	fi
fi

#========[FETCH DOTFILE REPO]========
echo
echo -e "${PURPLE}fetching dotfile repo${NC}"
# if it exists, cd into it and git pull and cd back out!!
if [ -d "$HOME/dotfiles" ]; then
	echo -e "${YELLOW}${BLUE}dotfiles${NC}${YELLOW} directory already exists! grabbing the latest changes...${NC}"
	cd "$HOME/dotfiles" || exit 1
	git pull origin main
	cd "$CWD" || exit 1
# if it doesn't exist, clone it
else
	echo -e "${YELLOW}cloning dotfiles repo into ${BLUE}$HOME/dotfiles${NC}${YELLOW}...${NC}"
	git clone https://github.com/oddhorse/dotfiles.git "$HOME/dotfiles"
fi

#========[BACKUP AND SYMLINK]========
echo
echo -e "${PURPLE_BOLD}backing up existing configs${NC}"

# Setup ~/.zshrc to source our dotfiles
# This allows local edits and tool auto-appends without affecting git
if [ -f "$HOME/.zshrc" ]; then
	# Check if it already sources our dotfile
	if grep -q "source.*dotfiles/zshrc" "$HOME/.zshrc" 2>/dev/null; then
		echo -e "${GREEN}${BLUE_BOLD}.zshrc${NC}${GREEN} already sources dotfiles/zshrc! skipping${NC}"
	else
		echo -e "${YELLOW}existing ${BLUE_BOLD}.zshrc${NC}${YELLOW} found! merging with dotfiles setup${NC}"
		# Create temporary file with our source line + existing content
		cat >"$HOME/.zshrc.tmp" <<'EOF'
# ===== DOTFILES SETUP =====
# Load shared config from ~/dotfiles/zshrc
source ~/dotfiles/zshrc

# ===== EXISTING CONFIG (from previous .zshrc) =====
# Your old .zshrc content has been preserved below:

EOF
		# Append existing .zshrc content
		cat "$HOME/.zshrc" >>"$HOME/.zshrc.tmp"
		# Add footer comment
		cat >>"$HOME/.zshrc.tmp" <<'EOF'

# ===== ADD NEW MACHINE-SPECIFIC CONFIG BELOW =====
# This file is not tracked in git - safe to edit!
# Tools (nvm, conda, etc.) can auto-append below this line.

EOF
		# Backup original
		mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
		# Move new version in place
		mv "$HOME/.zshrc.tmp" "$HOME/.zshrc"
		echo -e "${GREEN}merged! original backed up to ${BLUE_BOLD}.zshrc.backup${NC}"
	fi
else
	echo -e "${YELLOW}no existing ${BLUE_BOLD}.zshrc${NC}${YELLOW} found! creating new one${NC}"
	cat >"$HOME/.zshrc" <<'EOF'
# ===== DOTFILES SETUP =====
# Load shared config from ~/dotfiles/zshrc
source ~/dotfiles/zshrc

# ===== MACHINE-SPECIFIC CONFIG =====
# Add your machine-specific config below (not tracked in git)
#
# Examples:
#   - Homebrew: eval "$(brew shellenv)"
#   - NVM: export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#   - Custom aliases and functions
#
# Tools (conda, pyenv, etc.) can auto-append below this line.

EOF
	echo -e "${GREEN}created ${BLUE_BOLD}.zshrc${NC}"
fi

# Create ~/.config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Backup and symlink starship.toml (nerd font version - the default)
STARSHIP_NEEDS_SYMLINK=false
if [ -f "$HOME/.config/starship.toml" ]; then
	if [ -L "$HOME/.config/starship.toml" ]; then
		echo -e "${GREEN}existing ${BLUE_BOLD}starship.toml${NC}${GREEN} is already a symlink! skipping backup${NC}"
	else
		echo -e "${YELLOW_BOLD}existing ${BLUE_BOLD}starship.toml${NC}${YELLOW_BOLD} found! backing up to ${BLUE_BOLD}$HOME/.config/starship.toml.old${NC}"
		mv "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.old"
		STARSHIP_NEEDS_SYMLINK=true
	fi
else
	echo -e "${YELLOW_BOLD}no existing ${BLUE_BOLD}starship.toml${NC}${YELLOW_BOLD} found!${NC}"
	STARSHIP_NEEDS_SYMLINK=true
fi

if [ "$STARSHIP_NEEDS_SYMLINK" = true ]; then
	echo -e "${CYAN}creating symlink for ${BLUE_BOLD}starship.toml${NC}${CYAN} (nerd fonts)${NC}"
	ln -s "$HOME/dotfiles/starship.toml" "$HOME/.config/starship.toml"
else
	echo -e "${GREEN}skipping ${BLUE_BOLD}starship.toml${NC}${GREEN} symlink creation${NC}"
fi

# Symlink starship-text.toml (text-only version for tty)
STARSHIP_TEXT_NEEDS_SYMLINK=false
if [ -f "$HOME/.config/starship-text.toml" ]; then
	if [ -L "$HOME/.config/starship-text.toml" ]; then
		echo -e "${GREEN}existing ${BLUE_BOLD}starship-text.toml${NC}${GREEN} is already a symlink! skipping${NC}"
	else
		echo -e "${YELLOW_BOLD}existing ${BLUE_BOLD}starship-text.toml${NC}${YELLOW_BOLD} found! backing up to ${BLUE_BOLD}$HOME/.config/starship-text.toml.old${NC}"
		mv "$HOME/.config/starship-text.toml" "$HOME/.config/starship-text.toml.old"
		STARSHIP_TEXT_NEEDS_SYMLINK=true
	fi
else
	STARSHIP_TEXT_NEEDS_SYMLINK=true
fi

if [ "$STARSHIP_TEXT_NEEDS_SYMLINK" = true ]; then
	echo -e "${CYAN}creating symlink for ${BLUE_BOLD}starship-text.toml${NC}${CYAN} (text-only)${NC}"
	ln -s "$HOME/dotfiles/starship-text.toml" "$HOME/.config/starship-text.toml"
else
	echo -e "${GREEN}skipping ${BLUE_BOLD}starship-text.toml${NC}${GREEN} symlink creation${NC}"
fi

echo
echo -e "${CYAN}note: ${NC}${GREEN}starship will automatically detect terminal type${NC}"
echo -e "${GREEN}  - ${BLUE_BOLD}nerd fonts${NC}${GREEN} for terminal emulators (default config)${NC}"
echo -e "${GREEN}  - ${BLUE_BOLD}pure text${NC}${GREEN} for linux console (auto-switched)${NC}"

# Symlink gitconfig
echo
echo -e "${PURPLE_BOLD}setting up git config${NC}"
GITCONFIG_NEEDS_SYMLINK=false
if [ -f "$HOME/.gitconfig" ]; then
	if [ -L "$HOME/.gitconfig" ]; then
		echo -e "${GREEN}existing ${BLUE_BOLD}.gitconfig${NC}${GREEN} is already a symlink! skipping${NC}"
	else
		echo -e "${YELLOW_BOLD}existing ${BLUE_BOLD}.gitconfig${NC}${YELLOW_BOLD} found! backing up to ${BLUE_BOLD}$HOME/.gitconfig.old${NC}"
		mv "$HOME/.gitconfig" "$HOME/.gitconfig.old"
		GITCONFIG_NEEDS_SYMLINK=true
	fi
else
	echo -e "${YELLOW_BOLD}no existing ${BLUE_BOLD}.gitconfig${NC}${YELLOW_BOLD} found!${NC}"
	GITCONFIG_NEEDS_SYMLINK=true
fi

if [ "$GITCONFIG_NEEDS_SYMLINK" = true ]; then
	echo -e "${CYAN}creating symlink for ${BLUE_BOLD}.gitconfig${NC}"
	ln -s "$HOME/dotfiles/gitconfig" "$HOME/.gitconfig"
else
	echo -e "${GREEN}skipping ${BLUE_BOLD}.gitconfig${NC}${GREEN} symlink creation${NC}"
fi

# Symlink GitHub CLI config (only if gh is installed)
if command -v gh &>/dev/null; then
	echo
	echo -e "${PURPLE_BOLD}setting up GitHub CLI config${NC}"
	mkdir -p "$HOME/.config/gh"
	GHCONFIG_NEEDS_SYMLINK=false
	if [ -f "$HOME/.config/gh/config.yml" ]; then
		if [ -L "$HOME/.config/gh/config.yml" ]; then
			echo -e "${GREEN}existing ${BLUE_BOLD}gh/config.yml${NC}${GREEN} is already a symlink! skipping${NC}"
		else
			echo -e "${YELLOW_BOLD}existing ${BLUE_BOLD}gh/config.yml${NC}${YELLOW_BOLD} found! backing up to ${BLUE_BOLD}$HOME/.config/gh/config.yml.old${NC}"
			mv "$HOME/.config/gh/config.yml" "$HOME/.config/gh/config.yml.old"
			GHCONFIG_NEEDS_SYMLINK=true
		fi
	else
		echo -e "${YELLOW_BOLD}no existing ${BLUE_BOLD}gh/config.yml${NC}${YELLOW_BOLD} found!${NC}"
		GHCONFIG_NEEDS_SYMLINK=true
	fi

	if [ "$GHCONFIG_NEEDS_SYMLINK" = true ]; then
		echo -e "${CYAN}creating symlink for ${BLUE_BOLD}gh/config.yml${NC}"
		ln -s "$HOME/dotfiles/gh-config.yml" "$HOME/.config/gh/config.yml"
	else
		echo -e "${GREEN}skipping ${BLUE_BOLD}gh/config.yml${NC}${GREEN} symlink creation${NC}"
	fi
else
	echo
	echo -e "${YELLOW}${BLUE_BOLD}gh${NC}${YELLOW} not installed, skipping GitHub CLI config${NC}"
fi

# Symlink topgrade config (only if topgrade is installed)
if command -v topgrade &>/dev/null; then
	echo
	echo -e "${PURPLE_BOLD}setting up topgrade config${NC}"
	TOPGRADE_NEEDS_SYMLINK=false
	if [ -f "$HOME/.config/topgrade.toml" ]; then
		if [ -L "$HOME/.config/topgrade.toml" ]; then
			echo -e "${GREEN}existing ${BLUE_BOLD}topgrade.toml${NC}${GREEN} is already a symlink! skipping${NC}"
		else
			echo -e "${YELLOW_BOLD}existing ${BLUE_BOLD}topgrade.toml${NC}${YELLOW_BOLD} found! backing up to ${BLUE_BOLD}$HOME/.config/topgrade.toml.old${NC}"
			mv "$HOME/.config/topgrade.toml" "$HOME/.config/topgrade.toml.old"
			TOPGRADE_NEEDS_SYMLINK=true
		fi
	else
		echo -e "${YELLOW_BOLD}no existing ${BLUE_BOLD}topgrade.toml${NC}${YELLOW_BOLD} found!${NC}"
		TOPGRADE_NEEDS_SYMLINK=true
	fi

	if [ "$TOPGRADE_NEEDS_SYMLINK" = true ]; then
		echo -e "${CYAN}creating symlink for ${BLUE_BOLD}topgrade.toml${NC}"
		ln -s "$HOME/dotfiles/topgrade.toml" "$HOME/.config/topgrade.toml"
	else
		echo -e "${GREEN}skipping ${BLUE_BOLD}topgrade.toml${NC}${GREEN} symlink creation${NC}"
	fi
else
	echo
	echo -e "${YELLOW}${BLUE_BOLD}topgrade${NC}${YELLOW} not installed, skipping topgrade config${NC}"
fi

# Symlink ghostty config (only if ghostty is installed)
if command -v ghostty &>/dev/null; then
	echo
	echo -e "${PURPLE_BOLD}setting up ghostty config${NC}"

	# Determine ghostty config location based on XDG_CONFIG_HOME
	if [ -n "$XDG_CONFIG_HOME" ]; then
		GHOSTTY_CONFIG_DIR="$XDG_CONFIG_HOME/ghostty"
	else
		GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
	fi

	mkdir -p "$GHOSTTY_CONFIG_DIR"
	GHOSTTY_NEEDS_SYMLINK=false

	if [ -f "$GHOSTTY_CONFIG_DIR/config" ]; then
		if [ -L "$GHOSTTY_CONFIG_DIR/config" ]; then
			echo -e "${GREEN}existing ${BLUE_BOLD}ghostty/config${NC}${GREEN} is already a symlink! skipping${NC}"
		else
			echo -e "${YELLOW_BOLD}existing ${BLUE_BOLD}ghostty/config${NC}${YELLOW_BOLD} found! backing up to ${BLUE_BOLD}$GHOSTTY_CONFIG_DIR/config.old${NC}"
			mv "$GHOSTTY_CONFIG_DIR/config" "$GHOSTTY_CONFIG_DIR/config.old"
			GHOSTTY_NEEDS_SYMLINK=true
		fi
	else
		echo -e "${YELLOW_BOLD}no existing ${BLUE_BOLD}ghostty/config${NC}${YELLOW_BOLD} found!${NC}"
		GHOSTTY_NEEDS_SYMLINK=true
	fi

	if [ "$GHOSTTY_NEEDS_SYMLINK" = true ]; then
		echo -e "${CYAN}creating symlink for ${BLUE_BOLD}ghostty/config${NC}${CYAN} at ${BLUE_BOLD}$GHOSTTY_CONFIG_DIR${NC}"
		ln -s "$HOME/dotfiles/ghostty-config" "$GHOSTTY_CONFIG_DIR/config"
	fi

	# Clean up old macOS-specific ghostty config location (XDG takes priority)
	# Only check on macOS where this path exists
	if [[ "$OS" == "macOS" ]]; then
		MACOS_GHOSTTY="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
		if [ -f "$MACOS_GHOSTTY" ]; then
			echo -e "${YELLOW}found old macOS-specific ghostty config! moving to trash...${NC}"
			trash "$MACOS_GHOSTTY"
			echo -e "${GREEN}XDG config now takes priority at ${BLUE_BOLD}$GHOSTTY_CONFIG_DIR/config${NC}"
		fi
	fi
else
	echo
	echo -e "${YELLOW}${BLUE_BOLD}ghostty${NC}${YELLOW} not installed, skipping ghostty config${NC}"
fi

#========[FINISH]========
echo
echo -e "${GREEN}dotfiles installed successfully${NC}"
echo -e "${CYAN}reload your shell to apply changes: ${YELLOW_BOLD}source ${BLUE_BOLD}~/.zshrc${NC}"
