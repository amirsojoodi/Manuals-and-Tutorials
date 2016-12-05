###Installation

1.	Right click on the server click on new VM
2.	Select your preferred configuration
3.	Attach installation iso (e.g. Ubuntu 12.04 x64.iso)
4.	Start the VM
a.	If you face the error after creating a VM, that it cannot boot any ISO or CD Image to install your system, probably the boot order is not correctly set.
b.	Login to XenServer with secure shell
c.	Find the VM uuid by # xe vm-list
d.	Check the boot parameter first by # xe vm-param-list uuid=<vm-uuid> |grep HVM-boot
e.	Set the boot order by # xe vm-param-set uuid=<vm-uuid> HVM-boot-policy=BIOS\ order HVM-boot-params:order=dc
5.	Proceed the Installation process
6.	Configure apt:
a.	$ sudo gedit /etc/apt/apt.conf
b.	Put these lines in it:
i.	Acquire::http::proxy ÎéÎíhttp://user:pass@proxy:portÎéÎí;
ii.	Acquire::https::proxy ÎéÎíhttps://user:pass@proxy:portÎéÎí;
7.	Configure network:
a.	$ sudo apt-get purge network-manager
b.	$ sudo gedit /etc/network/interfaces
i.	E.g.
auto eth0
iface eth0 inet static
	address 192.168.2.200
	netmask 255.255.255.0
	gateway 192.168.2.193
	dns-nameserver 10.0.10.9 10.0.10.8
c.	$ sudo ifup eth0
d.	$ sudo ifdown eth0
e.	$ sudo ifup eth0
8.	Attach xen-tools.iso to the VM
9.	$ sudo mount /dev/sr0 /media
10.	$ sudo /media/Linux/install.sh
11.	Reboot VM
12.	$ sudo apt-get update
13.	Install a good editor with $ sudo apt-get install vim
14.	Install ssh server with $ sudo apt-get install openssh-server 

15.	Put these useful aliases in .bashrc
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
# alias du="du | sort -h"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias top="htop"
alias myip="curl http://ipecho.net/plain; echo"
alias DU="du --max-depth=1 -B M |sort -rn"

