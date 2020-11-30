# -*- coding: utf-8 -*-
from setuptools import setup

packages = \
['pytesting_utils']

package_data = \
{'': ['*']}

install_requires = \
['virtualenv>=16.7,<21.0']

setup_kwargs = {
    'name': 'pytesting-utils',
    'version': '0.5.0',
    'description': 'Utilities for the PyTesting project',
    'long_description': "# PyTesting Utils\n\n[![Build Status](https://travis-ci.com/pytesting/utils.svg?branch=master)](https://travis-ci.com/pytesting/utils)\n[![codecov](https://codecov.io/gh/pytesting/utils/branch/master/graph/badge.svg)](https://codecov.io/gh/pytesting/utils)\n[![License LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)\n[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/ambv/black)\n[![PyPI version](https://badge.fury.io/py/pytesting-utils.svg)](https://badge.fury.io/py/pytesting-utils)\n[![Supported Python Versions](https://img.shields.io/pypi/pyversions/pytesting-utils.svg)](https://github.com/pytesting/utils)\n\nPyTesting Utils is a collection of utilities for the \n[PyTesting](https://github.com/pytesting) project.\n\n## Prerequisites\n\nBefore you begin, ensure you have met the following requirements:\n- You have installed Python at least in version 3.6.\n- You have a recent Linux or MacOS machine.  The library was not tested under any\n other operating system.  Feel free to report experiences/issues on other systems.\n- For development it is necessary to have the [`poetry`](https://poetry.eustace.io)\n packaging and dependency management system.\n \n## Installing PyTesting Utils\n\nPyTesting Utils can be easily installed from [PyPI](https://pypi.org) using the\n `pip` utility:\n```bash\npip install pytesting-utils\n```\n\n## Contributing to PyTesting Utils\n\nTo contribute to PyTesting Utils, follow these steps:\n1. Fork this repository.\n2. Setup a virtual environment for development using `poetry`: `poetry install`.\n3. Create a branch: `git checkout -b <branch_name>`.\n4. Make your changes and commit them `git commit -m '<commit_message>'`.\n5. Push to the original branch: `git push origin <project_name>/<location>`.\n6. Create the pull request.\n\nPlease note that we require you to meet the following criteria:\n- Write unit tests for your code.\n- Run linting with `flake8` and `pylint`\n- Run type checking using `mypy`\n- Format your code according to the `black` code style\n\nTo ease the execution of the tools, we provide a `Makefile` with various targets.\nThe easiest way to execute all checks is to run `make check` on a `poetry shell`.\nPush your commits only if they pass all checks!\nThese tools are also executed in continuous integration on TravisCI and will also\n check you pull request.\nFailing a check will block your pull request from being merged!\n\n## Contributors\n\nSee the [Contributors page](https://github.com/pytesting/utils/graphs/contributors)\nfor a list of contributors.\nThanks to all contributors!\n\n## License\n\n`pytesting_utils` is free software: you can redistribute it and/or modify it\nunder the terms of the GNU Lesser General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.\n\n`pytesting_utils` is distributed in the hope that it will be useful but\nWITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS OF A PARTICULAR PURPOSE.  See the\nGNU Lesser General Public License for more details.\n\nYour should have received a [copy](LICENSE.txt) of the\nGNU Lesser General Public License\nalong with `pytesting_utils`.  If not, see\n[https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).\n",
    'author': 'Stephan Lukasczyk',
    'author_email': 'python-test-runner@googlegroups.com',
    'maintainer': None,
    'maintainer_email': None,
    'url': 'https://github.com/pytesting/utils',
    'packages': packages,
    'package_data': package_data,
    'install_requires': install_requires,
    'python_requires': '>=3.6,<4.0',
}


setup(**setup_kwargs)
