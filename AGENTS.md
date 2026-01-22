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
- `zshrc` - zsh configuration (symlinked to `~/.zshrc`)
- `starship.toml` - starship prompt config (symlinked to `~/.config/starship.toml`)
- `install.sh` - automated installer for fresh machines
- `README.md` - user-facing documentation
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

4. **Don't change the language/tone without asking**
   - User explicitly requested to keep the casual language when adding colors
   - The personality is intentional

### Installation script patterns learned:

**Oh My Zsh detection:**
- ❌ `command -v omz` - doesn't work in bash scripts (omz is a zsh function)
- ✅ `[ -d "$HOME/.oh-my-zsh" ]` - works reliably

**Non-interactive installation:**
- Use `RUNZSH=no` when installing Oh My Zsh from scripts
- Prevents the installer from trying to switch shells mid-script

**Symlink handling:**
- Check if file is already a symlink before backing up
- Only create symlinks when needed (use flags to track)
- Backup existing files to `.old` extensions

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
2. Update `install.sh` to symlink it
3. Add backup logic with appropriate flags
4. Update README.md with the new file
5. Test on a fresh system if possible

### Updating Oh My Zsh plugins:
1. Edit `zshrc` plugins array
2. Document any new plugin requirements in comments
3. If plugin needs installation, update install.sh

### Modifying Starship prompt:
1. Edit `starship.toml`
2. Test with `starship config` to validate
3. Document any nerd font symbol requirements

## Important Notes

- **Nerd fonts required** - Starship uses symbols that need nerd fonts
- **Git not auto-installed** - install.sh assumes git is already present
- **Brew not auto-installed on macOS** - user must install manually if missing
- **Sudo required on Linux** - for apt installations

## Testing Protocol

When making significant changes:
1. Test on current machine first (idempotent checks)
2. Consider testing in a Docker container for Linux
3. Ultimate test: deploy on Raspberry Pi 4
4. Verify symlinks point correctly
5. Verify shell loads without errors

---

**Last Updated:** 2026-01-21
