####################################
# Name: .bashrc
# Created on: ???1997???
# Created by: Geoffrey W. McNamara (c) 1999,2000,2001,2002:2003:2004
#        geoffm@companionway.net)
# Purpose: set up useful some what aesthetic environment to work in
# This script is designed to be called by ~/.bash_profile
#    Use this to call it from .bash_profile
#       if [ -f $HOME/.bashrc ]; then
#              . $HOME/.bashrc
#       fi
# To get this the first time:
# cd ~/dev/companionway
# export CVSROOT=:ext:cvsuser@hype.companionway.net:/data/cvsroot
# export CVS_RSH=ssh
# cvs co gomenu  (password for cvsuser=CVSUSER)
# all subsequent requests:
# cd ~/dev/companionway/gomenu
# then 
# cvs update 
# Other useful cvs projects (other than gomenu) might be:
# vim

# utils
# myphile
#
#####################################
# $Id: sample.bashrc,v 1.503 2016/01/18 17:13:14 geoffm Exp $ 
#####################################
# Note: 
#   There is a lot here.  I'm not a programmer, I am lazy.  This script
# reduces my work so that I can be lazy more often.  There are some useful
# tricks in this script that you might find helpful.  I often look
# here when I have forgotten how to script some things because this script
# contains so many different techniques.
#
# NOTES: ToDo and other misc issues
#  change the back quoted stuff to POSIX nestable $var = $( .... ) entries
#  use this construct (find or ls routines):
# ls | while read FILENAME
#       echo do-your-thing against $FILENAME
# done 
####
# last day of the month=cal |grep "[0-9]" |$AWK_CMD '{d=$NF} END {print d}'
# BTW - with gnu date command you can do some limited date calcs
# eg date -d "45 days ago" # works
# or date -d "yesterday"
# or date -d "last tue"
####
##### Tips and Tricks - notes ##########
#  length of a parameter= ${#varname} - eg 
#VAR="This is only a test"
#echo ${#VAR} # returns the length
#  will return the number 19
##### This code will 
#VAR="/var/log/httpd/ARCH/access.log.20041006"
#echo \$VAR=$VAR
#echo \${VAR#*.}=${VAR#*.} 
#echo \${VAR##*.}=${VAR##*.}
#echo \${VAR##*/}=${VAR##*/} - same as basename \$VAR
#echo \${VAR%/*}=${VAR%/*} - same as dirname \$VAR
#echo \${VAR%.*}=${VAR%.*}
#echo \${VAR%%.*}=${VAR%%.*}
##### produce this output
#$VAR=/var/log/httpd/ARCH/access.log.20041006
#${VAR#*.}=log.20041006
#${VAR##*.}=20041006
#${VAR##*/}=access.log.20041006 - same as basename $VAR
#${VAR%/*}=/var/log/httpd/ARCH - same as dirname $VAR
#${VAR%.*}=/var/log/httpd/ARCH/access.log
#${VAR%%.*}=/var/log/httpd/ARCH/access
# To just get the last subdir or a full path (with or without trailing slash)
# echo /my/full/path/ | sed -e 's/\(.*\)\/.*$/\1/' -e 's/.*\/\(.*\)$/\1/'
# To strip the trailing slash from a path
# echo /my/full/path/ | sed -e 's/\/$//'
# To sort ip addresses: sort -n -t. +0 -1 +1 -2 +2 -3 +3 -4
###################################

# ======== Setup Commands ================
# Turns messages from others (and daemons) off - set to "no"
# echo Setting mesg \(messages\) to "no"...
# mesg n

# Go grab the system .bashrc if it exists
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
# this next one basically prevents this from loading if the shell is not interactive
case $- in
  *i* ) 
    ;;
  * )
    return
    ;;
esac

#########
## For the intrepid spirit:
#if [ ! -f $HOME/.inputrc ]; then
#  touch $HOME/.inputrc
#fi
#if ! grep "editing-mode" $HOME/.inputrc; then
#cat <<EOF>>$HOME/.inputrc
##########
### For the intrepid spirit:
#set editing-mode vi
#set keymap vi-insert
### vs
## set editing-mode emacs
## set keymap emacs
##########
#"\e[5~": history-search-backward
#"\e[6~": history-search-forward
## Now if you type a command followed by PageUp 
## it will search for the last command that started 
## with the pattern you specified.
#EOF
#fi

# ======== End Setup Commands =============

########################################
# =========== Exports ================ #
########################################
# Platform dependant stuff
LOG_DIR=/var/log
if uname -s | grep -i linux >/dev/null; then
  MAIL_LOGFILE=$LOG_DIR/maillog
  MESSAGES_LOGFILE=/var/log/messages
  HTTP_ACCESS_LOGFILE=/var/log/httpd/access_log
  HTTP_ERROR_LOGFILE=/var/log/httpd/error_log
  BOOT_LOGFILE=/var/log/boot
  CRON_LOGFILE=/var/log/cron
  MYSQL_LOGFILE=/var/log/mysqld.log
  SECURE_LOGFILE=/var/log/secure
  AWK_CMD=awk
  GREP_CMD=grep
  EGREP_CMD=egrep
  OS=linux
fi
if uname -s | grep -i sun > /dev/null; then
  MAILLOG_LOGFILE=/var/adm/syslog
  MESSAGES_LOGFILE=/var/adm/messages
  AWK_CMD=nawk
  GREP_CMD=grep
  EGREP_CMD=egrep
  OS=sun
fi
if uname -s | grep -i HP-UX > /dev/null; then
  MAILLOG_LOGFILE=/var/adm/syslog/mail.log
  MESSAGES_LOGFILE=/var/adm/syslog/syslog.log
  AWK_CMD=awk
  GREP_CMD=grep
  EGREP_CMD=egrep
  OS=hp
fi
AWK_CMD=${AWK_CMD:-`type -p awk`}
GREP_CMD=${GREP_CMD:-`type -p grep`}
EGREP_CMD=${EGREP_CMD:-`type -p egrep`}

#################
processCMD ()
################
{
## This just makes it easier to write commands that you
## also want echo'ed to the screen
## Please be sure to escape all quotes (double or single)
## EXAMPLE: 
##   processCMD su - $MYUSER -c \"ls -la\"
#	#COLOR_FLAG=${COLOR_FLAG:-YES}
#	DEBUG=${DEBUG:-0}
#
#	##if [ "$COLOR_FLAG" = "YES" ]; then
#	  BLUE=${BLUE:-'[34m'}
#	  NORMAL=${NORMAL='[0m'}
#	#fi
	echo ${BLUE}Executing:${NORMAL} $*
#
#	if [ $DEBUG -eq 0 ]; then
#		# Because DEBUG is off - actually run the command
    eval $*
		ERRFLAG=$?
#	else
#		echo DEBUG is on [$DEBUG] so I am not actually running the command...
#	fi
##	if [ $ERRFLAG -gt 0 ]; then
##		doEXIT 
##	fi
	return $ERRFLAG
}

############
chkID ()
############
{
MIN_PARAMS=1
ERRFLAG=${ERRFLAG:-99};[ $# -ge $MIN_PARAMS ] || doEXIT "Bad params [$FUNCNAME]"
# param $* = list of acceptible users
# example:
# if chkID myname root webuser; then
#    echo Good, the current user is in the acceptible list of users
# else
#    ERRFLAG=99
#    doEXIT "You are not an approved user..."
# fi
#
# or id | awk 'BEGIN{FS="[()]"}{print $2}' to get the exact runas id name
# or id -un
# eg if [ `id -un` = "$1" ]; then echo Success; fi
  while [ $1 ]; do
    # consider "id -un" here - but is it portable?
    if id | cut -d" " -f 1 | grep $1 >/dev/null; then
      myERRFLAG=0
      break
    else
      myERRFLAG=1
      #doEXIT "You must be [$1] to use this script"
    fi
    shift
  done
  return $myERRFLAG
}

##########
manpathIT ()
##########
{
  #echo DEBUG: Now adding $1 to MANPATH
  #echo BEFORE: MANPATH=$MANPATH
  if [ "x$2" = after ]; then
    if ! echo $MANPATH | $EGREP_CMD "(^|:)$1(:|$)" >/dev/null ; then
      MANPATH=$MANPATH:$1
    fi
  else
    if ! echo $MANPATH | $EGREP_CMD "(^|:)$1(:|$)" >/dev/null ; then
      MANPATH=$1:$MANPATH 
      export MANPATH
    fi
  fi
  #echo AFTER: MANPATH=$MANPATH
}

##########
pathIT ()
##########
{
  #echo DEBUG: Now adding $1 to PATH
  #echo BEFORE: PATH=$PATH
  EGREP_CMD=${EGREP_CMD:-type -p egrep}
  if [ "x$2" = after ]; then
    if ! echo $PATH | $EGREP_CMD "(^|:)$1(:|$)" >/dev/null ; then
      PATH=$PATH:$1
    fi
  else
    if ! echo $PATH | $EGREP_CMD "(^|:)$1(:|$)" >/dev/null ; then
      PATH=$1:$PATH 
      export PATH
    fi
  fi
  #echo AFTER: PATH=$PATH
}

#function genstrip {
#        # NOTE: debugging is commented out because quoting is parsed every
#        #       time this function runs... whether debugging is enabled or not.
#        #print_debug "Stripping ${2} from ${1}"
#        #print_debug "${1} is\t\t${!1}"
#        eval $1=\"${!1//':'${2}':'/':'}\"
#        eval $1=\"${!1%:${2}}\"
#        eval $1=\"${!1#${2}:}\"
#        #print_debug "${1} is now\t${!1}"
#}

######################################
setbell ()  # set the bell [on | off]
######################################
{
# I do not care for the bell (alert beep) at the console so...
#INPUTRC often points to /etc/inputrc.
#To bind M-m to a command that invokes the man command at the beginning of line. 
# On the command line:
#     bind  '"\em": "\C-a man \r"'
# or  bind '"\M-m": "\C-a man \r"'
# or in the .inputrc file
# "\em":  "\C-a man \r"
# "\M-m": "\C-a man \r"
#You can use bind -s to show bound strings and bind -p to show bound commands.
case $1 in
  off )
    INPUTRC=$HOME/.inputrc
    if [ -f "$HOME/.inputrc" ] ; then
      if ! grep "bell-style none" $HOME/.inputrc >/dev/null; then
        # echo set bell-style visable >> $HOME/.inputrc
        #     or
        #echo set bell-style none >> $HOME/.inputrc
        processCMD replaceit "^set bell-style.*" "set bell-style none" $HOME/.inputrc
      else
        processCMD echo set bell-style none \>\> $HOME/.inputrc
      fi
    else
      processCMD echo set bell-style none \>\> $HOME/.inputrc
  fi
  # turn it off
  echo -e "\033[11;0]"
  # to turn it off in X...
  if [ ! "x$DISPLAY" = "x" ] && type -p xset >/dev/null; then
    # Thanks to Navin Markandeya for this one...
    processCMD xset b 0
  fi 
  ;;
  on )
    INPUTRC=$HOME/.inputrc
    if [ -f "$HOME/.inputrc" ] ; then
      if ! egrep "^bell-style " $HOME/.inputrc >/dev/null; then
        #echo set bell-style audible >> $HOME/.inputrc
        processCMD replaceit "^set bell-style.*" "set bell-style audible" $HOME/.inputrc
      fi
    else
      processCMD echo set bell-style audible \>\> $HOME/.inputrc
    fi
    # turn it on
    echo -e "\033[10;750]\33[11;250]"
    ;;
  * ) echo "Usage: $FUNCNAME on|off"
    ;;
  esac
}

# Just to be sure make the SHELL variable = what it is right now
#export SHELL=`type -p bash|sed 's/.* //'`

# This one makes your prompt color 
if [ -f $HOME/.color_prompt_flag ]; then
  echo DEBUG: FOUND .color_prompt_flag
  export PROMPT_STYLE=COLOR
	export COLOR_FLAG=YES
  # these lines will colorize man pages
  export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
  export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
  export LESS_TERMCAP_me=$'\E[0m' # end mode
  export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
  export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box
  export LESS_TERMCAP_ue=$'\E[0m' # end underline
  export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
else
  #echo DEBUG: DID NOT FIND .color_prompt_flag
  export COLOR_FLAG=NO
  # Uncomment following line if you want to disable colors in ls
  export PROMPT_STYLE=""
  #echo DEBUG env; env | grep COLOR
fi 

# Added this one on a recommendation for making slang based programs 
#    work better
#export  COLORFGBG="default;default"

# Added this one after RedHat 7.1 broke the ls sorting - to get it back
# to a normal ls sort use this (see man sort):
#export LC_ALL=C
# Commented it back out - looks like RH fixed it and this can break mc

# I have a softlink from $HOME/mail to $HOME/nsmail and to $HOME/Mail
export MAILDIR=$HOME/mail

# You should always have this one - your own bin directory under your HOME
pathIT "$HOME/bin"

# Just in case - build a minimum manpath
manpathIT "/usr/man"

# These make you look like you have root's PATH
pathIT /bin
pathIT /sbin
pathIT /usr/bin
pathIT /usr/sbin
pathIT /usr/local/sbin
if [ -d /usr/games ]; then
  pathIT /usr/games
fi

# This PATH entry will add Sun solaris css bin stuff and for prtdiag etc
if [ -d /usr/ccs/bin ] ; then
  if uname -i>/dev/null ; then
    pathIT /usr/ccs/bin
    pathIT /usr/platform/`uname -i`/sbin
  else
    pathIT /usr/platform/`uname -i | $AWK_CMD '{print $5}'`/sbin 
  fi
fi

# make sure $HOME/bin is in the PATH
if [ -d $HOME/bin ]; then
  pathIT $HOME/bin
fi

# Set up version concurrent version system (CVS) stuff
if [ -f $HOME/.SVN_Root_flag ]; then
  SVNROOT=`cat $HOME/.SVN_Root_flag`
fi

# Set up version concurrent version system (CVS) stuff
export CVS_RSH=ssh
###if [ "x$CVSROOT" = "x" ]; then
if [ "x$CVSROOT" = "x" ] && [ -f $HOME/.CVS_Root_flag ]; then
  #echo Last saved CVSROOT=`cat $HOME/.CVS_Root_flag`
  VAR=`cat $HOME/.CVS_Root_flag \
    | sed 's/:\([^:]*\):\([^@]*\)@\([^:]*\):\(.*\)/\1 \2 \3 \4/'`
set $VAR
myCVS_EXT=$1
myRUSER=$2
myRHOST=$3
myCVSDIR=$4
### Do NOT add anything in front of these line - including a tab!!
CVSROOT=:ext:${myRUSER}@${myRHOST}:${myCVSDIR};export CVSROOT
export CVSROOT
export CVS_RSH="ssh"
fi

# All my cvs sandbox projects are located in the dir below
# just a note here: cvs sticky can be a troublesome affair - I once used cvs admin -kkv to get rid of 
# them. cvs status -v will show you if they are there or not. THey were preventing key tag word updates
DEV=$HOME/dev
export DEV
#if [ ! -d $DEV ]; then
#  processCMD mkdir $DEV
#fi

#PRJ=$HOME/bin/prj
#export PRJ
#if [ ! -d $PRJ ]; then
#  mkdir $PRJ
#fi

