from setuptools import setup, find_packages
import sys, os

version = '0.0'

setup(name='op_robot_tests',
      version=version,
      description="",
      long_description="""\
""",
      classifiers=[], # Get strings from http://pypi.python.org/pypi?%3Aaction=list_classifiers
      keywords='',
      author='',
      author_email='',
      url='',
      license='',
      packages=find_packages(exclude=['ez_setup', 'examples', 'tests']),
      include_package_data=True,
      zip_safe=False,
      install_requires=[
          # -*- Extra requirements: -*-
          'robotframework',
          'iso8601',
          'PyYAML',
          'munch',
          'fake-factory',
          'robotframework-debuglibrary',
      ],
      entry_points={
          'console_scripts': [
              'openprocurement_tests = op_robot_tests.runner:runner',
          ],
      }
      )
