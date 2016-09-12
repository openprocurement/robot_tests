from setuptools import find_packages, setup

version = '2.2.1'

setup(name='op_robot_tests',
      version=version,
      description="",
      long_description="""\
""",
      classifiers=[],  # Get strings from http://pypi.python.org/pypi?%3Aaction=list_classifiers
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
          'robotframework-selenium2library',
          'robotframework-debuglibrary',
          'robotframework-selenium2screenshots',
          'Pillow',
          'iso8601',
          'PyYAML',
          'munch',
          'fake-factory',
          'dpath',
          'jsonpath-rw',
          'dateutils',
          'pytz',
          'parse',
          'chromedriver',
          'barbecue'
      ],
      entry_points={
          'console_scripts': [
              'openprocurement_tests = op_robot_tests.runner:runner',
          ],
      }
      )
