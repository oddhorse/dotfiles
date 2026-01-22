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

# Create ~/.zshrc that sources the shared dotfile
# This allows local edits and tool auto-appends without affecting git
ZSH_NEEDS_CREATION=false
if [ -f "$HOME/.zshrc" ]; then
	# Check if it already sources our dotfile
	if grep -q "source.*dotfiles/zshrc" "$HOME/.zshrc" 2>/dev/null; then
		echo -e "${GREEN}${BLUE_BOLD}.zshrc${NC}${GREEN} already sources dotfiles/zshrc! skipping${NC}"
	else
		echo -e "${YELLOW_BOLD}existing ${BLUE_BOLD}.zshrc${NC}${YELLOW_BOLD} found! backing up to ${BLUE_BOLD}$HOME/.zshrc.old${NC}"
		mv "$HOME/.zshrc" "$HOME/.zshrc.old"
		ZSH_NEEDS_CREATION=true
	fi
else
	echo -e "${YELLOW_BOLD}no existing ${BLUE_BOLD}.zshrc${NC}${YELLOW_BOLD} found!${NC}"
	ZSH_NEEDS_CREATION=true
fi

if [ "$ZSH_NEEDS_CREATION" = true ]; then
	echo -e "${CYAN}creating ${BLUE_BOLD}.zshrc${NC}${CYAN} that sources shared config${NC}"
	cat >"$HOME/.zshrc" <<'EOF'
# Load shared dotfiles config
source ~/dotfiles/zshrc

# Machine-specific config below this line
# (safe to edit, not tracked in git)

EOF
else
	echo -e "${GREEN}skipping ${BLUE_BOLD}.zshrc${NC}${GREEN} creation${NC}"
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

#========[FINISH]========
echo
echo -e "${GREEN}dotfiles installed successfully${NC}"
echo -e "${CYAN}reload your shell to apply changes: ${YELLOW_BOLD}source ${BLUE_BOLD}~/.zshrc${NC}"
