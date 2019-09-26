## Command line options for python:

Option to disabling assertions : `-o`
```
python -o file.py
```
This makes the code run faster and more important, keep on executing.
However, you have to make a decision between these 2 questions:
- Do the users want the code dead? or
- Do the users want the code to produce wrong results?

## Configure Test Coverage framework

```
$ sudo pip install coverage
$ sudo apt-get install python-dev
$ sudo apt-get install python3-dev
$ coverage --version
```
Use `coverage run` to run the program and gather data:
```bash
# if you usually do:
# $ python prog.py arg1 arg2
#
# then do:
$ coverage run prog.py arg1 arg2
```
Use `coverage report` to report the results.
```
$ coverage report -m
```
Or, for a nicer presentation, use:
```
$ coverage html
```

## A Reminder on how to use python slice with negative numbers:
```python
>>> l = ['abc', 'def', 'ghi', 'jkl', 'mno', 'pqr', 'stu', 'vwx', 'yz&']

# I want a string up to 'def' from 'vwx', all in between
# from 'vwx' so -2;to 'def' just before 'abc' so -9; backwards all so -1.
>>> l[-2:-9:-1]
['vwx', 'stu', 'pqr', 'mno', 'jkl', 'ghi', 'def']

# For the same 'vwx' 7 to 'def' just before 'abc' 0, backwards all -1
>>> l[7:0:-1]
['vwx', 'stu', 'pqr', 'mno', 'jkl', 'ghi', 'def']
```
