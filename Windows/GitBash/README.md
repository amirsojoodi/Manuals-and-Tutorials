## Run applications remotely with GUI 

If you are using Git-Bash on Windows and connecting to a remote server via ssh, you can do the following to have access to graphical applications.

1. Install & run [Xming](https://sourceforge.net/projects/xming/) or [VCXSRV](https://sourceforge.net/projects/vcxsrv/) on Windows
2. Export this variable in Git-Bash:
```
$ export DISPLAY=localhost:0
```
You can add it to the end of your bashrc.
3. Connect to the remote server with -X and -Y options.
```
$ ssh -XY havij@baghcheh
```
4. Test with the following:
```
$ xclock &
```
or
```
$ xeyes &
```
5. If you want to skip -XY part, you can add the following lines to the config file under the .ssh directory:
```
Host Kalam
	ForwardAgent yes
	ForwardX11 yes
```
Then, connect without the options:
```
$ ssh havij@kalam
```
6. Remember that the server should support X forwarding. Edit the file `/etc/sshd_config` and use the following settings:
```
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost no
```
Then restart the sshd service.

## Add hosts to make life easier:

Create a config file in ssh directory: `~/.ssh/config` and put the **updated!** content of these lines in it:

```
Host basket
    HostName basket.baghcheh.farm
    User carrot
    IdentityFile ~/.ssh/id_rsa #if you have a key
    IdentitiesOnly yes
    Port 22
    ServerAliveInterval 60

Host basket
    HostName basket.baghcheh.farm
    User cucumber
    IdentityFile ~/.ssh/id_rsa #if you have a key
    IdentitiesOnly yes
    Port 22
    ServerAliveInterval 60
```

## Add Git Bash to context menu:

1. On your desktop right click "New"->"Text Document" with name OpenGitBash.reg
2. Right click the file and choose "Edit"
3. Copy-paste the code below, save and close the file (Remember to edit the path to Git-bash)
4. Execute the file by double clicking it

```
Windows Registry Editor Version 5.00
; Open files
; Default Git-Bash Location C:\Program Files\Git\git-bash.exe

[HKEY_CLASSES_ROOT\*\shell\Open Git Bash]
@="Open Git Bash"
"Icon"="C:\\Program Files\\Git\\git-bash.exe"

[HKEY_CLASSES_ROOT\*\shell\Open Git Bash\command]
@="\"C:\\Program Files\\Git\\git-bash.exe\" \"--cd=%1\""

; This will make it appear when you right click ON a folder
; The "Icon" line can be removed if you don't want the icon to appear

[HKEY_CLASSES_ROOT\Directory\shell\bash]
@="Open Git Bash"
"Icon"="C:\\Program Files\\Git\\git-bash.exe"


[HKEY_CLASSES_ROOT\Directory\shell\bash\command]
@="\"C:\\Program Files\\Git\\git-bash.exe\" \"--cd=%1\""

; This will make it appear when you right click INSIDE a folder
; The "Icon" line can be removed if you don't want the icon to appear

[HKEY_CLASSES_ROOT\Directory\Background\shell\bash]
@="Open Git Bash"
"Icon"="C:\\Program Files\\Git\\git-bash.exe"

[HKEY_CLASSES_ROOT\Directory\Background\shell\bash\command]
@="\"C:\\Program Files\\Git\\git-bash.exe\" \"--cd=%v.\""
```
