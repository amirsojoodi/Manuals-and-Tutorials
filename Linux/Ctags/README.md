## Install and Configure Ctags

On Ubuntu you can install ctags, with:
```
$ sudo apt-get install ctags
# or
$ sudo apt-get install exuberant-ctags
```

After installation, add the following line in `~/.vimrc` to make it available in VIM. 
```
set tags=tags
```

## Usage

In the base directory of the project, hit:
```
$ ctags -R
```
- Then, when editing, put your cursor over a variable, method or class and hit `Ctrl-]` to jump to its definition. 
- Type `Ctrl-t` to jump back. Pop back to where you last were. Works until the stack of symbols is exhausted.
- To search for a specific tag and open the output in Vim to its definition, run the following command in your shell: `vim -t *tagname*`

## Add a new extention/language

If you want to add a new language, you can create a file in home directory: `vim ~/.ctags` and add the following:
```
#--langdef=name
--langdef=CUDA
```

Then add this line to map the new language with a file name extension(s), like:
```
--langmap=CUDA:.cu.CU
```

Or you can add the extension to the existing map with:
```
--langmap=CUDA:+.cuh
```

The list of langauges and their associated file names can be obtained by this command:
```
$ ctags --list-maps
```
