#!/bin/bash
mkdir -p /$HOME/.program_source_code
git clone https://github.com/nawar/kodi-cli /$HOME/.program_source_code 
mkdir -p /$HOME/scripts
ln -s /$HOME/.program_source_code /$HOME/scripts/kodi-cli
chmod +x /$HOME/kodi-cli
