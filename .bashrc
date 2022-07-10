# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

# Autocompletion
complete -cf doas 

# aliases
#alias pluginstall-all="~/.local/bin/pluginstall-all.sh"
#alias recompiledwm='doas emerge -q dwm'
#alias recompilest='doas emerge -q st'
#alias recompileurxvt='xrdb ~/.Xresources'
#alias doom='~/.emacs.d/bin/doom'

# import aliases
[ -f "$HOME/.aliasrc" ] && source "$HOME/.aliasrc"

# boot up zsh when opening urxvt
if [[ "$TERM" == *rxvt* ]]; then
   exec zsh
fi


