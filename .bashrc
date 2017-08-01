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
bash_util_dir=~/.bashrc_util

# function globals
gh_oauth_file="${bash_util_dir}/github-oauth"
if [[ -f "$gh_oauth_file" && $(wc -l < "$gh_oauth_file") == 2 ]]; then
	gh_oauth_frag="?client_id=$(head -n 1 "$gh_oauth_file")&client_secret="
	gh_oauth_frag+="$(tail -n 1 "$gh_oauth_file")"
else
	gh_oauth_frag=''
fi
gh_api_base_url='https://api.github.com'


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

# Bright
export COLOR_BBlack='\e[1;30m'
export COLOR_BRed='\e[1;31m'
export COLOR_BGreen='\e[1;32m'
export COLOR_BYellow='\e[1;33m'
export COLOR_BBlue='\e[1;34m'
export COLOR_BPurple='\e[1;35m'
export COLOR_BCyan='\e[1;36m'
export COLOR_BWhite='\e[1;37m'

# Background
export COLOR_On_Black='\e[40m'	# Equivalent to COLOR_Black
export COLOR_On_Red='\e[41m'	# Equivalent to COLOR_Red
export COLOR_On_Green='\e[42m'	# Equivalent to COLOR_Green
export COLOR_On_Yellow='\e[43m'	# Equivalent to COLOR_Yellow
export COLOR_On_Blue='\e[44m'	# Equivalent to COLOR_Blue
export COLOR_On_Purple='\e[45m'	# Equivalent to COLOR_Purple
export COLOR_On_Cyan='\e[46m'	# Equivalent to COLOR_Cyan
export COLOR_On_White='\e[47m'	# Equivalent to COLOR_White

# Color Reset
export COLOR_NC="\e[m"

# Alert color (bold white on red background)
export COLOR_ALERT="${COLOR_BWhite}${COLOR_On_Red}"


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
alias path='echo -e ${PATH//:/\\n}'	# pretty-print $PATH dirs
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

# Ensure `xdg-open` exists for opening web browser pages
if ! type xdg-open &>/dev/null; then
	alias xdg-open='python -m webbrowser'
fi


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
# TODO: check OS and load what is necessary; for now, just load all aliases.*
#       See "A note about os specific aliases" in:
#       http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html
for alias_file in "$bash_util_dir"/aliases.* ; do
	if ! grep -q -E '\.sample$' <<< "$alias_file"; then
		# shellcheck disable=SC1090,SC1091
		. "$alias_file"
	fi
done

# thefuck alias
if type thefuck &>/dev/null; then
	eval "$(thefuck --alias)"
fi


### functions

