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

echo "$info Started dotfile installer."
echo "$info Backups can be found at $BACKUP_LOCATION"

# Link loose files
for file in $(ls -a $path_to_self)
do
    src="$path_to_self/$file"
    dest="$HOME/$file"
    if [ -f $src ]
    then
        # $src is a non-directory file

        # Check for existing files and symlinks
        if [ -f "$dest" ]
        then
            # backup existing
            echo "$info Found existing [$file]. Creating backup."
            mv "$dest" "$BACKUP_LOCATION"
        
        elif [ -h "$dest" ]
        then
            # Remove existing symlink
            echo "$warn Found existing [$file] symlink. Removing."
            rm "$dest"
        fi

        # Make the new link
        echo "$info Linking [$src] to [$dest]"
        ln -s $src $dest 
    fi 
done


# Link backgrounds to $HOME/.backgrounds
if [ -d "$HOME/.backgrounds" ]
then
    # backup backgrounds dir
    echo "$warn Found existing .backgrounds dir. Creating backup."
    mv "$HOME/.backgrounds" "$BACKUP_LOCATION/.backgrounds"

elif [ -h "$HOME/.backgrounds" ]
then
    # Remove existing link
    echo "$warn Found existing .backgrounds symlink. Removing."
    rm "$HOME/.backgrounds"
fi
# Make new link
echo "$info Linking [$path_to_self/backgrounds] to [$HOME/.backgrounds]"
ln -s "$path_to_self/backgrounds" "$HOME/.backgrounds"


# Link .config/
for dir in $(ls "$path_to_self/.config")
do
    src="$path_to_self/.config/$dir"
    dest="$HOME/.config/$dir"
    if [ -d "$dest" ]
    then
        # Exists as dir in home, make a backup
        echo "$info Found existing [.config/$dir] at [$dest]. Creating backup."
        mv $dest $BACKUP_LOCATION

    elif [ -h "$dest" ]
    then
        # destination is a symlink, we can just remove and overwrite it
        # without harming the original file.
        echo "$warn Found existing symlink to [.config/$dir]. Removing."
        rm "$dest"
    fi
    
    # Make the new link
    echo "$info Linking [$src] to [$dest]"
    ln -s "$src" "$dest"
done


# Link binaries to /usr/local/bin
# Note: The term "binary" is used wrong here but I'm leaving it as is
# -- Ensure backup location exists with proper subdirs
if [ ! -d $BACKUP_LOCATION/binaries ]
then
    echo "$info Did not find a backup subdirectory for binaries. Creating one."
    mkdir -p $BACKUP_LOCATION/binaries
fi
# -- Iterate through the binaries
for binary in $(ls binaries)
do
    src="$path_to_self/binaries/$binary"
    dest="/usr/local/bin/$binary"
    if [ -f "$dest" ]
    then
        echo "$info Found existing [$binary] in [$dest]. Creating backup"
        sudo cp "$dest" "$BACKUP_LOCATION/binaries"

    elif [ -h "$dest" ]
    then
        echo "$warn Found existing $dest symlink. Removing."
        sudo rm "$dest"
    fi

    echo "$info Linking [$src] to [$dest]"
    sudo ln -s $path_to_self/binaries/$binary /usr/local/bin/$binary
done

