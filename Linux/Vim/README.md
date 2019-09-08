## VIM Configuration

- Copy the content of the file `.vimrc` to your `~/.vimrc`

- After completing [Vundle] setup, install your desired plugins, then launch vim and run `:PluginInstall`


### Plugin for markdown preview

Add `Plugin 'JamshedVesuna/vim-markdown-preview'` to your .vimrc.
Launch vim and run `:PluginInstall`

There are some requirements, and you have to install pip first:
```
$ sudo apt-get install python-pip python3-pip --yes
$ sudo python3 -m pip install pip --upgrade --force-reinstall
$ sudo python -m pip install pip --upgrade --force-reinstall
```

Install grip (for GitHub flavoured markdown) with the following:
```
$ sudo pip install grip
```
Put `let vim_markdown_preview_github=1` in your .vimrc file

Install xdotool with: 
```
$ sudo apt-get install xdotool
```

#### The final stage

Whenever you open a markdown file, hit `Ctrl+p` to preview the markdown file on your default browser.

[Vundle]:http://github.com/VundleVim/Vundle.vim
