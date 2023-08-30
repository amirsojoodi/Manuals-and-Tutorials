# How to debug multi-process Python code in VS Code

Create a debug configuration file and store it at `.vscode/launch.json`.

```json
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Remote Attach",
      "type": "python",
      "request": "attach",
      "connect": {
        "host": "localhost",
        "port": 5678
      },
      "pathMappings": [
        {
          "localRoot": "${workspaceFolder}",
          "remoteRoot": "."
        }
      ],
      "justMyCode": false
    },
    {
      "name": "Python Attach (local) proc 0",
      "type": "python",
      "request": "attach",
      "port": 5678,
      "host": "localhost",
      "justMyCode": false
    },
    {
      "name": "Python Attach (local) proc 1",
      "type": "python",
      "request": "attach",
      "port": 5679,
      "host": "localhost",
      "justMyCode": false
    },
    {
      "name": "Python Attach (local) proc 2",
      "type": "python",
      "request": "attach",
      "port": 5680,
      "host": "localhost",
      "justMyCode": false
    },
    {
      "name": "Python Attach (local) proc 3",
      "type": "python",
      "request": "attach",
      "port": 5681,
      "host": "localhost",
      "justMyCode": false
    },
    {
      "name": "GDB Attach proc 0",
      "type": "cppdbg",
      "request": "attach",
      "program": "/usr/bin/python3",
      "processId": "${command:pickProcess}",
      "MIMode": "gdb"
    },
    {
      "name": "GDB Attach proc 1",
      "type": "cppdbg",
      "request": "attach",
      "program": "/usr/bin/python3",
      "processId": "${command:pickProcess}",
      "MIMode": "gdb"
    }
  ]
}
```

Then simply install `debugpy` with pip, and use it like this:

```python
import debugpy
from mpi4py import MPI

P_world = MPIPartition(MPI.COMM_WORLD)
P_world._comm.Barrier()

debugpy.listen(('localhost', 5678 + P_world.rank))
debugpy.wait_for_client()
debugpy.breakpoint()
```

Then, attach whichever process you would like with the VS Code configurations you have created.

If the code has C/C++ parts, you can attach GDB to the running process to debug the the rest of the code.

This method also works for debugging on docker images. Just perform all these steps on the docker image, using VS Code docker extension.

## Resources

[Here](https://gist.github.com/kongdd/f49fabdbf0af20ec7fd6b4f8cd1f450d) and [there](https://github.com/microsoft/ptvsd/issues/1427)
