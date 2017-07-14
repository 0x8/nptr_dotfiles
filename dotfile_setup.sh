#!/bin/bash
# Author
## nullp0inter

# Description
## Script to setup rolling configs from 
## https://github.com/0x8/nptr_dotfiles
## This creates or sets the location of
## the files linked to github and symlinks
## to their respective system locations
## while non-destructively backing up
## existing configurations

# UTF8 and Colors
## Check if utf8 is supported for color messages
if [ $(locale -a | grep -i utf8) = "" ]; then
	echo -e "UTF8 not supported"
	echo -e "Using non-colored output"
else
	colored="TRUE"
fi

# Directory Setup
## Choose whether to set /commonconf as the location
## for all of the configs and the git directory or
## alternatively specify your own. If you specify
## your own, it must already contain my files for
## the rest of the script to run correctly

if [ $colored ]; then
	echo -e "\033[32mWould you like to setup /commonconf as the git config folder? [y/N]: \033[0m"
	read CHOICE
	if [{[ $CHOICE='y' ] || [ $CHOICE='Y' ]}]; then
		confdir="/commonconf"
		if [ $colored ]; then
			echo -e "\033[1m\033[32mCreating /commonconf and setting up...\033[0m"
		else
			echo -e "Creating /commonconf and setting up..."
		fi
		
		echo -e "\n"

		# Ensure this script is being run from the correct place
		if [ $colored ]; then
			echo -e "\x033[31mThe current directory is \033[3massumed\033[0;31m to be the"
			echo -e "\033[2mnptr_dotfiles\033[0;31m configuration directory. Before proceeding,"
			echo -e "is this still the case?\033[0m [y/N]: "
			read correctdiropt
			
			if [{[ $correctdiropt="y" ] || [ $correctdiropt="Y" ]}]; then
				correct="TRUE"
			else
				echo -e "\033[1;41;37mError\033[0;31m; Please place this script in the correct directory before continuing"
				exit
			fi
		else
			echo -e "The current directory is assumed to be the"
		  	echo -e "nptr_dotfiles configuration directory. Before proceeding,"
			echo -e "is this still the case? [y/N]: "
			read correctdiropt

			if [{[ $correctdiropt="y" ] || [ $correctdiropt="Y" ]}]; then
				correct="TRUE"
			else
				echo -e "[Error] Please place this script in the correct directory before continuing"
				exit
			fi
		fi
		
		echo -e "\n"
	fi
		#if [ ! -e /commonconfs ]; then
		#	sudo mkdir /commonconf
		#	sudo mv ./* commonconf
		#	sudo mv ./.* commonconf
		#	rm -r $PWD
		#fi		
fi

## Check for the existence of /commonconfs
if [ ! -e /commonconfs ] then;
	echo -e "Di
