# Dotfiles Wishlist

Ideas and future improvements for this dotfiles repo.

## Future Features

### SSH Config Management
- Add `.ssh/config` to dotfiles
- **Considerations:**
  - Privacy: might contain internal hostnames/IPs
  - Security: should strip sensitive host info before committing
  - Could use templating or example file approach
- **Research needed:** How other dotfiles repos handle SSH config

### SSH Terminfo Auto-Copy Wrapper
- Automatic terminfo installation on SSH to new servers
- **Status:** Shelved - Ghostty has built-in `ssh-terminfo` feature
- **Notes:** Kitty uses `kitten ssh` for similar functionality
- Could still be useful for other terminals (alacritty, wezterm)

## Potential Additions

### Tool Configs to Consider
- Karabiner Elements config (keyboard remapping)
- More git aliases and configurations
- Tmux config (if we start using tmux)

## Ideas
- Better documentation of what each config does
- Per-machine overrides pattern (like local.zshrc)
- Automated backup/export script

### Auto-Topgrade Scheduler
- [x] Set up automatic topgrade runs every 7 days
- [x] Prompt user Y/N choice during install
- [x] If enabled, check on every shell load (track last run date)
- [x] Politely notify when it's time to update: "It's been 7 days, run topgrade? [Y/n]"
- [x] Store last-run timestamp in `~/.local/share/dotfiles/last-topgrade` or similar
