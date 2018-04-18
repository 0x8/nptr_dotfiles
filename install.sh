#!/bin/bash

######################################################
# Set up the new dotfiles as symlinks while preserving  
# existing configs                                      
######################################################

# GLOBAL Reference to self (needed when linking)
path_to_self="$(readlink -f $0)"


#############################################
## Check for and backup existing config items
#############################################

# Create a function to reduce redundancy and 
# mv original config items to a safe location
# prior to link generation
backup_rc_file () {

    # Create a stashing directory if it doesn't exist
    if [ ! -d $HOME/.rc_file_backups ]
    then
        mkdir -p $HOME/.rc_file_backups
    fi

    # Define the paths we are working with
    path="$1"
    filename="$(basename $1)"
    backup_location="$HOME""/.rc_file_backups/""$filename"
    if [ -f "$1" ]
    then
        mv "$1" "$backup_location"
    fi
}

# Backup each file by providing its natural
# path to the backup_rc_file function defined
# above
echo "Checking for and backing up existing dotfiles ... "
echo "You can find these backups at the following location:"
echo "$HOME""/.rc_file_backups"
backup_rc_file $HOME/.aliases
backup_rc_file $HOME/.bashrc
backup_rc_file $HOME/.envvars
backup_rc_file $HOME/.fehbg
backup_rc_file $HOME/.config/i3/config
backup_rc_file $HOME/.pythonrc
backup_rc_file $HOME/.tmux.conf
backup_rc_file $HOME/.vimrc
backup_rc_file $HOME/.zshrc


# Given the name of a dotfile provided by this repo,
# create a symlink to it in the appropriate place
link_rc_file () {
    
    # Define the full path to the referenced dotfile
    new_rc_file="$path_to_self""/""$1"

    # Almost all files can simply be placed at the
    # $HOME base however for i3's configuration file
    # (i3config in this repo), the actual location
    # is in $HOME/.config/i3/config. This means we
    # must explicitly check for it and rename it
    # appropriately.
    if [[ "$(basename $1)" == "i3config" ]]
    then
        link_loc="$HOME""/.config/i3/config"
    else
        link_loc="$HOME""/""$1"
    fi

    # Generate the symlink
    # (ln -s TARGET LINK_NAME)
    ln -s $new_rc_file $link_loc
}

# Create the symlink for each file
echo "Creating links to dotfiles ... "
link_rc_file .aliases
link_rc_file .bashrc
link_rc_file .envvars
link_rc_file .fehbg
link_rc_file i3config
link_rc_file .pythonrc
link_rc_file .tmux.conf
link_rc_file .vimrc
link_rc_file .zshrc

# Copy the vmbg.jpg file to the Downloads folder.
# This shouldn't cause an issue but we will check
# for the 1 in a trillion chance of collision and
# make a backup.
if [ -f "$HOME/Downloads/vwbg.jpg" ]
then
    mv "$HOME/Downloads/vwbg.jpg" "$HOME/Downloads/vwbg_backup.jpg"
fi
# Copy the file
cp "$path_to_self""/vwbg.jpg" "$HOME""/Downloads/vwbg.jpg"

# "Install" i3exit by copying the executable script into /usr/bin
echo "Copying i3exit into /usr/bin ... "
echo "This will require sudo access"
echo "Please review the script if you do not trust this operation"
echo "You are looking for line 107"
sudo cp "$path_to_self/i3exit" /usr/bin/i3exit
