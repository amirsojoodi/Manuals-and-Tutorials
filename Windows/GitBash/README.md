## Run applications remotely with GUI 

If you are using Git-Bash on Windows and connecting to a remote server via ssh, you can do the following to have access to graphical applications.

1. Install & run Xming on Windows
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
