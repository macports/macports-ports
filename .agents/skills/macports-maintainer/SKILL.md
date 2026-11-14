---
name: macports-maintainer
description: |
  Full MacPorts port lifecycle in this tree: add new ports, version-bump and
  fix existing ones, take or leave maintainership, deprecate, replace/rename
  via obsolete/replaced_by, and remove ports after the guide waiting period.
  Also: sync upstream, livecheck, reuse open PRs, apply every PortGroup bump
  procedure, lint + install/smoke-test, then after human approval commit/push/
  open PRs (one port = one PR). Use whenever someone asks to add, update, fix,
  deprecate, obsolete, replace, remove, or maintain a port, check for updates,
  open a MacPorts PR, or clean merged PR branches — for any contributor.
---

# MacPorts port lifecycle

Executable procedures for this tree. **Policy and hard rules live only in
[AGENTS.md](../../../AGENTS.md)** — follow them; do not restate or weaken them
here.

| Detail | Doc |
| --- | --- |
| Lifecycle steps (new → remove) | [references/lifecycle.md](references/lifecycle.md) |
| PortGroup packaging | [references/portgroups.md](references/portgroups.md) |

## Resolve identity

```bash
git remote -v
# GITHUB_USER = owner segment of the fork remote:
#   …github.com[:/]OWNER/macports-ports…
```

Map remotes per AGENTS.md. No `gh` CLI required. Maintainer search:
`$GITHUB_USER`, `{@$GITHUB_USER}`, plus any handle/email the human gives.
Skip only ports they list as ignored.

## Choose the operation

