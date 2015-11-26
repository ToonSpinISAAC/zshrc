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


# generic zsh stuff ------------------------------------------------------------

setopt prompt_subst
autoload -U colors && colors


# aliases ----------------------------------------------------------------------

# bring color back to ls, also list hidden files and add indicators like / and *
alias ls='ls -AF --color=auto'

# bring color back to grep
alias grep='grep --color=auto'

# "runas USER <COMMAND>" runs COMMAND as USER, with homedir set
alias runas='sudo -H -u'
compdef _users runas

# handy alias for "sudo"
alias rr='runas root'

# easily navigate up the directory tree
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias .....='cd .. && cd .. && cd .. && cd ..'
alias ......='cd .. && cd .. && cd .. && cd .. && cd ..'
alias .......='cd .. && cd .. && cd .. && cd .. && cd .. && cd ..'

# find files by name, the "i" variant is case insensitive
ff() { find .  -name "$@" }
ffi() { find .  -iname "$@" }

# create a directory and cd into it
mdcd() { mkdir -p $1 && cd $1 }

# grep and ls
grepls() { grep -rl "$1" . | xargs ls -lrt }

# grep and rm
greprm() { grep -rl "$1" . | xargs rm }

# key bindings -----------------------------------------------------------------

# use Ctrl+arrow left and Ctrl+arrow right to move between words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# fix Delete key
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

# precmd -----------------------------------------------------------------------

# before each time the prompt is displayed, do this:
precmd() {
    # store the exit code of the last command, and determine the color to
    # display it with
    exitcode_value=$?
    if [ $exitcode_value -ne 0 ]; then
        exitcode_color='red'
    else
        exitcode_color='green'
    fi

    # add "tools" directory to path
    export PATH=$PATH:~/tools
}


# Git stuff --------------------------------------------------------------------

gitstatus=''

# check for presence of Git first
which git > /dev/null
if [ $? -eq 0 ]; then

    # handy aliases
    alias ga='git add'
    alias gch='git checkout'
    alias gc='git commit'
    alias gd='git diff'
    alias gf='git fetch'
    alias gg='git gui'
    alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    alias gm='git merge --no-ff'
    alias gp='git push'
    alias gsh='git show'
    alias gst='git status'

    # start up zsh-git-prompt (https://github.com/olivierverdier/zsh-git-prompt)
    if [ -f ~/.zsh-git-prompt/zshrc.sh ]; then
        source ~/.zsh-git-prompt/zshrc.sh
        ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[yellow]%}"

        # Add a space between the exit code and the zsh-git-prompt output
        ZSH_THEME_GIT_PROMPT_PREFIX=" $ZSH_THEME_GIT_PROMPT_PREFIX"

        # add zsh-git-prompt output to prompt
        gitstatus='$(git_super_status)'
    fi
fi


# Prompts ----------------------------------------------------------------------

# exit code markup for in the right prompt
exitcode='%{$fg_bold[$exitcode_color]%}$exitcode_value%{$reset_color%}%b'

# set left and right prompts
PROMPT="%{$fg_bold[green]%}%n@%m %{$fg_bold[blue]%}%0~ %(#.#.$)%{$reset_color%}%b "
RPROMPT="[$exitcode]$gitstatus"
