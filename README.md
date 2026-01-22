# oddhorse's dotfiles

my dotfiles !!!!!! #my dotfiles

**→ [Why this approach?](APPROACH.md)** - How this repo differs from popular dotfiles repos

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

# create .zshrc that sources the shared config
cat > ~/.zshrc << 'EOF'
# Load shared dotfiles config
source ~/dotfiles/zshrc

# Machine-specific config below this line
# (safe to edit, not tracked in git)

EOF

# symlink starship configs
mkdir -p ~/.config
ln -s ~/dotfiles/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/starship-text.toml ~/.config/starship-text.toml

# reload shell
source ~/.zshrc
```

**how it works:**

- `~/.zshrc` is a **real file** (not a symlink!) that sources `~/dotfiles/zshrc`
- the repo's `zshrc` has universal config (oh-my-zsh, plugins, editor, etc.)
- your actual `~/.zshrc` has machine-specific stuff (homebrew, nvm, custom aliases, etc.)
- tools can auto-append to `~/.zshrc` without affecting your git repo
- starship configs are symlinked to `~/.config/`
- `~/.config/starship.toml` is the default (nerd fonts) - works in terminal emulators
- `~/.config/starship-text.toml` is auto-selected when `$TERM == "linux"` (tty)

## cross-platform support

the shared zshrc works everywhere:
- **macOS**: loads `brew` and `macos` oh-my-zsh plugins automatically
- **Linux**: skips macOS-specific plugins
- **both**: git, fzf, starship, and other universal tools work everywhere

machine-specific setup (homebrew paths, nvm, conda, etc.) goes in your actual `~/.zshrc` on each machine

### adding machine-specific config

your actual `~/.zshrc` file sources the shared dotfile, so you can add local config after the source line:

```bash
# ~/.zshrc
source ~/dotfiles/zshrc

# Machine-specific stuff below:
eval "$(brew shellenv)"  # homebrew on macOS
export NVM_DIR="$HOME/.nvm"  # nvm setup
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Custom aliases
alias work="cd ~/work-projects"
```

tools like conda, nvm, etc. can auto-append to `~/.zshrc` without affecting your dotfiles repo~

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
