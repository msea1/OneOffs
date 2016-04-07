# ~/.bashrc: executed by bash(1) for non-login shells.

force_color_prompt=yes


### ALIASES ###
alias addrep='sudo add-apt-repository'
alias bashrc='subl ~/.bashrc'
alias cd..="cd .."
alias diskspace="du -S | sort -n -r |more"
alias g='git'
alias gitconfig='subl ~/.gitconfig'
alias h='history | grep'
alias inst='sudo apt-get install'
alias ld='ls -ABF --group-directories-first'
alias ll='ls -AhlF --group-directories-first'
alias mkdir='mkdir -pv'
alias root="sudo su -"
alias sorry='sudo $(fc -ln -1)'
alias update='sudo apt-get update'
alias vauth='vault auth -method=ldap username=$USER'
alias vssh='vault ssh -role otp_key_role'
alias wget='wget -c'
alias workon='source /usr/local/bin/virtualenvwrapper.sh && workon'


### CASES / CONDITIONALS ###

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi


if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\] $(parse_git_branch)\[\033[00m\] \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $(parse_git_branch) \$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [[ -f ~/.git-completion.bash ]]; then
    source ~/.git-completion.bash
fi
complete -o default -o nospace -F _git g

### COLORS ###
BLUE="\033[38;5;39m\]"
GREEN="\033[38;5;47m\]"
GREY="\033[38;5;7m\]"
WHITE="\033[38;5;15m\]"
YELLOW="\033[38;5;11m\]"

### ENVIRONMENT VARIABLES ###
export DJANGO_ENV=development
export EDITOR=subl
export GREP_OPTIONS='-I --color=always --exclude=*.xhprof'
export HISTCONTROL=ignoreboth
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export MC_HOME=$HOME/code/mission_control
export NVM_DIR="$HOME/.nvm"
export PS1="\[$GREEN\u@\[$(tput sgr0)\]\[$GREY\h \[$(tput sgr0)\]\[$BLUE[\w] \[$(tput sgr0)\]\[$YELLOW\$(parse_git_branch) \[$(tput sgr0)\]\[$WHITE\\$ \[$(tput sgr0)\]"
export PS1="\[$BLUE[\w] \[$(tput sgr0)\]\[$GREEN\$(parse_git_branch) \[$(tput sgr0)\]\[$WHITE\\$ \[$(tput sgr0)\]"
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.4
export SFN_HOME="$HOME/code/spaceflightnetworks"
export WORKON_HOME=$HOME/.virtualenvs


### FUNCTIONS ###

cdl() {
    builtin cd "${@}"
    if [ "$( ls | wc -l )" -gt 30 ] ; then
        ls --color=always | awk 'NR < 16 { print }; NR == 16 { print " (... snip ...)" }; { buffer[NR % 14] = $0 } END { for( i = NR + 1; i <= NR+14; i++ ) print buffer[i % 14] }'
    else
        ls
    fi
}

colors() {
    for i in {0..31} ; do echo "[7;(38;05;$i)mColor $i [0m    [7;(38;05;$(($i + 32)))mColor $(($i+32)) [0m  [7;(38;05;$(($i+64)))mColor $(($i+64)) [0m    [7;(38;05;$(($i + 96)))mColor $(($i+96)) [0m  [7;(38;05;$(($i+128)))mColor $(($i+128)) [0m  [7;(38;05;$(($i + 160)))mColor $(($i+160)) [0m    [7;(38;05;$(($i+192)))mColor $(($i+192)) [0m  [7;(38;05;$(($i + 224)))mColor $(($i+224))"; done; echo -n "[0m"
}

extract () {
 if [ -f $1 ] ; then
     case $1 in
         *.tar.bz2)   tar xvjf $1    ;;
         *.tar.gz)    tar xvzf $1    ;;
         *.bz2)       bunzip2 $1     ;;
         *.rar)       unrar x $1       ;;
         *.gz)        gunzip $1      ;;
         *.tar)       tar xvf $1     ;;
         *.tbz2)      tar xvjf $1    ;;
         *.tgz)       tar xvzf $1    ;;
         *.zip)       unzip $1       ;;
         *.Z)         uncompress $1  ;;
         *.7z)        7z x $1        ;;
         *)           echo "don't know how to extract '$1'..." ;;
     esac
 else
     echo "'$1' is not a valid file!"
 fi
}

gps() {
  arg=$1
  letter=${arg:0:1}
  brack='['$letter']'
  srch=$brack${arg:1}
  ps -ax | grep -i $srch
}

new_venv() {
  source /usr/local/bin/virtualenvwrapper.sh
  mkvirtualenv -p /usr/bin/python3 $1
  workon $1
  mv ~/.config/pip/pip.conf ~/.config/pip/pip.conf.bak
  pip install pip==7.1.2
  mv ~/.config/pip/pip.conf.bak ~/.config/pip/pip.conf
}

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

up(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}


### HTML ###



### OPTIONS ###
shopt -s cdspell  # Autocorrect fudged paths in cd calls
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s extglob
shopt -s histappend

set completion-ignore-case On

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


### PATHS ###

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:$HOME/software/arc/arcanist/bin"