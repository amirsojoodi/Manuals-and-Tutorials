## First steps
1. Compile with proper flags: `-g` 
2. (Optional) Turn off code optimization: `-O0`

## Debugging 

1. Run gdb with the program not passing its arguments in this step: `gdb ./example`
2. After executing gdb, you can start the program with **run** command (with any needed arguments)
3. You can run the gdb with the `-tui` flag to see the code while debugging.

|Command  |Short|Description|
|:--------|:----|:----------|
|run      |r    | Start the executable from the start |
|list     |l    | List code lines where the execution is |
|quit     |q    | or Ctrl-D, gdb exits |
|_Ctrl-C_ |     | While running, hit Ctrl-C stops the execution and gdb shows where the program was |
|frame    |f    | Print the current line |
|backtrace|ba   | Print the function call stack |
|continue |c    | Continue execution |
|down     |do   | Go to the called function |
|up       |up   | Go the calling function |
|print _var_| p _var_| Print variable's value |
|display _var_| disp _var_| Print the variable's value at every prompt |
|set _var_|set _var_| Change the variable's value |
|watch _var_ |wa _var_| Stops if the variable's value changes |
|break _line_|br | Insert breakpoints into the code, you can pass filename or function name as well |
|delete   |d    | Unset a breakpoint |
|condition|cond | Breaks if a condition is met |
|disable  |dis  | Disable a breakpoint |
|enable   |en   | Enable a breakpoint |
|info breakpoints | info b | List all breakpoints |
|tbreak   |tb   | Temporary breakpoint |
|next     |n    | Continue until next line |
|step     |s    | Step into function |
|finish   |fin  | Continue until the function's end |
|until    |unt  | Continue until line/function |
|help     |h    | Print description of a command |

## Inspecting the core file

If the program crashes with *Segmentation fault* message, it is sometimes helpful to 
increase the maximum core file size to save the in-memory state of the program at the time it crashes.
```
$ ./example
Segmentation fault
$ ulimit -c 2048
$ ./example
Segmentation fault (core dumped)
$ gdb ./example <corefile>
``` 
