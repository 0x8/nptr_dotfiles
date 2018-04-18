#!/bin/bash

# Remove symlinks if a run is unsuccessful for any reason

check_and_del_link () {
    config="$(echo "$HOME""/""$1")"
    if [ -h "$config" ]
    then       
        rm "$config"
    fi
}

check_and_del_link .aliases
check_and_del_link .bashrc
check_and_del_link .envvars
check_and_del_link .fehbg
check_and_del_link .config/i3/config
check_and_del_link .pythonrc
check_and_del_link .tmux.conf
check_and_del_link .vimrc
check_and_del_link .zshrc
