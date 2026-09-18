# Structure

Layout of this fish configuration.

```
fish
├── config.fish              # entry point, sets paths, clx, fastfetch, oh-my-posh, conda, bun
├── conf.d/
│   ├── mybash.fish          # 150+ aliases and functions from christitustech/mybash, guarded by type -q
│   └── nisko.fish           # PowerShell-inspired helpers from NiskoDT/PowerShell, guarded by type -q
├── functions/
│   └── cleanram.fish        # sync, drop_caches, compact_memory, reports free -h
├── completions/
│   └── bun.fish             # bun tab completion, 260 lines, generated
├── .gitignore               # ignores fish_variables, config.fish.bak*, __pycache__/
└── README.md                # install + credits
```

## Files

**config.fish** runs on every fish start. `fish_add_path` adds `~/.local/bin` etc without duplication. `clx` prints `tput lines -1` blank lines and homes the cursor. `fastfetch` runs inside `if status is-interactive`. `oh-my-posh init fish --config atomicBit.omp.json | source` renders the prompt. Conda block from `conda init` falls back to `miniforge3/bin/conda`. Bun exports `BUN_INSTALL` and prepends `bin`.

**conf.d/mybash.fish** ports christitustech/mybash. Safety aliases `cp -i`, `rm` to `trash-put` or `gio trash`, listing variants `la` through `lls`, `tree` wrappers, `diskspace` and `folders`, archive helpers `mktar` and `extract`, navigation `up`, `mkdirg`, `cpg`, `mvg`, git `gcom` and `lazyg`, system `distribution` and `ver`, network `whatsmyip`. All aliases check `type -q` or `command -v` before defining. Starship stays commented because this config uses oh-my-posh.

**conf.d/nisko.fish** ports NiskoDT/PowerShell. Overrides `grep` to `rg` and `cat` to `bat` when those binaries exist. `FZF_DEFAULT_COMMAND` uses `rg --files --hidden`. `rfv` runs live `rg` inside `fzf` and opens the selection in `EDITOR`. `nf` creates files, `ff` finds by name via `fd` or `rg`, `dirs` lists paths. `md5` and `sha256` wrap `md5sum` or `openssl`. `cpy` and `pst` use `wl-copy` or `xsel`. `hb` posts to `bin.christitus.com`, `weather` curls `wttr.in`. `rld` reloads the three fish files.

**functions/cleanram.fish** runs `sync` then `sync` with `drop_caches` and `compact_memory` via `sudo sh -c`, then prints `free -h`.

**completions/bun.fish** provides completion for `bun`.

**Required tools** are `fish 3.6+`, `zoxide`, `fzf`, `oh-my-posh`, `bun`. Install via `dnf`, `pacman`, or `apt` plus the oh-my-posh script.
