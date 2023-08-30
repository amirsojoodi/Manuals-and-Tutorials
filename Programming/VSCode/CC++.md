# C/C++

## Building the project

- If you want to use Cmake, just follow the instruction [here](https://vector-of-bool.github.io/docs/vscode-cmake-tools/getting_started.html) to add Cmake configuration to the project.

- If you are on Windows with MinGW, follow the instructions [here](https://code.visualstudio.com/docs/cpp/config-mingw) to setup the project environment.

## Debugging the project

You should config `launch.json` in the .vscode directory.
Add these configurations to the file:

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(gdb) Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}\\build\\${fileBasenameNoExtension}.exe",
            "args": [],
            "stopAtEntry": true,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerPath": "Path to gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        }
    ]
}
```

In my case, the path to gdb is :
`"C:\\Program Files\\mingw-w64\\x86_64-8.1.0-posix-seh-rt_v6-rev0\\mingw64\\bin\\gdb.exe"`
