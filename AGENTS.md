# AGENTS.md

**Project-specific instructions for AI assistants working with this dotfiles repository**

---

## Repository Purpose

Personal dotfiles repository for managing shell configuration across multiple machines (macOS and Raspberry Pi 4). The goal is to have a **consistent, beautiful, and functional** terminal experience that can be quickly deployed on fresh systems.

## Current Configuration

**Shell:** zsh with Oh My Zsh  
**Prompt:** Starship (using nerd-font-symbols preset with custom modifications)  
**Key Tools:** fzf, extensive Oh My Zsh plugins  

### Files in this repo:
- `zshrc` - zsh configuration (sourced by `~/.zshrc`, not symlinked)
- `starship.toml` - starship prompt config with nerd fonts (symlinked to `~/.config/starship.toml`)
- `starship-text.toml` - plain text prompt config for TTY (symlinked to `~/.config/starship-text.toml`)
- `gitconfig` - git user settings (symlinked to `~/.gitconfig`)
- `gh-config.yml` - GitHub CLI preferences (conditionally symlinked to `~/.config/gh/config.yml`)
- `topgrade.toml` - system update tool config (conditionally symlinked to `~/.config/topgrade.toml`)
- `ghostty-config` - Ghostty terminal emulator settings (conditionally symlinked, XDG-aware)
- `install.sh` - automated installer for fresh machines
- `README.md` - user-facing documentation
- `APPROACH.md` - explains source pattern vs symlinks/copying
- `WISHLIST.md` - future improvements and ideas
- `agents.md` - this file
- `.gitignore` - git ignore rules

## Working with this Repository

### When making changes:

1. **Always preserve the casual/playful tone in comments**
   - The install.sh has personality ("hey hey hey hey tugs on your sleeve")
   - Don't make it sterile and corporate
   - Keep the uwu energy where appropriate

2. **Maintain color coding in install.sh**
   - **BLUE** - command names, file names, paths, keywords
   - **GREEN** - success messages
   - **YELLOW** - warnings, actions being taken
   - **MAGENTA** - section headers
   - **CYAN** - info/instructions
   - **RED** - errors

3. **Keep scripts idempotent**
   - Safe to run multiple times
   - Check if things exist before installing
   - Use flags like `ZSH_NEEDS_SYMLINK` to avoid redundant operations

4. **Conditional config installation**
   - Only symlink configs for tools that are actually installed
   - Use `command -v tool_name &>/dev/null` to detect if tool exists
   - Git config always installed (git is universal)
   - Tool-specific configs (gh, topgrade, ghostty) are conditional

5. **Follow the source pattern for .zshrc**
   - `~/.zshrc` is a real file that sources `~/dotfiles/zshrc`
   - This prevents tools (nvm, conda, brew) from polluting the git repo
   - Re-running installer is safe, won't overwrite machine-specific config
   - See `APPROACH.md` for full explanation

6. **Don't change the language/tone without asking**
   - User explicitly requested to keep the casual language when adding colors
   - The personality is intentional

### Installation script patterns learned:

**Oh My Zsh detection:**
- ❌ `command -v omz` - doesn't work in bash scripts (omz is a zsh function)
- ✅ `[ -d "$HOME/.oh-my-zsh" ]` - works reliably

**Non-interactive installation:**
- Use `RUNZSH=no` when installing Oh My Zsh from scripts
- Prevents the installer from trying to switch shells mid-script

**Conditional tool config installation:**
```bash
# Only symlink if tool is installed
if command -v gh &>/dev/null; then
    ln -s ~/dotfiles/gh-config.yml ~/.config/gh/config.yml
fi
```

**XDG-aware config paths (Ghostty example):**
```bash
# Respect XDG_CONFIG_HOME if set, default to ~/.config
GHOSTTY_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
```
Note: Config location is determined at install time, not runtime. User must rerun installer if they change XDG_CONFIG_HOME later.

**Symlink handling:**
- Check if file is already a symlink before backing up
- Only create symlinks when needed (use flags to track)
- Backup existing files to `.old` extensions

**Source pattern for .zshrc:**
- Create real `~/.zshrc` file that sources `~/dotfiles/zshrc`
- Prevents pollution from tools that auto-append to .zshrc
- Safe to re-run installer (won't overwrite machine-specific additions)

## Goals & Philosophy

**Main goal:** Make it trivial to set up a new machine with a consistent shell environment

**Design principles:**
1. **Automated but transparent** - scripts should be readable and understandable
2. **Safe by default** - backups before overwriting, checks before installing
3. **Cross-platform** - works on macOS (brew) and Linux (apt)
4. **Personalized** - not generic, reflects preferences and personality

**Target systems:**
- macOS primary
- Raspberry Pi 4 secondary (Linux compatibility test target)

## Common Tasks

### Adding a new dotfile:
1. Move the file to `~/dotfiles/` (without leading dot)
2. Update `install.sh` to symlink it (conditionally if tool-specific)
3. Add backup logic with appropriate flags
4. Update README.md with the new file
5. Consider if config should be conditional on tool being installed
6. Test on a fresh system if possible

### Adding a new tool to be installed:
1. Add installation command to install.sh (brew for macOS, apt for Linux)
2. If tool has config file, add it to repo and symlink conditionally
3. Update README.md with the new tool
4. Test that script handles tool not being available gracefully

### Updating Oh My Zsh plugins:
1. Edit `zshrc` plugins array
2. Document any new plugin requirements in comments
3. If plugin needs installation, update install.sh

### Modifying Starship prompt:
1. Edit `starship.toml` (nerd font version) or `starship-text.toml` (plain text version)
2. Test with `starship config` to validate
3. Document any nerd font symbol requirements
4. Remember: zshrc switches between configs based on terminal capabilities

## Important Notes

- **Nerd fonts required** - Starship uses symbols that need nerd fonts (Maple Mono NF preferred)
- **Text-only fallback** - `starship-text.toml` for TTY/non-nerd-font terminals
- **Git not auto-installed** - install.sh assumes git is already present
- **Brew not auto-installed on macOS** - user must install manually if missing
- **Sudo required on Linux** - for apt installations
- **Block cursor preference** - User prefers block cursor, set via `echo -ne '\e[1 q'` in zshrc
- **Conditional configs** - Tool-specific configs only installed if tool is present
- **XDG awareness** - Ghostty config respects XDG_CONFIG_HOME
- **Source pattern** - .zshrc sources ~/dotfiles/zshrc to prevent git pollution

### Tools installed by install.sh:
- oh-my-zsh
- starship
- fzf
- micro (text editor)

### Tools with configs (installed conditionally):
- gh (GitHub CLI) - always installed via brew/apt
- topgrade (system updater) - only if installed
- ghostty (terminal emulator) - only if installed

## Testing Protocol

When making significant changes:
1. Test on current machine first (idempotent checks)
2. Consider testing in a Docker container for Linux
3. Ultimate test: deploy on Raspberry Pi 4
4. Verify symlinks point correctly
5. Verify shell loads without errors

---

**Last Updated:** 2026-01-22
