## VS Code currently do not support IBM power 9 servers remote development

If that is your case, you can:
1. Install the extention SFTP sftp/ftp sync
2. Follow the instructions to add the server information from [here](https://marketplace.visualstudio.com/items?itemName=liximomo.sftp).

## SFTP Extension:

1. `Ctrl+Shift+P` on Windows/Linux or `Cmd+Shift+P` on Mac open command palette, run SFTP: config command.
2. Add this configuration to the opened file:
```
{
    "name": "My Site",
    "host": "my.ftp.net",
    "protocol": "sftp",
    "port": 22,
    "username": "user",
    "password": "pass",
    "remotePath": "/home",
    "uploadOnSave": true,
    "interactiveAuth": true
}
```
If you are using your public/private key to login to the remote server, and if your key has a pass phrase, add this configuration as well:
`"passphrase": true,`


