#!/usr/bin/env python3
#
# This is a small script that intercepts the install command, and
# applies it to multiple wheels.
#


import multiprocessing.dummy
import os
import pathlib
import subprocess
import sys

sys.path.insert(0, "development-support")

import _install_tool

workdir = pathlib.Path(sys.argv[1])
cmd = sys.argv[2:]

for wheel in workdir.glob("*.whl"):
    subprocess.run(cmd + [wheel], cwd=workdir, check=True)