| Goal | Section |
| --- | --- |
| Add a port that does not exist | [New port](#new-port) |
| Newer upstream / checksum / patch bump | [Update](#update-enhance-fix) |
| Behavior/fix without version change | [Update](#update-enhance-fix) |
| Claim, co-maintain, or drop maintainership | [Maintainership](#maintainership) |
| Discourage use; port stays for now | [Deprecate](#deprecate) |
| Redirect upgrades to another port / rename | [Replace or rename](#replace-or-rename) |
| Delete directory from the tree | [Remove](#remove) |
| Scan everything I maintain | [Batch scan](#batch-scan) |

Every path: **[Sync](#1-sync-upstream)** first, then draft → lint/verify →
**[Publish](#publish)** only after human approval (AGENTS.md).

---

## 1. Sync upstream

```bash
git fetch "$UPSTREAM" && git fetch "$FORK"
git checkout master && git pull --ff-only "$UPSTREAM" master
git status -sb
```

Stop if not fast-forward. Keep local `sources.conf` usable; restore if changed.
Prune merged feature branches ([Cleanup](#cleanup)) unless asked to skip.

---

## New port

1. Confirm it is not already in the tree / an open PR (`port search`, and
   GitHub PR search — see [Existing open PR](#existing-open-pr)).
2. Create `<primary-category>/<name>/Portfile` (+ `files/` as needed).
   Primary `categories` entry **must** match the directory name.
3. Write the Portfile (modeline, `PortSystem`, metadata, fetch, checksums,
   deps, phases). Prefer fitting PortGroups; follow
   [portgroups.md](references/portgroups.md).
4. Set `maintainers` per AGENTS.md; `revision 0`.
5. `port -d checksum $name`; regenerate any group artifacts.
6. `port lint --nitpick $name`; install + smoke-test.
7. Publish: branch `$name-new`, subject/title `$name: new port`.

Full checklist/skeleton: [lifecycle.md §A](references/lifecycle.md).

---

## Update, enhance, fix

1. [Existing open PR?](#existing-open-pr) — reuse if present.
2. Branch `$port-update-$version` or `$port-fix-…`.
3. Version bump: set `version` / group `*.setup` version; `revision 0`;
   refresh **all** checksums; drop obsolete patches.
   Same-version fix/enhancement: bump `revision` only.
4. Apply every declared PortGroup procedure
   ([portgroups.md](references/portgroups.md)).
5. Lint + install/smoke-test.
6. Publish with matching subject (`$port: update to $version` / `$port: fix …`).

Details: [lifecycle.md §B](references/lifecycle.md).

### Detect newer upstream

1. `port livecheck $port`
2. Read Portfile PortGroups / setup / livecheck / homepage
3. Matching registries (`npm view`, Hackage, crates.io, project release pages,
   or `curl -fsSL https://api.github.com/repos/OWNER/REPO/releases/latest`)
4. Compare to `version` / `*.setup` (and epoch)

Skip routine livecheck on `obsolete` / pure stubs unless the human asks.

### Existing open PR

Prefer the GitHub UI (Guide). Optional `curl` if a scripted check helps:

```text
https://github.com/macports/macports-ports/pulls?q=is%3Apr+is%3Aopen+$port
https://github.com/macports/macports-ports/pulls?q=is%3Apr+is%3Aopen+author%3A$GITHUB_USER
```

```bash
# optional (GitHub REST; no gh required)
curl -fsSL "https://api.github.com/search/issues?q=repo:macports/macports-ports+is:pr+is:open+$port"
```

| Situation | Action |
| --- | --- |
| Open PR already at newest | Report URL; stop for that port |
| Open PR, older target | Update **that** PR’s head branch on the fork |
| Unrelated / closed | New PR only if tree behind upstream |
| Someone else’s correct bump | Report; supersede only if asked |

---

## Maintainership

- **Take:** `nomaintainer` or invited co-maintain → set `maintainers` per
  AGENTS.md; subject `$port: take maintainership` (or add co-maintainer).
- **Leave:** remove only yourself; leave others / `nomaintainer` intact.
- Semantic-only maintainer change → its own commit; if also fixing a bug,
  separate commits in the same one-port PR (Guide).
- Lint required; install optional if nothing else changed.

Details: [lifecycle.md §C](references/lifecycle.md).

---

## Deprecate

Port remains in the tree; usage discouraged.

1. Add `PortGroup deprecated 1.0` and set the appropriate knobs
   (`deprecated.upstream_support`, `macports_support`, `eol_version`,
   `maximum_osmajor`, `maximum_xcodeversion`) — read `deprecated-1.0.tcl`.
2. Bump `revision` so installed users upgrade and see notes / fail paths.
3. Lint; install unless this platform hits `known_fail`.
4. Subject: `$port: deprecate`.

Do **not** use `obsolete`/`replaced_by` here unless also replacing.
Details: [lifecycle.md §D](references/lifecycle.md).

---

## Replace or rename

Redirect users/upgrades to another port (or mark gone with no successor).

1. Prefer `PortGroup obsolete 1.0` + `replaced_by <newport>` (omit
   `replaced_by` only when there is no replacement — group still errors on
   install). Optional `obsolete.note`.
2. Bump `revision` (keep prior `version` lineage). Clear fetch/build via the
   group defaults — do not treat as a normal version bump.
3. Replacement port must already exist (or land in a coordinated PR the human
   scoped). One port = one PR remains the default.
4. Lint; expect install of the stub to fail with the replacement message;
   `port upgrade` of an installed stub should install `replaced_by`.
5. Subject: `$old: replaced by $new` / `$old: obsolete`.

`PortGroup stub` is unrelated (empty placeholder deps). Details:
[lifecycle.md §E](references/lifecycle.md).

---

## Remove

1. If there is a replacement: obsolete/`replaced_by` first; **wait ~1 year**
   (Guide) before deleting the directory.
2. If there is no replacement: deletion may be immediate.
3. Check reverse dependencies and open PRs; handle dependents in their own
   PRs unless the human explicitly coordinates otherwise.
4. Delete `<category>/<port>/`; subject `$port: remove`.

Details: [lifecycle.md §F](references/lifecycle.md).

---

## Discover maintained ports

```bash
port echo maintainer:$GITHUB_USER
rg -n -e "$GITHUB_USER" --glob '**/Portfile' -l
port info --maintainer --version --revision $port
port dir $port
```

Report port, version, path, maintainers. For batch work, skip obsolete stubs
in update tables unless the human names them.

---

## Publish

Shared endgame for every lifecycle operation (after human approval).

### Commit

Subjects follow AGENTS.md / CommitMessages, e.g.:

```text
$port: new port
$port: update to $version
$port: fix …
$port: take maintainership
$port: deprecate
$port: replaced by $other
$port: remove
```

Version-only → one commit vs upstream `master`. Squash WIP if needed:

```bash
git fetch "$UPSTREAM"
git reset --soft "$UPSTREAM/master"
git add <only this port's paths>
git commit -m "$port: …"
```

### PR

Push the feature branch, then open the PR in the GitHub UI (Guide):

```bash
git push -u "$FORK" HEAD:"$branch"
# open:
# https://github.com/macports/macports-ports/compare/master...$GITHUB_USER:$branch?expand=1
# fill title/body from .github/PULL_REQUEST_TEMPLATE.md
```

Update a behind PR by pushing to the same fork head branch (force-with-lease
after squash) instead of opening a duplicate. During review: check the PR’s
Checks tab on GitHub; squash follow-ups; force-with-lease the feature branch
only. Idle days → ask before mailing macports-dev. On merge → Cleanup.

### Cleanup

```text
https://github.com/macports/macports-ports/pulls?q=is%3Apr+is%3Amerged+author%3A$GITHUB_USER
```

```bash
git fetch "$FORK" --prune
# for each merged PR head branch (not master/main, not still open):
git push "$FORK" --delete "$branch"
git branch -d "$branch"
```

---

## Batch scan

1. Sync; prune merged branches.
2. List maintained ports; livecheck active (non-obsolete) ones.
3. Classify: up to date | open PR at newest | needs packaging / other lifecycle work.
4. Nothing to do → summary only; stop (AGENTS.md clean-scan).
5. Else ask which ports/operations; for each run the matching section → ask
   again before Publish.

---

## Cheatsheet

```bash
port echo maintainer:$GITHUB_USER
port search $name
port livecheck $port
port info --version --revision --maintainer $port
port lint --nitpick $port
port -d checksum $port
sudo port -v install $port
port echo depends:$port
git remote -v
git push -u "$FORK" HEAD:"$branch"
# PR search/compare: GitHub pulls UI or compare/master...$GITHUB_USER:$branch
```
