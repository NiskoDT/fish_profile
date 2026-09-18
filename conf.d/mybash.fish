# mybash → fish port (curated best of christitustech/mybash)
# ponytail: one file, guarded aliases/functions, no bash shims
# Source: https://github.com/christitustech/mybash
# Loaded automatically by fish from conf.d

# ── env ──────────────────────────────────────────────────
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx MYBASHDIR "$HOME/.local/share/mybash"
set -gx CLICOLOR 1
set -gx LS_COLORS 'no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
set -gx LESS_TERMCAP_mb \e'[01;31m'
set -gx LESS_TERMCAP_md \e'[01;31m'
set -gx LESS_TERMCAP_me \e'[0m'
set -gx LESS_TERMCAP_se \e'[0m'
set -gx LESS_TERMCAP_so \e'[01;44;33m'
set -gx LESS_TERMCAP_ue \e'[0m'
set -gx LESS_TERMCAP_us \e'[01;32m'

# editor (prefer nvim)
if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    alias vim nvim
    alias vi nvim
    alias vis 'nvim "+set si"'
else if type -q vim
    set -gx EDITOR vim
    set -gx VISUAL vim
else
    set -gx EDITOR vi
    set -gx VISUAL vi
end
type -q pico; and alias spico 'sudo pico'
type -q nano; and alias snano 'sudo nano'

# PATH extras (fish_add_path is idempotent, no dupes)
fish_add_path -m ~/.local/bin ~/bin ~/.local/share/pnpm/bin ~/.npm-global/bin ~/.yarn/bin ~/.yarn/global/node_modules/.bin ~/go/bin ~/.deno/bin ~/.cargo/bin /var/lib/flatpak/exports/bin ~/.local/share/flatpak/exports/bin

# ── safety / quality-of-life aliases ─────────────────────
alias cp 'cp -i'
alias mv 'mv -i'
alias mkdir 'mkdir -p'
alias ping 'ping -c 10'
alias less 'less -R'
alias cls clear
alias da 'date "+%Y-%m-%d %A %T %Z"'
alias sha1 'openssl sha1'
# rm → trash (safe)
if type -q trash-put
    alias rm trash-put
else if type -q trash
    alias rm 'trash -v'
else if type -q gio
    alias rm 'gio trash'
else
    alias rm 'rm -i'
end
type -q multitail; and alias multitail 'multitail --no-repeat -c'
type -q freshclam; and alias freshclam 'sudo freshclam'
type -q kitty; and alias kssh 'kitty +kitten ssh'

# ── navigation ───────────────────────────────────────────
alias home 'cd ~'
alias cd.. 'cd ..'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias bd 'cd $OLDPWD'
alias web 'cd /var/www/html'
# rmd: safe recursive delete (one-filesystem if supported)
if /bin/rm --recursive --force --verbose --one-file-system -- /tmp/.bashrc-rm-test-noop >/dev/null 2>&1
    alias rmd '/bin/rm --recursive --force --verbose --one-file-system --'
else
    alias rmd '/bin/rm -rfv --'
end

# ── listing (color aware) ────────────────────────────────
# fish ls already colored; keep mybash mnemonics
alias la 'ls -Alh'
if ls -d --color=always . >/dev/null 2>&1
    alias ls 'ls -aFh --color=always'
else
    alias ls 'ls -aFhG'
end
alias lx 'ls -lXBh'          # sort by extension
alias lk 'ls -lSrh'          # sort by size
alias lc 'ls -ltcrh'         # sort by change time
alias lu 'ls -lturh'         # sort by access time
alias lr 'ls -lRh'           # recursive
alias lt 'ls -ltrh'          # sort by date
alias lm 'ls -alh | more'
alias lw 'ls -xAh'
alias ll 'ls -Fls'
alias labc 'ls -lap'
alias lf "ls -l | grep -Ev '^d'"
alias ldir "ls -l | grep -E '^d'"
alias lla 'ls -Al'
alias las 'ls -A'
alias lls 'ls -l'
type -q tree; and alias tree 'tree -CAhF --dirsfirst'
type -q tree; and alias treed 'tree -CAFd'

# ── disk / system ───────────────────────────────────────
alias diskspace "du -S | sort -n -r | more"
if du -h --max-depth=1 /dev/null >/dev/null 2>&1
    alias folders 'du -h --max-depth=1'
else
    alias folders 'du -hd 1'
end
alias folderssort 'find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
if df -hT . >/dev/null 2>&1
    alias mountedinfo 'df -hT'
else
    alias mountedinfo 'df -h'
end
if type -q ss
    alias openports 'ss -tulpen'
else if type -q netstat
    alias openports 'netstat -nape --inet'
