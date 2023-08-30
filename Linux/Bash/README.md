# Some Bash Tips

## Use "Exit Traps" to make scripts more robust and reliable

You can place any code that you want to be certain to run in this "finish" function.

```bash
#!/bin/bash
function finish {
  # Your cleanup code here
}
trap finish EXIT
```

More info: [here](http://redsymbol.net/articles/bash-exit-traps/)

## Use Bash Strict Mode (Unless You Love Debugging!)

Add this in your scripts to cause them exit immediately in case of errors, bugs, and exceptions.

```bash
#!/bin/bash
set -euxo pipefail

# which is the short version of:

set -e
set -u
set -o pipefail
set -x
```

Read more from [here](http://redsymbol.net/articles/unofficial-bash-strict-mode/) to understand what each does.

## Run a specific command on a specific CPU(s)

```bash
# This will run the command on cpu 3:
$ taskset -c 3 command

# This will run the command on cores 64-127:
$ taskset -c 64-127 command
```

## Download multiple links with axel

```bash
while read url; do axel -n 10 $url; done < myLinks
```

## Redirect the command output

1. Redirect stdout to one file and stderr to another file:

```bash
command > out 2>error
```

2. Redirect stdout to a file (>out), and then redirect stderr to stdout (2>&1):

```bash
command >out 2>&1
```

3. Redirect both to a file (this isn't supported by all shells, bash and zsh support it, for example, but sh and ksh do not):

```bash
command &> out
```

More detailed methods: (got from [here](https://askubuntu.com/a/731237))

              || visible in terminal ||   visible in file   || existing
      Syntax  ||  StdOut  |  StdErr  ||  StdOut  |  StdErr  ||   file   
    ==========++==========+==========++==========+==========++===========
        >     ||    no    |   yes    ||   yes    |    no    || overwrite
        >>    ||    no    |   yes    ||   yes    |    no    ||  append
              ||          |          ||          |          ||
       2>     ||   yes    |    no    ||    no    |   yes    || overwrite
       2>>    ||   yes    |    no    ||    no    |   yes    ||  append
              ||          |          ||          |          ||
       &>     ||    no    |    no    ||   yes    |   yes    || overwrite
       &>>    ||    no    |    no    ||   yes    |   yes    ||  append
              ||          |          ||          |          ||
     | tee    ||   yes    |   yes    ||   yes    |    no    || overwrite
     | tee -a ||   yes    |   yes    ||   yes    |    no    ||  append
              ||          |          ||          |          ||
     n.e. (*) ||   yes    |   yes    ||    no    |   yes    || overwrite
     n.e. (*) ||   yes    |   yes    ||    no    |   yes    ||  append
              ||          |          ||          |          ||
    |& tee    ||   yes    |   yes    ||   yes    |   yes    || overwrite
    |& tee -a ||   yes    |   yes    ||   yes    |   yes    ||  append

(*) Bash has no shorthand syntax that allows piping only StdErr to a second command, which would be needed here in combination with tee again to complete the table. If you really need something like that, please look at "[How to pipe stderr, and not stdout?](https://stackoverflow.com/questions/2342826/how-can-i-pipe-stderr-and-not-stdout)" on Stack Overflow for some ways how this can be done e.g. by swapping streams or using process substitution.

## Disable the annoying bell in bash

1. To disable the beep in __bash__ you need to uncomment (or add if not already there) the line `set bell-style none` in your `/etc/inputrc` file.

_Note:_ Since it is a protected file you need to be a privileged user to edit it (i.e. launch your text editor with something like `sudo <editor> /etc/inputrc`).

2. To disable the beep also in __vim__ you need to add `set visualbell` in your `~/.vimrc` file.

3. To disable the beep also in __less__ (i.e. also in man pages and when using `git diff`) you need to add `export LESS="$LESS -R -Q"` in your `~/.profile` file.

## Make your prompt look nicer

- Put this line inside of .bashrc

```bash
export PS1="\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ "
```

## Display all IP addresses connected to your host

```bash
netstat -lantp | grep ESTABLISHED |awk '{print $5}' | awk -F: '{print $1}' | sort -u
```

## List the commands you use more often

```bash
history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
```

## Helpful aliases

- Put these aliases in .bashrc

```bash
alias c='clear'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias mkdir='mkdir -pv'
alias diff='colordiff'
alias h='history'
alias histg="history | grep"
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias vi='vim'
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'
alias ports='netstat -tulanp'
alias su='sudo -i'
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
alias wget='wget -c'
alias df="df -Tha --total"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias top="htop"
alias myip="curl http://ipecho.net/plain; echo"
alias DU="du --max-depth=1 -B M |sort -rn"
alias filecount="find . -type f 2> /dev/null | wc -l"
```

## Some useful user config

Put these into the file `~/.inputrc`:

```bash
# Place this file into your home directory
# none, visible or audible
set bell-style visible

# Ignore case for the command-line-completion functionality
# on:  default on a Windows style console
# off: default on a *nix style console
set completion-ignore-case on

set colored-stats On
set completion-ignore-case On
set completion-prefix-display-length 3
set mark-symlinked-directories On
set show-all-if-ambiguous On
set show-all-if-unmodified On
set visible-stats On
```

## Query the linked libraries of an executable

To see which libraries have been linked to a specific executable, e.g. `mpirun`

```bash
ldd `which mpirun`
```

Query the executable header, e.g. check RUNPATH entry

```bash
readelf -d /home/sojoodi/projects/def-queenspp/sojoodi/OpenMPI-Debug/build/bin/mpirun | grep RUNPATH
```

## LD_PRELOAD Trick

In summary, you can preload the specified shared libraries at runtime to resolve some conflicts happened at link-time, or to overright any previously statically bound libraries, like stubs. For instance, if you want to preload NVIDIA ML library to make sure your program points at the current location at runtime, you can do something like the following:

```bash
export LD_PRELOAD=/usr/lib64/nvidia/libnvidia-ml.so
/path/to/executable
```

To find more information about LD_PRELOAD trick, read [here](https://www.baeldung.com/linux/ld_preload-trick-what-is).
