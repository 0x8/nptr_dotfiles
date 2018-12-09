#!/usr/bin/env bash:w

# @Ian Guibas
# This is a new custom installer for my dotfiles found here.
# It is made with a non-destructive nature in mind while allowing
# easy updates via git pull.

# Specify where  existing files should be backed up to when possible
# and ensure the location exists.
BACKUP_LOCATION=$HOME/.rc_backups
if [ ! -d $BACKUP_LOCATION ]
then
    mkdir -p $BACKUP_LOCATION
fi

# Obtain a reference to the local directory for properly (and dynamically)
# linking the rc files later on
path_to_script="$(readlink -f $0)"
path_to_self="$(dirname "$path_to_script")"

backup_rc_file () {
    # @Param $1 : The path to the rc file we want to back up
    # @Goal : Create a backup of the given rc file to $BACKUP_LOCATION
    
    # Check if file is in .config in a rudimentary way (will need improvements)
    # by checking `basename $(dirname $(dirname $1))`. This works when the file
    # is merely 1 directory deep into .config (e.g. ".config/polybar/config")
    # but for anywhere that is not the case, will fail.
    conf_check="$(basename $(dirname $(dirname $1)))"
    if [[ $conf_check == ".config" ]]
    then
        # We have confirmed the file in question is in a directory within
        # .config, so we should verify first that
    fi

}

rc_file_linker () {
    # @Param $1 : The file we are linking, located in this directory
    # @Param $2 : The file we are linking TO, usually in $HOME or $HOME/.config
    # @Return : None
    # @Goal : The goal is to create symlinks to the files located within this 
    # space to the appropriate location for the config in question to take 
    # effect.



}
