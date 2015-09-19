# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt prompt_subst
autoload -U colors && colors

alias ls='ls -aF --color=auto'

alias runas='sudo -H -u'
alias rr='runas root'

alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias .....='cd .. && cd .. && cd .. && cd ..'
alias ......='cd .. && cd .. && cd .. && cd .. && cd ..'
alias .......='cd .. && cd .. && cd .. && cd .. && cd .. && cd ..'

ff() { find .  -name "$@" }
ffi() { find .  -iname "$@" }

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

precmd() {
    exitcode_value=$?
    if [ $exitcode_value -ne 0 ]; then
        exitcode_color='red'
    else
        exitcode_color='green'
    fi
    export PATH=$PATH:~/tools
}

gitstatus=''
which git > /dev/null
if [ $? -eq 0 ]; then
    alias ga='git add'
    alias gc='git commit'
    alias gd='git diff'
    alias gf='git fetch'
    alias gg='git gui'
    alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    alias gm='git merge --no-ff'
    alias gp='git push'
    alias gsh='git show'
    alias gst='git status'

    if [ -f ~/.zsh-git-prompt/zshrc.sh ]; then
        source ~/.zsh-git-prompt/zshrc.sh
        ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[yellow]%}"
        ZSH_THEME_GIT_PROMPT_PREFIX=" $ZSH_THEME_GIT_PROMPT_PREFIX"
        gitstatus='$(git_super_status)'
    fi
fi

# Set PROMPT and RPROMPT
exitcode='%{$fg_bold[$exitcode_color]%}$exitcode_value%{$reset_color%}%b'
PROMPT="%{$fg_bold[green]%}%n@%m %{$fg_bold[blue]%}%0~ %(#.#.$)%{$reset_color%}%b "
RPROMPT="[$exitcode]$gitstatus"

cu() { sudo -u $1 zsh -i 2>/dev/null }
compdef _users cu

current_user=`whoami`
if [[ $current_user != `basename $HOME` ]]; then
    HOME="/home/$current_user"
    cd
fi
