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
alias gl='/usr/bin/git pull'
alias gp='/usr/bin/git push'
alias gd='/usr/bin/git diff'
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

# fix ssh Home and End keys [root]
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

export VISUAL=vim
export EDITOR=vim
