# macOS

This module sets up macOS the way I actually want it: desktop, dev tools, and the machine-specific
bits I’m not interested in remembering twice.

It installs the required packages, links the dotfiles, and applies the local settings that make
this machine feel like mine instead of a clean install with opinions.

## Install

```bash
xcode-select --install
git clone https://codeberg.org/theoleksii/dotfiles.git "${HOME}/.dotfiles"
bash "${HOME}/.dotfiles/mac/install.sh"
```

> [!NOTE]
> The installer is interactive and will ask for values like device name, host name, full name, and email.
