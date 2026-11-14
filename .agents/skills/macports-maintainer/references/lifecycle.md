# Port lifecycle — detailed procedures

Guide anchors:

- New / enhance: https://guide.macports.org/chunked/project.contributing.html
- Creating a Portfile: https://guide.macports.org/chunked/development.creating-portfile.html
- Rename/replace / remove: https://guide.macports.org/chunked/development.practices.html
- Maintainership / non-maintainer: https://guide.macports.org/chunked/project.contributing.html#project.contributing.maintaining , https://guide.macports.org/chunked/project.update-policies.html
- Groups: `_resources/port1.0/group/{obsolete,deprecated,stub}-1.0.tcl`

Policy (one port = one PR, lint/test, publish gate): [AGENTS.md](../../../../AGENTS.md).

---

## A. New port

1. Pick primary `categories` entry; create `<category>/<name>/` (primary category
   **must** match the directory).
2. Add `Portfile` (+ `files/` patches, select files, group artifacts as needed).
3. Minimum shape (standard configure/make/install app):

```tcl
# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

PortSystem          1.0
# PortGroup         …   # only those required; then follow portgroups.md

name                example
version             1.0.0
revision            0
categories          sysutils
license             MIT
maintainers         {@user} openmaintainer
description         Short one-line summary
long_description    Longer description.

homepage            https://example.org/
master_sites        ${homepage}releases/
checksums           rmd160  … \
                    sha256  … \
                    size    …
```

4. Prefer appropriate PortGroups (`github`, `python`, `golang`, …) over
   hand-rolled fetch when they fit — see [portgroups.md](portgroups.md).
5. `maintainers` per AGENTS.md (GitHub `{@user}` and/or obfuscated email;
   encourage `openmaintainer` for sole maintainers).
6. `port -d checksum $name` → paste checksums; apply every PortGroup artifact
   step (lockfiles, vendors, …).
7. From the port dir or via local tree: `port lint --nitpick $name`, then
   install + smoke-test.
8. PR: title `$name: new port`; checklist type **submission** (auto-detected
   for new Portfiles). One port only.

Search first: `port search`, GitHub PRs, Trac — avoid duplicating an existing
or in-flight port.

---

## B. Version update / enhancement / fix

| Kind | What changes | Commit subject pattern |
| --- | --- | --- |
| Version update | `version` / setup version, `revision 0`, checksums, group artifacts, patches | `$port: update to $version` |
| Enhancement | new variant, dependency, feature | `$port: …` |
| Defect fix | build/runtime fix; bump `revision` if version unchanged | `$port: fix …` |

Always: open every `PortGroup`, regenerate artifacts, lint, install. Non-maintainer
edits follow AGENTS.md (openmaintainer / 72h).

---

## C. Take or leave maintainership

**Take** (`nomaintainer`, or invited co-maintain):

1. Confirm with `port info --maintainers $port`.
2. Edit `maintainers` only (or + unrelated fix as **separate commit** in the same PR
   if also fixing a bug — guide: one semantic change per commit).
3. Subject: `$port: take maintainership` / `$port: add maintainer`.
4. Do not Cc `nomaintainer` / `openmaintainer` as people.

**Leave / hand off:** remove yourself; leave `nomaintainer` or remaining
co-maintainers; do not silently drop others. Subject: `$port: drop maintainership`.

**Port Abandoned** (Trac protocol): only when guide abandonment criteria apply;
separate from a normal maintainer-line edit. See update-policies in the Guide.

---

## D. Deprecate (port still exists; discourage use)

Use when the port should remain installable for now but usage is discouraged
(unmaintained upstream, hard to keep building, EOL version line, …).

```tcl
PortGroup           deprecated 1.0

# set the matching knobs (see deprecated-1.0.tcl):
deprecated.upstream_support     no    ;# or
deprecated.macports_support     no    ;# or
deprecated.eol_version          yes   ;# or
deprecated.maximum_osmajor      …     ;# and/or
deprecated.maximum_xcodeversion …
```

Effects (from the group): notes warning users, and/or `known_fail` +
pre-fetch error when past max OS/Xcode. **Not** the same as `obsolete` — do
not clear distfiles or set `replaced_by` unless also replacing.

Bump `revision` so installed users see an upgrade. Lint; install still
expected to work unless `known_fail` paths apply. Subject:
`$port: deprecate` / `$port: mark deprecated`.

---

## E. Replace / rename (stub that redirects upgrades)

**Preferred:** `PortGroup obsolete 1.0` + `replaced_by <newport>`.

```tcl
PortSystem          1.0
PortGroup           obsolete 1.0

name                oldname
replaced_by         newname
version             …           ;# keep prior version lineage visible
revision            N           ;# bump so port outdated triggers upgrade
categories          …           ;# keep meaningful category
# optional:
obsolete.note       "Additional guidance."
```

The group clears distfiles/deps, sets `livecheck.type none`, `known_fail`,
and errors on configure telling users to install `replaced_by` (or uninstall
if no replacement). Override defaults only when needed — read `obsolete-1.0.tcl`.

**Also:**

- Ensure `<newname>` exists (same PR only if one logical replacement story;
  still prefer one port per PR when practical — e.g. add new port PR first,
  then obsolete PR, unless the human wants a paired change).
- Bump `revision` (or version/epoch) on the obsolete stub so `port outdated`
  fires for installed users.
- Subject: `$old: replaced by $new` / `$old: obsolete`.

Long-form without the group (manual `replaced_by`, empty `distfiles`,
`pre-configure` ui_error, …) is documented in the Guide; prefer the PortGroup.

**`stub` PortGroup:** dependency/placeholder ports that install almost nothing
(optional README). Not for deprecation or replacement — different purpose.

---

## F. Remove from the tree

| Case | Action |
| --- | --- |
| Has a replacement | Mark obsolete/`replaced_by` first; **wait ~1 year** before deleting the directory (Guide). |
| No replacement | Directory may be deleted immediately. |

Deletion PR: remove `<category>/<port>/` only after the wait (when applicable).
Subject: `$port: remove` / `$port: delete`. Confirm dependents
(`port echo depends:$port` / reverse deps) and open PRs; fix or obsolete
dependents first if needed — each port still its own PR unless the human
explicitly scopes a coordinated removal.

---

## Verification by lifecycle kind

| Kind | Lint | Install / smoke |
| --- | --- | --- |
| New / update / fix | Required | Required |
| Maintainership-only | Required | Not required if Portfile otherwise unchanged |
| Deprecated (still builds) | Required | Required unless `known_fail` on this platform |
| Obsolete stub | Required | Expect configure/fetch failure with replacement message; upgrading installed stub should pull `replaced_by` |
| Remove | N/A on deleted port | Ensure dependents handled |