# start ssh, only prompting for password on new ssh-agent creation
# (http://unix.stackexchange.com/a/217223/136537)
function ssh-setup {
	local loaded_idents
	if [ ! -S ~/.ssh/ssh_auth_sock ]; then
		eval "$(ssh-agent)"
		ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
	fi
	export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

	# only performs `ssh-add` if key is not loaded in agent and
	# only on files which have a header indicating it is an SSH key;
	# runs grep quietly for neatness
	loaded_idents="$(ssh-add -l)"
	for file in ~/.ssh/* ; do
		if [[ -f "$file" ]] && \
		grep -q -- '-BEGIN RSA PRIVATE KEY-' "$file" && \
		! grep -q "$file" <<< "$loaded_idents";
		then
			ssh-add "$file"
		fi
	done
}

# test colors available in the terminal
# (http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html)
function colortest {
	local T FGs FG BG
	T='gYw'   # The test text

	echo -e '\n                 40m     41m     42m     43m' \
	        '    44m     45m     46m     47m';

	for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' \
	           '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' \
	           '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m';
		do FG=${FGs// /}
		echo -en " $FGs \033[$FG  $T  "
		for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
			do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
		done
		echo
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
	[ "$#" -ne 2 ] && echo "${FUNCNAME[0]}: 2 arguments needed" && return 1
	[ ! -e "$1" ] && echo "${FUNCNAME[0]}: $1 does not exist" && return 2
	[ ! -e "$2" ] && echo "${FUNCNAME[0]}: $2 does not exist" && return 2

	local TMPFILE
	TMPFILE=tmp.$$

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
# each processes at most one parameter containing the path to traverse
# after going up N levels, where N is the number in the function name
function .. {
	.1 "$1"
}

function .1 {
	local prepend_path
	prepend_path=..
	.cd "${prepend_path}/${1}"
}

function .2 {
	local prepend_path
	prepend_path=../..
	.cd "${prepend_path}/${1}"
}

function .3 {
	local prepend_path
	prepend_path=../../..
	.cd "${prepend_path}/${1}"
}

function .4 {
	local prepend_path
	prepend_path=../../../..
	.cd "${prepend_path}/${1}"
}

function .5 {
	local prepend_path
	prepend_path=../../../../..
	.cd "${prepend_path}/${1}"
}

function .6 {
	local prepend_path
	prepend_path=../../../../../..
	.cd "${prepend_path}/${1}"
}

function .7 {
	local prepend_path
	prepend_path=../../../../../../..
	.cd "${prepend_path}/${1}"
}

function .8 {
	local prepend_path
	prepend_path=../../../../../../../..
	.cd "${prepend_path}/${1}"
}

function .9 {
	local prepend_path
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

# prints given elements in $2 ... joined by the string in $1
function join_by {
	if [ $# -lt 2 ]; then return 1; fi

	local d

	d="$1"
	shift
	echo -n "$1"
	shift
	printf '%s' "${@/#/$d}"
}

# Compact wrapper function for GitHub API calls
# Prints API response for a given path, using available OAuth credentials
# if available.
# Returns 1 for argument mismatch (not exactly 1 argument)
# Returns 2 if GitHub rate limit has been reached
function query_github_api {
	[ "$#" -ne 1 ] && echo "${FUNCNAME[0]}: 1 argument needed" >&2 && return 1

	local gh_rate_limit_resp gh_rate_limit_remaining gh_rate_limit_reset
	gh_rate_limit_resp="$(
		curl -sI "${gh_api_base_url}/rate_limit${gh_oauth_frag}"
	)"
	gh_rate_limit_remaining="$(
		grep 'X-RateLimit-Remaining: ' <<< "${gh_rate_limit_resp}" |
		cut -d ' ' -f '2'
	)"
	if [ "$gh_rate_limit_remaining" -eq '0' ]; then
		gh_rate_limit_reset="$(
			grep 'X-RateLimit-Reset: ' <<< "${gh_rate_limit_resp}" |
			cut -d ' ' -f '2'
		)"
		{
			echo "${FUNCNAME[0]}: GitHub API rate limit reached!"
			echo "This limit is reset at ${gh_rate_limit_reset}"
		} >&2
		return 2
	else
		curl -s "${gh_api_base_url}/${1}${gh_oauth_frag}"
	fi
}

# checks for jq updates, downloads if needed
# does not rely on query_github_api(), as that function depends on jq
function jq-check {
	# For now, only process on Windows; OSX and linux will use package managers
	# see https://stedolan.github.io/jq/download/ for info
	# run update command (no-op on latest package version is fine)
	if uname -s | grep -q 'MINGW'; then
		local gh_rate_limit_remaining jq_url_frag gh_response jq_gh_version \
		  arch download_url
		gh_rate_limit_remaining="$(
			curl -sI "${gh_api_base_url}/rate_limit${gh_oauth_frag}" |
			grep 'X-RateLimit-Remaining: ' |
			cut -d ' ' -f '2'
		)"
		if [ "$gh_rate_limit_remaining" != '0' ]; then
			jq_url_frag='repos/stedolan/jq/releases/latest'
			gh_response="$(
				curl -s "${gh_api_base_url}/${jq_url_frag}${gh_oauth_frag}"
			)"
			jq_gh_version="$(
				grep '"tag_name"' <<< "$gh_response" |
				awk -F\" '{print $(NF-1)}'
			)"
			if ! type jq &>/dev/null ||
			   [ "$(jq --version)" != "$jq_gh_version" ];
			then
				echo 'Downloading jq...'
				if grep '64' <<< "$(uname -m)" ; then
					arch='64'
				else
					arch='32'
				fi
				download_url="$(
					grep '"browser_download_url"' <<< "$gh_response" |
					grep "win${arch}" |
					awk -F\" '{print $(NF-1)}'
				)"
				curl -L -o ~/bin/jq.exe "$download_url"
				echo 'jq installed!'
				echo
			fi
		fi
	fi
}

# checks for Git for Windows updates (does not run in Cygwin/Linux)
function git-for-windows-check {
	if uname -s | grep -q 'MINGW'; then
		local git_href_frag git_for_windows_api_resp current_git_version \
		  latest_git_version latest_git_release_page
		git_href_frag='repos/git-for-windows/git/releases/latest'
		git_for_windows_api_resp="$(query_github_api "$git_href_frag")" ||
			echo \
			  'GitHub API rate limit reached, skipping git-for-windows check' \
			  >&2 &&
			return 1
		current_git_version="$(
			git --version |
			sed 's/git version */v/'
		)"
		latest_git_version="$(
			jq -r '.tag_name' <<< "$git_for_windows_api_resp"
		)"
		if [ "$current_git_version" != "$latest_git_version" ]; then
		  latest_git_release_page="$(
			jq -r '.html_url' <<< "$git_for_windows_api_resp"
		  )"
		  echo -e "${COLOR_ALERT}Your version of Git for Windows" \
				  "(${current_git_version}) is out of date!${COLOR_NC}"
		  echo -e "The latest version (${latest_git_version})" \
				  'can be downloaded here:'
		  echo -e "  ${COLOR_BGreen}${latest_git_release_page}${COLOR_NC}"
		  echo
		fi
	fi
}

