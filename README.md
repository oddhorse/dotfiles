# oddhorse's dotfiles

my dotfiles #my dotfiles

## in herre

- **zshrc** - with omz plugins and stuff
- **starship.toml** - starship prompt config

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

# reload shell
source ~/.zshrc
```

## updating

after making changes to your dotfiles:

```bash
cd ~/dotfiles
git add .
git commit -m "update configs"
git push
```

on other machines, just pull:

```bash
cd ~/dotfiles
git pull
source ~/.zshrc  # if you updated zshrc
```
