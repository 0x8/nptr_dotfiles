#!/usr/bin/env bash

# @Ian Guibas
# A simple installer for my dotfiles as symlinks. This installer attmepts to
# preserve all exisitng, non-symlinked config files and directories but it is
# far from perfect.

# Self references
path_to_script="$(readlink -f $0)"
path_to_self="$(dirname "$path_to_script")"

# User-defineable rc file backup location (for those that _can_ be backed up).
BACKUP_LOCATION="$HOME/.rc_file_backups"
if [ ! -d "$BACKUP_LOCATION" ]
then
    mkdir -p "$BACKUP_LOCATION"
fi

# LOGGING TAGS
info="\x1b[1;37m[INFO]\x1b[0m"
warn="\x1b[1;35m[WARN]\x1b[0m"
error="\x1b[1;31m[ERROR]\x1b[0m"

echo -e  "$info Started dotfile installer."
echo -e  "$info Backups can be found at $BACKUP_LOCATION"

# Link loose files
for file in $(ls -a $path_to_self)
do
    src="$path_to_self/$file"
    dest="$HOME/$file"
    if [[ $file == "install.sh" ]]
    then
        echo -e "$info Skipping install script."
    else
        if [ -f $src ]
        then
            # $src is a non-directory file

            # Check for existing files and symlinks
            if [ -h "$dest" ]
            then
                # Remove existing symlink
                echo -e  "$warn Found existing [$file] symlink. Removing."
                rm "$dest"

            elif [ -f "$dest" ]
            then
                # backup existing
                echo -e  "$info Found existing [$file]. Creating backup."
                mv "$dest" "$BACKUP_LOCATION"
            
            fi

            # Make the new link
            echo -e  "$info Linking [$src] to [$dest]"
            ln -s $src $dest 
        fi 
    fi
done


# Link backgrounds to $HOME/.backgrounds
if [ -h "$HOME/.backgrounds" ]
then
    # Remove existing link
    echo -e  "$warn Found existing .backgrounds symlink. Removing."
    rm "$HOME/.backgrounds"
elif [ -d "$HOME/.backgrounds" ]
then
    # backup backgrounds dir
    echo -e  "$warn Found existing .backgrounds dir. Creating backup."
    mv "$HOME/.backgrounds" "$BACKUP_LOCATION/.backgrounds"
fi
# Make new link
echo -e  "$info Linking [$path_to_self/backgrounds] to [$HOME/.backgrounds]"
ln -s "$path_to_self/backgrounds" "$HOME/.backgrounds"


# Link .config/
for dir in $(ls -a "$path_to_self/.config")
do
    src="$path_to_self/.config/$dir"
    dest="$HOME/.config/$dir"
    if [ -h "$dest" ]
    then
        # destination is a symlink, we can just remove and overwrite it
        # without harming the original file.
        echo -e  "$warn Found existing symlink to [.config/$dir]. Removing."
        rm "$dest"

    elif [ -d "$dest" ]
    then
        # Exists as dir in home, make a backup
        echo -e  "$info Found existing [.config/$dir] at [$dest]. Creating backup."
        mv $dest $BACKUP_LOCATION
    fi
    
    # Make the new link
    echo -e  "$info Linking [$src] to [$dest]"
    ln -s "$src" "$dest"
done


# Link binaries to /usr/local/bin
# Note: The term "binary" is used wrong here but I'm leaving it as is
# -- Ensure backup location exists with proper subdirs
if [ ! -d $BACKUP_LOCATION/binaries ]
then
    echo -e  "$info Did not find a backup subdirectory for binaries. Creating one."
    mkdir -p $BACKUP_LOCATION/binaries
fi
# -- Iterate through the binaries
for binary in $(ls binaries)
do
    src="$path_to_self/binaries/$binary"
    dest="/usr/local/bin/$binary"
    if [ -h "$dest" ]
    then
        echo -e  "$warn Found existing $dest symlink. Removing."
        sudo rm "$dest"

    elif [ -f "$dest" ]
    then
        echo -e  "$info Found existing [$binary] in [$dest]. Creating backup"
        sudo cp "$dest" "$BACKUP_LOCATION/binaries"
    fi
    

    echo -e  "$info Linking [$src] to [$dest]"
    sudo ln -s $path_to_self/binaries/$binary /usr/local/bin/$binary
done


# Fix up .tmux.conf POWERLINELOC
powerlineloc=$(pip show powerline-status | grep Location | cut -d" " -f2)
if [ ! -z "$powerlineloc" ]
then
    echo -e "$info Found powerline-status installed. Ensuring powerline is enabled"
    sed -i "s/\#run-shell \"powerline/run-shell \"powerline/g" $HOME/.tmux.conf
    sed -i "s@\#source /usr/local/lib/python@source /usr/local/lib/python@g" $HOME/.tmux.conf
else
    echo -e "$warn Failed to find powerline-status, Disabling tmux powerline"
    sed -i "s/run-shell \"powerline/\#run-shell \"powerline/g" $HOME/.tmux.conf
    sed -i "s@source /usr/local/lib/python@\#source /usr/local/lib/python@g" $HOME/.tmux.conf
fi

# Fix up vimrc to enable vim pathogen if it is installed
if [ -d "$HOME/.vim/autoload" ]
then
    # Found vim autoload dir, check for pathogen.vim
    if [ -f "$HOME/.vim/autoload/pathogen.vim" ]
    then
        echo -e "$info Found vim pathogen, ensuring it is enabled in vimrc"
        sed -i "s/\"execute path/execute path/g" $HOME/.vimrc
    else
        echo -e "$warn Failed to find vim pathogen. Ensuring call is commented out"
        sed -i "s/^execute path/\"execute path/g" $HOME/.vimrc
    fi
else
    # Pathogen not installed, ensure command is commented
    echo -e "$warn Failed to find vim autoload dir, pathogen not installed"
    sed -i "s/^execute path/\"execute path/g" $HOME/.vimrc
fi


# Write a simple gitconfig based on env-vars
GCONF="$HOME/.gitconfig"
if [ -e "$HOME/.gitconfig" ] # Handle existing config
then
    # Make a backup of the existing config
    echo -e "$info Found existing .gitconfig, backing it up."
    mv "$HOME/.gitconfig" "$BACKUP_LOCATION/.gitconfig_backup"
fi
# Now can write the new file
echo -e "$info Writing new .gitconfig based on environment."
echo "[User]" >> "$GCONF"
echo "    name = $USER" >> "$GCONF"
echo "    email = $USER@$HOST" >> "$GCONF"
echo "[Core]" >> "$GCONF"
echo "    editor = vim" >> "$GCONF"

