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
- [ ] referenced existing tickets on [Trac](https://trac.macports.org/wiki/Tickets) with full URL? <!-- Please don't open a new Trac ticket if you are submitting a pull request. -->
- [ ] checked your Portfile with `port lint --nitpick`?
- [ ] tried existing tests with `sudo port test`?
- [ ] tried a full install with `sudo port -vst install`?
- [ ] tested basic functionality of all binary files?

<!-- Use "skip notification" (surrounded with []) to avoid notifying maintainers -->
