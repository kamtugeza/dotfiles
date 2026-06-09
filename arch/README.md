# Arch Linux

This module sets up Arch the way I actually want it: desktop, dev tools, and the machine-specific
bits I’m not interested in remembering twice.

It installs the required packages, links the dotfiles, and applies the local settings that make
this machine feel like mine instead of a fresh install with ambition.

## Install

```bash
git clone https://codeberg.org/theoleksii/dotfiles.git "${HOME}/.dotfiles"
bash "${HOME}/.dotfiles/arch/install.sh"
```

> [!NOTE]
> The installer is interactive and will ask for values like hostname, device name, full name, and email.
