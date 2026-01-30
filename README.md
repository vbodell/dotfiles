# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
# Install stow (macOS: brew install stow, Linux: apt/pacman install stow)
cd ~ && git clone <your-repo-url> dotfiles && cd dotfiles

# Deploy configs
stow darwin      # macOS

# macOS: Install Homebrew packages
brew bundle install --file=darwin/Brewfile
```

## Usage

```bash
vim ~/.vimrc           # Edit configs (symlinked to repo)
stow -R darwin         # Re-stow after adding files
stow -D darwin         # Remove symlinks
stow -n -v darwin      # Dry run

# Homebrew (macOS)
brew bundle dump --file=darwin/Brewfile --force  # Update Brewfile
brew bundle install --file=darwin/Brewfile       # Install packages
brew bundle cleanup --file=darwin/Brewfile       # Remove unlisted packages
```

## Contents

**darwin**: zsh, vim, tmux, nvim, helix, newsboat, fortune, morning.sh, Brewfile  

## Notes

- Backup existing dotfiles before stowing: `mkdir ~/dotfiles-backup && mv ~/.vimrc ~/.zshrc ~/dotfiles-backup/`
- Configure Git for signed commits as needed