end
alias rebootsafe 'sudo shutdown -r now'
alias rebootforce 'sudo shutdown -r -n now'
alias mktar 'tar -cvf'
alias mkbz2 'tar -cvjf'
alias mkgz 'tar -cvzf'
alias untar 'tar -xvf'
alias unbz2 'tar -xvjf'
alias ungz 'tar -xvzf'
alias logs "sudo find /var/log -type f -exec file {} \\; | grep text | cut -d' ' -f1 | sed -e 's/:\$//g' | grep -v '[0-9]\$' | xargs tail -f"
alias sshperms 'cd ~ && chmod 600 ~/.ssh/* && chmod 700 ~/.ssh && chmod 644 ~/.ssh/*.pub 2>/dev/null; echo ssh perms fixed'
alias topcpu "/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias checkcommand "type -t"
alias mx 'chmod a+x'

# dnf/fzf pickers (Fedora)
if type -q dnf; and type -q fzf
    alias dnff "dnf --quiet list --available | cut -d' ' -f1 | grep '\\.' | fzf --multi --preview 'dnf info {1}' --preview-window=down:75% | xargs -ro sudo dnf install"
    alias dnfr "dnf --quiet list --installed | cut -d' ' -f1 | grep '\\.' | fzf --multi --preview 'dnf info {1}' --preview-window=down:75% | xargs -ro sudo dnf remove"
end

# history / process search (fish history is better, but keep shorthands)
alias h "history | grep "
alias p "ps aux | grep "
alias f "find . | grep "

# ── integrations ─────────────────────────────────────────
# zoxide (install with: sudo dnf install zoxide) — skipped if missing
if type -q zoxide
    zoxide init fish | source
end
# fzf keybindings (install with: sudo dnf install fzf)
if type -q fzf
    fzf --fish | source
end
# starship: you use oh-my-posh, so leave starship disabled.
# To use mybash starship prompt instead of oh-my-posh:
#   1. sudo dnf install starship
#   2. comment out oh-my-posh line in config.fish
#   3. uncomment next line:
# if type -q starship; starship init fish | source; end

# ── functions ────────────────────────────────────────────

# sudo edit with $EDITOR
function sedit
    sudo $EDITOR $argv
end
function svi
    sudo $EDITOR $argv
end

function alert --description "Desktop notification for last command"
    set -l last (history | tail -n 1 | string replace -r '^\s*\d+\s*' '')
    set -l code $status
    if type -q notify-send
        if test $code -eq 0
            notify-send --urgency=low -i terminal "$last"
        else
            notify-send --urgency=low -i error "$last"
        end
    else
        echo "$last"(test $code -eq 0; and echo " Done"; or echo " Failed")
    end
end

function extract --description "Extract any archive"
    for archive in $argv
        if test -f "$archive"
            switch $archive
                case '*.tar.bz2'
                    tar xvjf "$archive"
                case '*.tar.gz'
                    tar xvzf "$archive"
                case '*.bz2'
                    bunzip2 "$archive"
                case '*.rar'
                    rar x "$archive"
                case '*.gz'
                    gunzip "$archive"
                case '*.tar'
                    tar xvf "$archive"
                case '*.tbz2'
                    tar xvjf "$archive"
                case '*.tgz'
                    tar xvzf "$archive"
                case '*.zip'
                    unzip "$archive"
                case '*.Z'
                    uncompress "$archive"
                case '*.7z'
                    7z x "$archive"
                case '*'
                    echo "don't know how to extract '$archive'..."
            end
        else
            echo "'$archive' is not a valid file!"
        end
    end
end

function ftext --description "Search text in all files"
    grep -iIHrn --color=always "$argv[1]" . | less -r
end

function cpp --description "Copy with progress bar (needs strace)"
    if test (count $argv) -ne 2
        echo "Usage: cpp SOURCE DESTINATION"
        return 2
    end
    if not type -q strace
        echo "cpp requires strace (sudo dnf install strace)"
        return 1
    end
    set -l size (stat -c '%s' "$argv[1]" 2>/dev/null; or stat -f '%z' "$argv[1]")
    strace -q -ewrite cp -- "$argv[1]" "$argv[2]" 2>&1 | awk -v total_size="$size" '
        { count += $NF; if (count % 10 == 0 && total_size > 0) { percent=int(count/total_size*100); if(percent>100) percent=100; printf "%3d%% [",percent; for(i=0;i<=percent;i++) printf "="; printf ">"; for(i=percent;i<100;i++) printf " "; printf "]\r" } } END{print ""}'
end

function cpg --description "Copy and cd"
    if test -d "$argv[2]"
        cp "$argv[1]" "$argv[2]" && cd "$argv[2]"
    else
        cp "$argv[1]" "$argv[2]"
    end
end

