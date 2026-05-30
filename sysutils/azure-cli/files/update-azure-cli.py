#!/usr/bin/env python3.13
"""Generate portfile distfiles/checksums sections for a new azure-cli release.

Usage:
    files/update-azure-cli.py <new-version> [--workdir DIR]

azure-cli has a lot of dependencies/submodules that are pinned to
specific versions for a particular release, so we install all of them
via (arch-independent) wheels in a single port.

This script uses `pip download` to resolve the dependencies of a new
version of azure-cli. It outputs replacement master_sites, distfiles,
checksums, and depends_lib blocks for the Portfile.
"""

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
import urllib.request

# Which packages to install via this port (vs non-Azure packages to
# depends_lib on)
BUNDLED_RE = re.compile(r"^(azure_|msrest-)")

# General assumption: Python module ports have the same name as the
# PyPI package, except using hyphens instead of underscores.
# Exceptions that do not follow this pattern:
PYPI_TO_PORT_OVERRIDES = {
    "py_deviceid": "deviceid",
    "python_dateutil": "dateutil",
    "pyyaml": "yaml",
    "pyjwt": "jwt",
    "pyopenssl": "openssl",
    "pysocks": "socks",
    "typing_extensions": "typing_extensions",
}

# Python version used by the port. This should be invoked with the
# matching Python interpreter. Make sure this matches the portfile.
EXPECTED_PYTHON_VERSION = "3.13"

INDENT = " " * 20
CS_INDENT = INDENT + "    "


def parse_wheel(filename):
    """Return (package, version) parsed from a wheel filename."""
    # Wheel: {name}-{version}(-{build})?-{python}-{abi}-{platform}.whl
    parts = filename[:-4].split("-")
    return parts[0], parts[1]


def pypi_to_port_suffix(pkg):
    """Map a wheel package name to the MacPorts `py-X` suffix `X`."""
    key = pkg.lower()
    if key in PYPI_TO_PORT_OVERRIDES:
        return PYPI_TO_PORT_OVERRIDES[key]
    return key.replace("_", "-")


def fetch_pypi_url_record(pkg, version, filename):
    """Return the PyPI JSON `urls` record matching `filename`."""
    # PyPI normalizes the project name per PEP 503.
    normalized = re.sub(r"[-_.]+", "-", pkg).lower()
    url = f"https://pypi.org/pypi/{normalized}/{version}/json"
    with urllib.request.urlopen(url) as r:
        data = json.load(r)
    for u in data["urls"]:
        if u["filename"] == filename:
            return u
    raise SystemExit(f"PyPI has no file {filename} for {normalized}=={version}")


def rmd160(path):
    """Compute RIPEMD-160 of a file via the `openssl` CLI."""
    out = subprocess.check_output(["openssl", "rmd160", path], text=True)
    return out.strip().rsplit(" ", 1)[-1]


def download_wheels(workdir, version):
    expected = tuple(map(int, EXPECTED_PYTHON_VERSION.split(".")))
    if sys.version_info[:2] != expected:
        print(
            f"WARNING: running under Python {sys.version_info.major}"
            f".{sys.version_info.minor},", 
            f"expected version {EXPECTED_PYTHON_VERSION}.",
            file=sys.stderr,
        )
    subprocess.check_call(
        [
            sys.executable,
            "-m",
            "pip",
            "download",
            "--only-binary=:all:",
            "-d",
            workdir,
            f"azure-cli=={version}",
        ],
        stdout=sys.stderr,
    )


def format_aligned(option, value_lines):
    """Format `option<spaces>value` with continuation backslashes."""
    head = option + " " * (len(INDENT) - len(option))
    body = (" \\\n" + INDENT).join(value_lines)
    return head + body


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("version", help="new azure-cli version, e.g. 2.86.0")
    ap.add_argument(
        "--workdir",
        help="directory to download wheels into (default: a temp dir)",
    )
    args = ap.parse_args()

    if args.workdir:
        workdir = os.path.abspath(args.workdir)
        os.makedirs(workdir, exist_ok=True)
    else:
        workdir = tempfile.mkdtemp(prefix="azure-cli-wheels-")
    print(f"Downloading wheels into {workdir} ...", file=sys.stderr)
    download_wheels(workdir, args.version)

    wheels = sorted(f for f in os.listdir(workdir) if f.endswith(".whl"))
    bundled = [w for w in wheels if BUNDLED_RE.match(w)]
    external = [w for w in wheels if not BUNDLED_RE.match(w)]

    print(
        f"\n{len(bundled)} azure_*/msrest-* wheels will be bundled.",
        file=sys.stderr,
    )
    print(
        f"{len(external)} other wheels are external dependencies.",
        file=sys.stderr,
    )
    for w in external:
        pkg, ver = parse_wheel(w)
        port = "py${py_ver_nodot}-" + pypi_to_port_suffix(pkg)
        print(f"    {port}: {ver}", file=sys.stderr)
    print(file=sys.stderr)

    entries = []
    for w in bundled:
        pkg, ver = parse_wheel(w)
        print(f"  PyPI metadata: {pkg} {ver}", file=sys.stderr)
        rec = fetch_pypi_url_record(pkg, ver, w)
        entries.append(
            {
                "tag": pkg,
                "file": w,
                "url": rec["url"].rsplit("/", 1)[0] + "/",
                "sha256": rec["digests"]["sha256"],
                "size": rec["size"],
                "rmd160": rmd160(os.path.join(workdir, w)),
            }
        )
    entries.sort(key=lambda e: e["tag"])

    print(format_aligned(
        "master_sites", [f"{e['url']}:{e['tag']}" for e in entries]))
    print()
    print(format_aligned(
        "distfiles", [f"{e['file']}:{e['tag']}" for e in entries]))
    print()
    cs_blocks = [
        f"{e['file']} \\\n"
        f"{CS_INDENT}rmd160  {e['rmd160']} \\\n"
        f"{CS_INDENT}sha256  {e['sha256']} \\\n"
        f"{CS_INDENT}size    {e['size']}"
        for e in entries
    ]
    print(format_aligned("checksums", cs_blocks))
    print()

    dep_suffixes = sorted({pypi_to_port_suffix(parse_wheel(w)[0]) for w in external})
    dep_lines = ["port:python${py_ver_nodot}"] + [
        "port:py${py_ver_nodot}-" + s for s in dep_suffixes
    ]
    print(format_aligned("depends_lib", dep_lines))


if __name__ == "__main__":
    main()
