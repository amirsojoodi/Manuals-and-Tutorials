
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
