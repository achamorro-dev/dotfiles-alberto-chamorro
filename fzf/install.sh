#!/bin/bash

if [ ! -f $HOME/.fzf.zsh ]; then 
  $(brew --prefix)/opt/fzf/install
fi

