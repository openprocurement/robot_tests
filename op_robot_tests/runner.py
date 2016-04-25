from chromedriver import CHROMEDRV_PATH
from robot import run_cli
import os
import sys

sys.path.append(CHROMEDRV_PATH)


def runner():
    args = sys.argv[1:]
    if '-d' not in args and '--outputdir' not in args:
        directory = os.path.join(os.getcwd(), 'test_output')
        if not os.path.exists(directory):
            os.mkdir(directory)
        args += ['-d', directory]
    if '-L' not in args and '--loglevel' not in args:
        args += ['--loglevel', 'trace:info']
    args.append(os.path.join(os.path.dirname(__file__), 'tests_files'))
    return run_cli(args)
