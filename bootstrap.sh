#!/bin/bash
#
# This script bootstraps the dev environment
#
# How to call:
#
#    ./bootstrap.sh
#

set -e

SOURCE_DIR=`dirname "${BASH_SOURCE[0]}"`

# Smoketest environment
if [[ $OSTYPE != darwin* ]]; then
  echo "INFO Only Mac OS X is currently supported."
  exit 0
fi

# Check for python (needed for ansible)
if [[ `which python` ]]; then
  echo "OK Found python!"
else
  echo "Please install python first."
  exit 1
fi

# Check for rvm (conflicts with rbenv)
if [[ `which rvm` ]]; then
  echo "WARN Found rvm!"
  echo "WARN Please uninstall rvm first!"
  exit 1
fi

# Installing most important package
if [[ `which ansible` ]]; then
  echo "OK Ansible is already installed"
else
  echo "INFO Installing ansible..."
  brew install ansible
fi

# Check Vim and create softlink for vimrc file
if [[ 'which vim' ]]; then
   cp -f ${SOURCE_DIR}/myvimrc/vimrc ${HOME}/.vimrc
   echo "OK Update .vimrc"

   mkdir -p ~/.vim/autoload
   cp -f ${SOURCE_DIR}/myvimrc/pathogen.vim ${HOME}/.vim/autoload
   echo "OK Update pathogen"

   mkdir -p ~/.vim/colors
   cp -f ${SOURCE_DIR}/myvimrc/vgod.vim ${HOME}/.vim/colors
   echo "OK Update vgod color"

else
  echo "Please install vim"
fi

if [[ 'which docker' ]]; then
   echo "Docker is already installed"

else
   echo "Docker is not yet installed"
   curl -sSL https://get.docker.com/ | sudo sh
fi

# Check the Pretzo exists
if [ ! -d ~/.zprezto ]; then
   echo "Directory of .zprezto not found!"
   git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
   /bin/zsh ./pretzo.sh
else 
   echo "OK .zprezto"
fi

echo "Install Graphiz"
brew install graphviz

# Link config file of Prezto
#setopt EXTENDED_GLOB
#for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
#   ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
#done


# Run ansible which deals with the rest of the setup
#echo "INFO Execute ansible playbook"
#ansible-playbook -c local -i "localhost," -K ${SOURCE_DIR}/ansible/dev_environment.yml $*
