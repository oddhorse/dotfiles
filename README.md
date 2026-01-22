# oddhorse's dotfiles

my dotfiles !!!!!! #my dotfiles

## what's in here

- **zshrc** - oh-my-zsh config with lots of plugins
- **starship.toml** - nerd font starship prompt (auto-selected for terminal emulators)
- **starship-text.toml** - pure text prompt (auto-selected for linux console/tty)

## features

### auto-detects terminal capabilities

the zshrc automatically detects whether you're in a terminal emulator or linux console:

- **terminal emulators** (alacritty, kitty, iterm2, ssh sessions, etc.) → nerd font starship config
- **linux console** (tty, /dev/tty1, bare metal console) → pure text config, no symbols

## how to set up on new machine

### you need

#### macos

**WE ARE ASSUMING you have homebrew!** points my finger at you

install homebrew first:

``` bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### debian (raspberry pi os counts !)

``` bash
sudo apt update && sudo apt upgrade
```

### then run the installer

``` bash
curl -fsSL https://raw.githubusercontent.com/oddhorse/dotfiles/main/install.sh | bash
```

later maybe i'll make a full system config script but not now. bigger fish to fry lol

### manually install dotfiles

```bash
# clone this repo
git clone https://github.com/oddhorse/dotfiles.git ~/dotfiles

# backup existing configs (if any)
mv ~/.zshrc ~/.zshrc.backup 2>/dev/null
mv ~/.config/starship.toml ~/.config/starship.toml.backup 2>/dev/null

# create symlinks
ln -s ~/dotfiles/zshrc ~/.zshrc
mkdir -p ~/.config
ln -s ~/dotfiles/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/starship-text.toml ~/.config/starship-text.toml

# reload shell
source ~/.zshrc
```

**how it works:**

- `~/.config/starship.toml` is the default (nerd fonts) - works in terminal emulators
- `~/.config/starship-text.toml` is auto-selected when `$TERM == "linux"` (tty)

## cross-platform support

the zshrc automatically adapts to your OS:
- **macOS**: loads `brew` and `macos` plugins, sets up homebrew
- **Linux**: skips macOS-specific stuff
- **both**: nvm, git, fzf, and other universal tools work everywhere

### machine-specific config

for settings that shouldn't be in your dotfiles repo (API keys, local paths, etc.), create `~/.zshrc.local`:

```bash
# ~/.zshrc.local (not tracked in git)
export MY_SECRET_KEY="..."
export LOCAL_TOOL_PATH="/some/local/path"
```

this file is automatically sourced if it exists~

## updating

after making changes to the dotfiles:

```bash
cd ~/dotfiles
git add .
git commit -m "update configs"
git push
```

on other machines just pull:

```bash
cd ~/dotfiles
git pull
source ~/.zshrc  # if you updated zshrc
```
