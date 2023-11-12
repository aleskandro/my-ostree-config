This Repro was originally a fork from [vim-nerdtree_plugin_collections](https://github.com/t9md/vim-nerdtree_plugin_collections).

## NerdtreePluginOpen
NerdtreePluginOpen extends [Nerdtree](https://github.com/scrooloose/nerdtree) with the ability to open non text files with an appropriate application independent from vim.


## Install
Install this plugin with your favorite plugin-manager or manual with the following command:
    
    git clone https://github.com/aufgang001/vim-nerdtree_plugin_open.git  ~/.vim/vim-nerdtree_plugin_open.git

Extend your .vimrc file with the following command:

    let g:nerdtree_plugin_open_cmd = '<your command>'

"Your command" depends on the operating system and desktop environment, just check if one of those are available: 

* xdg-open (desktop-independent tool)
* gnome-open (gnome)
* exo-open (xfce)
* gvfs-open (whatever, I have no idea)
* kde-open (kde)
* open (MacOS)
* use your own command, if you think that stuff is to creepy
    

## Usage
Select an arbitrary file or directory and press the button <**E**> to open the file with the default program choosen by the operating system or the directory with the default file manager.


