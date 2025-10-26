# 🧾 Pull Request Summary

### What does this PR do?
<!-- Short description of what this pull request changes or adds. -->

- [ ] 🔧 MacPorts workflow update
- [ ] 💾 Bitcoin daemon configuration
- [ ] 🧰 General maintenance / refactor
- [ ] 🧱 Documentation or README update
- [ ] 🐛 Bug fix / security patch

---

## 🔍 Description & Context
<!-- Explain why this change is needed, what issue it addresses, or what improvement it introduces. -->
<!-- Example: "Updated mirror.yml to support OIDC authentication and removed static SSH keys." -->

---

## ✅ Verification Steps

**Before submitting this PR:**
- [ ] Confirmed local syntax/lint passes (`yamllint`, `plistlib` check)
- [ ] CI runs successfully on fork or test branch
- [ ] Verified no credentials or tokens appear in the diff
- [ ] Confirmed `.github/workflows/` still uses **pinned commit SHAs**
- [ ] Tested LaunchDaemon behavior locally (if modified)
- [ ] Checked file permissions and ownership in configs (macOS):
  - `/etc/bitcoin/bitcoin.conf` → `bitcoin:bitcoin 0600`
  - `/Library/LaunchDaemons/org.bitcoin.bitcoind.plist` → `root:wheel 0644`

---

## 🛡️ Security & Privacy Checklist

### GitHub Workflows
- [ ] No plain-text secrets or tokens in workflow YAML
- [ ] All actions pinned to **commit SHAs**
- [ ] No `echo ${{ secrets.* }}` statements
- [ ] If SSH is used, verified via **restricted key / command** in authorized_keys
- [ ] Prefer OIDC for artifact upload (where available)

### Bitcoin Daemon
- [ ] `bitcoin.conf` does **not** include rpcuser/rpcpassword
- [ ] Uses **cookie authentication** only
- [ ] Optional privacy mode (Tor/DNS seed disabled) verified if enabled
- [ ] Log rotation active via `/etc/newsyslog.d/bitcoind.conf`

### General
- [ ] No sensitive file paths revealed in logs
- [ ] No secrets or tokens added to repository history
- [ ] Configuration changes documented below

---

## 📦 Configuration or Secret Changes
<!-- Document if new secrets, keys, or environment variables are required -->
| Type | Name | Required? | Notes |
|------|------|------------|-------|
| 🔐 GitHub Secret | MIRROR_DB_URL | Yes | Mirror database endpoint |
| 🔐 GitHub Secret | MIRROR_DB_CREDENTIALS | Yes | Service credentials or token |
| 🔐 GitHub Secret | MIRROR_UPLOAD_URL | Optional | Artifact upload target |
| 🔐 GitHub Secret | GOOGLE_OIDC_TOKEN | Optional | OIDC upload auth |
| ⚙️ System Config | bitcoin.conf | Yes | Verified secure configuration |

---

## 🧪 Testing Evidence
<!-- Provide logs, screenshots, or CI run links showing tests passed and service working as expected. -->
Example:
#### Description

<!-- Note: it is best to make pull requests from a branch rather than from master -->

###### Type(s)
<!-- update (title contains ": U(u)pdate to"), submission (new Portfile) and CVE Identifiers are auto-detected, replace [ ] with [x] to select -->

- [ ] bugfix
- [ ] enhancement
- [ ] security fix

###### Tested on
<!-- Triple-click and copy the next line and paste it into your shell. It will copy your OS and Xcode version to the clipboard. Paste it here replacing this section.
sh -c 'echo "macOS $(sw_vers -productVersion) $(sw_vers -buildVersion) $(uname -m)"; xcode=$(xcodebuild -version 2>/dev/null); if [ $? == 0 ]; then echo "$(echo "$xcode" | awk '\''NR==1{x=$0}END{print x" "$NF}'\'')"; else echo "Command Line Tools $(pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | awk '\''/version:/ {print $2}'\'')"; fi' | tee /dev/tty | pbcopy
-->
macOS x.y
Xcode x.y / Command Line Tools x.y.z

###### Verification <!-- (delete not applicable items) -->
Have you

- [ ] followed our [Commit Message Guidelines](https://trac.macports.org/wiki/CommitMessages)?
- [ ] squashed and [minimized your commits](https://guide.macports.org/#project.github)?
- [ ] checked that there aren't other open [pull requests](https://github.com/macports/macports-ports/pulls) for the same change?
- [ ] referenced existing tickets on [Trac](https://trac.macports.org/wiki/Tickets) with full URL in commit message? <!-- Please don't open a new Trac ticket if you are submitting a pull request. -->
- [ ] checked your Portfile with `port lint`?
- [ ] tried existing tests with `sudo port test`?
- [ ] tried a full install with `sudo port -vst install`?
- [ ] tested basic functionality of all binary files?
- [ ] checked that the Portfile's most important [variants](https://trac.macports.org/wiki/Variants) haven't been broken?

<!-- Use "skip notification" (surrounded with []) to avoid notifying maintainers -->
