## CppStyle for Windows Eclipse C/C++

If you want to format your code using clang-format in Eclipse IDE in windows do the following:

- Install LLVM from [here](https://releases.llvm.org/download.html)
- Add LLVM binary directory to the path.
- Add this link `https://releases.llvm.org/download.html` to the eclipse (help -> install new software)
- Install CppStyle and restart Eclipse. If it occurred any problem, see [here](https://github.com/wangzw/CppStyle)

### Configure CppStyle

To configure CppStyle globally, go to **Preferences -> C/C++ -> CppStyle** dialog.

To enable CppStyle(clang-format) as default C/C++ code formatter, go to **Preferences -> C/C++ -> Code Style -> Formatter** page and switch **"Code Formatter"** from **[built-in]** to **"CppStyle (clang-format)"**

### To configure clang-format

CppStyle does not support appending command line parameters to clang-format and cpplint.py. So, use their respective configuration files to do this.

CppStyle will pass the full absolute path of the source file to clang-format in command line. And clang-format will try to find the configuration file named **.clang-format** in the source file's path, and its parent's path if not found previously, and parent's path of the parent and so on.

So put the configuration file **.clang-format** into the project's root direcotry can make it work for all source files in the project.

Further more, you can also add the configuration file **.clang-format** into Eclipse workspace root directory to make it work for all projects in the workspace.

To generate the clang-format configuration file **.clang-format**:

`clang-format -dump-config -style=Google > .clang-format`

**If no configure file named .clang-format is found, "-style=Google" will be passed to clang-format and Google style will be used by default.**
