## VIM Configuration

- Copy the content of the file `.vimrc` to your `~/.vimrc`

- After completing [Vundle] setup, install your desired plugins, then launch vim and run `:PluginInstall`


### Plugin for [Vim-Markdown-Preview]

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

### Vim commands (summary):

1. i -> insert mode
2. x,X -> delete one char
3. o,O -> insert new line and go to insert mode
4. J -> join the current line with its next one
5. r -> replace one character
6. a -> append 
7. u -> undo
8. d -> delete (dw, dd, d$, d^, ..)
9. G -> go to line (10G, 1G, G)
10. y -> yank/copy (yy, yw, y$, ..)
11. p,P -> paste
12. /x -> search for x (n, N)
13. $ -> end of line
14. ^ -> start of line
15. . -> repeat
16. % -> swap to closing/opening bracket
17. v -> visual mode, enter, and then run command
18. split/Hexplore -> Horizontal split/explore
	- To change between windows -> Ctrl+w, up/down/left/right
	- To open current file in split horizontal view -> Ctrl+w, s
	- To open current file in split vertical view -> Ctrl+w, v
19. Vsplit/Vexplore -> vertical split/explore
20. ! -> run OS commands
21. !! -> run OS commands and write the output
22. s/a/b -> replace a by b 
	- :%s/a/b/g -> replace a by b in entire file
	- :12,20s/a/b/g -> replace a by b in lines 12-20
	- :15,23s/^/\/\//g -> comment lines 15-23
	- :15,23s/\/\/ -> uncomment lines 15-23


[Vundle]:http://github.com/VundleVim/Vundle.vim
[Vim-Markdown-Preview]:https://github.com/JamshedVesuna/vim-markdown-preview
