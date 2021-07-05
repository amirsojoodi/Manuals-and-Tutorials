## Run a specific command on a specific CPU(s):
```
# This will run the command on cpu 3:
$ taskset -c 3 command

# This will run the command on cores 64-127:
$ taskset -c 64-127 command
```

## Download multiple links with axel:
```
while read url; do axel -n 10 $url; done < myLinks
```

## Redirect the command output

1. Redirect stdout to one file and stderr to another file:
```
$ command > out 2>error
```
2. Redirect stdout to a file (>out), and then redirect stderr to stdout (2>&1):
```
$ command >out 2>&1
```
3. Redirect both to a file (this isn't supported by all shells, bash and zsh support it, for example, but sh and ksh do not):
```
$ command &> out
```

## Disable the annoying bell in bash:

1. To disable the beep in __bash__ you need to uncomment (or add if not already there) the line `set bell-style none` in your `/etc/inputrc` file.

_Note:_ Since it is a protected file you need to be a privileged user to edit it (i.e. launch your text editor with something like `sudo <editor> /etc/inputrc`).

2. To disable the beep also in __vim__ you need to add `set visualbell` in your `~/.vimrc` file.

3. To disable the beep also in __less__ (i.e. also in man pages and when using `git diff`) you need to add `export LESS="$LESS -R -Q"` in your `~/.profile` file.

## Make your prompt look nicer:

- Put this line inside of .bashrc
```
export PS1="\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ "
```

## Display all IP addresses connected to your host:

```
netstat -lantp | grep ESTABLISHED |awk '{print $5}' | awk -F: '{print $1}' | sort -u
```

## List the commands you use more often:

```
history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
```

## Helpful aliases:

- Put these aliases in .bashrc
```
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
