# AGENTS.md — macports-ports

Project policy for agents and contributors. Authority: the
[MacPorts Guide](https://guide.macports.org/). Prefer GitHub PRs over Trac.

**How to run port lifecycle workflows** (new, update, fix, maintainership,
deprecate, obsolete/replace, remove): `.agents/skills/macports-maintainer/`
(procedures only — this file is the rule source).

## Policy sources

| Topic | Source |
| --- | --- |
| Git / PRs | [project.github](https://guide.macports.org/chunked/project.github.html) |
| Contribute | [project.contributing](https://guide.macports.org/chunked/project.contributing.html) |
| Non-maintainer / timeout | [project.update-policies](https://guide.macports.org/chunked/project.update-policies.html) |
| Commit subjects | [CommitMessages](https://trac.macports.org/wiki/CommitMessages) |
| PortGroups | [reference.portgroup](https://guide.macports.org/chunked/reference.portgroup.html); `_resources/port1.0/group/` |
| PR checklist | `.github/PULL_REQUEST_TEMPLATE.md` |

## PortGroups

A **PortGroup** is a shared Tcl include (`PortGroup name version`) that factors
common Portfile behavior. Sources:
`_resources/port1.0/group/<name>-<version>.tcl`. Guide coverage is incomplete —
**the group file’s header comments are authoritative** when the guide lacks a
section.

Groups set fetch/livecheck defaults, language or build conventions, vendored
dependency lists, or helpers. A Portfile may use several. On any edit or
version bump: list every `PortGroup` line → open each matching group file →
regenerate group-owned artifacts (lockfiles, `cargo.crates` / `go.vendors` /
`pub.packages`, select files, …). Version + top-level `checksums` alone are
often not enough.

Per-family packaging steps:
`.agents/skills/macports-maintainer/references/portgroups.md`.

## Hard rules

1. **One port = one PR.** One logical change per commit; minimize commits (ideally one). Version-only → **one squashed commit**. Unrelated fix + version bump → separate commits, still one PR. Squash review-only tweaks before merge readiness.
2. **Lint + test before publish:** `port lint --nitpick $port` (fix all issues) **and** install/smoke-test from this tree. When claiming Verification, follow `.github/PULL_REQUEST_TEMPLATE.md` (`port test`, `sudo port -vst install`, variants). Prefer binaries for unrelated upgrades (`buildfromsource ifneeded`); never blanket `-s` on `upgrade outdated`.
3. **Commits:** subject ≤50–55 chars (hard max ~60); `$port: update to $version` / `$port: fix …` / `$port: new port`; blank line; body wrap 72; **full Trac/GitHub URLs** (not bare `#123`); `Closes:` / `See:` + URL for tickets.
4. **PR flow:** fork → feature branch off current upstream `master` → push fork → PR into `macports/macports-ports:master`. Rebase on upstream `master` before open/update. `--force-with-lease` **feature branch on the fork only**; never force-push `master`/`main`.
5. **No duplicate PRs:** search open PRs for the same port/change first; update a behind PR instead of opening another.
6. **`maintainers`:** `{domain.tld:localpart @github}` and/or `{@github}`; optional `openmaintainer`. Use a bare MacPorts handle only if that person has `handle@macports.org`. Do not invent `@macports.org` addresses. Do not rewrite, reorder, or drop co-maintainers on unrelated bumps.
7. **Non-maintainer edits:** `nomaintainer` → free; with `openmaintainer` → minor OK for committers (major still needs contact); else wait **72h** or maintainer ACK. Do not merge someone else’s PR for a maintained port before 72h unless you are the creator or the maintainer.
8. **Version bump:** set `version` (or the group’s setup keyword); `revision 0`; refresh **all** checksums; drop obsolete patches; apply every PortGroup’s bump procedure (PortGroups section).
9. **Tree hygiene:** sync to upstream `master` before discovery/packaging/PR work; never commit `PortIndex*`, editor backups, or unrelated drift. After merge, delete local and fork feature branches (never delete `master`/`main` or a branch that still backs an open PR).
10. **Agent publish gate:** draft locally; `git commit` / `git push` / opening or editing a GitHub PR (and force-push of a PR branch) only after explicit human approval for that action. Prefer plain `git` plus the GitHub web UI (Guide); do not require the `gh` CLI.
11. **Clean scan:** if every needed bump already has an open PR at the newest upstream version, report the table and stop — no busywork menus.

## Remotes

Detect from `git remote -v` (do not hardcode a person):

| Role | Typical names | Expected URL |
| --- | --- | --- |
| Upstream | `origin` or `upstream` | `macports/macports-ports` |
| Contributor fork | `fork` or `origin` | `$GITHUB_USER/macports-ports` |

`$GITHUB_USER`: parse from the fork remote URL (`github.com[:/]USER/macports-ports`), or ask the human. Override only if they name a different identity.

## PR body

Use `.github/PULL_REQUEST_TEMPLATE.md`. Title ≈ primary commit subject. Record real OS / Xcode or CLT / MacPorts versions and the commands actually run.

If a PR sits idle for several days, the human may ping `macports-dev@lists.macports.org` with the PR link — ask before sending mail.