# You may want to set this to your own preferences for JAVA...
#if ! env | grep JAVA_HOME >/dev/null ; then
#  TMP_JAVA_HOME=/usr/java/jre1.3.1_01 # change this to the proper dir
#  or consider
#  If you installed JRE:
#   export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
# If you installed JDK:
#   export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
#  if [ -d $TMP_JAVA_HOME ]; then
#    export JAVA_HOME=$TMP_JAVA_HOME
#    export PATH=$PATH:$JAVA_HOME
#  fi
#fi
#
#if [ -d /usr/java/bin ]; then
 #export JAVA_HOME=/usr/java/bin
 #export JAVA_HOME=/usr/java
 # pathIT $JAVA_HOME/bin
#else
#  if [ -d /usr/java ]; then
#    USR_JAVA_DIRS=`ls -d /usr/java/*|wc -l`
#    if [ $USR_JAVA_DIRS -gt 0 ]; then
#      # get the latest one
#      export JAVA_HOME=`ls -trd /usr/java/*|tail -1`
#    fi
#    pathIT $JAVA_HOME/bin
#  fi
#fi

if [ -d $HOME/dev/utils ]; then
  # this one is for me folks... gwm
  pathIT $HOME/dev/utils
fi

if [ -d $HOME/dev/cvs/utils ]; then
  # this one is for me folks... gwm
  pathIT $HOME/dev/cvs/utils
fi

# lets force .usr/local/bin to the front of $PATH
if [ -x /bin/sed ]; then
  PATH=`echo $PATH | /bin/sed 's|/usr/local/bin:||'`
fi
pathIT /usr/local/bin

#export PATH=$PATH:/usr/games:/usr/local/games
#export PATH=$PATH:/usr/X11R6
alias less="less -r" # displays color and prompt codes correctly`
if [ -x /usr/bin/less ]; then
  export PAGER="less -i " # case insensitive searches
else
  export PAGER=more
fi
#GUILE_LOAD_PATH=/usr/share/guile

# now let fix up CDPATH
export CDPATH=.:~:/usr:/usr/local

# ========== End Exports ================

# =============== Alias's ======================
if type -p less >/dev/null 2>&1 ; then
  alias pg="less -i"   # most unix platforms have a pg command ...
fi
# alias minicom="minicom -l" # the older terms couldn't handle the charsi
#                               correctly
alias sled=$EDITOR   # sled was an dos favorite of mine-hard to break habits
alias tv="mc"        # and treeview was a great dos file manager...
#alias gcmdr="gnome-commander"
alias gc="gnome-commander"
alias md="mkdir"
alias copy="cp"
alias cp="cp -i"
alias mv="mv -i"
alias ".."="cd .."
alias "cd.."="cd .."
# OK-Mandrake, RH, and others are changing ls="ls --color" - this is not a good
# thing from my perspective.  If you use ls in scripts the color codes
# will crush something somewhere - so use the lsc listed below instead and...
if ( alias | grep " ls=" >/dev/null ) ; then
  unalias ls 2>/dev/null
fi
#	#COLOR_FLAG=${COLOR_FLAG:-YES}
if env|grep COLOR_FLAG=YES >/dev/null; then
  alias ls="ls --color=auto -p"
  alias grep="grep --color=auto"
else
  alias ls="ls --color=never -p"
  alias grep="grep --color=never"
fi
alias lsc="ls --color -p"
alias ls.='ls -d .??* | grep -v ^d '
alias ll="ls -lF -p"
alias la="ls -aF -p"
alias lA="ls -AF -p"
alias lla="ls -laF -p"
alias lst="ls -ltr -p"
alias lsth="ls -ltrh -p"
alias lss="ls -lShr -p"
alias dtime="date +%Y%m%d-%H%M"
alias idun="id -un"


alias cpuvmflags="sudo egrep '^flags.*(vmx|svm)' /proc/cpuinfo"
# because I do this everyday (it is my calculator)
alias bcl="bc -l " # consider qalc / qalculate
# notes - I often need this below to convert threads to hex or back to deci
#$ echo "ibase=16; 7A15 "| bc # provides h2d answer: 31253
#$ echo "obase=16; 31253 "| bc # provides d2h anser: 7A15

alias diffit="sdiff --suppress-common-lines " # requires two file names as args
alias clscr="cd ~;clear"


##########
llh ()  # human readable ls -l .... this one is experimental
########### 
{
  echo "ls long human readable"
  ls -l $*  | \
    awk '{if (length($5)>5){$5=int($5/1024)"k"};
          if (length($5)>5){$5=int($5/1024)"M"};
          if (length($5)>5){$5=int($5/1024)"G"};
    print $0}'
}

#alias lsh="ls -d .[^.]* ..?*"            # All hidden files
#   or - also for hidden files - take your pick
#alias l.="ls -d .*"

# This is to show ALL files including bogus (hidden) characters and
# it will place a "$" at the end so you can see spaces or tabs at the
# end of files... it can help you find when you have been hacked.
alias lsv="ls -l | cat -vet"

alias +=pushd
alias _=popd

# Show all programs connected or listening on a network port
alias nsl='netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2'



# I use vim whenever I can ... it has WAY too many advantages
#   to ignore ...
#if [ -f $HOME/.vim_alias_flag ] && type -p vim >/dev/null 2>&1 ; then
if [ -f $HOME/.vimrc ] &&  type -p vim >/dev/null ; then
  #alias vi="vim -u $HOME/.vimrc"
  # here is a tip folks - if you experience:
  #    - slow vim loads of files (regardless of size)
  #    - see and ending warning about "no protocol specified"
  # use the -X argument to disable the X clipboard connections that vim by
  # default is attempting. 
  alias vi="vim "
  export EDITOR=vi
fi
#else
#  if [ -f $HOME/.vimrc ] ; then
#    echo Found [$HOME/.vimrc] ...consider using the function [setvim on]...
#  fi
  export EDITOR=vi
#fi
alias vu=view


#########
dirsum ()
#########
{
  # this is just a fun little ditty
  ls -l | awk '{sum +=$5};END{print "Directory Sum: "sum/1024/1024" MB"}'
}

alias sdus="sudo du -sk ./ | sort -n"
#alias dus="du -sk $1 * | sort -n"
dus ()
{
  if [ x$1 = x-h ]; then
    du -sh $2 * | sort -n
  else
    du -sk $1 * | sort -n
  fi
}

# See the function "dusp"

#alias scp="scp -c blowfish " # this is 20% faster on large files but it has been removed from default ssh
alias scpb="scp -c blowfish " # it 20% faster - what can I say

# See exports above related to RCS (not CVS!) - JUST USE CVS!!!
# Note that to check something in while leaving a read only copy use:
#  ci -u filename  
#     or (whatever is appropriate)
#  co -l filename
#alias chkout="co -l"
#alias chkin="ci -u"
alias ci=vi # this is to correct for my typos

if type -p tkcvs >/dev/null 2>&1 ; then
  alias tkcvs="cd $DEV;tkcvs &"
fi

alias r="fc -s"      # recall last command - good in most shells or settings.

#alias gomenu="gomenu -C $@"  # my menu program launched with color...

# I got used to using HPUX's lpstat so...
if type -p lpc >/dev/null 2>&1; then
  alias lpstat="/usr/sbin/lpc status"
fi

# I hate typing startx - call it lazy...
# and I move to tmp first because that's where I want all browser downloads
# to go - this just makes it easier - of course you need the $HOME/tmp 
# directory. I added an exit for security
if uname -a | grep -i Linux >/dev/null; then
  alias x="cd $HOME/tmp;startx $*;exit" # the exit for additional security
fi

# Likewise: make sure downloads go to the ~/tmp dir
#alias lynx="cd $HOME/tmp;lynx"

# This one is for fast root access using su - here's what you do
# run "su" (note: you can't use "su -"  because of login restriction) 
# then put in the password - this gives you root access with
# the root environment (this is NOT a hack/crack trick).  Then, when
# you want to return as your normal self (regular user) type "suspend" or 
# use this alias.  Do what you need as regular user.  Then type "fg" 
# (foreground) to restore the root access session... use suspend to go 
# back ... etc
alias sus="suspend"
# I use this next one all the time...
# this next one might work with sudo -i
#alias super="sudo su root -c $SHELL" # can also be done with sudo -i
alias super="sudo -E $SHELL" # this retains your environment but makes you root
# note sudo -i does the same thing essentially

# my ipchains firewall is set up to block ports below 1024 (privileged ports)
# so in order to make ssh work through it I need this:
# hmmm got fixed in version 2.51 of Portable OpenSSH
# Woops got broken in alpha 7.1 RH releases.... putting it back now.
# This is now deprecated - due to enhancements to ssh...
#alias ssh="ssh -P"

alias tmp="cd ~/tmp"
alias dev="cd $DEV"
alias gitdir="cd $DEV/git"

# short cut for using sudo vim
alias svi="sudo vi"

# for TODO package use
if type -p devtodo >/dev/null; then
  # I also like the devtodo package at swappoff.org so....
  
  TODO_OPTIONS="--timeout --summary"
  
  cd()
  {
    if builtin cd "$@"; then
      devtodo ${TODO_OPTIONS} all
    fi
  }
  
  pushd()
  {
    if builtin pushd "$@"; then
      devtodo ${TODO_OPTIONS}
    fi
  }
  
  popd()
  {
    if builtin popd "$@"; then
      devtodo all
    fi
  }
  
  # now fire it up on login
  # actually I put this in the .bash_local file now
  #processCMD devtodo children
fi
#### end todo package settings ###


function lsmodg ()
{
  lsmod | grep -i $1
}

############################################
# ============= End Alias's ================
############################################

############################################
# ======= Defines - Prompt Control ========
############################################
# set up variables for prompt
# see this line above !!! "export PROMPT_STYLE=COLOR" to toggle color on or off
# Note:   <--is the escape char. You can use Cntrl-V Escape to create it
# in vi or use this for example RED="-e \033[31m" - \033=ESC and the -e
# means interpret \### as an ascii char. Or use $'\033\'[31m (bash)
# Another option is to use tput like this (this doesn't universally work for me)
# tput setf {2}  # set green foreground
# tput setb {0}  # set black background
# color stays changed until you change it to something else (usually NORMAL)

##############
initCOLOR ()
##############
{
  COLOR_FLAG=${COLOR_FLAG:-YES} # Can be YES or NO - I use color to easily 
  export COLOR_FLAG
  if [ "x$COLOR_FLAG" = "xYES" ]; then
    BLACK=$'\033'"[30m"
    RED=$'\033'"[31m"
    GREEN=$'\033'"[32m"
    YELLOW=$'\033'"[33m"
    BLUE=$'\033'"[34m"
    MAGENTA=$'\033'"[35m"
    CYAN=$'\033'"[36m"
    WHITE=$'\033'"[37m"
    BRIGHT=$'\033'"[01m"
    BLINK=$'\033'"[05m"
    REVERSE=$'\033'"[07m"
    NORMAL=$'\033'"[0m"
    LINE="${YELLOW}============================================================${NORMAL}"
  else
    BLACK=''
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    MAGENTA=''
    CYAN=''
    WHITE=''
    BRIGHT=''
    BLINK=''
    REVERSE=''
    NORMAL=''
    LINE="============================================================"
  fi
  export LINE
}
# now lets run that function
initCOLOR
SLINE="-------------------------------------------------------------"

# Just a note here: if your terminal gets munged by cat'ing a binary
# file try resetting it with "stty sane" or "tput sgr0"

# Fix TERM setting before using tput or tset commands...
#if [ "$OS" = "sun" ] && [ "$TERM" = "linux" ]; then
#  TERM=vt100
#fi
if [ "x$TERM" = "x" ]; then
  TERM=vt100
  #echo TERM=$TERM
fi

if [ "$OS" != "linux" ] && [ "$TERM" = "linux" ]; then
  TERM=vt100
  #echo TERM=$TERM
fi

if [ "$TERM" = "sun" ]    || \
   [ "$TERM" = "dtterm" ] || \
   [ "$TERM" = "cygnus" ] || \
   [ "$TERM" = "hp" ]     ; then
   #[ "$TERM" = "screen" ] ; then
  # just get rid of problems from vendor specific term settings
  TERM=vt100
  #echo TERM=$TERM
   #[ "$TERM" = "Eterm" ] || \
fi
if [ "$OS" = "sun" ] && [ "$TERM" = "screen" ]; then
  TERM=vt100
  SCR="YES"
  #echo TERM=$TERM
fi
if env | grep DISPLAY= >/dev/null; then
  TERM=xterm
fi
export TERM

# The suggestion to use tput commands came from Bruce Verderaime
# This makes this portable across all TERM settings - thanks Bruce!
# See terminfo man page for more info...
# Had to go back to escape codes - this is slow and scp crapped out on it
# no matter how I did the TERM variable
# BLACK="`tput setaf 0`"
# RED="`tput setaf 1`"
# GREEN="`tput setaf 2`"
# YELLOW="`tput setaf 3`"
# BLUE="`tput setaf 4`"
# MAGENTA="`tput setaf 5`"
# CYAN="`tput setaf 6`"
# WHITE="`tput setaf 7`"
# BRIGHT="`tput bold`"
# NORMAL="`tput sgr0`"
# BLINK="`tput blink`"
# REVERSE="`tput smso`"
# UNDERLINE="`tput smul`"
 
# ========= Prompt Control ================
# sample bash-prompt
# surround all non-printable characters (color codes) with '\[' and '\]' 
# to avoid cursor/display problems on long command lines...
# TERM or DISPLAY control

# If the TERM variable is for emacs turn off color prompt
#   You may want to add others - then I would turn this into 
#  a case/esac routine
if [ "$TERM" = "emacs" ]; then
    export PROMPT_STYLE=""
fi

if [ "$TERM" != "linux" ] && [ "x$DISPLAY" = "x" ] ; then
  export DISPLAY=$(hostname):0.0
fi

# ======= History Control HISTORY ==========
export PROMPT_COMMAND='history -a'
# now each time my command has finished, it appends the unwritten history 
# item to ~/.bash_history before displaying the prompt (only $PS1) again.
HISTSIZE=75000
export HISTSIZE
# or unset HISTSIZE to avoid truncation
##export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTTIMEFORMAT="%F %T "
#HISTFILE=${HOME}/.bash_history_`who am i|awk '{ print $1}'`
#export HISTFILE
#date >>$HISTFILE


###### Set the prompt style to color or non-color #######
setprompt ()
#########################################################
{
if [ "$PROMPT_STYLE" != "COLOR" ] ; then
  PS1="\n\d \t TTY=`tty` TERM=$TERM\n\u@\h ...\W \\$ ";
else
  if grep lightbackground $HOME/.color_prompt_flag>/dev/null; then
    PS1="\n\[${BLUE}\]\d \t \[${BRIGHT}${BLACK}\]TTY=\[${NORMAL}${RED}\]`tty` \[${BRIGHT}${BLACK}\]TERM=\[${NORMAL}${RED}\]$TERM\[${BLACK}\]\n\[${BRIGHT}${BLUE}\u${BLUE}@${BRIGHT}${BLUE}\]\h:\[${BLACK}\] ...\W \\$ \[${NORMAL}\]"
  else
    PS1="\n\[${BRIGHT}${YELLOW}\]\d \t \[${NORMAL}\]TTY=\[${RED}\]`tty` \[${NORMAL}\]TERM=\[${RED}\]$TERM\[${WHITE}\]\n\[${BRIGHT}${BLUE}\u${CYAN}@${BRIGHT}${BLUE}\]\h:\[${WHITE}\] ...\W \\$ \[${NORMAL}\]"
  fi  
fi
if [ x$1 = "xsimple" ]; then
  # make it simple
  PS1="\u@\h:...\W \\$ "
  export PS1
  #echo Just made the prompt simple: $PS1
fi
}

