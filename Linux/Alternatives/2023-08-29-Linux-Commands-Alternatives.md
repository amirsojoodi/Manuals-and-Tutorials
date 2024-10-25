---
title: 'Alternatives to Some Linux Commands'
date: 2023-08-29
modified: 2024-10-25
permalink: /posts/Alternatives-to-Linux-Commands/
tags:
  - Linux
---

Some linux commands and their alternatives that I use. For most of them, it's easier to create aliases.

1. `dust` instead of `du`

See how to install it, [here](https://github.com/bootandy/dust).

It's very informative!
![image](https://github.com/amirsojoodi/Manuals-and-Tutorials/assets/10928452/44de523e-bb9c-4598-b646-5088fe00c6d6)

2. `tldr` instead of `man`

The purpose of TLDR (Too Long, Didn't Read!) is to show examples of using various commands.
On Ubuntu it will be installed with `sudo apt install tldr`

![image](https://github.com/amirsojoodi/Manuals-and-Tutorials/assets/10928452/3afb07e6-d54e-4c91-965f-0c7d283b3a61)

3. `bat` or `batcat` instead of `cat`

See [here](https://github.com/sharkdp/bat) to find how to install it.

![image](https://github.com/amirsojoodi/Manuals-and-Tutorials/assets/10928452/accc6645-243d-49d4-9e83-26246671d949)

4. `exa` instead of `ls`

Check out its [website](https://the.exa.website/).
`exa` is especially useful when you want to see the directory tree.

![image](https://github.com/amirsojoodi/Manuals-and-Tutorials/assets/10928452/044b701b-c486-4caf-ad39-af0e78885521)

5. `duf` instead of `df`

Check [here](https://github.com/muesli/duf) to find more about `duf`.

![image](https://github.com/amirsojoodi/Manuals-and-Tutorials/assets/10928452/453cda30-989d-4e42-b532-c06c769ef7b6)

6. `colordiff` instead of `diff`
   
7. `htop` instead of `top`, (edit: actually `btop` instead of `top`!)

Check [here](https://github.com/aristocratos/btop/) for more information on how to set it up.
It looks cool!

![image](https://github.com/user-attachments/assets/ae460ca8-c063-49b8-a453-00182c352e05)

8. `ack` instead of `grep`
9. `cloc` instead of `wc`
10. Using `xclip` instead of copy and paste.

```bash
# installation on Ubuntu
sudo apt install xclip

# Optional aliases in the profile/bashrc
alias "c=xclip" # copy to X clipboard
alias "cs=xclip -selection clipboard" # copy to system wide clipboard
alias "v=xclip -o" # output copied content (paste)
alias "vs=xclip -o -selection clipboard" # paste from system wide clipboard

# Some usages (notice the backticks)
# Terminal 1
echo pwd | c
# Terminal 2
cd `v`
```


