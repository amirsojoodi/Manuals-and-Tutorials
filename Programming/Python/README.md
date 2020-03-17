## Install Python packages on Windows 10:

**Preferably install python 3.7 (64 bit) and Git bash.**
```bash
# If there is a file requirements.txt you can install the packages using this command:
$ pip3 install -r requirements.txt

$ pip3 install numpy
$ pip3 install scipy
$ pip3 install pandas
$ pip3 install jupyter
$ pip3 install notebook
$ pip3 install matplotlib
```
To install pytorch, go to [this](https://pytorch.org/get-started/locally/) page and generate the command easily. 
```
# The generated command looks like this:
$ pip install torch==1.4.0+cpu torchvision==0.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
```

## Command line options for python:

Option to disabling assertions : `-o`
```
python -o file.py
```
This makes the code run faster and more important, keep on executing.
However, you have to make a decision between these 2 questions:
- Do the users want the code dead? or
- Do the users want the code to produce wrong results?

## Configure Test Coverage framework (on Ubuntu)

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

### How to define a 3 dimension list in python:
```python
# to create l[6][5][4] filled with zero
>>> l = [[[0 for z in range(4)]for col in range(5)] for row in range(6)]
```
