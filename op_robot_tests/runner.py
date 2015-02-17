from robot import run_cli
import os
import sys


def runner():
    args = sys.argv[1:]
    args.append(os.path.join(os.path.dirname(__file__), 'tests_files'))
    return run_cli(args)
