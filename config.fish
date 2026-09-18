# User specific paths (migrated from .bashrc)
fish_add_path ~/.local/bin ~/bin ~/.opencode/bin

if status is-interactive
# Commands to run in interactive sessions can go here
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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/abdul/miniforge3/bin/conda
    eval /home/abdul/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/abdul/miniforge3/etc/fish/conf.d/conda.fish"
        . "/home/abdul/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/abdul/miniforge3/bin" $PATH
    end
end
# <<< conda initialize <<<
