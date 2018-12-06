#!/bin/bash

######################################################
# Set up the new dotfiles as symlinks while preserving  
# existing configs                                      
######################################################

# GLOBAL Reference to self (needed when linking)
path_to_script="$(readlink -f $0)"
path_to_self=$"$(dirname "$path_to_script")"

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
        echo "[INFO] Backing up $1 to $backup_location"
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
backup_rc_file $HOME/.config/i3/config
backup_rc_file $HOME/.config/i3status/config
backup_rc_file $HOME/.pythonrc
backup_rc_file $HOME/.tmux.conf
backup_rc_file $HOME/.vimrc
backup_rc_file $HOME/.zshrc

# Given the name of a dotfile provided by this repo,
# create a symlink to it in the appropriate place
link_rc_file () {
    
    # Define the full path to the referenced dotfile
    new_rc_file="$path_to_self""/""$1"
    
    # Check for i3config and i3status as they are
    # treated differently than the other config files
    if [[ "$(basename $1)" == "i3config" ]]
    then
        link_loc="$HOME""/.config/i3/config"
    elif [[ "$(basename $1)" == "i3status" ]]
    then
        # Check that .config/i3status/ exists and
        # create it if not. This is because for some
        # reason or another, it tends to not be a
        # default folder but i3status looks here for
        # userspace extensions
        if [ ! -d "$HOME/.config/i3status" ]
        then
            echo "Creating i3status config folder ... "
            mkdir -p "$HOME/.config/i3status" 
        fi
        
        # Set the link location
        link_loc="$HOME""/.config/i3status/config"
    else
        link_loc="$HOME""/""$1"
    fi

    # Generate the symlink
    # (ln -s TARGET LINK_NAME)
    echo "[INFO] Linking $link_loc to $new_rc_file"
    ln -s $new_rc_file $link_loc
}

# Create the symlink for each file
echo "Creating links to dotfiles ... "
link_rc_file .aliases
link_rc_file .bashrc
link_rc_file .envvars
link_rc_file i3config
link_rc_file i3status
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
echo "Linking i3exit into /usr/bin ... "
echo "This will require sudo access"
echo "Please review the script if you do not trust this operation"
echo "You are looking for line 119"
sudo ln -s "$path_to_self/i3exit" /usr/bin/i3exit

# Fix up .tmux.conf POWERLINELOC
powerlineloc=$(pip show powerline-status | grep Location | cut -d" " -f2)
if [ ! -z "$powerlineloc" ]
then
    # powerlineloc initially simply evaluates whether or not powerline-status
    # is installed via pip, but won't point to the actual location. If the
    # var is non-empty we know it exists and can fill in the rest of the path
    powerlineloc=$powerlineloc/powerline/bindings/tmux/powerline.conf
    sed -i "s/POWERLINELOC/$powerlineloc/g" $HOME/.tmux.conf
else
    # If we failed to find powerline, we need to disable the powerline shell 
    # command and comment out the pointer to powerline so we don't get errors
    # on tmux start
    sed -i "s/run-shell/#run-shell/g" $HOME/.tmux.conf
    sed -i "s/source POWERLINELOC/#source POWERLINELOC/g" $HOME/.tmux.conf
fi


