#!/bin/bash
### .bashrc examples:
###   * http://tldp.org/LDP/abs/html/sample-bashrc.html
###   * http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# source global definitions (if any)
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

### set shell options
set -o notify
set -o noclobber
set -o ignoreeof
     # see http://wiki.bash-hackers.org/internals/shell_options#extglob
shopt -s extglob
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s histappend histreedit histverify
shopt -s hostcomplete
shopt -s interactive_comments
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nullglob
shopt -s progcomp
shopt -s promptvars
shopt -s sourcepath

shopt -u mailwarn
#unset MAILCHECK	# don't want shell to warn me of incoming mail

# bash time/hist/host file and formatting vars exported after color vars
# are defined, toward bottom of script; see before '# echo motd'


### variables

# dirs
bash_start_dir="$HOME"

# colors
# Normal colors
Black='\e[0;30m'
Red='\e[0;31m'
Green='\e[0;32m'
Yellow='\e[0;33m'
Blue='\e[0;34m'
Purple='\e[0;35m'
Cyan='\e[0;36m'
White='\e[0;37m'

# Bold
BBlack='\e[1;30m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
BCyan='\e[1;36m'
BWhite='\e[1;37m'

# Background
On_Black='\e[40m'
On_Red='\e[41m'
On_Green='\e[42m'
On_Yellow='\e[43m'
On_Blue='\e[44m'
On_Purple='\e[45m'
On_Cyan='\e[46m'
On_White='\e[47m'

# Color Reset
NC="\e[m"

# Alert color (bold white on red background)
ALERT="${BWhite}${On_Red}"


### functions

# start ssh, only prompting for password on new ssh-agent creation
# (http://unix.stackexchange.com/a/217223/136537)
function ssh-setup {
	if [ ! -S ~/.ssh/ssh_auth_sock ]; then
		eval "$(ssh-agent)"
		ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
	fi
	export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

	# only performs `ssh-add` if key is not loaded in agent and
	# only on files which have a header indicating it is an SSH key;
	# runs grep quietly for neatness
	brctmp=~/bashrc-temp
	rm -f "$brctmp"  && \
	ssh-add -l > "$brctmp" ; \
	find ~/.ssh \
		-type 'f' \
		-exec grep -q -- '-BEGIN RSA PRIVATE KEY-' {} \; \
		! -exec grep -q "{}" "$brctmp" \; \
		-exec ssh-add {} \; && \
	rm -f "$brctmp"
}

# test colors available in the terminal
# (http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html)
function colortest {
	T='gYw'   # The test text

	echo -e '\n                 40m     41m     42m     43m' \
	        '    44m     45m     46m     47m';

	for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' \
	           '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' \
		   '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m';
		do FG=${FGs// /}
		echo -en " $FGs \033[$FG  $T  "
		for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
			do echo -en \
			  "$EINS \033[$FG\033[$BG  $T  \033[0m";
		done
		echo;
	done
	echo
}

# find a file with a pattern in name
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
function ff {
	find . -type f -iname '*'"$*"'*' -ls ;
}

# find a file with pattern $1 in name and execute $2 on it
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
function fe {
	find . -type f -iname '*'"${1:-}"'*' \
	  -exec "${2:-file}" {} \; ;
}

# swap 2 filenames around, if they exist
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
function swap {
	local TMPFILE=tmp.$$

	[ "$#" -ne 2 ] && echo 'swap: 2 arguments needed' && return 1
	[ ! -e "$1" ] && echo "swap: $1 does not exist" && return 2
	[ ! -e "$2" ] && echo "swap: $2 does not exist" && return 2

	mv "$1" $TMPFILE
	mv "$2" "$1"
	mv $TMPFILE "$2"
}

# handy extract program
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
function extract {
	if [ -f "$1" ] ; then
		case "$1" in
			*.tar.bz2)   tar xvjf "$1"   ;;
			*.tar.gz)    tar xvzf "$1"   ;;
			*.bz2)       bunzip2 "$1"    ;;
			*.rar)       unrar x "$1"    ;;
			*.gz)        gunzip "$1"     ;;
			*.tar)       tar xvf "$1"    ;;
			*.tbz2)      tar xvjf "$1"   ;;
			*.tgz)       tar xvzf "$1"   ;;
			*.zip)       unzip "$1"      ;;
			*.Z)         uncompress "$1" ;;
			*.7z)        7z x "$1"       ;;
			*)           echo "'$1' cannot be extracted " \
			                  'via >extract<' ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

# exit function
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
function _exit {
	# for some reason, this doesn't respect our alias...
	# must explicitly add `-e` flag for colors to be shown
	echo -e "${BCyan}Bye!${NC}"
	sleep 1
}
trap _exit EXIT