function mvg --description "Move and cd"
    if test -d "$argv[2]"
        mv "$argv[1]" "$argv[2]" && cd "$argv[2]"
    else
        mv "$argv[1]" "$argv[2]"
    end
end

function mkdirg --description "Mkdir and cd"
    mkdir -p "$argv[1]" && cd "$argv[1]"
end

function up --description "Up N dirs (up 3)"
    set -l limit 1
    if test (count $argv) -gt 0
        set limit $argv[1]
    end
    if not string match -qr '^[0-9]+$' -- "$limit"
        echo "Usage: up [number]"
        return 2
    end
    set -l d ""
    for i in (seq $limit)
        set d "$d/.."
    end
    set d (echo "$d" | sed 's/^\///')
    test -z "$d"; and set d ..
    cd "$d"
end

function pwdtail --description "Last 2 dirs of pwd"
    pwd | awk -F/ '{nlast=NF-1; print $nlast"/"$NF}'
end

function distribution --description "Detect distro (mybash)"
    switch (uname -s)
        case Darwin
            echo macos
        case Linux
            if test -r /etc/os-release
                set -l id (grep -m1 '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | string trim -c '"' | string trim)
                set -l id_like (grep -m1 '^ID_LIKE=' /etc/os-release 2>/dev/null | cut -d= -f2 | string trim -c '"' | string trim)
                # fallback if grep empty
                test -z "$id"; and set id unknown
                switch $id
                    case fedora rhel centos
                        echo redhat
                    case sles opensuse\*
                        echo suse
                    case ubuntu debian
                        echo debian
                    case gentoo
                        echo gentoo
                    case arch manjaro cachyos
                        echo arch
                    case slackware
                        echo slackware
                    case '*'
                        if string match -q "*fedora*" -- "$id_like"; echo redhat; return; end
                        if string match -q "*debian*" -- "$id_like"; echo debian; return; end
                        if string match -q "*arch*" -- "$id_like"; echo arch; return; end
                        echo unknown
                end
            else
                echo unknown
            end
        case '*'
            echo unknown
    end
end

function ver --description "Show OS version"
    set -l dtype (distribution)
    switch $dtype
        case redhat
            if test -s /etc/redhat-release; cat /etc/redhat-release; else; cat /etc/issue; end; uname -a
        case debian
            lsb_release -a 2>/dev/null; or cat /etc/os-release
        case arch
            cat /etc/os-release
        case macos
            sw_vers; uname -a
        case '*'
            if test -s /etc/issue; cat /etc/issue; else; echo "Unknown distribution"; return 1; end
    end
end

function whatsmyip --description "Show internal + external IP"
    echo -n "Internal IP: "
    if type -q ip
        ip -o -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}'
    else if type -q ifconfig
        ifconfig | awk '/inet / && $2 != "127.0.0.1" {print $2; exit}'
    else
        echo unknown
    end
    echo -n "External IP: "
    if type -q curl
        curl -4fsS --max-time 5 https://ifconfig.me; echo
    else
        echo "curl not installed"
    end
end

function gcom --description "git add . + commit"
    if test (count $argv) -eq 0
        echo 'Usage: gcom "commit message"'
        return 2
    end
    git add . && git commit -m "$argv"
end

function lazyg --description "git add . + commit + push"
    if test (count $argv) -eq 0
        echo 'Usage: lazyg "commit message"'
        return 2
    end
    git add . && git commit -m "$argv" && git push
end

function countfiles --description "Count files/links/dirs recursively"
    for t in files links directories
        echo (find . -type (string sub -l 1 $t) | wc -l) $t
    end 2>/dev/null
end

function clickpaste --description "Click to paste (Wayland/X11)"
    sleep (test (count $argv) -gt 0; and echo $argv[1]; or echo 3)
    if type -q wl-paste; and type -q wtype
        wl-paste | wtype -
    else if type -q xclip; and type -q xdotool
        xdotool type (xclip -o -selection clipboard)
    else
        echo "clickpaste requires wl-paste+wtype (Wayland) or xclip+xdotool (X11)"
        return 1
    end
end

function docker-clean --description "Prune docker containers/images/networks/volumes"
    if not type -q docker
        echo "docker is not installed."
        return 1
    end
    docker container prune -f
    docker image prune -f
    docker network prune -f
    docker volume prune -f
end

function trim --description "Trim whitespace"
    string trim -- "$argv"
end
alias whatismyip whatsmyip

# optional: auto-ls after cd (mybash does builtin cd && ls) — comment out if annoying
# ponytail: kept as opt-in, not default. Uncomment to enable:
# function cd --wraps cd
#     if test (count $argv) -gt 0
#         builtin cd $argv && ls
#     else
#         builtin cd ~ && ls
#     end
# end
