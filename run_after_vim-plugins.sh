#!/bin/sh
# Install/update Vim plugins declared in ~/.vimrc using git directly (no vim).
#
# Parses the active `Plugin '...'` lines from ~/.vimrc and clones/pulls each
# into ~/.vim/bundle/<name>, replicating Vundle's spec -> URL -> directory rules
# (see s:parse_name in Vundle's autoload/vundle/config.vim). It deliberately
# does NOT run vim, so it does not regenerate :helptags — run :PluginInstall! or
# :PluginUpdate inside vim yourself if you want help docs.
#
# vimrc parsing rules honored:
#   * Commented lines (a leading `"`, indented or not) are ignored.
#   * Only the first quoted string on a line is used as the spec, so trailing
#     comments and option dicts (e.g. `, {'rtp': 'x/'}`) are stripped.
#   * A plugin's `rtp` option only changes vim's runtimepath at load time, not
#     where the repo is cloned, so it is correctly irrelevant here.
#   * The `set rtp+=...`, `call vundle#begin()/end()` lines aren't `Plugin`
#     directives, so they're never treated as plugins.
#   * NOT honored (none are used in this vimrc): a `{'name': 'x'}` override
#     (would change the clone dir) and `{'pinned': 1}` (would skip updates).
#
# Runs on every `chezmoi apply`/`update`: missing plugins are cloned, existing
# ones are `git pull`ed. ~/.vimrc is re-parsed each run, so added/removed
# `Plugin` lines are picked up immediately.

set -eu

command -v git >/dev/null 2>&1 || { echo "git not found; skipping Vim plugin setup" >&2; exit 0; }

vimrc="$HOME/.vimrc"
[ -f "$vimrc" ] || { echo "no $vimrc; skipping Vim plugin setup" >&2; exit 0; }

# Bundle dir = the directory holding Vundle.vim, derived from the
# `set rtp+=.../Vundle.vim` line in ~/.vimrc so that relocating Vundle there
# moves where plugins install. Handles rtp/runtimepath, +=/^=, and ~ / $HOME.
# Falls back to ~/.vim/bundle if no such line is found.
bundle_dir="$HOME/.vim/bundle"
rtp_path=$(awk '/^[ \t]*set[ \t]+(rtp|runtimepath)[+^]=.*[Vv]undle\.vim/ {
	line=$0
	sub(/^[ \t]*set[ \t]+(rtp|runtimepath)[+^]=/, "", line)   # strip up to +=/^=
	sub(/[ \t].*$/, "", line)                                 # strip trailing ws/comment
	print line
	exit
}' "$vimrc")
if [ -n "$rtp_path" ]; then
	rtp_path=${rtp_path%/}       # drop any trailing slash
	dir=${rtp_path%/*}           # dirname -> the bundle dir
	case $dir in
		"~")           dir=$HOME ;;
		"~/"*)         dir=$HOME/${dir#"~/"} ;;
		'$HOME'|'${HOME}')  dir=$HOME ;;
		'$HOME/'*)     dir=$HOME/${dir#'$HOME/'} ;;
		'${HOME}/'*)   dir=$HOME/${dir#'${HOME}/'} ;;
	esac
	bundle_dir=$dir
fi

# Map a Vundle plugin spec to its clone URL ($uri) and bundle dir name ($name),
# following Vundle's s:parse_name precedence: github shorthand / user-repo
# first, then explicit URLs, then a bare name (github.com/vim-scripts/<name>).
parse_spec() {
	spec=$1
	case $spec in
		gh:*|github:*)
			uri=https://github.com/${spec#*:}
			case $uri in *.git) ;; *) uri=$uri.git ;; esac ;;
		*://*|git@*)
			uri=$spec ;;
		*/*)
			uri=https://github.com/$spec
			case $uri in *.git) ;; *) uri=$uri.git ;; esac ;;
		*)
			uri=https://github.com/vim-scripts/$spec.git ;;
	esac
	name=${uri##*/}
	name=${name%.git}
}

mkdir -p "$bundle_dir"

# Active plugin specs: lines whose first token is `Plugin`, taking the first
# quoted string. \047 = single quote, \042 = double quote.
specs=$(awk '/^[ \t]*Plugin[ \t]/ { if (match($0, /[\047\042][^\047\042]+[\047\042]/)) print substr($0, RSTART+1, RLENGTH-2) }' "$vimrc")

# Plugin specs never contain whitespace, so word-splitting on $specs is safe.
for spec in $specs; do
	parse_spec "$spec"
	dest="$bundle_dir/$name"

	if [ -d "$dest/.git" ]; then
		echo "Updating $name ..."
		git -C "$dest" pull --ff-only --quiet \
			&& git -C "$dest" submodule update --init --recursive --quiet \
			|| echo "  ! update failed for $name" >&2
	else
		# Missing, or a stale non-git dir (e.g. the old submodule copy of
		# Vundle) — git clone refuses a non-empty target, so clear it first.
		if [ -e "$dest" ]; then
			echo "  replacing non-git dir $name"
			rm -rf "$dest"
		fi
		echo "Cloning $name ..."
		git clone --depth 1 --recurse-submodules --shallow-submodules --quiet "$uri" "$dest" \
			|| echo "  ! clone failed for $name" >&2
	fi
done