### scripts

# aliases (can be bypassed by using `\command`)
# (http://ss64.com/bash/alias.html)
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias echo='echo -e'
alias df='df -Th'
alias mkdir='mkdir -pv'
alias less='less -R'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias mount='mount | column -t'
alias shellcheck='shellcheck --color'

alias aliases='alias -p'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias more='less'
alias path='echo ${PATH//:/\\n}'	# pretty-print $PATH dirs
alias sha1='openssl sha1'
alias now='date +"%T"'
alias nowtime='now'
alias nowdate='date +"%d-%m-%y"'
alias vi='vim'
     # get headers
alias headers='curl -I'
     # test for gzip/mod_deflate support
alias headersc='curl -I --compress'
alias ..='cd ..'
alias .1='..'
alias .2='.1 && .1'
alias .3='.2 && .1'
alias .4='.3 && .1'
alias .5='.4 && .1'

# add colors for filetype and human-readable sizes by default on `ls`
alias ls='ls -h --color'
alias lx='ls -lXB'	# sort by extension
alias lk='ls -lSr'	# sort by date, biggest last
alias lt='ls -ltr'	# sort by date, most recent last
alias lc='ls -ltcr'	# sort by/show change time, most recent last
alias lu='ls -ltur'	# sort by/show access time, most recent last

# add `ll`: directories first with alphanumeric sorting
alias ll='ls -lv --group-directories-first'
# can add the following to group dir *and symlinks to dirs* first:
# http://unix.stackexchange.com/a/111639/136537
alias lm='ll | more'	# pipe through `more`
alias lr='ll -R'	# recursive ls
alias la='ll -A'	# show hidden files
alias tree='tree -Csuh'	# nice alternative to recursive `ls`

## tailoring less
#alias more='less'
#export PAGER=less
#export LESSCHARSET='latin1'
#export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
#                # Use this if lesspipe.sh exists.
#export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
#:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
#
#LESS man page colors (makes Man pages more readable).
#export LESS_TERMCAP_mb=$'\E[01;31m'
#export LESS_TERMCAP_md=$'\E[01;31m'
#export LESS_TERMCAP_me=$'\E[0m'
#export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;44;33m'
#export LESS_TERMCAP_ue=$'\E[0m'
#export LESS_TERMCAP_us=$'\E[01;32m'

# OS-specific aliases
### TODO: program shortcuts, etc?
###       See "A note about os specific aliases" in:
###       http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

# start ssh-agent
ssh-setup

if ! ssh-add -l > /dev/null; then
	echo 'Dead socket, clearing cached file' \
	     'and retrying ssh-agent setup'
	rm ~/.ssh/ssh_auth_sock
	ssh-setup
fi

# programmable completion
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
if [ "$(echo "${BASH_VERSION}" | cut -d '.' -f '1')"  -lt "3" ]; then
	echo 'You will need to upgrade to version 3.0 for full' \
	     'programmable completion features'
	return
fi

shopt -s extglob

complete -A hostname	rsh rcp telnet rlogin ftp ping disk
complete -A export	printenv
complete -A variable	export local readonly unset
complete -A enabled	builtin
complete -A alias	alias unalias
complete -A function	function
complete -A user	su mail finger

complete -A helptopic	help	# currently same as builtins
complete -A shopt	shopt
complete -A stopped -P '%' bg
complete -A job -P '%'	fg jobs disown

complete -A directory	mkdir rmdir
complete -A directory	-o default cd

# compression
complete -f -o default -X '*.+(zip|ZIP)'	zip
complete -f -o default -X '!*.+(zip|ZIP)'	unzip
complete -f -o default -X '*.+(z|Z)'		compress
complete -f -o default -X '!*.+(z|Z)'		uncompress
complete -f -o default -X '*.+(gz|GZ)'		gzip
complete -f -o default -X '!*.+(gz|GZ)'		gunzip
complete -f -o default -X '*.+(bz2|BZ2)'	bzip2
complete -f -o default -X '!*.+(bz2|BZ2)'	bunzip2
complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)'	extract

complete -f -o default -X '!*.pl'	perl perl5

#export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
#export HISTIGNORE="&:bg:fg:ll:h"
#export HISTTIMEFORMAT="$(echo ${BCyan})[%d/%m %H:%M:%S]$(echo ${NC}) "
#export HISTCONTROL=ignoredups
#export HOSTFILE=$HOME/.hosts	# Put a list of remote hosts in ~/.hosts

# echo motd
echo "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${NC}\n"
date
if [ -x fortune ]; then
	fortune -s	# Makes the day a bit more fun :)
fi

# move to bash start dir
cd "$bash_start_dir" || exit 0
