# Fix XDG_RUNTIME_DIR for tmux / non-login shells (podman-tui, podman socket)
if test -z "$XDG_RUNTIME_DIR"
    set -gx XDG_RUNTIME_DIR /run/user/(id -u)
end

# User specific paths (migrated from .bashrc)
fish_add_path ~/.local/bin ~/bin ~/.opencode/bin

# PowerShell-style startup status messages
# Keep the network probe capped so SSH logins cannot hang on startup.
if status is-interactive
    set_color green
    echo "Loading fish profile..."
    set_color normal
    if ping -c1 -W2 google.com >/dev/null 2>&1
        set_color green
        echo "Internet connection established!"
        set_color normal
    else
        set_color red
        echo "No internet connection. Commands and terminal output may be limited."
        set_color normal
    end
    for t in rg bat fzf fd jq fastfetch zoxide oh-my-posh
        if type -q $t
            set_color green
            echo "$t is installed."
            set_color normal
        else
            set_color red
            echo "$t not found."
            set_color normal
        end
    end
end

# oh-my-posh init line for fish
oh-my-posh init fish --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/atomicBit.omp.json' | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH


# clx — push screen up without clearing scrollback (port of PowerShell clx)
function clx --description "Push screen up (like clear but keeps scrollback)"
    set -l h (tput lines 2>/dev/null; or stty size 2>/dev/null | string split ' ' | head -n1; or echo 30)
    # h is lines; print h-1 blank lines then home cursor
    for i in (seq (math "$h - 1") 2>/dev/null; or seq 29)
        echo ""
    end
    tput cup 0 0 2>/dev/null; or printf '\033[H'
end

# Automatically enter tmux session (disabled — was: if not TMUX → tmux new-session else clx+fastfetch)
# if status is-interactive
#     if not set -q TMUX
#         tmux new-session
#     else
#         clx
#         fastfetch
#     end
# end

# spit out system information — push-scroll then fetch
if status is-interactive
    clx
    fastfetch
end

# Privilege status after fastfetch, separated by one blank line on each side.
if status is-interactive
    echo
    if test (id -u) -eq 0
        set_color red
        echo "WARNING: Running with ELEVATED privileges."
        set_color normal
    else
        set_color green
        echo "Running with normal user privileges."
        set_color normal
    end
    echo
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniforge3/bin/conda
    eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$HOME/miniforge3/bin" $PATH
    end
end
# <<< conda initialize <<<
