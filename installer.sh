#!/usr/bin/env bash

# @Ian Guibas
# A simple installer for my dotfiles as symlinks. This installer attmepts to
# preserve all exisitng, non-symlinked config files and directories but it is
# far from perfect.

# User-defineable rc file backup location (for those that _can_ be backed up).
BACKUP_LOCATION="$HOME/.rc_file_backups"
if [ ! -d "$BACKUP_LOCATION" ]
then
    mkdir -p "$BACKUP_LOCATION"
fi

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
            mv "$dest" "$BACKUP_LOCATION"
        
        elif [ -h "$dest" ]
        then
            # Remove existing symlink
            rm "$dest"
        fi

        # Make the new link
        ln -s $src $dest 
    fi 
done


# Link backgrounds to $HOME/.backgrounds
if [ -d "$HOME/.backgrounds" ]
then
    # backup backgrounds dir
    mv "$HOME/.backgrounds" "$BACKUP_LOCATION/.backgrounds"

elif [ -h "$HOME/.backgrounds" ]
then
    # Remove existing link
    rm "$HOME/.backgrounds"
fi
# Make new link
ln -s "$path_to_self/backgrounds" "$HOME/.backgrounds"


# Link .config/
for dir in $(ls $path_to_self/.config)
do
    src="$path_to_self/.config/$dir"
    dest="$HOME/.config/$dir"
    if [ -d $dest ]
    then
        # Exists as dir in home, make a backup
        mv $dest $BACKUP_LOCATION

    elif [ -h $dest ]
    then
        # destination is a symlink, we can just remove and overwrite it
        # without harming the original file.
        rm $dest
    fi
    
    # Make the new link
    ln -s "$src" "$dst"
done


# Link binaries to /usr/local/bin
# Note: The term "binary" is used wrong here but I'm leaving it as is
# -- Ensure backup location exists with proper subdirs
echo "The binaries section (line 81) requires sudo permissions to work"
if [ ! -d $BACKUP_LOCATION/binaries ]
then
    mkdir -p $BACKUP_LOCATION/binaries
fi
# -- Iterate through the binaries
for binary in $(ls binaries)
do
    src="$path_to_self/binaries/$binary"
    dest="/usr/local/bin/$binary"
    if [ -f "$dest" ]
    then
        sudo cp "$dest" "$BACKUP_LOCATION/binaries"

    elif [ -h "$dest" ]
    then
        sudo rm "$dest"
    fi
    sudo ln -s $path_to_self/binaries/$binary /usr/local/bin/$binary
done

