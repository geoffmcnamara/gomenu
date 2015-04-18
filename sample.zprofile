#################
# sample .zprofile   
# gwm 2003 04/07
# $Id: sample.zprofile,v 1.4 2012/02/24 16:02:38 cvsuser Exp $
### First write a ~/.zshrc like this...
# .zshrc
#if [ -f ~/.zprofile ]; then
#  clear
#  source ~/.zprofile >/dev/null
#fi
######### EOF ~/.zshrc ######

## flush old settings ##
autoload -U compinit  # completion initialization
compinit
autoload -U colors    # color initialization
colors

### VARS ####
# set the command prompt
#PS1="%{$bg[red]$fg[white]%}%*%{$bg[default]%} %{$bg[black]$fg[red]%}TTY=%l
PS1="%{$bg[black]$fg_bold[yellow]%}%D{%a %b %d %H:%M}%{$bg[default]%} %{$bg[black]$fg_no_bold[default]%}TTY=%{$fg[red]%l %{$fg[default]%}TERM=%{$fg[red]%}`echo $TERM` 
%{$fg_bold[blue]%}%n%{$fg[cyan]%}@%{$fg[blue]%}%m:%{$fg[white]%} ...%1d%{$bg[default]$fg[white]%} %# " 
export

# set the PATH 
#PATH=.:/usr/usc/gnu/bin:/usr/usc/gnu/wget/default/bin:/usr/openwin/bin:/usr/usc/tex/3.1415/bin:/usr/local/bin:/usr/usc/bin:/usr/usc/X/bin:/usr/spac/bin:/usr/ucb:/usr/ccs/bin:/usr/etc:/usr/usc/etc:/usr/sbin:/usr/bin:/bin:$PATH
export

# set the MANPATH
#MANPATH=$MANPATH:/usr/usc/tex/3.1415/man:/usr/openwin/man:/usr/local/man:/usr/usc/man:/usr/usc/X/man:/usr/spac/man:/usr/man
#export MANPATH="/usr/usc/man:/usr/usc/gnu/man:$MANPATH"

# set the default EDITOR
#export EDITOR="emacs"

# set the MAIL dir
#export MAIL="/var/mail/$USER[0]/$USER"

# set the LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib

####Aliases
alias ll='ls -l'
#alias finger='finger -l'
#alias frm='frm -n'
#alias e=' /usr/usc/emacs/20.6/bin/emacs'
#alias j="/auto/usc/jdk/1.3/bin/java"
#alias jc="/auto/usc/jdk/1.3/bin/javac"
#alias ns6="/usr/usc/netscape/6.01a/netscape"

######
SETENV () { export $1=$2; }


## OPTIONS ##
setopt NOBGNICE
setopt NOHUP
setopt PROMPT_SUBST
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history
setopt APPEND_HISTORY
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY
setopt NO_BEEP
setopt AUTO_CD
setopt CORRECT
setopt AUTO_LIST 
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt listtypes 
setopt interactivecomments
unsetopt flowcontrol

bindkey '^i' expand-or-complete-prefix
LISTMAX=0
