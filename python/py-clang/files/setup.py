#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Based on https://raw.githubusercontent.com/trolldbois/python-clang/master/setup.py

from setuptools import setup

setup(
    name="clang",
    version="6.0",
    description="libclang python bindings",
    long_description=open("README.txt").read(),
    url="http://clang.llvm.org/",
    download_url="http://llvm.org/releases/download.html",
    license="License :: OSI Approved :: University of Illinois/NCSA Open Source License",
    classifiers=[
        "Intended Audience :: Developers",
        "License :: OSI Approved :: University of Illinois/NCSA Open Source License",
        "Development Status :: 5 - Production/Stable",
        "Topic :: Software Development :: Compilers",
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3"
    ],
    keywords=["llvm", "clang", "libclang"],
    author="LLVM team",
    zip_safe=False,
    packages=["clang"],
    # if use nose.collector, many plugins not is avaliable
    # see: http://nose.readthedocs.org/en/latest/setuptools_integration.html
    test_suite="nose.collector",
    tests_require=['nose']
)
