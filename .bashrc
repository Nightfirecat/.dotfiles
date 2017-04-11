#!/bin/bash
### .bashrc examples:
###   * http://tldp.org/LDP/abs/html/sample-bashrc.html
###   * http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# source global definitions (if any)
if [ -f /etc/bashrc ]; then
	# shellcheck disable=SC1091
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
shopt -s progcomp
shopt -s promptvars
shopt -s sourcepath

shopt -u mailwarn
shopt -u nullglob	# `ls nonexist/*` should fail, not act like `ls`
#unset MAILCHECK	# don't want shell to warn me of incoming mail

# bash time/hist/host file and formatting vars exported after color vars
# are defined, toward bottom of script; see before '# echo motd'


### variables

# dirs
bash_start_dir="$HOME"

# colors
# Normal colors
export COLOR_Black='\e[0;30m'
export COLOR_Red='\e[0;31m'
export COLOR_Green='\e[0;32m'
export COLOR_Yellow='\e[0;33m'
export COLOR_Blue='\e[0;34m'
export COLOR_Purple='\e[0;35m'
export COLOR_Cyan='\e[0;36m'
export COLOR_White='\e[0;37m'

# Bold
export COLOR_BBlack='\e[1;30m'
export COLOR_BRed='\e[1;31m'
export COLOR_BGreen='\e[1;32m'
export COLOR_BYellow='\e[1;33m'
export COLOR_BBlue='\e[1;34m'
export COLOR_BPurple='\e[1;35m'
export COLOR_BCyan='\e[1;36m'
export COLOR_BWhite='\e[1;37m'

# Background
export COLOR_On_Black='\e[40m'
export COLOR_On_Red='\e[41m'
export COLOR_On_Green='\e[42m'
export COLOR_On_Yellow='\e[43m'
export COLOR_On_Blue='\e[44m'
export COLOR_On_Purple='\e[45m'
export COLOR_On_Cyan='\e[46m'
export COLOR_On_White='\e[47m'

# Color Reset
export COLOR_NC="\e[m"

# Alert color (bold white on red background)
export COLOR_ALERT="${COLOR_BWhite}${COLOR_On_Red}"


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

	[ "$#" -ne 2 ] && echo "${FUNCNAME[0]}: 2 arguments needed" && return 1
	[ ! -e "$1" ] && echo "${FUNCNAME[0]}: $1 does not exist" && return 2
	[ ! -e "$2" ] && echo "${FUNCNAME[0]}: $2 does not exist" && return 2

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
			                  "via >${FUNCNAME[0]}<" ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

# functions for fast traversal through parent directories
# each acknowledges at most one parameter, containing the path to be traversed
# after going up N levels, where N is chosen in the function name
function .. {
  .1 "$1"
}

function .1 {
  prepend_path=..
  .cd "${prepend_path}/${1}"
}

function .2 {
  prepend_path=../..
  .cd "${prepend_path}/${1}"
}

function .3 {
  prepend_path=../../..
  .cd "${prepend_path}/${1}"
}

function .4 {
  prepend_path=../../../..
  .cd "${prepend_path}/${1}"
}

function .5 {
  prepend_path=../../../../..
  .cd "${prepend_path}/${1}"
}

function .6 {
  prepend_path=../../../../../..
  .cd "${prepend_path}/${1}"
}

function .7 {
  prepend_path=../../../../../../..
  .cd "${prepend_path}/${1}"
}

function .8 {
  prepend_path=../../../../../../../..
  .cd "${prepend_path}/${1}"
}

function .9 {
  prepend_path=../../../../../../../../..
  .cd "${prepend_path}/${1}"
}

# attempts to navigate to the passed path and print its canonical path
# (similar to `cd -`)
function .cd {
  if cd "$1"; then
    readlink -f .
  fi
}

# prints given elements in $2... joined by the character/string in $1
# useful for joining elements of an array, ala `join_by "$str" "${arr[@]}"`
function join_by {
  if [ $# -lt 2 ]; then return 1; fi
  local d
  d="$1"
  shift
  echo -n "$1"
  shift
  printf '%s' "${@/#/$d}"
}

# checks for Git for Windows updates (does not run in Cygwin/Linux)
function git-for-windows-check {
	if [ ! -z "$EXEPATH" ]; then
		github_api_base_url='https://api.github.com'
		github_rate_limit_status="$(
			curl -sI "${github_api_base_url}/rate_limit" |
			grep 'Status: ' |
			cut -d ' ' -f '2'
		)"
		if [ "$github_rate_limit_status" == '200' ]; then
			current_git_version="$(
				git --version |
				sed 's/git version */v/'
			)"
			git_href_frag='repos/git-for-windows/git/releases/latest'
			git_for_windows_api_resp="$(
				curl -s "${github_api_base_url}/${git_href_frag}"
			)"
			latest_git_version="$(
				echo "$git_for_windows_api_resp" |
				grep '"tag_name"' |
				awk -F\" '{print $(NF-1)}'
			)"
			if [ "$current_git_version" != "$latest_git_version" ]; then
				latest_git_release_page="$(
					echo "$git_for_windows_api_resp" |
					grep -e '^  "html_url"' |
					awk -F\" '{print $(NF-1)}'
				)"
				echo -e "${ALERT}Your version of Git for Windows" \
				        "(${current_git_version}) is out of date!${NC}"
				echo -e "The latest version (${latest_git_version})" \
				        'can be downloaded here:'
				echo -e "  ${COLOR_BGreen}${latest_git_release_page}${COLOR_NC}"
				echo
			fi
		fi
	fi
}

# exit function
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
function _exit {
	# for some reason, this doesn't respect our alias...
	# must explicitly add `-e` flag for colors to be shown
	echo -e "${COLOR_BCyan}Bye!${COLOR_NC}"
	sleep 0.5
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

# add colors for filetype and human-readable sizes by default on `ls`
alias ls='ls -h --color --show-control-chars'
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
ssh-setup 2>/dev/null

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

# returns completion items for .* functions
# notably returns files/dirs in parent directories where the command is called
function .complete {
  local cmd word
  cmd="$1"
  word=${COMP_WORDS[COMP_CWORD]}

  if ! echo "$cmd" | grep -q -E '^\.[1-9]$'; then
    echo "${FUNCNAME[0]}: parent function must match '.[1-9]'"
  fi

  local parent_depth path_array parent_path
  parent_depth="${cmd//.}"
  path_array=()
  for (( i=0; i<parent_depth; i++ )); do
    path_array+=( '..' )
  done
  parent_path="$(join_by '/' "${path_array[@]}")"

  COMPREPLY=($(compgen -W "$(\ls "$parent_path")" -- "$word"))
}

complete -F .complete .1 .2 .3 .4 .5 .6 .7 .8 .9

#export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
#export HISTIGNORE="&:bg:fg:ll:h"
#export HISTTIMEFORMAT="$(echo ${BCyan})[%d/%m %H:%M:%S]$(echo ${NC}) "
#export HISTCONTROL=ignoredups
#export HOSTFILE=$HOME/.hosts	# Put a list of remote hosts in ~/.hosts

# echo motd
echo "${COLOR_BCyan}This is BASH ${COLOR_BRed}${BASH_VERSION%.*}${COLOR_NC}\n"
date && echo
git-for-windows-check
if command -v fortune >/dev/null; then
	fortune -s	# Makes the day a bit more fun :)
fi

# move to bash start dir
cd "$bash_start_dir" || exit 0