# Checks to ensure Python2 (python) and Python3 (python3) are installed, and
# are of the correct versions (python =/= Python3)
# Returns 1 if python or python3 are absent
# Returns 2 if python/python3 do not associate to Python2/Python3, respectively
# As of now, only prints the download URL if missing or mismatched
# TODO: improve this function--download Windows installer
# TODO: add UNIX package manager commands for non-Windows systems
function python-check {
	local error return_val python_download_url
	error=''
	return_val=0
	python_download_url='https://www.python.org/downloads/'
	if ! type python &>/dev/null ||
	   ! type python3 &>/dev/null;
	then
		! type python &>/dev/null &&
		  error+="Python2 is missing!\n"
		! type python3 &>/dev/null &&
		  error+="Python3 is missing!\n"
		return_val=1
	fi
	if [ "$return_val" -eq 0 ] && (
	   ! python --version 2>&1 | grep -q ' 2.' ||
	   ! python3 --version 2>&1 | grep -q ' 3.'
	); then
		! python --version 2>&1 | grep -q ' 2.' &&
		  error+="${COLOR_Yellow}python${COLOR_NC} is not Python2!\n"
		! python3 --version 2>&1 | grep -q ' 3.' &&
		  error+="${COLOR_Yellow}python3${COLOR_NC} is not Python3!\n"
		return_val=2
	fi

	[[ ! -z "$error" ]] && {
		echo -e "$error"
		echo "Download python or python3 here: $python_download_url"
	} >&2
	return "$return_val"
}

# Prints a human-readable time from a passed number of seconds
function displaytime {
	[ "$#" -ne 1 ] && echo "${FUNCNAME[0]}: 1 argument needed" >&2 && return 1

	local T D H M S
	T="$1"
	D=$((T/60/60/24))
	H=$((T/60/60%24))
	M=$((T/60%60))
	S=$((T%60))
	[ "$D" -gt 0 ] &&
		echo -n "${D}d "
	([ "$D" -gt 0 ] || [ "$H" -gt 0 ]) &&
		printf '%02.0fh ' "$H"
	([ "$D" -gt 0 ] || [ "$H" -gt 0 ] || [ "$M" -gt 0 ]) &&
		printf '%02.0fm ' "$M"
	printf '%02.0fs' "$S"
}

