## Download multiple links with axel:
```while read url; do axel -n 10 $url; done < myLinks```

## Make your prompt look nicer:

Put this line inside of .bashrc
```
export PS1="\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ "
```

