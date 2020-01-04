#### Description

<!-- Note: it is best to make pull requests from a branch rather than from master -->

###### Type(s)
<!-- update (title contains ": U(u)pdate to"), submission (new Portfile) and CVE Identifiers are auto-detected, replace [ ] with [x] to select -->

- [ ] bugfix
- [ ] enhancement
- [ ] security fix

###### Tested on
<!-- Generate version information with this command in shell:
    echo "macOS $(sw_vers -productVersion) $(sw_vers -buildVersion)"; echo "Xcode $(xcodebuild -version | awk '{print $NF}' | tr '\n' ' ')"
-->
macOS 10.x
Xcode 8.x

###### Verification <!-- (delete not applicable items) -->
Have you

- [ ] followed our [Commit Message Guidelines](https://trac.macports.org/wiki/CommitMessages)?
- [ ] squashed and [minimized your commits](https://guide.macports.org/#project.github)?
- [ ] checked that there aren't other open [pull requests](https://github.com/macports/macports-ports/pulls) for the same change?
- [ ] referenced existing tickets on [Trac](https://trac.macports.org/wiki/Tickets) with full URL?
<!-- Please don't open a new Trac ticket if you are submitting a pull request. -->
- [ ] checked your Portfile with `port lint`?
- [ ] tried existing tests with `sudo port test`?
- [ ] tried a full install with `sudo port -vst install`?
- [ ] tested basic functionality of all binary files?

<!-- Use "skip notification" (surrounded with []) to avoid notifying maintainers -->

###### Git references
Please refer to these pages and the commented cheat sheet below:
* https://guide.macports.org/#project.github
* https://trac.macports.org/wiki/WorkingWithGit
<!-- git cheat sheet

# Setup

git config --global user.name 'Foo Barbaz'
git config --global user.email 'foo.bar.baz@email.com'

## Clone the MacPorts repo

### HTTPS
git clone https://github.com/macports/macports-ports.git
### or SSH
git clone git@github.com:macports/macports-ports.git

## Add macports/macports-ports.git as the "upstream" repo

cd macports-ports
git remote add upstream https://github.com/macports/macports-ports.git

# New PR; single port

## Reset the local master to upstream [destructive]

git checkout master
git fetch --all
git reset --hard upstream/master
git push -f origin master

## New branch off master, single port

git checkout -b myport-branch master
vi category/port/Portfile
git add category/port/Portfile
vi category/port/files/myfile
git add category/port/files/myfile
git commit
git push --set-upstream origin myport-branch
open -a Safari https://github.com/myaccount/macports-ports/pull/new/myport-branch

## PR edits; single port

git checkout myport-branch
vi category/port/Portfile
git add category/port/Portfile
git commit --amend --no-edit
git push -f origin myport-branch

# New PR; multiple ports

## Reset the local master to upstream, as above

## New branch off master, multiple ports

git checkout -b myport-branch master
vi category/port1/Portfile
git add category/port1/Portfile
git commit
vi category/port2/Portfile
git add category/port2/Portfile
git commit
...
git push --set-upstream origin myport-branch
open -a Safari https://github.com/myaccount/macports-ports/pull/new/myport-branch

## PR edits; multiple ports

git checkout myport-branch
### rebase to specific commit
#### find commit hash fffffffffffffffffffffffffffffffffffffffff
git log --graph
#### rebase to the previous commit [note the caret at the end of hash^]
git rebase --interactive fffffffffffffffffffffffffffffffffffffffff^
#### change the command on the first line from 'pick' to 'edit'
vi category/port/Portfile
git add category/port/Portfile
git commit --amend --no-edit
git rebase --continue
### edit additional specific commits as necessary
git push -f origin myport-branch

# Rebase the PR to upstream

## Reset the local master to upstream, as above

git checkout myport-branch
git pull --rebase --autostash origin master

# Troubleshooting

## Show all files modified in the local branch

git diff --name-only myport-branch $(git merge-base myport-branch master)

-->