setprompt

# The code below comes from O'Reilly's Unix Power Tools 2nd edition pg 113
#   but isn't normally needed - it is here for instructional purposes only
#trap setprompt 5
#while :
#do
#  kill -5 $$
#  sleep 10
#done &
#PROMPTpid=$!; export PROMPTpid
#if ! grep PROMPTpid $HOME/bash_logout >/dev/null ; then
#  # This will kill the while loop above when you logout...
#  echo kill $PROMPTpid >> $HOME/bash_logout
#fi
######## End Prompt Control ##################

###############################################
# =============== FUNCTIONS ================= #
###############################################

########################################
askYN () # Ask yes or no prompt function
########################################
{
# expects param 1 to be prompt string
# param 2 is optional default ans (case does not matter)
# default to N without any other direction...
# always returns a capital Y or N in ANS variable
# this function will always return 0 if the ANSwer is Y     else it returns 1
# EXAMPLE:
# if askYN "Are you happy" y ; then ...
#
  ANS="N"

  if [ $# -lt 1 ]; then
    #ERRFLAG=1
    #doEXIT "This function requires more paramters [askYN]"
    # Assume that the user want a simple prompt to continue
    echo Hit ENTER to continue... use Ctrl-c to cancel out...
    return
  fi

  # Set the default
  case "$2" in
    [Yy]|[Yy][Ee][Ss] )
      ANS="Y"
      ;;
    [Nn]|[Nn][Oo] )
      ANS="N"
      ;;
  esac

  while : ; do
    printf "$1 (y/n [$ANS]): "
    read myANS
    case "$myANS" in
      [Yy]|[Yy][Ee][Ss] )
        ANS="Y"
        break
        ;;
      [Nn]|[Nn][Oo] )
        ANS="N"
        break
        ;;
      * )
        break
        ;;
    esac  
  done
  export ANS
  if [ "${ANS}x" = "Yx" ]; then
    return 0
  else
    return 1
  fi
}

#################
doEXIT ()
#################
{
  echo $LINE
  if [ "$*x" != "x" ]; then
    echo $*
  fi
  echo Done... Enjoy!
}

############
setHOME () # setup home dir - EXPERIMENTAL
############
{
  echo Puts the latest .bashrc in ~/dev and then gets Companionway gomenu and vim pkgs
  echo and links .bashrc .vimrc and .screenrc to the home dir.
  if ! type -p ssh >/dev/null; then
    echo Please install ssh ...
    return
  fi
  if ! type -p cvs >/dev/null; then
    echo Please install cvs...
    return
  fi

  CHECKOUT_DIR=$HOME/dev/
  #CHECKOUT_DIR=$HOME/dev/cvs
  if ! [ -d $CHECKOUT_DIR ]; then
    mkdir -p $CHECKOUT_DIR
  fi

  processCMD cd $CHECKOUT_DIR
  CVSUSER=cvsuser
  CVS_HOST=hype.companionway.net
  CVS_REPOS=/data/share/cvsroot

  printf "Please indicate what user you would like for the cvs access [${CVSUSER}]: " 
  read myCVSUSER
  if [ x"$myCVSUSER" != "x" ]; then CVSUSER=$myCVSUSER; fi

  printf "Please indicate what host you would like for the cvs access [${CVS_HOST}]: " 
  read myCVS_HOST
  if [ x"$myCVS_HOST" != "x" ]; then CVSUSER=$myCVS_HOST; fi

  #echo See the sample .bashrc for ${CVSUSER} password...
  
  if ! [ -d $CHECKOUT_DIR/gomenu ]; then
    processCMD setcvs
    if [ ! -f ~/.CVS_Root_flag ]; then
      echo ":ext:${CVSUSER}@${CVS_HOST}:${CVS_REPOS}">~/.CVS_Root_flag
      #processCMD sshkeypush ${CVSUSER} ${CVS_HOST}
    fi

    echo This is used only to get the first ${CHECKOUT_DIR}/.bashrc source file.
    # don't change the user below...
    #processCMD scp ${CVSUSER}@${CVS_HOST}:${CVS_REPOS}/gomenu/sample.bashrc ./
    #processCMD source .bashrc

    processCMD cd $CHECKOUT_DIR # not needed but makes it clear
    processCMD cvs co gomenu utils vim
  else
    echo It appears that $CHECKOUT_DIR/gomenu exits...
  fi

  if ! [ -h $HOME/.bashrc ]; then
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc.`date +%Y%m%d-%H%M`
    processCMD ln -s $CHECKOUT_DIR/gomenu/sample.bashrc $HOME/.bashrc
  else
    echo It appears that ~/.bashrc is linked...
  fi

  if ! [ -h $HOME/.vimrc ]; then
    [ -f $HOME/.vimrc ] && mv $HOME/.vimrc $HOME/.vimrc.`date +%Y%m%d-%H%M`
    processCMD ln -s ${CHECKOUT_DIR}/vim/sample.vimrc $HOME/.vimrc
    processCMD ln -s ${CHECKOUT_DIR}/vim/vimrc-files $HOME/vimrc-files
  else
    echo It appears that ~/.vimrc is linked...
  fi

  if ! [ -h $HOME/.screenrc ]; then
    [ -f $HOME/.screenrc ] && mv $HOME/.screenrc $HOME/.screenrc.`date +%Y%m%d-%H%M`
    processCMD ln -s ${CHECKOUT_DIR}/vim/sample.screenrc $HOME/.screenrc
  else
    echo It appears that ~/.screenrc is linked...
  fi

  cd
  echo Consider running: sshkeypush $CVSUSER companionway.net if needed
}

##########
doTITLE ()
##########
{
  # echo
  echo $LINE
  echo "   $*"
  echo $LINE
}

###########
subTITLE ()
###########
{
  echo 
  echo "+---------------------------------------"
  echo "| *** $*"
  echo "+---------------------------------------"
}

