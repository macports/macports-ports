# PortGroups — packaging reference

PortGroups are Tcl includes under `_resources/port1.0/group/<name>-<ver>.tcl`.
Guide: https://guide.macports.org/chunked/reference.portgroup.html
(partial). **Always read the group file header** for the PortGroups a Portfile
declares — that is the source of truth for keywords and bump steps.

## Universal procedure (every bump / new port)

1. From the Portfile, collect every `PortGroup name version` line (order can
   matter; nested groups pulled in by another group still count).
2. For each, open `_resources/port1.0/group/<name>-<version>.tcl`.
3. Note: setup keywords (`*.setup`), options that embed versioned deps, files
   under `${filespath}`, generators named in comments (`go2port`, `cargo2port`,
   `pub2port`, …).
4. Apply that group’s bump steps **before** lint/install.
5. Refresh top-level and appended `checksums` (`port -d checksum $port`).
6. If install fails with frozen-lock / missing vendor / checksum mismatch,
   re-read the group — an artifact was almost certainly skipped.

Commit group-owned artifacts in the **same** version-bump commit as the
Portfile (unless the human asked for separate logical commits).

---

## Host / VCS setup groups

Set coordinates + version via `*.setup`; they wire `master_sites`, `distname`,
and often `livecheck`. Bumping usually means updating the version argument (and
tag prefix/suffix if tags changed), then checksums.

| Group | Typical setup | Notes |
| --- | --- | --- |
| `github` | `github.setup author project version [tag_prefix [tag_suffix]]` | Releases vs tarball/tag strategies — see group + guide |
| `gitlab` | `gitlab.setup` | Same idea |
| `bitbucket` | `bitbucket.setup` | |
| `gitea` / `codeberg` / `sourcehut` / `notabug` / `cgit` | respective `*.setup` | |
| `git_archive` | archive-from-git fetch | |

On bump: change version in `*.setup` (not only a lone `version` line if setup
owns it), confirm tag prefix still matches upstream tags, recompute checksums.

---

## Language / module ecosystems

### `golang`

- `go.setup domain/author/project version [tag_prefix]` (may auto-apply github/…).
- Optional `go.package` for vanity import paths.
- **`go.vendors`** — vendored modules + checksums from `go.sum` / lockfiles.
  Regenerate with **`go2port`** (MacPorts) on every bump that changes deps.
- `go.toolchain_min` if the project needs a newer Go.

### `rust` / `cargo` / `cargo_fetch`

- **`cargo.crates`** — `name version sha256` triples from upstream `Cargo.lock`.
- Optional **`cargo.crates_github`** for crates not on crates.io.
- Regenerate with **`cargo2port`** or the `egrep`/`perl` pipeline documented in
  the group header. Missing crate list → fetch/build failures under `--frozen`.

### `pub` (+ `dart`)

- **`pub.packages`** — `name version sha256` from `pubspec.lock`.
- Regenerate with **`pub2port`** (https://github.com/amake/pub2port).

### `bun`

- Registry install like npm; **`files/bun.lock`** required (`bun.lockfile`,
  default `${filespath}/bun.lock`).
- Destroot runs `bun install --frozen-lockfile`. Bumping only `version` +
  checksums fails with “lockfile had changes”.
- Regenerate from the new distfile:

```bash
cp "$distfile" "$workdir/"
# package.json must match destroot:
# trustedDependencies = bun.rootname (+ bun.trusted_dependencies)
# dependencies = { "${bun.rootname}": "file:./${distname}.tgz" }
bun install --lockfile-only
cp bun.lock <category>/$port/files/bun.lock
```

### `npm`

- `npm.rootname` (default `${name}`); distfile from registry.
- Bump `version` + checksums; keep `npm.nodejs_version` / `npm.version` coherent
  with the package’s engines if declared. No committed lockfile by default.

### `python`

- Modules: `py-*` + `python.versions` → subports `pyXX-*`.
- Apps: set `python.default_version`.
- On bump: update version/checksums; only change `python.versions` when dropping
  or adding Python lines — test affected subports.

### `perl5` / `ruby` / `php` / `lua` / `luarocks` / `luarocks_org` / `R` / `octave` / `ocaml` / `janet` / `haskell_cabal` / `haskell_stack` / `java` / `elisp` / `tree_sitter`

- Follow each group’s version/module keywords and default livecheck.
- Bumps are usually version + checksums + any group-specific module name/branch.
- Haskell: do not overwrite configure/build/destroot defaults the group sets
  unless intentionally overriding.

---

## Build-system groups

Usually **no extra committed artifacts** on a pure version bump — still open the
file for option renames between group versions (`cmake` 1.0 vs 1.1, etc.).

| Group | Role |
| --- | --- |
| `cmake` / `meson` / `waf` / `makefile` | configure/build defaults |
| `qmake` / `qmake5` / `qmake6` | Qt qmake |
| `xcode` / `xcodeversion` / `xcode_workaround` | Xcode projects |
| `gnustep` | GNUstep |
| `bazel` / `maven` | respective toolchains |
| `compiler_wrapper` / `compilers` / `fortran` / `legacysupport` / `muniversal` / `limit_flags` / `debug` / `mpi` | compiler/ABI helpers |

Bump: version + checksums; verify `compiler.cxx_standard` / blacklist options
still match upstream requirements.

---

## App / OS integration

| Group | Packaging notes |
| --- | --- |
| `app` | Optional wrapper/executable from `${filespath}` — keep in sync if renamed |
| `select` | Commit `files/*` select group files referenced by the Portfile |
| `startupitem` (keyword, not always a PG) | plist/params when present |
| `fuse` / `x11font` / `xmlcatalog` / `yelp` / `gpg_verify` / `active_variants` / `conflicts_build` / `openssl` / `boost` / `linear_algebra` / `gobject_introspection` / `gnu_info` / `gnulib` | Feature helpers — read before changing related options |

---

## Lifecycle / stub groups

| Group | Use |
| --- | --- |
| `obsolete` | Replaced/removed ports — see [lifecycle.md](lifecycle.md) §E–F |
| `deprecated` | Discourage use; port remains — see [lifecycle.md](lifecycle.md) §D |
| `stub` | Empty placeholder dependency port — not for deprecation/replacement |

Do not livecheck/bump `obsolete` stubs like normal ports unless the human asks.

---

## Generators (prefer over hand-editing vendor lists)

| Ecosystem | Tool (from group comments) |
| --- | --- |
| Go | `go2port` |
| Rust/Cargo | `cargo2port` |
| Dart pub | `pub2port` |
| Bun | `bun install --lockfile-only` (see above) |

If a group documents a generator, use it. Hand-syncing long `go.vendors` /
`cargo.crates` / `pub.packages` blocks invites checksum errors.

---

## Anti-patterns

- Bumping `version`/`checksums` without opening every declared PortGroup file
- Leaving stale `cargo.crates` / `go.vendors` / `pub.packages` / `bun.lock`
- Changing `python.versions` without testing subports
- Treating `obsolete`/`stub` ports as normal updates
- Assuming the Guide documents every group — **read the Tcl**
