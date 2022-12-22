# Makefile Tips and Tricks

## Special Macros

1. `$@`

`$@` is the name of the target. This allows you to easily write a generic action that can be used for 
multiple different targets that produce different output files. For example, the following two targets 
produce output files named client and server respectively.

```bash
client: client.c
    $(CC) client.c -o $@
 
server: server.c
    $(CC) server.c -o $@
```

2. `$?`

The `$?` macro stores the list of dependents more recent than the target (i.e., those that have changed
since the last time make was invoked for the given target). We can use this to make the build commands
from the above example even more general:

```bash
client: client.c
    $(CC) $? -o $@
 
server: server.c
    $(CC) $? -o $@
```

3. `$^`

`$^` gives you all dependencies, regardless of whether they are more recent than the target. 
Duplicate names, however, will be removed. This might be useful if you produce transient output
(such as displaying a result to the screen rather than saving it to a file).

```bash
# print the source to the screen
viewsource: client.c server.c
    less $^
```

4. `$+`

`$+` is like `$^`, but it keeps duplicates and gives you the entire list of dependencies in the order
they appear.

```bash
# print the source to the screen
viewsource: client.c server.c
    less $+
```

5. `$<`

If you only need the first dependency, then `$<` is for you. Using `$<` can be safer than relying
on `$^` when you have only a single dependency that needs to appear in the commands executed by the
target. If you start by using `$^` when you have a single dependency, if you then add a second,
it may be problematic, whereas if you had used `$<` from the beginning, it will continue to work.
(Of course, you may want to have all dependencies show up. Consider your needs carefully.)

## Wildcards

The percent sign `%` can be used to perform wildcard matching to write more general targets.
When a `%` appears in the dependencies list, it replaces the same string of text throughout the
command in makefile target. If you wish to use the matched text in the target itself, use the 
special variable `$*`. For instance, the following example will let you type make *name of .c file*
to build an executable file with the given name:
  
```bash
%:
    gcc -o $* $*.c
```
E.g. `make test` would run `gcc -o test test.c

## Replacing text

It is possible to create a new macro based on replacing part of an old macro. For instance,
given a list of source files, called `SRC`, you might wish to generate the corresponding object
files, stored in a macro called `OBJ`. To do so, you can specify that `OBJ` is equivalent to `SRC`,
except with the `.c` extension replaced with a `.o` extension:

```bash
BIN = $(SRC:.c=.o)

$(BIN): $(SRC)
    gcc -o $@ $^
```
Note that this is effectively saying that in the macro SRC, .c should be replaced with .o.

[Reference](https://www.cprogramming.com/tutorial/makefiles_continued.html)

## Silent execution

Makefile commands can be suppressed with `@`.

```bash
greet:
    @echo hello
    echo bye
```

When running:
```bash
$ make greet
hello
echo bye
bye
```

The other way is to silence all of the makefile commands. For the above example,

```bash
$ make -s greet
hello
bye
```

## Creating folders

```bash
BIN_DIR=./bin

run: | $(BIN_DIR)

$(BIN_DIR):
  @echo "Folder $(BIN_DIR) does not exist!"
  mkdir $@
```

## Makefile cookbook

Taken from https://makefiletutorial.com/:

```bash
# Thanks to Job Vranish (https://spin.atomicobject.com/2016/08/26/makefile-c-projects/)
TARGET_EXEC := final_program

BUILD_DIR := ./build
SRC_DIRS := ./src

# Find all the C and C++ files we want to compile
# Note the single quotes around the * expressions. Make will incorrectly expand these otherwise.
SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.c' -or -name '*.s')

# String substitution for every C/C++ file.
# As an example, hello.cpp turns into ./build/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# String substitution (suffix version without %).
# As an example, ./build/hello.cpp.o turns into ./build/hello.cpp.d
DEPS := $(OBJS:.o=.d)

# Every folder in ./src will need to be passed to GCC so that it can find header files
INC_DIRS := $(shell find $(SRC_DIRS) -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP

# The final build step.
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CXX) $(OBJS) -o $@ $(LDFLAGS)

# Build step for C source
$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Build step for C++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)
```
