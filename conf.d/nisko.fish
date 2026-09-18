# NiskoDT/PowerShell → fish — curated extras not already in mybash
# ponytail: only portable, high-signal utils. Windows/Scoop/Catppuccin/carapace skipped.
# https://github.com/NiskoDT/PowerShell

# ── env ──────────────────────────────────────────────────
# fzf + ripgrep: faster file listing, respects .gitignore, hidden files
if type -q rg
    set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git"'
end

# ── smart overrides (only if tool exists, else keep stock) ──
if type -q rg
    # grep → ripgrep
    function grep --wraps rg --description "grep → rg (or stock grep)"
        rg $argv
    end
end
if type -q bat
    function cat --wraps bat --description "cat → bat"
        bat $argv
    end
end
if type -q fd
    function find --wraps fd --description "find → fd"
        fd $argv
    end
else if type -q fdfind
    function find --wraps fdfind
        fdfind $argv
    end
end

# ── file helpers ─────────────────────────────────────────
# mkcd alias — mkdirg already exists in mybash, keep mkcd for muscle memory
if not type -q mkcd
    alias mkcd mkdirg
end

function nf --description "New file in cwd (like touch)"
    for n in $argv
        touch "./$n"
    end
end

function ff --description "Recursively find file by name"
    if test (count $argv) -eq 0
        echo "Usage: ff <name>"
        return 1
    end
    # prefer fd/rg if available, else find
    if type -q fd
        fd --type f --hidden --follow --glob "*$argv[1]*" 2>/dev/null
        fd "$argv[1]" --type f 2>/dev/null | head -n 50
    else if type -q rg
        rg --files --hidden --glob "*$argv[1]*" 2>/dev/null | head -n 50
    else
        find . -type f -name "*$argv[1]*" 2>/dev/null | head -n 50
    end
end

function dirs --description "Recursive full paths, optional patterns"
    if test (count $argv) -gt 0
        for pat in $argv
            find . -type f -name "$pat" -printf "%p\n" 2>/dev/null; or find . -name "$pat" 2>/dev/null
        end
    else
        find . -type f 2>/dev/null | head -n 200
    end
end

# ── hashes (mybash has sha1; add md5/sha256 companions) ──
function md5 --description "MD5 hash of file"
    if test (count $argv) -eq 0
        echo "Usage: md5 <file>"
        return 1
    end
    # use coreutils md5sum if present
    if type -q md5sum
        md5sum $argv
    else
        openssl md5 $argv 2>/dev/null; or Get-FileHash -Algorithm MD5 $argv 2>/dev/null
    end
end

function sha256 --description "SHA256 hash of file"
    if test (count $argv) -eq 0
        echo "Usage: sha256 <file>"
        return 1
    end
    if type -q sha256sum
        sha256sum $argv
    else
        openssl sha256 $argv
    end
end

# ── clipboard ────────────────────────────────────────────
function cpy --description "Copy args or stdin to clipboard"
    if test (count $argv) -gt 0
        if type -q wl-copy
            printf "%s" "$argv" | wl-copy 2>/dev/null; and return
        end
        if type -q xsel
            printf "%s" "$argv" | xsel --clipboard --input 2>/dev/null; and return
        end
        if type -q xclip
            printf "%s" "$argv" | xclip -selection clipboard 2>/dev/null
        end
    else
        if type -q wl-copy
            wl-copy 2>/dev/null; and return
        end
        if type -q xsel
            xsel --clipboard --input 2>/dev/null; and return
        end
        if type -q xclip
            xclip -selection clipboard 2>/dev/null
        end
    end
end

function pst --description "Paste from clipboard"
    if type -q wl-paste
        wl-paste 2>/dev/null; and return
    end
    if type -q xsel
        xsel --clipboard --output 2>/dev/null; and return
    end
    if type -q xclip
        xclip -o -selection clipboard 2>/dev/null
    end
end

# ── network / paste ──────────────────────────────────────
function hb --description "Upload file to hastebin (bin.christitus.com)"
    if test (count $argv) -eq 0
        echo "Usage: hb <file>"
        return 1
    end
    set -l f $argv[1]
    if not test -f "$f"
        echo "File not found: $f"
        return 1
    end
    if not type -q curl
        echo "curl required"
        return 1
    end
    set -l resp (curl -s -X POST --data-binary @"$f" https://bin.christitus.com/documents 2>&1)
    # response is JSON like {"key":"abc123"}
    set -l key (echo $resp | string match -r '"key"\s*:\s*"([^"]+)"' | head -n1)
    if test -n "$key"
        set key (echo $key | string replace -r '.*"key"\s*:\s*"([^"]+)".*' '$1')
        echo "https://bin.christitus.com/$key"
        # also copy to clipboard
        echo -n "https://bin.christitus.com/$key" | cpy 2>/dev/null
    else
        echo $resp
    end
end

function weather --description "wttr.in weather (weather [location])"
    set -l loc ""
    if test (count $argv) -gt 0
        set loc (string join '+' $argv)
        set loc "/$loc"
    end
    if type -q curl
        curl -s "https://wttr.in$loc?m&format=v2"
    else
        echo "curl required"
        return 1
    end
end

# ── interactive ripgrep + fzf (rfv) ──────────────────────
function rfv --description "Fzf live ripgrep (rfv [query]) — enter to open in EDITOR"
    if not type -q fzf
        echo "fzf required (sudo dnf install fzf)"
        return 1
    end
    if not type -q rg
        echo "ripgrep required (sudo dnf install ripgrep)"
        return 1
    end
    set -l q ""
    if test (count $argv) -gt 0
        set q "$argv"
    end
    set -l reload 'reload:rg --column --color=always --smart-case {q} || :'
    set -l ed $EDITOR
    test -z "$ed"; and set ed nvim
    # --delimiter : splits rg output file:line:col:text
    fzf --disabled --ansi --multi \
        --bind "start:$reload" \
        --bind "change:$reload" \
        --bind "enter:become($ed {1})" \
        --delimiter : \
        --preview "bat --style=full --color=always --highlight-line {2} {1} 2>/dev/null | head -n 200; or sed -n '1,200p' {1}" \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$q"
end

# ── profile reload ───────────────────────────────────────
function rld --description "Reload fish config"
    echo "Reloading..."
    source ~/.config/fish/config.fish
    source ~/.config/fish/conf.d/mybash.fish 2>/dev/null
    source ~/.config/fish/conf.d/nisko.fish 2>/dev/null
    echo "Done."
end
alias reload rld
