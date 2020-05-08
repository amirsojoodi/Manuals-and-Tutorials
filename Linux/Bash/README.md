## Download multiple links with axel:
```while read url; do axel -n 10 $url; done < myLinks```

## Make your prompt look nicer:

- Put this line inside of .bashrc
```
export PS1="\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ "
```

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
