## Set up logger for Python 

If you want to set up a logger for a multi-module Python project, you can set up the logger with a specific configuration once, and import it in other modules.

First, set up the logger in a source, named `my_logger.py`

```python
import sys
import logging
import argparse

# Setting the defult logging format. 
LOG_FORMAT = '%(levelname)s: PID-%(process)d - %(pathname)s:%(lineno)d (%(funcName)s) - %(message)s'

logging.basicConfig(format=LOG_FORMAT)
logging.logThreads = False
logging.logProcesses = True
logging.logMultiprocessing = True

# Configure the logger from command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('-log', '--loglevel', default='ERROR', 
                    choices=logging._nameToLevel.keys(), 
                    help="Provide logging level. Example --loglevel DEBUG, default=ERROR")
args = parser.parse_args()

# Create the logger module and set its level (gotten from command line argument)
logger = logging.getLogger(name="My-Logger")
logger.setLevel(level=args.loglevel.upper())

# Set up the stdout handler (e.g. for more serious info)
stdout_handler = logging.StreamHandler(sys.stdout)
stdout_handler.setFormatter(logging.Formatter(fmt=LOG_FORMAT))
stdout_handler.setLevel(logging.ERROR)

# Set up the file handler for storing more general info
file_handler = logging.FileHandler('path/to/proper/logfile.log')
file_handler.setFormatter(logging.Formatter(fmt=LOG_FORMAT))
file_handler.setLevel(logging.DEBUG)

logger.addHandler(file_handler)
logger.addHandler(stdout_handler)

logger.info("Logger initialized.")
```

To use the logger in another source file which is in the same directory as `my_logger.py`:

```python
import my_logger as logger

logger.info("Instead of blaming the darkness, light a candle!")

logger.warning("It's better to light a candle!")

logger.error("No candle found!")
```

