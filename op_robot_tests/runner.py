from robot import run_cli
import os
import sys


def runner():
    args = sys.argv[1:]
    if '-s' not in args:
        args += ['-s', 'OpenProcurementProcess']
    if '-d' not in args:
        directory = os.path.join(os.getcwd(), 'test_output')
        if not os.path.exists(directory):
            os.mkdir(directory)
        args += ['-d', directory]
    args.append(os.path.join(os.path.dirname(__file__), 'tests_files'))
    return run_cli(args)