# Prints the code for a random non-black color using echo -e
function randomcolor {
	local colors random_index
	colors=(
		# "$COLOR_Black" (cannot read on black bg)
		"$COLOR_Red"
		"$COLOR_Green"
		"$COLOR_Yellow"
		# "$COLOR_Blue" (very hard to read on black bg)
		"$COLOR_Purple"
		"$COLOR_Cyan"
		# "$COLOR_White" (can't differentiate from standard text)
		"$COLOR_BRed"
		"$COLOR_BGreen"
		"$COLOR_BYellow"
		"$COLOR_BBlue"
		"$COLOR_BPurple"
		"$COLOR_BCyan"
		"$COLOR_BWhite"
	)
	random_index="$(shuf -i 1-"${#colors[@]}" -n 1)"
	random_index=$(( random_index - 1 ))
	echo -e "${colors[$random_index]}"
}

# Prints the message of the day (time, shell info, system info, etc.)
function motd {
	local kernel_string uptime_seconds uptime_msg cpuinfo cpu_model cpu_cores \
	      cpu_msg free_memory total_memory mem_msg

	# Print shell info
	echo -e "$(randomcolor)This is BASH" \
			"$(randomcolor)${BASH_VERSION%.*}${COLOR_NC}"
	kernel_string="$(
		(
			uname -s
			uname -r
			uname -m
			uname -o
		) | tr "\n" ' '
	)"
	echo -e "This kernel is: $(randomcolor)${kernel_string}${COLOR_NC}"

	# Print date and uptime
	echo -e "It's $(randomcolor)$(date)${COLOR_NC}"
	uptime_seconds="$(cut -d '.' -f 1 < /proc/uptime)"
	uptime_msg="This machine has been up for $(randomcolor)"
	uptime_msg+="$(displaytime "$uptime_seconds")${COLOR_NC}"
	echo -e "$uptime_msg"
	echo

	# Print CPU and Memory info
	cpuinfo="$(cat /proc/cpuinfo)"
	cpu_model="$(
		grep -m 1 'model name' <<< "$cpuinfo" |
		cut -d ':' -f 2 |
		sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
	)"
	cpu_cores="$(
		grep -m 1 'cpu cores' <<< "$cpuinfo" |
		cut -d ':' -f 2 |
		sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
	)"
	cpu_msg="CPU: $(randomcolor)${cpu_model} ${cpu_cores}-core processor"
	cpu_msg+="${COLOR_NC}"
	echo -e "$cpu_msg"
	# TODO: simplify memory calculation, color-code free memory,
	#       show more human-readable numbers
	free_memory="$(
		grep 'MemFree' < /proc/meminfo |
		sed -r -e 's/^.+ ([[:digit:]]+.+)$/\1/'
	)"
	total_memory="$(
		grep 'MemTotal' < /proc/meminfo |
		sed -r -e 's/^.+ ([[:digit:]]+.+)$/\1/'
	)"
	mem_msg="Memory: ${COLOR_BYellow}${free_memory}${COLOR_NC}/${COLOR_BGreen}"
	mem_msg+="${total_memory}${COLOR_NC} available"
	echo -e "$mem_msg"
	echo

	# Print fortune, if avialable
	if type fortune &>/dev/null; then
		fortune -s
	fi
}

# Runs software checks and pulls .dotfiles repo if branch is master
function software-and-bashrc-check {
	local dotfiles_update_output
	jq-check
	git-for-windows-check
	python-check
	dotfiles_update_output="$(
		cd "$bash_start_dir" &&
		[[ "$(git symbolic-ref --short HEAD)" == 'master' ]] &&
		git pull --ff-only
	)"
	if [[ "$dotfiles_update_output" != 'Already up-to-date.' ]]; then
		echo "$dotfiles_update_output"
	fi
}

# exit function
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
function _exit {
	# for some reason, this doesn't respect our alias...
	# must explicitly add `-e` flag for colors to be shown
	echo -e "$(randomcolor)Bye!${COLOR_NC}"
	sleep 0.5
}
trap _exit EXIT


# programmable completion
# (http://tldp.org/LDP/abs/html/sample-bashrc.html)
if [ "$(cut -d '.' -f '1' <<< "$BASH_VERSION")"  -lt "3" ]; then
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
# notably returns files/dirs in parent directories from PWD
function .complete {
	local cmd word
	cmd="$1"
	word=${COMP_WORDS[COMP_CWORD]}

	if ! grep -q -E '^\.[.1-9]$' <<< "$cmd"; then
		echo "${FUNCNAME[0]}: parent function must match '.[.1-9]'"
		return 1
	fi

	local parent_depth path_array parent_path
	parent_depth="${cmd//.}"
	if [[ -z "$parent_depth" ]]; then
		parent_depth=1
	fi
	path_array=()
	for (( i=0; i<parent_depth; i++ )); do
		path_array+=( '..' )
	done
	parent_path="$(join_by '/' "${path_array[@]}")"

	COMPREPLY=(
		$(
			compgen -W "$(
				printf "%s\n" "$parent_path"/*/ |
				sed -e 's|^\(../\)*||'
			)" -- "$word"
		)
	)
}

complete -F .complete .. .1 .2 .3 .4 .5 .6 .7 .8 .9

#export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
#export HISTIGNORE="&:bg:fg:ll:h"
#export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
#export HISTCONTROL=ignoredups
#export HOSTFILE=$HOME/.hosts	# Put a list of remote hosts in ~/.hosts

# start ssh-agent
ssh-setup 2>/dev/null

if ! ssh-add -l > /dev/null; then
	echo 'Dead socket, clearing cached file' \
	     'and retrying ssh-agent setup'
	rm ~/.ssh/ssh_auth_sock
	ssh-setup
fi

# echo motd
motd

# move to bash start dir
cd "$bash_start_dir" ||
  (
	  echo "Bash start dir '${bash_start_dir}' could not be found!" &&
	  exit 1
  )

software-and-bashrc-check
