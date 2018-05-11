from setuptools import find_packages, setup

version = '2.4.dev0'

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
          'Faker',
          'Pillow',
          'PyYAML',
          'barbecue',
          'dateutils',
          'dpath',
          'haversine',
          'iso8601',
          'jsonpath-rw',
          'munch',
          'parse',
          'pytz',
          'robotframework',
          'robotframework-selenium2library',
          'selenium < 3.0.dev0',
      ],
      entry_points={
          'console_scripts': [
              'op_tests = op_robot_tests.runner:runner',
          ],
      }
      )
