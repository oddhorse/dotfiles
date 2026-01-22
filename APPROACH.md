# Why This Dotfiles Approach?

This repo uses a different pattern than most popular dotfiles repositories. Here's why.

## The Problem with Symlinks

Most dotfiles repos use symlinks:

```bash
~/dotfiles/zshrc → ~/.zshrc (symlink)
```

**The issue:** When tools like `nvm`, `conda`, `pyenv`, etc. auto-append to your shell config, they write to the symlinked file, which means **they write directly to your git repository**.

This causes:
- Git shows "modified" files you didn't manually edit
- Tool-generated code gets committed to your dotfiles
- Or you have to manually configure every tool to not auto-append

## The Problem with Copying

Some repos (like [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)) use `rsync` to copy files:

```bash
rsync ~/dotfiles/.bash_profile ~/ 
```

**The issue:** Re-running the install script **overwrites** your home dotfiles, destroying any tool auto-appends.

This means:
- You can never safely re-run the install script
- Or you must manually configure all tools
- Or you use a separate `.extra` file for everything machine-specific

## Our Solution: Source Pattern

We use a **real file that sources shared config**:

```bash
# ~/.zshrc (real file, NOT a symlink, NOT in git)
source ~/dotfiles/zshrc

# Machine-specific config below
# Tools can auto-append here safely
# Your personal edits go here too
```

### Why This Works

✅ **Tools auto-append naturally** - they write to `~/.zshrc`, not the repo  
✅ **Shared config stays clean** - `~/dotfiles/zshrc` never gets tool code  
✅ **Safe to re-run installer** - detects existing setup, doesn't overwrite  
✅ **Safe to `git pull`** - updates shared config without touching `~/.zshrc`  
✅ **Machine-specific edits** - just add below the source line in `~/.zshrc`  
✅ **Zero maintenance** - no fighting with symlinks or manual tool setup  

## Comparison

| Approach | Re-run installer? | Tool auto-append? | Complexity |
|----------|-------------------|-------------------|------------|
| **Symlinks** (holman) | ✅ Safe | ⚠️ Writes to repo | Medium |
| **Copy** (mathiasbynens) | ❌ Overwrites | ❌ Must use `.extra` | High |
| **Source** (this repo) | ✅ Safe | ✅ Works naturally | Low |

## How It Works

### Initial Setup

```bash
curl -fsSL https://raw.githubusercontent.com/oddhorse/dotfiles/main/install.sh | bash
```

The installer:
1. Installs oh-my-zsh, starship, fzf
2. Clones dotfiles repo to `~/dotfiles`
3. Creates `~/.zshrc` that sources the shared config
4. Symlinks starship configs to `~/.config/`

### After Installation

When you install tools:

```bash
# Install nvm - it auto-appends to ~/.zshrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Install conda - it auto-appends to ~/.zshrc  
conda init zsh
```

These append to `~/.zshrc` (the real file), not to the repo. Everything just works!

### Updating

Pull the latest shared config:

```bash
cd ~/dotfiles
git pull
```

Your `~/.zshrc` stays untouched. Tool auto-appends stay safe. Shared config updates.

### Machine-Specific Config

Two options:

1. **Edit `~/.zshrc` directly** - add below the source line
2. **Let tools auto-append** - they go to `~/.zshrc` safely

## The Insight

Most dotfiles repos try to **control everything** through symlinks or copying.

We embrace the ecosystem: let tools work naturally, provide clean shared config, separate concerns.

It's simpler, safer, and actually easier to maintain.

---

**tl;dr:** Real file sources shared config = tools auto-append safely + zero maintenance.
