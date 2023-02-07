#!/usr/bin/env python3
#
# This is a small script that intercepts the build command, and
# applies it to multiple directories, in parallel.
#

import multiprocessing.dummy
import pathlib
import subprocess
import sys

sys.path.insert(0, "development-support")

import _install_tool

jobs = int(sys.argv[1])
cmd = sys.argv[2:]
dirs = ["pyobjc-core"] + _install_tool.sorted_framework_wrappers()

failed = []

def build(dirpath):
    r = subprocess.run(
        cmd,
        cwd=dirpath,
        check=dirpath == "pyobjc-core",
    )

    if not r:
        failed.append(dirpath)



with multiprocessing.dummy.Pool(jobs) as p:
    p.map(build, dirs)


print("FAILED:", *failed)
