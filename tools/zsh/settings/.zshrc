# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function cat_xml() {
    xmllint --format ${1} | cat
}

alias gs='/usr/bin/git status'
alias ga='/usr/bin/git add'
alias gr='/usr/bin/git rm'
alias gal='/usr/bin/git add *'
alias gc='/usr/bin/git commit'
alias gck='/usr/bin/git checkout'
alias gl='/usr/bin/git pull'
alias gp='/usr/bin/git push'
alias gd='/usr/bin/git diff'
alias gb='/usr/bin/git branch'
alias catl='/bin/bat'
alias catn='/bin/cat'
alias cat='/bin/bat --paging=never'
alias catx=cat_xml
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias history='history 0'
alias xcp='tr -d "\n" | xclip -sele clic'
alias lzg='lazygit'
alias lzd='lazydocker'
alias ccd='cd $(fzf)'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export TERMINFO=/etc/terminfo
export TERM=tmux-256color

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# fix zsh Home and End keys
bindkey  '^[[H'   beginning-of-line
bindkey  '^[[F'   end-of-line
bindkey  '^[[3~'  delete-char

# fix zsh Home and End keys [root]
bindkey  '\e[1~'  beginning-of-line  # Linux console
bindkey  '\e[H'   beginning-of-line  # xterm
bindkey  '\eOH'   beginning-of-line  # gnome-terminal
bindkey  '\e[2~'  overwrite-mode     # Linux console, xterm, gnome-terminal
bindkey  '\e[3~'  delete-char        # Linux console, xterm, gnome-terminal
bindkey  '\e[4~'  end-of-line        # Linux console
bindkey  '\e[F'   end-of-line        # xterm
bindkey  '\eOF'   end-of-line        # gnome-terminal

# fix tmux Home and End keys
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# fix Ctrl + left/right arrow keys
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

export VISUAL=vim
export EDITOR=vim

export FZF_DEFAULT_COMMAND='find .           \
  -not \( -path "*/Pictures" -prune \)       \
  -not \( -path "*/Videos" -prune \)         \
  -not \( -path "*/Music" -prune \)          \
  -not \( -path "*/output" -prune \)         \
  -not \( -path "*/dist" -prune \)           \
  -not \( -path "*/chroma_db" -prune \)      \
  -not \( -path "*/Android" -prune \)        \
  -not \( -path "*/Unity" -prune \)          \
  -not \( -path "*.mp3" -prune \)            \
  -not \( -path "*/snap" -prune \)           \
  -not \( -path "*/\.*" -prune \)            \
  -not \( -path "*/build" -prune \)          \
  -not \( -path "*/PackageCache" -prune \)   \
  -not \( -path "*/.venv" -prune \)          \
  -not \( -path "*/.cache" -prune \)         \
  -not \( -path "*/.local" -prune \)         \
  -not \( -path "*/.mypy_cache" -prune \)    \
  -not \( -path "*/node_modules" -prune \)   \
  -not \( -path "*/__pycache__" -prune \)    \
  -not \( -path "*/.git" -prune \)           \
  -not \( -path "*/VirtualBox VMs" -prune \) \
  -print 2> /dev/null'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

# change mouse cursor style
_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-plugins/sudo.plugin.zsh

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

eval $(keychain -q --noask --eval id_rsa)

export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

export PATH="${HOME}/.local/share/gem/ruby/3.0.0/bin:$PATH"

setxkbmap -layout us -option compose:ralt