##################################################
vers () # get version for .bashrc
##################################################
{
  doTITLE Version for this .bashrc script
  echo Revision$(echo $VERSION |sed s/\\$//g )
  echo Date$(echo $VDATE|sed s/\\$//g )
  doEXIT
}

##################################################
wordfreq () # counts frequency of words and sorts
##################################################
{
  doTITLE "wordfreq function"
  if [ $1x = x ]; then
    echo Usage: $FUNCNAME file_name
    return 1
  fi
  tr -c a-zA-Z '\n' < $1 |sort -f |/usr/share/dict/words - |uniq -i -c |sort -n
  doEXIT
}

###################################################
lsfuncs () # lists all the functions in this .bashrc or param 1
###################################################
{
#  You might want to remember this one - because it lists all
#     the functions for you.
# Note - to list all the loaded functions use typeset -F
# To get a detailed listing use: declare -f
doTITLE "lsfuncs [\$1] - List of functions in this .bashrc or \$1 script"
if [ -f "$1" ]; then
  THIS_SCRIPT=$1
  echo Found \$1=$1
else
  THIS_SCRIPT=$HOME/.bashrc
fi

if type -p less>/dev/null; then
  PAGER=less
else
  PAGER=more
fi
#compgen -A function # this one works great too
egrep "^[A-Za-z0-9].* \(\) #" $THIS_SCRIPT | \
  $AWK_CMD 'BEGIN {FS = "#" }
  {printf ("%-13s %s\n",$1 ,$2 )| "sort" } ;' |\
  $PAGER
doEXIT
}

######################
lsplmods () # list perl modules
######################
{
  doTITLE "lsplmods - List of Perl Modules"
  if ! type -p perl>/dev/null; then
    echo I failed to find perl on this system.
  else
    find `perl -e  'print "@INC"'` -name '*.pm' -print
  fi
  doEXIT
}

######################
lsum () # prints the total size in bytes for file that match the pattern
#######################
{
doTITLE "lsum - Print total size for each matched file"
if [ "$1x" = "x" ]; then
  echo Usage: $FUNCNAME file_pattern
  echo "  NOTE: you must put quotes around any global substitutions"
  echo "  for example: lsum \"*tst*\" "
  return 2
else
  echo Here is a list of matching files...
  echo $LINE
#  LST=`echo $1|sed -e "s/\*/\\\*/"`
#  echo LST=$LST
  ls -l $1 |$AWK_CMD 'BEGIN {tot=0;} {print $0; tot += $5;} END {printf "'$LINE'\n\t\t\t\tTotal= "tot" bytes\n" ;}'WK_CMD:u
fi
doEXIT
}

########################################
setcolor () # setcolor on|off for the prompt
########################################
{
doTITLE "setcolor - Turn color prompt on or off function [on|off] [lb|db]"
if [ "$1" != "on" ] && [ "$1" != "off" ] ; then
  echo "Usage: $FUNCNAME [ on|off ] [ lb | db ]"
  echo "  lb = for a light background term session"
  echo "  db = for a dark background term session"
  return
fi
if [ "$1" = "on" ]; then
  echo "This is for turning ON the color prompt" > $HOME/.color_prompt_flag
  if [ "$2" = "lb" ]; then
    echo "for a lightbackground term session" >> $HOME/.color_prompt_flag
  else
    echo "for a darkbackground term session" >> $HOME/.color_prompt_flag
  fi
else
  # otherwise remove the flag file and the result is no color
  rm -f $HOME/.color_prompt_flag
  # Uncomment following line if you want to disable colors in ls
  DISABLE_LS_COLORS="true"
fi
exec $SHELL
}

########################################
setvim () # setvim on|off for the prompt
########################################
{
doTITLE "setvim - set vi aliased to vim function [on or off]"
if [ "$1" != "on" ] && [ "$1" != "off" ] ; then
  echo "Usage: $FUNCNAME on|off"
  return
fi
if [ "$1" = "on" ]; then
  echo "This is for turning on the vim alias" > $HOME/.vim_alias_flag
  alias vi=vim
  export EDITOR=vim
else
  # otherwise remove the flag file and the result is no vim alias
  unalias vi
  rm -f $HOME/.vim_alias_flag
fi
exec $SHELL
}

###########################################################
moveit () # move to a dated filename or [-s] [filename] to remove spaces or [-o] [filename] to move o OLD.filename
###########################################################
{
DTIME=$(date +%Y%m%d-%H%M)
if [ $# = 0 ]; then
  echo Usage 
  echo "   $FUNCNAME filename [move filename to finename.$DTIME"
  echo "or $FUNCNAME -s \"filename\" [moves file name file-name]"
  echo "or $FUNCNAME -o filename [moves filename to OLD.filename]"
  echo "or $FUNCNAME -O filename [moves filename to ORIG.filename]"
  return
fi
OLD_NAME=""
NEW_NAME=""
NOSPACES_NAME=""
DIR=""
BASE_DIR=""
BASENAME=""

if [ "x$1" = "x-s" ]; then
  # remove spaces - replace with a dash "-"
  NOSPACES_NAME=`echo $2 | tr " " "-"`
  OLD_NAME=\"$2\"
  BASE_DIR=$(dirname "$2")
  BASE_DIR=${BASE_DIR:-"./"}
  DIR=$BASE_DIR
  DIR=${DIR:-"./"}
  NEW_NAME=$NOSPACES_NAME
  #echo DEBUG: 1st param is -s and BASE_DIR=[$BASE_DIR] DIR=[$DIR] NEW_NAME=[$NEW_NAME]
fi


if [ "x$1" = "x-o" ] && [ -f "$2" -o -d "$2" ]; then
  # these blocks are to rename file to OLD.filename
  if [ -d $2 ]; then
    DIR="."
  fi
  if [ -f $2 ]; then
    # if this is a file and not a directory to be moved
    BASE_DIR=$(dirname $2)
    DIR=${DIR:-"$BASE_DIR"}
  fi
  BASENAME=$(basename $2)
  OLD_NAME=$2
  NEW_NAME=OLD.$BASENAME 
fi

if [ "x$1" = "x-O" ] && [ -f "$2" -o -d "$2" ]; then
  # these blocks are to rename file to ORIG.filename
  if [ -d $2 ]; then
    DIR="."
  fi
  if [ -f $2 ]; then
    # if this is a file and not a directory to be moved
    BASE_DIR=$(dirname $2)
    DIR=${DIR:-"$BASE_DIR"}
  fi
  BASENAME=$(basename $2)
  OLD_NAME=$2
  NEW_NAME=ORIG.$BASENAME 
fi

# to deal with default or one of the above
#BASE_DIR=${BASE_DIR:-`dirname $1`}
DIR=${DIR:-"$BASE_DIR"}
if [ -f $1 ]; then
  BASENAME=${BASENAME:-`basename $1`}
fi
OLD_NAME=${OLD_NAME:-$1}
NEW_NAME=${NEW_NAME:-$BASENAME.$DTIME}

#echo DEBUG: BASE_DIR=[$BASE_DIR] DIR=[$DIR] BASENAME=[$BASENAME] DIR=[$DIR] NEW_NAME=[$NEW_NAME]
processCMD mv $BASE_DIR/"$OLD_NAME" $DIR/$NEW_NAME
[ $? -eq 0 ] && echo $BASENAME has been moved to $DIR/$NEW_NAME|sed "s#\/\/#\/#" || echo move failed...

return
}

###########################################################
saveit () # Save a dated backup copy of a file 
###########################################################
{
doTITLE "saveit - Saves a dated copy of filename supplied to function"
if [ "x$1" = "x" ] && [ ! -f "$1" ] ; then
  echo "Usage: $FUNCNAME file_to_save [path_for_save]"
  return
fi
if [ "x$2" != x ] && [ ! -d "$2" ] ; then
  echo "Usage: $FUNCNAME file_to_save [path_for_save]"
  return
else
  DIR=$2
fi
BASENAME=$(basename $1)
# NOTE: basename can also be determined with this
#  BASENAME=${0##*/}    (works in ksh too)
# also you can grab the dirname like this:
#  DIRNAME=${0%/*} 
# If you want the DOMAINNAME - try this 
# DOMAINNAME=`echo myhost.mydomain.name | sed 's/^[^\.]*\.//'`

## if DIR isn't set (see above) then make it the BASE_DIR
BASE_DIR=$(dirname $1)
DIR=${DIR:-"$BASE_DIR"}
#DTIME=$(date +%Y%m%d-%H:%M) # the colon throws off scp and rsync etc
DTIME=$(date +%Y%m%d-%H%M)
processCMD cp -r $1 $DIR/$BASENAME.$DTIME # will recursively cp a dir 
echo $BASENAME has been copied to $DIR/$BASENAME.$DTIME|sed "s#\/\/#\/#"
doEXIT
}

###########################################################
rcbu () # Remote cpio back-up (uses rsh or remsh and cpio-version specific)
###########################################################
{
if [ $# != 3 ]; then
  echo "Usage: $FUNCNAME source_dir remote_host target_dir"
  echo "Note: uses cpio and rsh|remsh to make transfers"
else
  doTITLE "Remote cpio of $2:$1 ->localhost:$3 "
  if ( uname |grep Linux ) ; then
    RCMD=rsh
  else
    RCMD=remsh
  fi
  if ! [ -d "$1"  ]; then
    echo $1 does not appear to be a dir...
    echo Exiting....
    return
  fi
  cd $1
  find . -xdev -print | cpio -ocva | $RCMD $2 \( cd /$3 \; cpio -icdum --no-absolute-filenames \)
  doEXIT
fi
}

###########
tlog () # tail a standard log
########
{
FILE_STR=${1:-syslog} # this is a good default to debian - change as desired
DIRS="/var/log /var/adm"
CMD="tail -100f "  ### this is where the rubber meets the road ###
LIST=`find -L $DIRS -name $FILE_STR\* -type f -a ! -name \*\.[0-9]\* -a ! -name \*.gz 2>/dev/null | grep -v install 2>/dev/null | sort`
# this next line does not seem to work....?
trap 'echo $SLINE;echo Finished: $CMD $LIST;echo $SLINE' INT
if [ `echo $LIST | wc -w` = 1 ]; then
  #echo Hit ENTER when ready to $CMD $LIST; read ANS
    if ! [ -r $LIST ] ; then
      # try sudo
      echo Trying sudo $CMD ...
      processCMD sudo $CMD $LIST
    else
      processCMD $CMD $LIST
    fi
  return
else
  LIST="$LIST quit"
  select i in $LIST; do
    [ x"$i" = "xquit" ] && return
    if [ ! -r $i ] ; then
      echo Exiting - file not readable for string [$i]...;break
      # try sudo
      processCMD sudo $CMD $i
    else
      trap 'echo $SLINE;echo Finished: $CMD $i;echo $SLINE' INT
      echo $CMD $i \| zenity --info-text --width 700 --height 400
      #if type -p zenity ; then # this is a WIP
      #  $CMD $i | zenity --text-info --width 1000 --height 500 ##--progress --auto-kill
      #else
        processCMD $CMD $i
      #fi
    fi
    ####
    if [ $ERRFLAG -ne 0 ]; then
      echo You may have a permissions issue consider adding yourself to the adm group or similar  
    fi
    return
  done
fi
}

###########################################################
tmsgs () # tail -100f /var/log/messages
###########################################################
{
# this is a fallback if nothing else works
LOGFILE=$MESSAGES_LOGFILE

if [ -d /var/log ] ; then 
  LOGDIR=/var/log
fi
if [ -f $LOGDIR/$1 ]; then 
  LOGFILE=$LOGDIR/$1
else
  if [ 1 = `find $LOGDIR -name $1 -type f 2>/dev/null | wc -l` ]; then
    LOGFILE=`find $LOGDIR -name $1  -type f 2>/dev/null`
  else
    if [ 1 = `find $LOGDIR -name $1.log  -type f 2>/dev/null | wc -l` ]; then
      LOGFILE=`find $LOGDIR -name $1.log  -type f 2>/dev/null`
    fi
  fi
fi

LOGFILE=${LOGFILE:-$1}

if [ $UID != 0 ] ; then
  #echo You need to be root to open the file...
  if [ "x$2" = "x" ]; then
    #su -l root -c "tail -100f $LOGFILE"
    processCMD sudo tail -100f $LOGFILE
    ERRFLAG=$?
  else
    # $2=number of lines
    #su -l root -c "tail -$2f $LOGFILE"
    processCMD sudo tail -$2f $LOGFILE
    ERRFLAG=$?
  fi
else
  doTITLE "tmsgs logfilename"
  if [ "x$2" = "x" ]; then
    processCMD tail -100f $LOGFILE
    ERRFLAG=$?
  else
    processCMD tail -$2f $LOGFILE
    ERRFLAG=$?
  fi
fi
}

###########################################################
cbu () # cpio back-up (cpio version specific)
###########################################################
{
if [ $# != 2 ]; then
  echo "Usage: $FUNCNAME source_dir target_dir"
else
  if ! [ -d "$1"  ]; then
    echo $1 does not appear to be a dir...
    echo Exiting....
    return
  fi
  if ! [ -d "$2" ]; then
    echo $2 does not appear to be a dir...
    echo Exiting...
    return
  fi
  doTITLE "cpio backup of $1 -> $2"
  cd $1
  echo "You are about to copy everything from `pwd` to $2."
  echo -e "Is this correct [y/n] \c"
  read ANS
  if [ "$ANS" != "y" ]; then
    return  
  else
    find . -xdev -print | cpio -ocva | ( cd /$2; cpio -icdum --no-absolute-filenames )
    # Note: here's another method but it sends over full absolute
    # pathnames:
    # tar cf - /where/ever | (cd /where/ever/else ; tar -xvf - ) 
    doEXIT
  fi
fi
}

###########################################################
rcmd ()  # remote command execution using perl (INSECURE!)
###########################################################
# This is just another sample function to demonstrate the power
# of perl using a shell script to get there... this is a DANGEROUS
# function due to the fact that is is extremely INSECURE.  Your 
# password can be sniffed across the wire, it will show on a process
# listing and it will be on the history recall - all of which are 
# big "no nos".  But it is a good demo of what can be done.
# NOTE: if will fail for root because of the prompt string
# search - this is by design - DON'T USE IT AS ROOT - this
# is for your own protection - obviously if you are using it
# then you are on a net and you are sending root's  password
# out into wild clear bly sky...
# Also note that all the variables in the cat'd perl script
# had to be escaped with a preceding "\" before the "$" 
# symbol to prevent the shell from translating them.
{
if [ $# != 4 ]; then
  echo Usage: $FUNCNAME username password host 
  return
fi
if ! type -p perl >/dev/null 2>&1 ; then
  echo "Failure: perl could not be found... exiting..."
  return
fi
doTITLE "Running $1 on $2@$4 ..."
cat >/tmp/rcmd$$.tmp <<EOF
#!$perlloc
use Net::Telnet ();
\$username="\$ARGV[0]";
\$passwd="\$ARGV[1]";
\$host="\$ARGV[2]";
\$command="\$ARGV[3]";
\$t=new Net::Telnet (Timeout => 20, Prompt => '/\\$/');
\$t->open("\$host");
\$t->login(\$username, \$passwd);
@lines=\$t->cmd("\$command");
print @lines;
EOF

chmod +x /tmp/rcmd$$.tmp
/tmp/rcmd$$.tmp $1 $2 $3 $4
#rm -f /tmp/rcmd$$.tmp
doEXIT
}

##############################################
fsuid () # find suid files
##############################################
{

doTITLE "Files that have suid flags set"
echo $LINE
if [ $UID != 0 ]; then
  su - root -c "find / -type f \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \;"
else
  find / -type f \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \;
fi
doEXIT
}

#########################################
tresponse ()  # timed response using perl
#########################################
# Here's another little perl sample that provides something that is 
# missing in most shells - a timed response capability.  For example,
# if you want to ask a user for a response in most shells, it will
# wait forever at the "read RESPONSE" line.  This didy gives you
# a timed response funtion.  It returns the user input to STDIO.
# Note that all the variables in the cat'd perl script
# had to be escaped with a preceding "\" before the "$" 
# symbol to prevent the shell from translating them.

#if [ "x$1" = "x" ]; then
#  echo Usage: $FUNCNAME seconds_to_wait
#  exit
#fi
#if ! type -p perl >/dev/null 2>&1 ; then
#  echo Could not locate perl... exiting...
#  return
#fi
#
#cat >/tmp/tresponse$$.tmp <<EOF
##!$perlloc
#\$SIG{ALRM} = sub { die "timeout" };
#if ( @ARGV > 0 ) {
#  \$ARGV[0]=~ /\\d/ || die "First param must be a number...";
#}
#\$ARGV[0]=\$ARGV[0] || 10;
#eval {
#  alarm(\$ARGV[0]);
#  # long time operation
#  \$response = <STDIN>;
#  alarm(0);
#};
#if (\$@) {
#  if (\$@ =~ /timeout/) {
#    # timed out - do what you want here
#    exit 1;
#  } else {
#    alarm(0);  # clear the pending alarm
#    die        # propagate unexpected exception
#  }
#}
#print \$response;
#EOF
#
#chmod +x /tmp/tresponse$$.tmp
#/tmp/tresponse$$.tmp $1
#rm -f /tmp/tresponse$$.tmp

############################################
# I lied - there is a way to do it in the shell
# using "read -t" - this might be a better solution
{
if [ "x$1" = "x" ]; then
  echo Usage: $FUNCNAME seconds_to_wait
  exit
fi

read -e -t $1 RESPONSE <&1
if [ -z "$RESPONSE" ]; then
  echo "Timed out in $1 seconds..."
else
  echo $RESPONSE
fi
}

###############################
tacit () # read a file backwards when tac is not available
###############################
{
# dont ask how it works - just use it
if [ $# -ne 1 ]; then
  echo Usage: $FUNCNAME filename
  return 99
fi
sed -e '1!G;h;$!d' $1
}

###########################################################
lfdisk () # list the fdisk output for device
###########################################################
{
if [ "x$1" = "x" ]; then
  echo Usage: $FUNCNAME /dev/device_to_list 
  return
fi
doTITLE "Listing of partitions on $1" 
if [ $UID != 0 ]; then
  processCMD su -l root -c \"fdisk -l $1\"
else
  processCMD fdisk -l $1
fi
doEXIT
}

###########################################################
h () # quick help for .bashrc
###########################################################
# UNIX (linux) can be hard to learn if you don't know how to get help
# so....
{
if [ -f ~/help.nts ]; then
  HELP_FILE=${HELP_FILE:-~/help.nts}
else
  if [ -f ~/dev/utils/help.nts ]; then
    #ln -s ~/dev/utils/help.nts ~/
    HELP_FILE=${HELP_FILE:-~/dev/utils/help.nts}
  else
    echo Could not find the file: help.nts
    return
  fi
fi
if [ "x$1" = "x-e" ]; then
  processCMD $EDITOR $HELP_FILE
  return
fi
if [ ! "x$1" = "x" ] && [ ! "x$1" = "x-e" ]; then
  processCMD sed -ne \'/\\[.*$1.*\\]/,/\\[[a-zA-Z ]*.*\\]/p\' $HELP_FILE \| sed -e \'\$d\'
  return
fi

doTITLE "Help for this .bashrc"
HELP_FILE=~/help.nts
case $1 in
  -e )
   $EDITOR $HELP_FILE
   ;;
  [a-ZA-Z]* )
   #echo DEBUG: we are here; read ANS
   sed -ne "/\[$1.*\]/,/\[.*\]/p" $HELP_FILE | sed -e '$d'
   ;;
esac

if [ $# -eq 0 ]; then
cat << EOF
Try:
  lsfuncs                     <-- to list all the .bashrc functions
  type <function_name>        <-- to see the source code for the function
  man -k string-to-look-for   <-- to see what MIGHT be available
	lscmds                      <-- to list all cmds in your path

Use the "tab" key generously! (Invoke command or file completion)
  Type this:
    d<Tab><Tab>

RedHat keeps all the docs here:
    /usr/docs   or   /usr/share/doc

You can type "help|more" at the command line, but it is pretty lame.
 
$FUNCNAME -e allows you toedit your own $HELP_FILE file
 given a format of
[mysql]
 This is helpfor mysql

[lsof]
  lsof -i :3306 # show process info using port 3306

 Then use this to get specific info yu have written:
  $FUNCNAME mysql
       or
  $FUNCNAME lsof

NOTE: csh - use ESC for file completion
        csh ... set history=100
        csh set prompt='% '
      ksh - use ESC ESC for file completion
    use stty erase [Ctrl-v backspace] for reset the backspace key 
    If you "set -o vi" then use "Esc-\" key combo for command or file completion.
EOF
doEXIT
fi
}

###########################################################
ladd () # local address for interface given
###########################################################
# Get local address for choice of interface
{
STR=$1
if [ "x$1" = "x" ]; then
  echo "Usage: $FUNCNAME interface"
  echo For references here is a listing of your interface addresses:
  # for all active interfaces
  ifconfig | $AWK_CMD '/Link/{IFDEV=$1;getline;if($1~/inet/&&$2~/addr:[0-9]/)split($2,iaddr,":"); print IFDEV" "iaddr[2];}'
  return 1
else
  /sbin/ifconfig -a | $AWK_CMD '( $1 ~ /'$STR'/ ) {getline ;print $2; }' | \
  /sbin/ifconfig $1 | $AWK_CMD '/addr/{print $2; }' | \
  $AWK_CMD 'BEGIN {FS=":"} {print $2}'
fi
}

#######################################
myip () # get my internet IP address
#######################################
{
  dig +short myip.opendns.com @resolver1.opendns.com
  # or
  #dig TXT +short o-o.myaddr.l.google.com @ns1.google.com|sed s/\"//g
  # or
  #host myip.opendns.com resolver1.opendns.com
}

###########################################################
gwadd () # gw address default route
###########################################################
# get the default route and pull out the next hop
{
  echo "Now running: route -n | awk '$1~/0.0.0.0/ {print $2}'"
  route -n | awk '$1~/0.0.0.0/ {print $2}'
}

#######################################################
lsdu () # prints files in a dir w/size in k and a total
#######################################################
{
ls -l | $AWK_CMD 'BEGIN { tot=0; } 
  {tot += $5/1000;printf("%-20s\t%15.2f k\n",
  $9, $5/1000); } END { printf("%-20s\t %15.2f k\n", "Total: ", tot);
  }'
}

###########################################################
lspath () # lists each path on a separate lines - easy to read.
###########################################################
# This code borrowed from Teach Yorseld Script Programming in 24 hours
{
doTITLE "lspath - List each PATH entry on a single line [-s]=sorted"
#OLDIFS="$IFS"
#IFS=:
#for DIR in $PATH; do
#  echo $DIR
#done | sort
#IFS="$OLDIFS"
if [ "x$1" = "x-s" ];then
  echo $PATH | tr ":" "\n" | sort
else
  echo $PATH | tr ":" "\n" 
fi
doEXIT
}

############################################
nsdump () # Full list of a domain's addresses
############################################
{
doTITLE "nsdump [domain.name] - Dump the nameserver records for a domain"
if [ "x$1" = "x" ]; then
    echo Usage: $FUNCNAME domain.name [ns_server]
    echo Note: you need a functional nameserver as this
    echo "  will use the default nameserver for it's lookup"
    return
else
    # echo ls -d $1 | nslookup # This is OLD code based on nslookup
    #  host -l $1
    # $1=domain.name
    # $2=ns_server to use (optional)
    processCMD dig axfr $1 $2
fi
doEXIT
}

##################################################
psload () # provides sorted by cpu load ps listing
##################################################
{
ps -ef | sort -n -k4,5
}

#######################################################
pwdups () # looks for duplicate UIDs in the passwd file
#######################################################
{
SEP="---------------------------------------------------------------"
FILE=/etc/passwd
THIS_UID=x
#LAST_UID=x
FOUND=FALSE
echo "     Checking $FILE for duplicate UIDs"
echo $SEP
 cut -d":" -f3 $FILE | sort -n |
 while read THIS_UID; do
   if [ "$THIS_UID" = "$LAST_UID" ]; then
      FOUND=TRUE
      echo "A dupe [UG]ID exists in the $FILE file = $THIS_UID"
      echo "It is associated with these entries:"
      grep ":$THIS_UID:" $FILE
      echo $SEP
   fi
   LAST_UID=$THIS_UID
  done
if [ "$FOUND" != "TRUE" ] ; then
 echo "            No duplicates found..."
 echo $SEP
fi
echo "Done...  Enjoy!"
}

#####################################
pwsort () # pwsort [pw_file] - password file sort by UID
#####################################
{
 if [ "x$1" = "x" ]; then
   sort -n -t":" -k3 /etc/passwd
 else
   sort -n -t":" -k3 $1
 fi
}

###########################################################
#mc () # gives mc ability to drop to current dir
###########################################################
## To give mc the ability to drop out to the directory being viewed
#{
#  MC=/tmp/mc$$-"RANDOM"
#    /usr/bin/mc -x -c on -P "$@" > "$MC"
#    cd "`cat $MC`"
#    rm -f "$MC"
#    unset MC;
#}

###########################################################
rpmvu () # rpm package contents lister
###########################################################
# This funnction reads and displays the contents of an rpm file
{
  if [ "x$1" = "x" ]; then
    echo "Usage: $FUNCNAME filename.rpm"
  else
    # rpm2cpio $1 | cpio --list
    #    or
    rpm -qpl $1
   fi
}

#########################################
rpmg () # rpm - grep for an installed pkg
#########################################
{
   if [ "x$1" = "x" ]; then
     echo "Usage: $FUNCNAME string_to_look_for"
     echo "   example: rpmg afterstep "
     echo "     will locate all installed pakges with afterstep (case insensitive)"
   else
     doTITLE "Searching for any rpm pkg with [$1] in it's name..."
#     echo $LINE
     rpm -qa | grep -i $1
#     echo $LINE
#    echo "Enjoy!"
     doEXIT
fi
}

#########################################################
sshkeypush () # pass your ssh public key to a remote host
#########################################################
{
echo This mimics what ssh-copy-id user@host does
echo But it has the advantage of creating the id_rsa.pub first.
if [ "x$2" != "x" ]; then
  RUNAME=$1
  RHOST=$2
elif [ "x$2" = "x" ] && [ "x$1" != "x" ]; then
  #RUNAME=`whoami`
  RUNAME=`id|sed -e "s/[^(]*(\([^)]*\)).*/\1/"`
  RHOST=$1
else
  echo Usage: $FUNCNAME \[remote_username\] remote_host [-1]
  return 1
fi

#if [ -f $HOME/.ssh/identity.pub ] || [ "$1x" != "x" ]; then
#if [ -f $HOME/.ssh/id_dsa.pub ]; then
if [ -f $HOME/.ssh/id_rsa.pub ]; then
  echo Attempting to pass your indentity.pub key to user $RUNAME@$RHOST...
  echo $LINE
  #cat $HOME/.ssh/identity.pub|ssh -v -l $RUNAME $RHOST 'cat >>.ssh/authorized_keys'
  if [ "x$3" = "x-1" ] || [ "x$2" = "x-1" ]; then
    #processCMD cat $HOME/.ssh/id_dsa.pub\|ssh $RUNAME@$RHOST \'cat \>\>.ssh/authorized_keys\'
    processCMD cat $HOME/.ssh/id_rsa.pub\|ssh $RUNAME@$RHOST \'cat \>\>.ssh/authorized_keys\'
  else
    #processCMD cat $HOME/.ssh/id_dsa.pub\|ssh $RUNAME@$RHOST \'cat \>\>.ssh/authorized_keys2\'
    processCMD cat $HOME/.ssh/id_rsa.pub\|ssh $RUNAME@$RHOST \'cat \>\>.ssh/authorized_keys2\'
  fi
  processCMD ssh $RUNAME@$RHOST \"chmod 0600 .ssh/authorized_keys\*\"
  echo $LINE
  echo Now you may run:  ssh  $RUNAME@$RHOST
  if askYN "Would you like to connect now" y; then
    processCMD ssh $RUNAME@$RHOST
  fi
else
  echo NOTE: For this to work you must have a null pass phrase.
  echo "   Also keep in mind that the $HOME/.ssh/authorized_keys file must"
  echo "   have permissions = 0600 or -rw------- and owned by $RUNAME."
  echo File $HOME/.ssh/identity.pub was not found.
  #echo You probably need to run ssh-keygen with a null pass phrase.
  #processCMD ssh-keygen -t dsa
  processCMD ssh-keygen -t rsa -b 2048
  processCMD $FUNCNAME $RUNAME $RHOST
  return 1
fi
echo Enjoy!
}

###########################################################
tolower () # convert input string to lower case
###########################################################
{
  if [ "x$1" = "x" ]; then
    echo Usage: tolower strings 
  else
    echo $1 | tr '[A-Z]' '[a-z]' 
      fi
}

###########################################################
dos2unix () # convert input dos file to unix
###########################################################
{
# convert a dos text file to unix (eliminate the ^Ms)
# here's a possibility
# sed 's/^V^M//g' foo > foo.new
# the above has not been tested by me yet
# or
# convert DOS newlines (CR/LF) to Unix format (LF)
# - strip newline regardless; re-print with unix EOL
#  ruby -ne 'BEGIN{$\="\n"}; print $_.chomp' < file.txt
# or
# ruby -pe 'sub! /\r\n$/, "\n"'
# or
# convert DOS newlines (CR/LF) to Unix format (LF)
# - strip newline regardless; re-print with unix EOL
# ruby -ne 'BEGIN{$\="\n"}; print $_.chomp' < file.txt
# convert Unix newlines (LF) to DOS format (CR/LF)
# - strip newline regardless; re-print with dos EOL
# ruby -ne 'BEGIN{$\="\r\n"}; print $_.chomp' < file.txt
#
  if [ $# != 2 ]; then
    echo "Usage: dos2unix inputfile outputfile"
  else
    tr -d '\015' < $1 > $2
    echo "Done... Enjoy!"
  fi
# Note: to do the opposite: unix2dos - do this
# awk '{printf("%s\r\n", $0)}' infile > outfile.txt
# or
# ruby -pe 'BEGIN{$; = "\n"}; chomp!'
}

###########
hex2dec () # convert hex to decimal
############
{
	# Thanks to Noah Robin..
  echo $1 | perl -e 'print hex(<>)'
  # notes - I often need this below to convert threads to hex or back to deci
  #$ echo "ibase=16; 7A15 "| bc # provides h2d answer: 31253
  #$ echo "obase=16; 31253 "| bc # provides d2h anser: 7A15

}

######################
bin2ascii () # convert binary to ascii
#####################
{
  # $1=binary number
  if type -p perl >/dev/null; then 
    perl -e '$s=$ARGV[0];$l=length $s;@a=pack "B$l",$s;print "@a\n"' $1
  else
    echo Ooops... need perl to pull this off...
    return 92
  fi
  # to just convert base 2 to base 10
  # $(( 2#$1 ))
}


##################
ascii2bin () # convert ascii to binary
##################
{ 
 # $1 = "string to convert"
  if type -p perl >/dev/null; then 
    perl -e '$s=$ARGV[0];$l=(length $s)*8;@a=unpack "B$l",$s;print "@a\n"' "$1"
  else
    echo Ooops... need perl to pull this off...
    return 92
  fi
}

###########################################################
radd () # remote P-t-P address
###########################################################
# Get remote (P-t-P) address (assumes only one P-t-P interface)
{
if [ "$1x" = "x" ]; then
  /sbin/ifconfig | \
    grep "P-t-P" | \
    $AWK_CMD 'BEGIN{FS=" "} {print $3}' | \
    $AWK_CMD 'BEGIN{FS=":"} {print $2}'
else
  echo Usage: radd
  echo "Note: this function only is useful when a Point-to-Point "
  echo "      interface exists."
fi
}

###########################################################
ds () # diskspace - depends on df output in kilobytes
###########################################################
{
# here's a simple perl Total vs Free line of code:
# df | perl -lane '$tot+=$F[1]; $free+=$F[3]; print "Total $tot Free $free\n" if eof'
#
# Note - to add commas 
#  df -k | sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta'

# is the df command Posix compliant?
df -kP >/dev/null
if [ "$?" = "0" ]; then
  DF_CMD="df -kP "
else
  DF_CMD="df -k "
fi

#if [ "$PROMPT_STYLE" = "COLOR" ]; then
#  ORIG_LINE=$LINE
#  LINE=${GREEN}${LINE}${CYAN}
#fi

$DF_CMD | $AWK_CMD '
  BEGIN  {printf("%-15s %-15s %13s %13s %10s\n%s\n", "Device", "Mount", "Used","Avail","% Used","'$LINE'")}
  NR != 1 {printf("%-13s (%-15s) %10.2f Mb %10.2f Mb %10s\n", $1, $6, $3/1000, $4/1000, $5 )}'
echo $LINE
$DF_CMD | grep -v ":" |
$AWK_CMD '
    BEGIN { total = 0 ; used = 0 ; avail = 0 ; }
    NR != 1 { total += $2/1000 ; used += $3/1000 ; avail += $4/1000 ; }
    END { printf("%-10s\t %10.2f Mb\n","Total:",total);
  printf("%-10s\t %10.2f Mb\t(%3.2f%% approx.)\n",\
      "Used:",used,(used*100)/total);
  printf("%-10s\t %10.2f Mb\t(%3.2f%% approx.)\n",\
      "Available:",avail,(avail*100)/total); 
  printf("\n%s\n%s%2.0f%% appox.\n", \
      "Most unix systems reserve disk space for emergency use.", \
      "This system appears to be using ",100-(((avail+used)*100)/total)); } '
#if [ "$PROMPT_STYLE" = "COLOR" ]; then
#  LINE=$ORIG_LINE
#fi
}

#########################################
dusp () # sorted disk usage for one partition
##############################################
{
# this one needs work... need to add an array for each dir total 
#find / -mount -ls   |awk '
#  {
#     tot+=$7
#  }
#  END {
#    print "Total="tot/1000000000 " G"
#  }'

if [ "x$1" = "x" ]; then
  echo Usage: dusp dir_name
  return 99
fi
PART=`df $1 | awk '{getline;print $1}'`
echo This will summarize the consumed space under [$1]
echo    ... and which are on the same partition [$PART]
echo $LINE
for i in `ls -d $1/*`; do
  #echo Now checking $i with grep $PART
  if df $i | grep $PART >/dev/null ; then
    #echo Now doing du on $i
    du -sk $i 2>/dev/null | sed -e 's/\/\//\//g' 
  else 
    echo Skipping $i because it is on partition [$PART]
  fi
done | sort -n
}

###########################################################
lockit () # lock the terminal session
###########################################################
# Locks the session/terminal 
{
trap "" 2 3
stty -echo
tput clear
tput cup 5 10
echo -e "Enter your PASSWORD: \c"
read PW
tput clear
tput cup 10 10
echo -e "System is LOCKED!"
PW2=""
until [ "$PW" = "$PW2" ]
do
  tput cup 15 10
  echo -e "Password: \c"
  read PW2
done
stty echo
tput clear
}

####################
renameit () # renames all files mathing a patterns with a replacement pattern
#####################
{
# This one come from a Mr. Andy Yoder who taught me more 
#  than he will ever know...
if [ $# -eq 1 ] && [ -f $1 ]; then
  NEWFILENAME=`echo $1 | tr " " "-" | tr [:upper:] [:lower:]` 
  if askYN "Do you want to rename $1 to [$NEWFILENAME]?" y; then  
    processCMD mv $1 $NEWFILENAME
  fi
  return
fi
if [ $# -ne 2 ]; then
  echo "Usage: renameit <from string> <to string>"
  return 2
fi
echo $LINE
for i in `ls -dF *$1*|grep -v "\/"`; do
  echo $i | sed -e "s/\(.*\)$1\(.*\)/echo mv & \1$2\2/" | /bin/ksh
done
echo $LINE
ANS=y
echo "Is this what you want to do? (Y/n) "
read ANS
echo $LINE
if [ $ANS = "y" ]; then
  for i in `ls -d "*$1*"`; do
    echo $i | sed -e "s/\(.*\)$1\(.*\)/mv & \1$2\2/" | /bin/ksh
  done
fi
echo Done... Enjoy!
}

###########################################################
replaceit () # replace string with string in file
###########################################################
# Replace a word/phrase with another word/phrase in a file
# There is a program available called "replace" (imagine that!)
# which does this much better - and it will accept stdio.
{
# make sure noclobber is off 
# ie: set +o noclobber
# gnu sed allows in place substitutions and bakups with the
# -i.bak-ext-name parap argument I would use -i.`date +%Y%m%d-%h%M`
if [ $# != 3 ]; then
  echo 'Usage: replaceit "string to find" "string to place" filename'
else
  if ! uname -s | grep -i CYGWIN >/dev/null; then
    TMP_DIR=/tmp
    FILE_SIZE=$(ls -l $3 | $AWK_CMD '{print $5}')
    AVAIL_SIZE=$(df -k $TMP_DIR | $AWK_CMD '{getline;printf "%.0f", $4*1024}')
    SIZE_DIFF=$( expr $AVAIL_SIZE - $FILE_SIZE )
    echo Available size in temp dir [$TMP_DIR]=$AVAIL_SIZE
    echo File size: $FILE_SIZE
  else
   SIZE_DIFF=2
  fi
  if [ $SIZE_DIFF -le 0 ]; then
    doEXIT There is insufficient room to make a temporary file
  else
    # echo "Note: We will DANGEROUSLY edit the file in-place...no backup is made!"
    # Using ed is a wonderful tool but it fails under one Solaris
    # E4500 I have worked on for some unknown reason so I am switching
    # back to the other method of using sed... gwm 10-09-01
#ed -s $3 << EOF
#1
#%s/$1/$2/g
#w
#q
#EOF
  # The sed method - it attempts to preserve ownership and permissions
  # However - no backup is preserved here...
    if [ ! -w $3 ]; then
      doEXIT It appears that the file [$3] is not writable...
    else
      echo Now replacing all occurances of [$1] with [$2] in file [$3]
      echo $LINE
      echo "Replacing $(egrep -c "$1" $3) occurances of $1 in the file $3..."
      sed "s|$1|$2|g" $3 > $TMP_DIR/replaceit$$
      # by cat'ing the tmp file back over the original we preserve permissions
      cat $TMP_DIR/replaceit$$ > $3
      rm $TMP_DIR/replaceit$$
      doEXIT
    fi
  fi
  #
  # or 
  # here's a perl trick
  # this will do all the replaces and leave a filename.bak around.
  # perl -pibak -e's/STRNG2RPLC/NEWSTRNG/g' filename
  # uncomment the next line if you want to cat the file after editing it
  # cat $3
fi
}

######################################################
ldict () # Look up a word in on-line dictionary w/lynx [-t] for thesuarus
######################################################
{
if [ "$1" = "-t" ] || [ "$2" = "-t" ] && [ $# > 1 ]; then  
  if [ "$1" = "-t" ]; then
    WORD=$2
  else
    WORD=$1
  fi
  lynx "http://machaut.uchicago.edu/cgi-bin/ROGET.sh?word=$WORD"
else
  if [ -z $1 ]; then
    echo Usage: "ldict word_to_lookup"
    echo "        add -t to get thesuarus lookup instead"
  else
    if type -p lynx >/dev/null 2>&1; then
      # lynx "http://www.m-w.com/cgi-bin/dictionary?book=Dictionary&va=$1"
      \lynx "http://www.cogsci.princeton.edu/cgi-bin/webwn/?stage=1&word=$1"
    else
      echo Could not find lynx browser...
    fi
  fi
fi
}


###########################################################
dt () # Print a crude dir-tree
###########################################################
{
  # assumes LINE is already set
  set +o nounset # needed for ksh
  TYPE="-type d";
  if [ "${1}" = "-f" ]; then
    shift;
    TYPE="";
    ( cd ${1-"."} );
  else
    if [ "${2}" = "-f" ]; then
      TYPE="";
      ( cd ${1-"."} );
    fi;
  fi;
  echo "${LINE}";
  echo "             `hostname` : `pwd`/${1-.}  ";
  echo " Run Date: `date` ";
  echo "${LINE}";
  find ${1-.} $TYPE -print 2> /dev/null | sort -f | sed -e "s,^${1-.},," -e "/^$/d" -e "s,[^/]*/\([^/]*\)$,\+-----\1," -e "s,[^/]*/,|     ,g";
  echo "${LINE}";
  echo "    Note: use \"dt -f\" to add files to the tree listing";
  echo "Enjoy!"

#  echo "${LINE}"
#  #echo "             `hostname` : `pwd`  "
#  echo "             `hostname` : `pwd`/${1-.}  "
#  echo " Run Date: `date` "
#  echo "${LINE}"
#     
#  find ${1-.} $TYPE -print 2>/dev/null \
#   | sort -f \
#   | sed -e "s,^${1-.},," \
#       -e "/^$/d" \
#       -e "s,[^/]*/\([^/]*\)$,\+-----\1,"  \
#       -e "s,[^/]*/,|     ,g"
#  echo "${LINE}"
#  echo "    Note: use \"dt -f\" to add files to the tree listing"
#  echo "Enjoy!"
}

###########################################################
trunc () # truncate a file to last x lines
###########################################################
# To Truncate a file (last x lines)
{
# test tail to see how it handles parameters
tail -n 4 /dev/null
if [ "$?" = "0" ]; then
  TAIL_CMD="tail -n "
else
  TAIL_CMD="tail "
fi

# this has a problem with permissions
# another possibility is to use ex or ed like this
# ed $1
# 1,\$-$2 d
# w
# q

if [ "x$1" = "x" ] || [ ! -f $1 ]; then
   echo "Usage: trunc (filename) [num_of_lines]"
   echo "                        (defaults to 100 lines if not delineated)"
else
  # this next line does not work for all shells
  # NUMOLINES=${2:-100}
  #  so
  if [ "x$2" = "x" ]; then
    NUMOLINES=100
  else
    NUMOLINES=$2
  fi
  # these next two line look weird but they are meant to
  # preserve the ownership 
  cp -p $1 $1.tmp
  > $.tmp
  $TAIL_CMD $NUMOLINES $1 > $1.tmp
  mv $1.tmp $1
fi
}

###########################################################
pman () # print a man page (pipe it out to mpage -H2X for a nice output)
###########################################################
# To print a man page
{
# on an hp-ux machine I had to get ugly and do this:
# cd (where-the-manpage-is);cat manpage-name|uncompress|nroff -man| lp -d(ptr-name)
if [ $1x = x ]; then
  echo "Usage: pman  help_item  printer_name"
  echo "                    or"
  echo "        pman  help_item (goes out to STDIO to allow redirects to"
  echo "              mpage for example )"
else
  if [ "x$2" != "x" ]; then
    man -t $1 | lpr -P$2;
  else
    man -t $1
  fi
fi
}

###########################################################
mpg ()  # mpage -H2X - two page per sheet output
###########################################################
# To print a file sideways in two columns try this:
#  On an old LaserJet IIIP I had to force the margins a little with
#   this command
#       mpage -H2X -m75l50r40t file-to-print | lp
#     Note: that is an "l" (ell) between the 75 and the 50 
#          The "l"=left "r"=right "t"=top
# See the man page for mpage - you can set environment variables too.
# other options: enscript -2rF -P<printer> <file>
#   or pr <options> <file> | lpr <options>
####### or 
#alias port='enscript -G -j '
#alias land='enscript -r -E -C -G -j '
#alias fine='enscript -r -G -j -f Courier7 '
#"port" prints portrait with a page header. 
#"land" prints landscape, with line numbers, syntax highlighting (bold, italic), line-wrap, and  header. 
#"fine" prints landscape, micro-print 
###### or
# try a2ps
{
if [ "x$1" = "x" ];then
  echo "Usage: mpg filename [printername]"
fi
if [ "x$2" = "x" ]; then
  mpage -H2X $1 | lpr
else
  mpage -H2X $1 | lpr -P$2
fi
}

###########################################################
ffind () # find a file or pathname
###########################################################
# To find a file function
{
# was named ff until I found a solaris util called ff... ffile
if [ "x$1" = "x" ]; then
  echo "Usage: $FUNCNAME [dir] file_pattern"
  echo "   Use quotes around any regular expressions"
else
  if [ "x$2" = "x" ] ; then
    echo "NOTE: you must use quotes around any globals or regex."
    echo "Now searching for $1 in `pwd` (recursively);"
    echo "... please be patient..."
    echo "${LINE}"
    #processCMD find . -type f -mount -xdev -depth -follow -name \"$1\" 2\>/dev/null
    #processCMD find . -type f -xdev -depth -follow -name \"$1\" 2\>/dev/null
    #processCMD find . -type f  -follow -name \"$1\" 2\>/dev/null
    processCMD find . -follow -name \"$1\" 2\>/dev/null
    echo "${LINE}"
    echo "Enjoy!"
  else
    echo "NOTE: you must use quotes around any globals or regex."
    echo "Now searching for $2 in $1 (recursively);"
    echo "...  please be patient..."
    echo "${LINE}"
    #processCMD find $1 -type f -mount -xdev -depth -follow -name \"$2\" 2\>/dev/null
    #processCMD find $1 -type f -xdev -depth -follow -name \"$2\" 2\>/dev/null
    #processCMD find $1 -type f -follow -name \"$2\" 2\>/dev/null
    processCMD find $1 -follow -name \"$2\" 2\>/dev/null
    echo "${LINE}"
    echo "Enjoy!"
  fi
fi
}

###########################################################
fname () # find a file or dir with name
###########################################################
# To find a file function
{
# was named ff until I found a solaris util called ff...
if [ "x$1" = "x" ]; then
  echo "Usage: $FUNCNAME [dir] name_pattern"
  echo "   Use quotes around any regular expressions"
else
  if [ "x$2" = "x" ] ; then
    echo "NOTE: you must use quotes around any globals or regex."
    echo "Now searching for $1 in `pwd` (recursively);"
    echo "... please be patient..."
    echo "${LINE}"
    #processCMD find . -mount -xdev -depth -follow -name \"$1\" 2\>/dev/null
    #processCMD find . -xdev -depth -follow -name \"$1\" 2\>/dev/null
    processCMD  find . -follow -name \"$1\" 2\>/dev/null
    echo "${LINE}"
    echo "Enjoy!"
  else
    echo "NOTE: you must use quotes around any globals or regex."
    echo "Now searching for $2 in $1 (recursively);"
    echo "...  please be patient..."
    echo "${LINE}"
    #processCMD find $1 -mount -xdev -depth -follow -name \"$2\" 2\>/dev/null
    #processCMD find $1 -xdev -depth -follow -name \"$2\" 2\>/dev/null
    processCMD  find $1 -follow -name \"$2\" 2\>/dev/null
    echo "${LINE}"
    echo "Enjoy!"
  fi
fi
}

##########################################
awkcols ()  # print out one or more columns
##########################################
# This one may be more appropriate as it just hits text based file
{
if [ "x$1" = "x" ]; then
  echo "Usage: cat file | awkcols [-d DELIMINATOR] #,#,#,#..."
else
  while  [ "x$1" != "x" ]; do
    if [ "$1" = "-d" ]; then
      DELIM=$2
      shift
      shift
    else
      cols=\$$( echo $1 | sed 's/,/,\$/g' )
      shift
    fi
  done
  if [ "x$DELIM" = "x" ] ; then
    eval "$AWK_CMD '{print $cols}'"
  else
    eval "$AWK_CMD -v delim=$DELIM 'BEGIN {FS=delim} {print $cols}'"
  fi
fi
doEXIT
}

###########################################################
lf () # lookfor a string in text files
###########################################################
{
#  an easy solution in linux is grep -r --with-filename "string" *
# this recursively checks with a filename also presented
if grep "with-filename" `type grep` >/dev/null 2>&1 ; then
  processCMD GREP_CMD=\"grep --with-filename\"
else # must not be GNU grep (no --with-filename option)
  processCMD GREP_CMD=\"grep\"
fi

doTITLE "LookFor a string in text files recursively..."
if [ $# -eq 1 ]; then 
  # only one param provided ... string only
  DIR="."
elif [ $# = 2 ] && [ -d $2  ] ; then
  # two params provided - first is the string, second is the dir
  DIR=$2
else
   echo "Usage: $FUNCNAME string [dir]"
   echo "NOTE: you must use quotes around any globals or regex."
   return
fi
  echo "NOTE: you must use quotes around any globals or regex."
  echo "Now searching for [$1] in text files in [${DIR}]"
  echo "    (recursively-case sensitive)  please be patient... "
  echo "${LINE}"
  processCMD find ${DIR} -type f -follow -print 2\>/dev/null \
     \|xargs file \
     \|${GREP_CMD} text \
     \|cut -d\":\" -f1 \
     \|xargs ${GREP_CMD} \"$1\" 2>/dev/null
  doEXIT
}

###########################################################
lfall () # lookfor a string in ALL files
###########################################################
# lookfor (lf) function use: lf "string" "dir"
#  this routine works on most flavors of unix BTW.
{
if [ $# = 0 ]; then
  echo Usage: $FUNCNAME \"string\" [dir]
  return
fi
if grep "with-filename" `type grep` >/dev/null 2>&1; then
  GREP_CMD="grep --with-filename "
else
  GREP_CMD="grep "
fi
doTITLE "LookFor a string in all files recursively..."
if [ $# -eq 1 ]; then 
  # only one param provided ... string only
  DIR="."
elif [ $# = 2 ] && [ -d $2  ] ; then
  # two params provided - first is the string, second is the dir
  DIR=$2
else
  # Notes: the 2>/dev/null stuff is to get rid of no permission msgs
  #   The semi colon has to be escaped (\) so the shell doesn't see
  #   it - it is really for find  to know where the -exec ends.
  #  The curly braces are where the name of each file gets substituted
  #       grep -l: says to just print the filename
  # These command works as well: 
  #     find . -type f | xargs grep -l $1
  #     grep -l $1 $(find . -type f)
  #     find . -type f -exec grep -l "$1" 2>/dev/null {} \;
  # Each of these launch grep against each file singly
  #  so this means grep won't show the file and the line
  #  containing the string.  Better to use the method 
  #  given so it will show filename and line content AND
  #  it is "nicer" to the CPU - less load
  # This one has been suggested in text books but it gets memory
  # hiccups ...
  echo "Usage: $FUNCNAME string [dir]"
  echo "NOTE: you must use quotes around any globals or regex."
fi

echo "NOTE: you must use quotes around any globals or regex."
echo "Now searching for [$1] in all files in [${DIR}]"
echo "    (recursively-case sensitive)  please be patient... "
echo "${LINE}"
find ${DIR} -type f -follow -print 2>/dev/null \
    | xargs $GREP_CMD "$1" 2>/dev/null
doEXIT
}

###########################################################
envg () # grep the env output for a string
###########################################################
{
  if [ $# -ne 1 ];then
    echo Usage: $FUNCNAME string
  else
    env | grep $1
  fi
}

###########################################################
psg () # is a process running? (psg=ps -ef|grep ...)
###########################################################
# To see if a process is running - useage: running process_name
# This is very much like pgrep -l util
{
if [ "x$1" = "x" ] ; then
  echo "Usage: psg string-to-look-for"
else
# the most efficient way to look for a string in the ps table is like this
#   ps -ef | grep [s]tring # the brackets around the first char avoids showing the grep proc itself
#   but that is not easily done here... so we take the easy route
  if uname -a | grep -i linux>/dev/null; then 
    PS_OPTS=" -e -o user,pid,ppid,pcpu,etime,rss,time,args"
     #ps jax | grep PID | grep -v "grep"
     #ps jax | grep $1 | grep -v "grep"
	   #ps -auxwww | grep $1 | grep -v "grep"
	   #ps -aefwww | grep $1 | grep -v "grep"
    if [ x"$1" = "x-h" ] || [ x"$1" = "x-h" ]; then
      ps $PS_OPTS | head -1
      echo $SLINE
    fi
    ps $PS_OPTS | grep $1 | grep -v "grep"
  else
#   ps -aef | grep PID | grep -v "grep"
    #ps -aef | grep $1 | grep -v "grep"
    PS_OPTS=" -e -o user,pid,ppid,pcpu,etime,rss,time,nlwp,args"
    if uname -a | grep -i cygwin>/dev/null ; then
      PS_OPTS=" -ef "
    fi
    if [ x"$1" = "x-h" ] || [ x"$1" = "x-h" ]; then
      ps $PS_OPTS | head -1
      echo $SLINE
    fi
    if [ -x /usr/ucb/ps ]; then
      /usr/ucb/ps -auxwww | grep $1 | grep -v grep
    else
      ps $PS_OPTS | grep $1 | grep -v "grep"
    fi
  fi
fi
}

###################################
pss () # ps list sorted on cpu load - last is = highest load
###################################
{
## This next line works with linux but not other OS's
#ps -eo %cpu,pid,user,tty,args --sort %cpu
#ps aux --sort=-%cpui | head  # this works too
# So we will stick with what works every where...
doTITLE "Sorted ps list with last ones having highest load"
#ps -ef|grep -v UID|$AWK_CMD '{print $4"\t"$1"\t"$2"\t"$3"\t"$6"\t"$8}'|sort -n
# for reference: to get wide args on solaris
# ps -e  -o user,pid,ppid,cmd,args
#PS_OPTS=
if [ "$OS" = "linux" ]; then
  #PS_OPTS=" -e -o pid,ppid,pcpu,etime,rss,time,args"
  PS_OPTS=" -e -o user,pid,ppid,stime,pcpu,rss,args"
  SORT_OPTS=" -n -k 5,6"
  # ps -e -o pid,pcpu,etime,rss,time,nlwp,args
  #ps $PS_OPTS | $GREP_CMD -v USER|sort -n -k 5,6 
  #ps -e -o user,pid,ppid=PARENT -o stime,pcpu,args |$GREP_CMD -v USER|sort -n -k 5,6
  ps $PS_OPTS | $GREP_CMD -v USER|sort $SORT_OPTS |grep -v "$PS_OPTS"|grep -v "$SORT_OPTS"
  if [ x"$1" = "x-h" ]; then
    echo $SLINE
    processCMD ps $PS_OPTS \| head -1
  fi
fi
if [ "$OS" = "solaris" ]; then
  # Sun solaris should be
  #PS_OPTS=" -e -o pid,ppid,pcpu,etime,rss,time,nlwp,args"
  PS_OPTS=" -e -o user,pid,ppid,stime,pcpu,rss,nlwp,args"
  SORT_OPTS=" -n -k 5,6"
  ps $PS_OPTS | $GREP_CMD -v USER|sort $SORT_OPTS |grep -v "$PS_OPTS"|grep -v "$SORT_OPTS"
  if [ x"$1" = "x-h" ]; then
    echo $SLINE
    processCMD ps $PS_OPTS \| head -1
  fi
  #ps -e -o user,pid,ppid=PARENT -o stime,pcpu,args |$GREP_CMD -v USER|sort -n -k 5,6
fi
if [ "$OS" = "hp" ]; then 
  # hp should be
  #PS_OPTS=" -e -o pid,ppid,pcpu,etime,vsz,time,nlwp,args"
  PS_OPTS=" -e -o user,pid,ppid,stime,pcpu,rss,nlwp,args"
  SORT_OPTS=" -n -k 5,6"
  UNIX95=1 ps $PS_OPTS | $GREP_CMD -v USER|sort $SORT_OPTS |grep -v "$PS_OPTS"|grep -v "$SORT_OPTS"
  if [ x"$1" = "x-h" ]; then
    echo $SLINE
    processCMD ps $PS_OPTS \| head -1
  fi
  #ps -e -o user,pid,ppid=PARENT -o stime,pcpu,args |$GREP_CMD -v USER|sort -n -k 5,6
fi
doEXIT
}

###############################################
psms () # ps memory sort list - largest 5 first
###############################################
{
  # if you want to sort and show largest memory use first and have the label line use something like this
   ps aux|awk '{if (NR == 1 ) {print }else{print  | "sort -k4rn"}}'| head -5
}

###########################################################
killike () # kill all processes like (dangerous!)
###########################################################
# Linux has "killall" but it can be a little restrictive (ie: exact name)
# so here is a more dangerous version:
# This is much like the pkill utility
{
if [ "x$1" = "x" ]; then
  echo "Usage: killike string-to-look-for"
else
  ANS="n"
  CNT=`ps -aef | grep $1 | grep -v "grep " | wc -l | sed -e 's/ *//'`
  doTITLE Processes matching [$1]:
  ps -aef | grep $1 | grep -v "grep "
  echo $LINE
  echo "Are you sure you want to kill -9 all [$CNT] of these? [N] "
  echo "  Note: optionally you may enter PID PID PID... etc "
  printf "Your choice: PID PID ... or  ( y/[N] ) "
  read ANS
  if echo $ANS | egrep "^[0-9]+$" >/dev/null ; then
    echo " NOTE: if you answer with \"s\" here instead of a \"y\" or an \"n\" sudo will be used"
     if askYN "Are you sure you want to kill -9 $ANS" n ; then
       if [ x$ANS = xs ]; then
         SUDO_CMD="sudo "
       fi
       $SUDO_CMD kill -9 $ANS
       doEXIT "Done - go forth and kill not again..."
     else
       doEXIT "OK - no killing done .... we're outta' here ..."
     fi
  fi
  if [ "$ANS" = "y" ]; then
    if ps -ef|grep $1|grep -v grep>/dev/null ; then
      kill -9 `ps -aef | grep $1 | grep -v "grep "|$AWK_CMD '{print $2}'`
      doEXIT Done - go forth, and kill not again...
    else
      echo No matches found in the process list for [$1]... 
    fi
  fi
  if [ "$ANS" = "n" ] ; then
    doEXIT "OK - no killing done .... we're outta' here ..."
  fi
fi
}

#####################################
rehup ()  # kill -HUP $1
#####################################
{
if [ $# != 1 ]; then
  Usage: rehup exact_daemon_name 
else
  echo This match was found in the process list:
  echo $LINE
  ps -ef| grep $1|grep -v grep
  echo $LINE
  if askYN "Is this what you want reHUPped?" y ; then
     echo "Now reHUPping: `ps -ef| grep $1|grep -v grep|$AWK_CMD '{print $8 " (" $2 ")"}'` ..."
    kill -HUP `ps -ef| grep $1|grep -v grep|$AWK_CMD '{print $2}'`
    doEXIT 
  else
    doEXIT "Nothing done ..."
  fi
fi
}

#########################################################
setsvn () # sets the SVNROOT variable (for this session)
#########################################################
{
doTITLE "Set your svn environment variables temporarily" 
if [ "x$1" = "x-s" ]; then
  myRUSER="svnuser"
  processCMD export SVN_SSH="ssh"
  processCMD export SVNROOT="svn+ssh://$myRUSER@companionway.net:/data/svnrepos"
  CWD=`pwd`
  processCMD cd ~/dev/svn
  processCMD cvs co utils
  processCMD cd $CWD
  return
fi


if [ -f $HOME/.SVN_Root_flag ]; then 
  processCMD cat $HOME/.SVN_Root_flag ]
  echo $SLINE
  echo Last saved SVNROOT=`cat $HOME/.SVN_Root_flag`
  VAR=`cat $HOME/.SVN_Root_flag \
    | sed 's/\([^:]*\):\/\/\([^@]*\)@\([^\/]*\)\/\(.*\)/\1 \2 \3 \4/'`
set $VAR
#echo DEBUG: BAR=$VAR
mySVN_EXT=$1
myRUSER=$2
myRHOST=$3
mySVNDIR=$4
fi
#echo DEBUG: mySVNEXT=$mySVN_EXT myRUSER=$myRUSER myRHOST=$myRHOST mySVNDIR=$mySVNDIR
echo $LINE


if [ ! -z $SVNROOT ]; then
  echo Your current SVNROOT=[$SVNROOT]
  echo Example of use: svn update \$SVNROOT/myproj
fi

if askYN "Do you intend to use a remote SVN host?" y ; then
#  if askYN "Will you be using ssh to access the SVN server?" y;then
    SVN_EXT=svn+ssh
    SVN_SSH="ssh"
#  else
#    SVN_EXT=pserver
#  fi
  
  myRUSER=${myRUSER:-$(id | sed -e "s,).*$,,"|sed -e "s/.*(//")}
  printf "Please enter the USER to use for svn host: [$myRUSER] "
  read RUSER
  if [ -z $RUSER ]; then
    RUSER=$myRUSER
  fi

  myRHOST=${myRHOST:-$( echo $SVNROOT  |sed 's/.*@//; s/:.*//' )} 
  if [ -z $myRHOST ]; then
    myRHOST=`hostname`
  fi
  printf "Please enter the HOST for svn: [${myRHOST}] "
  read RHOST
  if [ -z $RHOST ]; then
    RHOST=$myRHOST
  fi
fi

mySVNDIR=${mySVNDIR:-$( echo $SVNROOT | sed 's|.*:||' )}
printf "Please enter the svnroot directory: [$mySVNDIR] "
read SVNDIR

if [ -z $SVNDIR ]; then
  SVNDIR=$mySVNDIR
fi

processCMD export SVNROOT=$SVN_EXT://${RUSER}@${RHOST}${SVNDIR}
echo $SVNROOT>$HOME/.SVN_Root_flag
echo $LINE
echo This is your new SVNROOT: [$SVNROOT]
echo To use this eg: svn co \$SVNROOT/myproj
return
}

#########################################################
setcvs () # sets the CVSROOT variable (for this session)
#########################################################
{
doTITLE "Set your cvs environment variables temporarily" 
if [ "x$1" = "x-s" ]; then
  #myRUSER=${myRUSER:-$(id | sed -e "s,).*$,,"|sed -e "s/.*(//")}
  myRUSER="cvsuser"
  processCMD export CVS_RSH="ssh"
  processCMD export CVSROOT=":ext:$myRUSER@hype.companionway.net:/data/cvsroot"
  CWD=`pwd`
  processCMD cd ~/dev
  processCMD cvs co utils
  processCMD cd $CWD
  return
fi
if [ ! -z $CVSROOT ]; then
  echo Your current CVSROOT=[$CVSROOT]
fi
if [ -f $HOME/.CVS_Root_flag ]; then 
  echo Last saved CVSROOT=`cat $HOME/.CVS_Root_flag`
  VAR=`cat $HOME/.CVS_Root_flag \
    | sed 's/:\([^:]*\):\([^@]*\)@\([^:]*\):\(.*\)/\1 \2 \3 \4/'`
set $VAR
myCVS_EXT=$1
myRUSER=$2
myRHOST=$3
myCVSDIR=$4
fi
echo $LINE

if askYN "Do you intend to use a remote cvs host?" y ; then
  if askYN "Will you be using ssh to access the cvs server (no=pserver)?" y;then
    CVS_EXT=ext
    CVS_RSH="ssh"
  else
    CVS_EXT=pserver
  fi
  
  myRUSER=${myRUSER:-$(id | sed -e "s,).*$,,"|sed -e "s/.*(//")}
  printf "Please enter the USER to use for cvs host: [$myRUSER] "
  read RUSER
  if [ -z $RUSER ]; then
    RUSER=$myRUSER
  fi

  myRHOST=${myRHOST:-$( echo $CVSROOT  |sed 's/.*@//; s/:.*//' )} 
  if [ -z $myRHOST ]; then
    #myRHOST=`hostname`
    myRHOST=hype.companionway.net
  fi
  printf "Please enter the HOST for cvs: [${myRHOST}] "
  read RHOST
  if [ -z $RHOST ]; then
    RHOST=$myRHOST
  fi
fi

myCVSDIR=${myCVSDIR:-$( echo $CVSROOT | sed 's|.*:||' )}
printf "Please enter the cvsroot directory: [$myCVSDIR] "
read CVSDIR
if [ -z $CVSDIR ]; then
  CVSDIR=$myCVSDIR
fi

processCMD export CVSROOT=:${CVS_EXT}:${RUSER}@${RHOST}:${CVSDIR}
echo $CVSROOT>$HOME/.CVS_Root_flag
echo $LINE
echo This is your new CVSROOT: [$CVSROOT]

doEXIT
}

if  alias |grep del= >/dev/null ; then
  unalias del
fi
###########################################################
del () # sends files to $HOME/trash (safer than rm)
###########################################################
# deletes file to /trash dir (ala Win95 etc) - just moves the file
{
doTITLE "Moving $1 to $HOME/trash"
if [ ! -d $HOME/trash ]; then
  processCMD mkdir $HOME/trash
fi
  processCMD mv $1 $HOME/trash
  doEXIT File removed to trash directory...
}

#########
docs () # docs TOPIC - cd to /usr/share/doc/TOPIC
#########
{
  if [ -d /usr/share/doc/$1 ] ; then
    processCMD cd /usr/share/doc/$1
  else
    echo Failed to find /usr/share/doc/$1
  fi
}

###########################################################
llsm () # lists filename [long] where it was modified on a particular date
###########################################################
{
if [ "x$1" = "x" ]; then
  echo 'Usage: llsm <"date"> '
  echo 'Example:'
  echo '  llsm "Jun  5"'
  echo '      or'
  echo '  llsm "Jun" # for all modified file in June'
  echo '  Be careful of the number of spaces and the use of quotes'
else
  doTITLE "List of all files modified on $1"
  processCMD ls -la \| grep -i \"$1\" 
  doEXIT
fi
}

###########################################################
lsm () # lists filename only where it was modified on a particular date
###########################################################
{
if [ "x$1" = "x" ]; then
  echo 'Usage: lsm <"date"> (eg llsm "Jun  5"<-note the spaces)'
else
  # ls -la | grep -i "^.\{42\}$1" | cut -c55- 
  #ls -la | awk '{printf "%s %2d %s\n", $6, $7, $9}'| grep -i "$1"
  ls -la |  grep -i "$1" |awk '{print $9}' 
fi
}


##############################################################
watchit () # a loop that watches your command @ 10 seconds...
##############################################################
{
CYCLE_TIME=10
CMD="$*"
LINES=`expr $(tput lines) - 3`

while : ;do
  tput clear
  doTITLE "Watching: [$CMD] every $CYCLE_TIME seconds... "
  #tput cup 3 0
  eval $CMD
  #tput cup $LINES 0
  echo "$LINE"
  echo "Please use quotes around your command."
  echo "Last cycle: `date`   Hit Ctrl-C to exit... "
  echo "$LINE"
  sleep $CYCLE_TIME
done
}

##############
getweather ()
##############
{
#  ZONE=vaz053
## There are a couple of choices here...
#  #doTITLE "Weather for ZONE=vaz053"`` # fairfax
#  #URL=http://weather.noaa.gov/cgi-bin/iwszone?Sites=:$ZONE 
#  URL=http://forecast.weather.gov/MapClick.php?CityName=Elizabeth+City&state=NC&site=AKQ&textField1=36.296&textField2=-76.2206#.Va0e6R_iu00
#  echo "This function has a preset variable for ZONE=$ZONE"
#  echo "That ZONE variable is used if lynx is found..."
#  echo "Zone listings: https://alerts.weather.gov/cap/co.php?x=2"
#  if type  -p lynx >/dev/null 2>&1; then
#    \lynx $URL
#  else
#    telnet rainmaker.wunderground.com 3000 
#  fi
#  doEXIT
curl -s wttr.in # w3m http://wttr.in/:help
#if type -p weather >/dev/null ; then
#  weather -i fips3720580 # use just weather -i search "your city"
#fi
}

###########
getexcuse ()
###########
{
  telnet bofh.jeffballard.us 666
}

###########################################################
xbar () # puts new label on Xwindow title bar and icon
###########################################################
# This function displays the title on the window bar in X
#  You can pass the title you want with a parameter
{
  doTITLE "Setting the title bar and icon label in your X session"
  ## NOTE: in vi editor to create the escape (^[) and the ctrl-g (^G):
  ##                                  ctrl-V,Esc          ctrl-V,ctrl-g
  if [  "x$1" != "x" ];then 
    echo "  Setting title... "
    echo ]1\;$*
    echo "  Setting icon label... "
    echo ]2\;$*
  else 
    echo "  Setting title... "
    echo ]1\;$LOGNAME@$HOSTNAME
    echo "  Setting icon label... "
    echo ]2\;$LOGNAME@$HOSTNAME
  fi
  #The title of a XTERM window can be set using the following
  #escape sequence:
  #
  #    ESC ] 0 ; title ^G
  #
  #Example:
  #
  #    echo "^[]0;This is a title^G"

  # This sets the screen window name if screen is running - sets it to the hostname
  HOSTNAME=`hostname`
  if echo $TERMCAP|grep screen >/dev/null; then
    echo -n -e "\033k$HOSTNAME\033\134\\"
  fi
  return
}

###########################################################
#pwsub # () # Allows selective changes to passwd records w/output to stdio
###########################################################
# Sample code only - and folks this one took a LOT of banging
# until it submitted and did what I wanted.  I am sure there is
# a better way - but "show me"!! <please>
# {
# clear
# if [ $UID != 0 ]; then
#   echo You are not root!
# fi
# echo 
# echo Given that:
# echo /etc/passwd field format is:
# echo 
# echo "          name:pword:uid:gid:gcos:home:shell"
# echo
# echo "Do this now.....   Change all records where ..."
# echo
# echo "Match field  : _______    equals:  ____________________________"
# echo "       and"
# echo "Replace field: _______    with  :  ____________________________"
# echo
# tput cup 9 16
# read MFLD
# tput cup 9 36
# read EQUALS
# tput cup 11 16
# read RFLD
# tput cup 11 36
# read WITH
# # if  [ ! "${MFLD}" ] || [ ! "${EQUALS}" ] || [ ! $RFLD ] || [ ! "$WITH" ] ; then
#   echo Every field must be appropriately filled out.
#   return
# fi
# echo $LINE
# echo "Proceeding to change ${RFLD} with ${WITH} where ${MFLD} equals ${EQUALS}."
# IFS=":" 
# while read name pword uid gid gcos home shell 
# do 
#    MFLDx=$( eval echo \$$MFLD )
#    if [ "${MFLDx}" = "${EQUALS}" ]; then 
#       eval ${RFLD}="\"${WITH}\""
#    fi
#    echo "${name}:${pword}:${uid}:${gid}:${gcos}:${home}:${shell}" 
# done < /etc/passwd 
#}

########################
xlinks () # find broken links
##############################
{
# from Unix Power Tools - O'Reilly - Jerry Peek, Tim O'Reilly, Mike Loukides
# 2nd edition pg. 287
doTITLE "Finding broken links... usage: xlinks [dir_name] "
if [ "$1x" = "x" ]; then
  #find . -type l -print 2>/dev/null | perl -nle '-e || print'
  find . -type l -print 2>/dev/null |xargs file|grep broken
else
  #find $1 -type l -print 2>/dev/null | perl -nle '-e || print'
  find $1 -type l -print 2>/dev/null |xargs file|grep broken
fi
doEXIT 
}

# just in case I ever need something like this
####################################
txt2html () # Convert a text file to an html doc
####################################
{
  awk -v FNAME=$1 '
  BEGIN    {print "<html>"
  print "<head>"
  print "<title>" 
  print FNAME 
  print "</title>"
  print "</head>"
  print "<body><pre>"}
  /^---*$/  {print "<hr align=\"left\" width=" length "0 size=1>"; next}
  /^===*$/  {print "<hr align=\"left\" width=" length "0 size=3>"; next}
  {gsub("<","\&lt;")
  gsub(">","\&gt;")
  gsub("^L","<br>\&nbsp;<br>\&nbsp;<br>\&nbsp;<br>")
  print}
  END {print "</pre></body>"}
  ' $1
}

########
calcit() # command line calculator
########
{
  ## bc 
  # best not to include spaces in your formula?
  # consider installing qalc / qalculate
  if [ x$1 = "x" ] ; then
    echo Examples: calcit -s 2 \"13000 / 530000\"
    echo "   the -s 2 means set the scale to 2 decimal places"
    echo or
    echo calcit \"13000 / 530000\"
  fi
  if [ "x$1" = "x-s" ]; then
    SCALE=$2
    shift 2
  fi 
  SCALE=${SCALE:-1}

bc -ql <<EOF
scale=$SCALE
$@
EOF

  ### or ###
  #perl -wlne 'print eval';
}

####################
lscmds () # list all executable cmds in your path
#####################
{
for i in `echo $PATH | tr ":" "\n"`; do
  if [ -d $i ]; then 
	  find $i -perm -u=x -exec basename {} \;
	fi
done | sort | uniq
}

#############
setTMOUT () # set the TMOUT variable
################
{
  if [ "x$1" = "x" ]; then
    echo Usage: setTMOUT no_of_seconds
  else
    processCMD export TMOUT=$1
  fi
}

# ======= End Functions ========
if chkID root; then
  export HISTSIZE=3000
  export HISTFILESIZE=5000
  export HISTFILE=/root/.bash_hist-$(who am i | awk '{print $1}';exit)
fi

# ======= Setting shopt (shell options) parameters =======
# from debian .bashrc
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
#shopt -s autocd # Makes bash-4.x like zsh. Automatically cd into a directory if a command 
                # with that name doesn't exists. Too many shells fail with this so commenting it out.

#If you "set -o vi" then use "Esc-\" key combo for command or file completion.
set -o notify
#set -o noclobber
set +o noclobber # turns off the noclobber option
#shopt -uo noclobber
# use shopt -o noclobber <-- to see its current state
# the shopt -uo noclobber will unset the option noclobber
if shopt >/dev/null 2>&1; then
  ## -s = enable -u = disable -q = quiet
  ## here are the default settings - use shopt alone to see these
  # cdable_vars    	off
  # cdspell        	off
  shopt -s cdspell
  # checkhash      	off
  # checkwinsize   	off
  # cmdhist        	on
  shopt -s dotglob
  # execfail       	off
  # expand_aliases 	off
  # extglob        	off
  shopt -s extglob
  # histreedit     	off
  # histappend     	off
  # histverify     	off
  # hostcomplete   	on
  # huponexit      	off
  # interactive_comments	on
  # lithist        	off
  shopt -s lithist   # saves multicommand lines with newline characters at end of line
  # login_shell    	off
  # mailwarn       	off
  # no_empty_cmd_completion	off
  # nocaseglob     	off
  # nullglob       	off
  # progcomp       	on
  # promptvars     	on
  # restricted_shell	off
  # shift_verbose  	off
  # sourcepath     	on
  # xpg_echo       	off
fi
# ======= End shopt settings ======

# ======= Add for local flavor ====
# This sets the backspace key to do what it is suppose to in X
LOADKEYS_CMD=`type -p loadkeys`
$LOADKEYS << EOF
keycode 14 = BackSpace
keycode 111 = Delete
EOF
# This is a personal thing here folks - I just like this old slackware font
# Only works under console - not Xwindows - dangit!
#if [ -f $HOME/fonts/t.fnt ] && \
#   [ "x$DISPLAY" = "x" ] && \
#   ( tty | grep tty >/dev/null ) && \
#   ( uname -a | grep -i linux >/dev/null ); then
#  if type -p consolechars >/dev/null 2>&1; then
#    #echo Now running: consolechars -f  $HOME/fonts/t.fnt
#    consolechars -f  $HOME/fonts/t.fnt
#  else
#    #echo Now running: setfont $HOME/fonts/t.fnt
#    setfont $HOME/fonts/t.fnt
#  fi
#fi
if [ -f $HOME/.fnt_flag ] \
  && [ -z $WINDOWID ] \
  && [ -z $SSH_TTY ] \
  && ! tty | grep "pts"       >/dev/null \
  && ! tty | grep "not a tty" >/dev/null ; then
  #echo DEBUG: SSH_TTY=$SSH_TTY TTY=`tty`
  processCMD setfont `cat $HOME/.fnt_flag`
fi

#################
setfnt () # select the font of your choice
#################
{
PS3="Please make your Choice: "
CHOICES=`cd /lib/kbd/consolefonts/;ls *.gz`
select CHOICE in $CHOICES; do
  if [ -f /lib/kbd/consolefonts/$CHOICE ] ; then
    processCMD setfont /lib/kbd/consolefonts/$CHOICE
    if askYN "Do you want to save this font selection" n; then
      processCMD echo /lib/kbd/consolefonts/$CHOICE \>.fnt_flag
    fi
    break
	else
		echo $LINE
		echo Woops - bad choice... or you just wanted out...
    break
	fi
done
}

##################
atmsg () # atmsg "TIME" "MSG" - eg atmsg "now + 5 minutes" "Get coffee" 
#################
{
if [ $# -eq 0 ]; then
  echo Usage: $FUNCNAME \"time expression\" \"Message to display\"
  echo eg $FUNCNAME noon \"get lunch\"
  echo eg $FUNCNAME \"1am tomorrow\" \"do monthly reports\"
  echo eg $FUNCNAME \"now + 25 minutes\" \"go home\"
  echo eg $FUNCNAME \"5pm + 3 days\" \"go home\"
  echo eg $FUNCNAME \"1:45 pm Tue\" \"f-2-f interview with Louis\"
  return
fi
SOUND_FILE=/usr/lib/openoffice/share/gallery/sounds/laser.wav
RUN_TIME=$1
MSG=$2

if [ -f $SOUND_FILE ]; then
  processCMD echo play $SOUND_FILE  \| at $1 
fi

if env | grep DISPLAY >/dev/null ; then
  processCMD echo DISPLAY=$DISPLAY xmessage \"$2\" \| at $1
else
  processCMD echo wall $2 \| at $1
fi
}

##############
sharedtty () # shared-tty - tail -f /tmp/$USER.`hostname`.`date +%Y%m%d 
#############
{
# allow localhost ssh in - passwordless
# alternative:  
# you start with: screen -S NAME 
# make sure you have "multiuser on" in launch session .screenrc file
# co-worker uses: screen -x NAME whenever either of you type in your 
# screen both of you will see what is going on at the same time.
DATE=`date +%Y%m%d`
echo $LINE
echo Another user/terminal can tail -f /tmp/$USER.`hostname`.${DATE}.out
echo to watch all that is done in this session.
echo This also allows capturing of all data as your session transpires.
echo
echo Exit the seesion to stop sharing or recording.
echo
if askYN "Do you want to continue" y ; then
  if ! grep $USER@localhost ~/.ssh/authorized_keys2>/dev/null; then
    cat ~/.ssh/id_dsa.pub >>~/.ssh/authorized_keys2
  fi
  processCMD ssh localhost \| tee /tmp/$USER.\`hostname\`.${DATE}.out
  echo $LINE
  if askYN "Do you want to remove /tmp/$USER.`hostname`.${DATE}.out file" y; then
    processCMD rm /tmp/$USER.`hostname`.${DATE}.out
  fi
fi
}

##########################
oldconns () # get and optionally kill old connections
##############################
{
if [ "$OS" = "linux" ]; then
  # on linux
  #WHO_OLD_CMD="who -i "
  WHO_OLD_CMD="who -u "
fi

if [ "$OS" = "sun" ]; then
  # solaris only right now and this is unfinished!!
  WHO_OLD_CMD="who -u "
fi

$WHO_OLD_CMD | grep "old"
if askYN "Would you like to kill these" n; then
  if chkID root; then
    if [ "$OS" = "sun" ]; then
      kill -9  `$WHO_OLD_CMD | awk '/old/{print $7}'`
    fi
    if [ "$OS" = "linux" ]; then
      kill -9  `$WHO_OLD_CMD | awk '/old/{print $6}'`
    fi
  else
    echo You should be root to use this function...
  fi
fi
}

######################
vimit () # does the same thing as vim \$(which \$1)
#############################
{
  # this is just a bad kludge...
  processCMD vim `which $1` $2 $3 $4
}

######################
whoisit () # whois listings
##################
{
  processCMD whois -h whois.geektools.com $1
}

#############
scr () # short cut for screen
#############
{
# if a $1 appears use that for the .screen config file to load
# screen -c $1 # UNTESTED!
#### note buobu ignores .screenrc - for me that is unacceptible
#if type -p byobu-launcher>/dev/null; then
#  byobu-launcher
#  return
#fi
echo Usage: scr 
if [ x$1 = "x" ]; then
  SCR_NAME=scr-$USER
else
  SCR_NAME=$1
fi
DEAD_SCREENS=`screen -list | grep -i "Dead" | wc -l`
if [ $DEAD_SCREENS -gt 2 ]; then
  if askYN "Shall I wipe out the Dead screens first" y; then
    processCMD screen -wipe
  fi
fi
#if [ "x$1" = "x" ]; then
#  processCMD screen -DRR
#else
#  if [ -d ~/$1 ]; then
#    processCMD cd ~/$1 
#  fi
#  #processCMD screen -DRR $1 -t $1 $2 
  echo screen -DRR -S $SCR_NAME -t `hostname`
  screen -DRR -S $SCR_NAME -t `hostname`
  # screen name=scr-USER with hostname title (on status bar)
#fi
}

############
llw () # long listing of `which executable_file`
#############
{
  if [ $# = 0 ] ; then
    echo Usage: $FUNCNAME executable_filename
    return
  fi
  ls -l `which $1`
}

############
#grepconfigs ()
#############
#{
#  # this is sooo bogus and just for my work at fmae - remove this someday
#  if [ ! x$1 = x ]; then
#    grep "$1" https-*/config/*  
#  else
#    echo need a string to search the configs for...
#  fi
#}

###########
doPURIFY ()
###########
{
# This function will "purify" any input - stripping out all
# comments and blank lines regardless of position in a line
# Can be called with a filename or just as a pipe
# To call as a pipe - do this cat /etc/hosts | doPURIFY
# and this will strip out all comments in /ect/hosts
# comments can also be removed with egrep -v "^[[:space:]]*(#.*)?$" 
if [ "x$1" = "x" ]; then
  # we did not receive a filename
  sed -e "s/#.*$//" | sed "/^$/d" | sed "s/^M//g"
 else
  # we received a filename
  cat $1 |sed -e "s/#.*$//" | sed "/^$/d" | sed "s/^M//g"
fi
}

npsudo ()
{
#nopass sudo
#eg yourname ALL=(ALL) NOPASSWD: ALL
echo Add the following \(or similar\) to /etc/sudoers
echo $USER ALL=\(ALL\) NOPASSWD: ALL 
}

##########
#fixsudoers () # WIP 
#{
# see fixsudoers.sh
#  # sudo cat /etc/sudoers| awk '/^%sudo/{for (i=1;i<NF;i++)printf "%s ",$i;print "NOPASSWD: "$NF}'
#  sudo egrep "%admin|%sudo|$USER" /etc/sudoers| awk '{print "Change: "$0";{for (i=1;i<NF;i++)printf "%s ",$i;print "NOPASSWD: "$NF}}'
#}

#######
#printfrom2 () # < file
#######
#{
# needs work
# print section of file between two regular expressions, /foo/ and /bar/
#ruby -ne @found=true if $_ =~ /$1/; next unless @found; puts $_; exit if $_ =~ /$2/
#}

####### EOB FUNCTIONS ##########

#################################
# ====== Add local flavor stuff
#################################
# some distros have enhanced bash_completion
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
# You might consider using another source file for your local stuff
# here is one method
# Typically this file might have entries like this
# alias wls="cd /opt/bea/wlserver/config"
# alias content="cd /data/content"
# alias myapt=apt.sh # this is a wrapper script for apt that I wrote
MYHOME=$HOME # change this as you see fit
if [ -f $MYHOME/.bash_local ]; then
  source $MYHOME/.bash_local
else
  echo "### this file created by .bashrc - add what you want ###">>$MYHOME/.bash_local
  echo "### alias snamp=\"sudo nmap\"">>$MYHOME/.bash_local
  echo 'PATH=$PATH:$HOME/dev/utils'>>$MYHOME/.bash_local
  source $MYHOME/.bash_local
fi
if ! egrep "^clear$" ~/.bash_logout >/dev/null; then
  echo clear >> ~/.bash_logout
fi

# load up a welcome script if found in ~/bin - an example is here too
if [ -f ~/bin/welcome.sh ] ; then
  ~/bin/welcome.sh
  ## sample ~/bin/welcome.sh
  # uptime
  # if type -p figlet>/dev/null; then
  #   figlet Welcome
  # fi
  # cal
  # ===================
  # grep -h `date +"%m/%d"` /usr/share/calendar/cal*
  # ===================
  ## EOF
fi

# ====== EOB Add local flavor ===
DTIME=$(date +%Y%m%d-%H%M) # I use this in file names
# experimental
#if [ ! x$SSH_TTY = "x" ] && [ ! x$TERM = "xscreen" ] && type -p screen; then
#   if [ ! -f ~/.screenrc ] && [ -f ~/dev/vim/.screenrc ]; then
#     # This is a personal preference thing - screen gets really useful
#     # with a good personalized .screen file
#     # Yes, I keep current versions of all my dot files in the vim repository
#     # That was where my first useful dot file was - .vimrc
#     ln -s ~/dev/vim/.screenrc ~/.screenrc
#   fi
#   echo Remote ssh connection detected and screen is available.
#   if askYN "Would you like to use screen" y ; then
#     screen -DRR
#   fi
#fi
# remove this if you don't like it...
if type -p figlet>/dev/null; then
  if [ ! -f ~/.bash_logout ]; then
    echo "figlet Enjoy">~/.bash_logout
  fi
fi

# ======== End .bashrc =========

PATH=$PATH:/usr/share/ruby-rvm/bin # Add RVM to PATH for scripting

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
