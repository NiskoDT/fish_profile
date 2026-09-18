# fish_profile

Portable fish shell configuration for Fedora, Arch, and Ubuntu.

## Structure

config.fish
conf.d/
  mybash.fish      # christitustech/mybash port
  nisko.fish       # NiskoDT/PowerShell port
functions/
  cleanram.fish
completions/
  bun.fish
.gitignore

## File Descriptions

config.fish loads oh-my-posh with the atomicBit theme, initializes bun completions, sets up conda, and configures clx for colorized ls output.

conf.d/mybash.fish ports aliases and functions from christitustech/mybash including git shortcuts, docker helpers, and system utilities.

conf.d/nisko.fish ports PowerShell-inspired aliases and functions from NiskoDT/PowerShell including navigation shortcuts and package manager wrappers.

functions/cleanram.fish drops caches and compacts memory using sync and sysctl calls.

completions/bun.fish provides tab completion for the bun JavaScript runtime.

.gitignore excludes fish_variables, config.fish.bak*, __pycache__/, and *.pyc from version control.

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

## License

MIT