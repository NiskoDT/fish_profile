# fish_profile

Portable fish shell configuration for Fedora, Arch, and Ubuntu.

## Structure

```
config.fish              # oh-my-posh atomicBit, bun, conda, clx
conf.d/mybash.fish       # christitustech/mybash port
conf.d/nisko.fish        # NiskoDT/PowerShell port
functions/cleanram.fish  # sync + drop_caches
completions/bun.fish     # bun completions
.gitignore               # fish_variables + backups
```

See [`config.fish`](config.fish) for the startup order, [`conf.d/mybash.fish`](conf.d/mybash.fish) and [`conf.d/nisko.fish`](conf.d/nisko.fish) for the ported aliases.

Details for each file live in [`STRUCTURE.md`](STRUCTURE.md).

## Requirements

- fish shell 3.6 or newer
- zoxide for directory jumping
- fzf for fuzzy finding
- oh-my-posh for prompt rendering
- bun for JavaScript runtime completions

## Install

```bash
git clone https://github.com/NiskoDT/fish_profile ~/.config/fish
```

The configuration expects zoxide, fzf, and oh-my-posh to be installed separately. On Fedora: `sudo dnf install zoxide fzf oh-my-posh`. On Arch: `sudo pacman -S zoxide fzf oh-my-posh`. On Ubuntu: `sudo apt install zoxide fzf` then install oh-my-posh via the official script at https://ohmyposh.dev/docs/installation.

After cloning, restart your shell or run `source ~/.config/fish/config.fish` to apply changes.

## Credits

- christitustech/mybash (conf.d/mybash.fish)
- NiskoDT/PowerShell (conf.d/nisko.fish)
