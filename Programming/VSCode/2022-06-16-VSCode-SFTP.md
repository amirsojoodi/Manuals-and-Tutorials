---
title: 'Setup SFTP Extension in VSCode'
date: 2022-06-16
permalink: /posts/Setup-SFTP-Extension-in-VSCode
tags:
  - Programming
  - SFTP
  - VSCode
---

VS Code currently do not support IBM power 9 servers remote development. If this is your case, you can:

1. Install the extention SFTP sftp/ftp sync
2. Follow the instructions to add the server information from [here](https://marketplace.visualstudio.com/items?itemName=liximomo.sftp).

## SFTP Extension

1. `Ctrl+Shift+P` on Windows/Linux or `Cmd+Shift+P` on Mac open command palette, run SFTP: config command.
2. Add this configuration to the opened file:

```json
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

## Add multiple profiles to SFTP extension

Edit `sftp.json` as following:

```json
{
    "name": "Project",
    "protocol": "sftp",
    "port": 22,
    "defaultProfile": "HostA-debug",
    "profiles": {
        "HostA-debug": {
            "host": "HostA",
            "remotePath": "/path/to/Project-Debug",
            "privateKeyPath": "~/.ssh/id_rsa",
            "passphrase": true,
            "uploadOnSave": true,
            "interactiveAuth": true
        },
        "HostA-release": {
            "host": "HostA",
            "remotePath": "/path/to/Project-Release",
            "privateKeyPath": "~/.ssh/id_rsa",
            "passphrase": true,
            "uploadOnSave": true,
            "interactiveAuth": true
        },
        "HostB-debug": {
            "host": "HostB",
            "remotePath": "/path/to/Project-Debug",
            "privateKeyPath": "~/.ssh/id_rsa",
            "passphrase": true,
            "uploadOnSave": true,
            "interactiveAuth": true
        },
        "HostB-release": {
            "host": "HostB",
            "remotePath": "/path/to/Project-Release",
            "privateKeyPath": "~/.ssh/id_rsa",
            "passphrase": true,
            "uploadOnSave": true,
            "interactiveAuth": true
        }
    }
}
```
