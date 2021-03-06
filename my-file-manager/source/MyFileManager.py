#!/usr/bin/env python

import os
import sys
import subprocess

search_paths = os.environ["PATH"].split(os.pathsep)
interpreter_list = ('python2.9', 'python2.8', 'python2.7', 'python2.6')
application_file = os.path.join(os.path.dirname(sys.argv[0]), 'application', 'main.py')

def _can_execute(path):
    """Check if specified path can be executed"""
    return os.path.exists(path) and os.access(path, os.X_OK)

def _check_interpreter(interpreter):
    """Check path for existing interpreters"""
    result = None

    for path in search_paths:
        full_path = os.path.join(path, interpreter)

        if _can_execute(full_path):
            # interpreter was found in specified directory
            result = full_path
            break

    return result

def _get_interpreters():
    """Return available interpreters"""
    result = []

    # check every interpreter in the list
    for item in interpreter_list:
        full_path = _check_interpreter(item)

        if full_path is not None:
            result.append(full_path)

    return result

# get 2.x interpreter
interpreters = _get_interpreters()

if len(interpreters) > 0:
    code = 2

    # try with all interpreters
    for interpreter in interpreters:
        params = [os.path.abspath(sys.argv[0]), application_file]
        params.extend(sys.argv[1:])

        # execute interpreted
        process = subprocess.Popen(params, executable=interpreter)
        process.wait()

        if process.returncode == 0:
            # if interpreter manages to run
            # we don't need to execute others
            break

        else:
            # print interpreter error
            print("Failed running with {0}".format(os.path.basename(interpreter)))

    sys.exit(code)

else:
    # no valid interpreters found, notify user
    print("No valid Python 2.x interpreter was found!")
    sys.exit(2)

