# Forest, an extension to work on a set of nested Mercurial trees.
#
# Copyright (C) 2006 by Robin Farine <robin.farine@terminus.org>
#
# This software may be used and distributed according to the terms
# of the GNU General Public License, incorporated herein by reference.

# Repository path representation
#
# Repository paths stored in the filesystem representation are stored
# in variables named 'rpath'. Repository roots in the mercurial
# representation, stored in variables named 'root', are used in
# snapshot files and in command output.

"""Operations on trees with nested Mercurial repositories.

This extension provides commands that apply to a composite tree called
a forest. Some commands simply wrap standard Mercurial commands, such
as 'clone' or 'status', and others involve a snapshot file.

A snapshot file represents the state of a forest at a given time. It
has the format of a ConfigParser file and lists the trees in a forest,
each tree with the following attributes:

  root          path relative to the top-level tree
  revision      the revision the working directory is based on
  paths         a list of (alias, location) pairs

The 'fsnap' command generates or updates such a file based on a forest
in the file system. Other commands use this information to populate a
forest or to pull/push changes.


Configuration

This extension recognizes the following item in the forest
configuration section:

walkhg = (0|no|false|1|yes|true)

  Whether repositories directly under a .hg directory should be
  skipped (0|no|false) or not (1|yes|true). The default value is true.
  Some commands accept the --walkhg command-line option to override
  the behavior selected by this item.

partial = (0|no|false|1|yes|true)

  Whether fpull should default to partial. The default value is 0.

"""

import errno
import os
import re
import shutil

from mercurial import cmdutil, commands, error, hg, hgweb, node, util
from mercurial import localrepo, sshrepo, sshserver, httprepo, statichttprepo
from mercurial.i18n import gettext as _

# For backwards compatibility, we need the following function definition.
# If we didn't want that, we'd have just written:
#     from mercurial.commands import 
def findcmd(ui, cmd, table, strict=True):
    """Find and execute mercurial.*.findcmd([ui,] cmd[, table, strict])."""
    try:
        return findcmd.findcmd(cmd=cmd, table=table, strict=strict)
    except TypeError:
        try:
            return findcmd.findcmd(ui=ui, cmd=cmd, table=table)
        except TypeError:
            return findcmd.findcmd(ui, cmd)
try:
    findcmd.findcmd = cmdutil.findcmd
    findcmd.__doc__ = cmdutil.findcmd.__doc__
except AttributeError:
    findcmd.findcmd = commands.findcmd
    findcmd.__doc__ = commands.findcmd.__doc__
for m in (error, cmdutil, commands):
    if hasattr(m, "UnknownCommand"):
        UnknownCommand = m.UnknownCommand
        break
try:
    # Assign the exceptions explicitely to avoid demandload issues
    import mercurial.repo
    import mercurial.cmdutil
    RepoError = mercurial.repo.RepoError
    ParseError = mercurial.dispatch.ParseError
except AttributeError:
    import mercurial.error
    RepoError = mercurial.error.RepoError
    ParseError = mercurial.error.ParseError

# For backwards compatibility, find the parseurl() function that splits
# urls and revisions.  Mercurial 0.9.3 doesn't have this, so we need
# to provide a stub.
try:
    parseurl = cmdutil.parseurl
except:
    try:
        _parseurl = hg.parseurl
        def parseurl(url, branches=None):
            url, revs = _parseurl(url, branches)
            if isinstance(revs, tuple):
                # hg >= 1.6
                return url, revs[1]
            return url, revs
    except:
        def parseurl(url, revs):
            """Mercurial <= 0.9.3 doesn't have this feature."""
            return url, (revs or None)

# For backwards compatibility, find the HTTP protocol.
if not hasattr(hgweb, 'protocol'):
    hgweb.protocol = hgweb.hgweb_mod.hgweb

# There are no issues with backward compatibility and ConfigParser.
# But since it was replaced in mercurial >= 1.3, the module is not
# longer shipped by Windows binary packages. In this case, use
# mercurial.config instead.
try:
    from mercurial import config
    ConfigError = error.ConfigError

    def readconfig(path):
        cfg = config.config()
        try:
            cfg.read(path)
            return cfg
        except IOError:
            return None

except (ImportError, AttributeError):
    import ConfigParser
    ConfigError = ConfigParser.Error    

    def readconfig(path):
        cfg = ConfigParser.RawConfigParser()
        if not cfg.read([path]):
            return None
        return cfg

class SnapshotError(ConfigError):
    pass

def cmd_options(ui, cmd, remove=None, table=commands.table):
    aliases, spec = findcmd(ui, cmd, table)
    res = list(spec[1])
    if remove is not None:
        res = [opt for opt in res
               if opt[0] not in remove and opt[1] not in remove]
    return res

def walkhgenabled(ui, walkhg):
    if not walkhg:
        walkhg = ui.config('forest', 'walkhg', 'true')
    try:
        res = { '0' : False, 'false' : False, 'no' : False,
                '1' : True, 'true' : True, 'yes' : True }[walkhg.lower()]
    except KeyError:
        raise util.Abort(_("invalid value for 'walkhg': %s" % walkhg))
    return res

def partialenabled(ui, partial):
    if partial:
        return partial
    else:
        partial = ui.config('forest', 'partial', 'false')
    try:
        res = { '0' : False, 'false' : False, 'no' : False,
                '1' : True, 'true' : True, 'yes' : True }[partial.lower()]
    except KeyError:
        raise util.Abort(_("invalid value for 'partial': %s" % partial))
    return res

def _localrepo_forests(self, walkhg):
    """Shim this function into mercurial.localrepo.localrepository so
    that it gives you the list of subforests.

    Return a list of roots in filesystem representation relative to
    the self repository.  This list is lexigraphically sorted.
    """

    def errhandler(err):
        if err.filename == self.root:
            raise err

    def normpath(path):
        if path:
            return util.normpath(path)
        else:
            return '.'

    res = {}
    paths = [self.root]
    while paths:
        path = paths.pop()
        if os.path.realpath(path) in res:
            continue
        for root, dirs, files in os.walk(path, onerror=errhandler):
            hgdirs = dirs[:]  # Shallow-copy to protect d from dirs.remove() 
            for d in hgdirs:
                if d == '.hg':
                    res[os.path.realpath(root)] = root
                    if not walkhg:
                        dirs.remove(d)
                else:
                    p = os.path.join(root, d)
                    if os.path.islink(p) and os.path.abspath(p) not in res:
                        paths.append(p)
    res = res.values()
    res.sort()
    # Turn things into relative paths
    pfx = len(self.root) + 1
    return [normpath(r[pfx:]) for r in res]

localrepo.localrepository.forests = _localrepo_forests

def repocall(repo, *args, **kwargs):
    if hasattr(repo, '_call'):
        # hg >= 1.7
        callfn = repo._call
    else:
        callfn = repo.do_read
    return callfn(*args, **kwargs)

def _sshrepo_forests(self, walkhg):
    """Shim this function into mercurial.sshrepo.sshrepository so
    that it gives you the list of subforests.

    Return a list of roots as ssh:// URLs.
    """

    if 'forests' not in self.capabilities:
        raise util.Abort(_("Remote forests cannot be cloned because the "
                           "other repository doesn't support the forest "
                           "extension."))
    data = repocall(self, "forests", walkhg=("", "True")[walkhg])
    return data.splitlines()

sshrepo.sshrepository.forests = _sshrepo_forests


def _sshserver_do_hello(self):
    '''the hello command returns a set of lines describing various
    interesting things about the server, in an RFC822-like format.
    Currently the only one defined is "capabilities", which
    consists of a line in the form:
    
    capabilities: space separated list of tokens
    '''

    caps = ['unbundle', 'lookup', 'changegroupsubset', 'forests']
    if self.ui.configbool('server', 'uncompressed'):
        if hasattr(self.repo, "revlogversion"):
            version = self.repo.revlogversion
        else:
            version = self.repo.changelog.version
        caps.append('stream=%d' % version)
    self.respond("capabilities: %s\n" % (' '.join(caps),))

sshserver.sshserver.do_hello = _sshserver_do_hello


def _sshserver_do_forests(self):
    """Shim this function into the sshserver so that it responds to
    the forests command.  It gives a list of roots relative to the
    self.repo repository, sorted lexigraphically.
    """
    
    key, walkhg = self.getarg()
    forests = self.repo.forests(bool(walkhg))
    self.respond("\n".join(forests))

sshserver.sshserver.do_forests = _sshserver_do_forests



def _httprepo_forests(self, walkhg):
    """Shim this function into mercurial.httprepo.httprepository so
    that it gives you the list of subforests.

    Return a list of roots as http:// URLs.
    """

    if 'forests' not in self.capabilities:
        raise util.Abort(_("Remote forests cannot be cloned because the "
                           "other repository doesn't support the forest "
                           "extension."))
    data = repocall(self, "forests", walkhg=("", "True")[walkhg])
    return data.splitlines()

httprepo.httprepository.forests = _httprepo_forests


def _httpserver_do_capabilities(self, req):
    caps = ['lookup', 'changegroupsubset', 'forests']
    if self.configbool('server', 'uncompressed'):
        if hasattr(self.repo, "revlogversion"):
            version = self.repo.revlogversion
        else:
            version = self.repo.changelog.version
        caps.append('stream=%d' % version)
    # XXX: make configurable and/or share code with do_unbundle:
    unbundleversions = ['HG10GZ', 'HG10BZ', 'HG10UN']
    if unbundleversions:
        caps.append('unbundle=%s' % ','.join(unbundleversions))
    resp = ' '.join(caps)
    req.httphdr("application/mercurial-0.1", length=len(resp))
    req.write(resp)

hgweb.protocol.do_capabilities = _httpserver_do_capabilities


def _httpserver_do_forests(self, req):
    """Shim this function into the httpserver so that it responds to
    the forests command.  It gives a list of roots relative to the
    self.repo repository, sorted lexigraphically.
    """

    resp = ""
    if req.form.has_key('walkhg'):
        forests = self.repo.forests(bool(req.form['walkhg'][0]))
        resp = "\n".join(forests)
    req.httphdr("application/mercurial-0.1", length=len(resp))
    req.write(resp)


hgweb.protocol.do_forests = _httpserver_do_forests


def _statichttprepo_forests(self, walkhg):
    """Shim this function into
    mercurial.statichttprepo.statichttprepository so that it gives you
    the list of subforests.

    It depends on the fact that most directory indices have directory
    names followed by a slash.  There is no reliable way of telling
    whether a link leads into a subdirectory.

    Return a list of roots in filesystem representation relative to
    the self repository.  This list is lexigraphically sorted.
    """

    import HTMLParser
    import string
    import urllib
    import urllib2
    import urlparse

    class HtmlIndexParser(HTMLParser.HTMLParser):
        def __init__(self, ui, paths, walkhg):
            self._paths = paths
            self._ui = ui
            self._walkhg = walkhg
            self.current = None
        def handle_starttag(self, tag, attrs):
            if string.lower(tag) == "a":
                for attr in attrs:
                    if (string.lower(attr[0]) == "href" and
                        attr[1].endswith('/')):
                        link = urlparse.urlsplit(attr[1])
                        if (not self._walkhg and
                            link[2].rstrip('/').split('/')[-1] == '.hg'):
                            break
                        if not link[0] and not link[2].startswith('/'):
                            self._ui.debug(_("matched on '%s'") % attr[1])
                            self._paths.append(urlparse.urljoin(self.current,
                                                                attr[1]))

    if self._url.endswith('/'):
        url = self._url
    else:
        url = self._url + '/'

    res = []
    paths = [url]
    seen = {}

    parser = HtmlIndexParser(self.ui, paths, walkhg)
    while paths:
        path = paths.pop()
        if not seen.has_key(path):
            seen[path] = True
            parser.current = path
            index = None
            try:
                self.ui.debug(_("retrieving '%s'\n") % path)
                index = urllib2.urlopen(path)
                parser.reset()
                parser.feed(index.read())
                parser.close()
                hg_path = urlparse.urljoin(path, '.hg')
                self.ui.debug(_("retrieving '%s'\n") % hg_path)
                hg = urllib2.urlopen(hg_path)
                res.append(path)
            except urllib2.HTTPError, inst:
                pass
                #raise IOError(None, inst)
            except urllib2.URLError, inst:
                pass
                #raise IOError(None, inst.reason[1])

    res.sort()
    # Turn things into relative paths
    return [root[len(url):].rstrip('/') or "." for root in res]

statichttprepo.statichttprepository.forests = _statichttprepo_forests


def die_on_numeric_revs(revs):
    """Check to ensure that the revs passed in are not numeric.

    Numeric revisions make no sense when searching a forest.  You want
    only named branches and tags.  The only special exception is
    revision -1, which occurs before the first checkin.
    """
    if revs is None:
        return
    if not hasattr(revs, '__iter__'):
        revs = [revs]
    for strrev in revs:
        try:
            intrev = int(strrev)
        except:
            continue                    # String-based revision
        if intrev == 0 and strrev.startswith("00"):
            continue                    # Revision -1
        raise util.Abort(_("numeric revision '%s'") % strrev)


def relpath(root, pathname):
    """Returns the relative path of a local pathname from a local root."""
    root = os.path.abspath(root)
    pathname = os.path.abspath(pathname)
    if root == pathname or pathname.startswith(root + os.sep):
        pathname = os.path.normpath(pathname[len(root)+1:])
    return pathname


def urltopath(url):
    if url and hg.islocal(url):
        if url.startswith("file://"):
            url = url[7:]
        elif url.startswith("file:"):
            url = url[5:]
    return url


class Forest(object):
    """Describes the state of the forest within the current repository.

    This data structure describes the Forest contained within the
    current repository.  It contains a list of Trees that describe
    each sub-repository.
    """    

    class Tree(object):
        """Describe a local sub-repository within a forest."""

        class Skip(Warning):
            """Exception that signals this tree should be skipped."""
            pass

        __slots__ = ('_repo', '_root', 'revs', 'paths')

        def __init__(self, repo=None, root=None, revs=[], paths={}):
            """Create a Tree object.

            repo may be any mercurial.localrepo object
            root is the absolute path of this repo object
            rev is the desired revision for this repository, None meaning the tip
            paths is a dictionary of path aliases to real paths
            """
            self._repo = repo
            self.revs = revs
            if repo:
                self.paths = {}
                self.setrepo(repo)
                self.paths.update(paths)
            else:
                self.setroot(root)
                self.paths = paths

        def die_on_mq(self, rootpath=None):
            """Raises a util.Abort exception if self has mq patches applied."""
            if self.mq_applied():
                rpath = self.root
                if rootpath:
                    if not isinstance(rootpath, str):
                        rootpath = rootpath.root
                    rpath = relpath(rootpath, rpath)
                raise util.Abort(_("'%s' has mq patches applied") % rpath)

        def mq_applied(self):
            rpath = urltopath(self.root)
            if not hg.islocal(rpath):
                raise util.Abort(_("'%s' is not a local repository") % rpath)
            rpath = util.localpath(rpath)
            rpath = os.path.join(rpath, ".hg")
            if not os.path.isdir(rpath):
                return False
            for entry in os.listdir(rpath):
                path = os.path.join(rpath, entry)
                if (os.path.isdir(path) and
                    os.path.isfile(os.path.join(path, 'series'))):
                    try:
                        s = os.stat(os.path.join(path, "status"))
                        if s.st_size > 0:
                            return path
                    except OSError, err:
                        if err.errno != errno.ENOENT:
                            raise
            return False

        def getpath(self, paths):
            assert(type(paths) != str)
            if paths is None:
                return None
            for path in paths:
                if not hg.islocal(path):
                    return path
                result = urltopath(path)
                if os.path.isdir(result):
                    return result
                result = urltopath(self.paths.get(path, None))
                if result is not None:
                    return result
            return None

        def getrepo(self, ui=False):
            if not self._repo and self._root:
                if ui is False:
                    raise AttributeError("getrepo() requires 'ui' parameter")
                self._repo = hg.repository(ui, self._root)
            return self._repo

        def setrepo(self, repo):
            self._root = None
            self._repo = repo
            if repo.ui:
                self.paths.update(dict(repo.ui.configitems('paths')))

        def getroot(self):
            if self._repo:
                return self._repo.root
            else:
                return self._root

        def setroot(self, root):
            self._repo = None
            self._root = root

        @staticmethod
        def skip(function):
            """Decorator that turns any exception into a Forest.Tree.Skip"""
            def skipme(*args, **keywords):
                try:
                    function(*args, **keywords)
                except Exception, err:
                    raise Forest.Tree.Skip(err)
            return skipme

        @staticmethod
        def warn(function):
            """Decorator that turns any exception into a Warning"""
            def warnme(*args, **keywords):
                try:
                    function(*args, **keywords)
                except Exception, err:
                    raise Warning(err)
            return warnme

        def working_revs(self):
            """Returns the revision of the working copy."""
            try:
                ctx = self.repo[None]
            except TypeError:
                ctx = self.repo.workingctx()
            parents = ctx.parents()
            return [node.hex(parents[0].node())]

        def __repr__(self):
            return ("<forest.Tree object "
                    "- repo: %s "
                    "- revs: %s "
                    "- root: %s "
                    "- paths: %s>") % (self.repo, self.revs,
                                       self.root, self.paths)

        repo = property(getrepo, setrepo, None, None)
        root = property(getroot, setroot, None, None)
        
    __slots__ = ('trees', 'snapfile')

    def __init__(self, error=None, top=None, snapfile=None, walkhg=True):
        """Create a Forest object.

        top is the mercurial.localrepo object at the top of the forest.
        snapfile is the filename of the snapshot file.
        walkhg controls if we descend into .hg directories.

        If you provide no snapfile, the top repo will be searched for
        sub-repositories.

        If you do provide a snapfile, then the snapfile will be read
        for sub-repositories and no searching of the filesystem will
        be done.  The top repository is queried for the root of all
        relative paths, but if it's missing, then the current
        directory will be assumed.
        """
        if error:
            raise AttributeError("__init__() takes only named arguments")
        self.trees = []
        self.snapfile = None
        if snapfile:
            self.snapfile = snapfile
            if top is None:
                toppath = ""
            else:
                toppath = top.root
            self.read(snapfile, toppath)
        elif top:
            self.trees.append(Forest.Tree(repo=top))
            if top.ui:
                top.ui.note(_("searching for repos in %s\n") % top.root)
            self.scan(walkhg)

    def collate_files(self, pats):
        """Returns a dictionary of absolute file paths, keyed Tree.

        This lets us iterate over repositories with only the files
        that belong to them.
        """
        result = {}
        files = [os.path.abspath(path) for path in list(pats)]
        if files:
            files.sort(reverse=True)
            trees = self.trees[:]
            trees.sort(reverse=True, key=(lambda tree: tree.root))
            for tree in trees:
                paths = []
                for path in files[:]:
                    if not os.path.exists(path):
                        raise util.Abort(_("%s not under root") % path)
                    if path.startswith(tree.root):
                        paths.append(path)
                        files.remove(path)
                if paths:
                    result[tree] = paths
        return result


    def apply(self, ui, function, paths, opts, prehooks=[]):
        """Apply function(repo, targetpath, opts) to the entire forest.

        path is a path provided on the command line.
        function is a function that should be called for every repository.
        opts is a list of options provided to the function
        prehooks is a list of hook(tree) that are run before function()

        Useful for the vast majority of commands that scan a local
        forest and perform some command on each sub-repository.
        
        Skips a sub-repository skipping it isn't actually a repository
        or if it has mq patches applied.

        In function(), targetpath will be /-separated.  You may have
        to util.localpath() it.
        """
        opts['force'] = None                # Acting on unrelated repos is BAD
        if paths:
            # Extract revisions from # syntax in path.
            paths[0], revs = parseurl(paths[0], opts['rev'])[0:2]
        elif 'rev' in opts:
            revs = opts['rev']
        else:
            revs = []
        die_on_numeric_revs(revs)
        for tree in self.trees:
            rpath = relpath(self.top().root, tree.root)
            ui.status("[%s]\n" % rpath)
            try:
                for hook in prehooks:
                    try:
                        hook(tree)
                    except Forest.Tree.Skip:
                        raise
                    except Warning, message:
                        ui.warn(_("warning: %s\n") % message)
            except Forest.Tree.Skip, message:
                ui.warn(_("skipped: %s\n") % message)
                ui.status("\n")
                continue
            except util.Abort:
                raise
            if revs:
                opts['rev'] = revs
            else:
                opts['rev'] = tree.revs
            targetpath = paths or None
            if paths:
                targetpath = tree.getpath(paths)
                if targetpath:
                    if targetpath == paths[0] and rpath != os.curdir:
                        targetpath = '/'.join((targetpath, util.pconvert(rpath)))
            function(tree, targetpath, opts)
            ui.status("\n")

    def read(self, snapfile, toppath="."):
        """Loads the information in snapfile into this forest.

        snapfile is the filename of a snapshot file
        toppath is the path of the top of this forest
        """
        if not toppath:
            toppath = "."
        cfg = readconfig(snapfile)
        if not cfg:
            raise util.Abort("%s: %s" % (snapfile, os.strerror(errno.ENOENT)))
        seen_root = False
        sections = {}
        for section in cfg.sections():
            if section.endswith('.paths'):
                # Compatibility with old Forest snapshot files
                paths = dict(cfg.items(section))
                section = section[:-6]
                if section in sections:
                    sections[section].paths.update(paths)
                else:
                    sections[section] = Forest.Tree(paths=paths)
            else:
                root = cfg.get(section, 'root')
                if root == '.':
                    seen_root = True
                    root = toppath
                else:
                    root = os.path.join(toppath, util.localpath(root))
                root = os.path.normpath(root)
                rev = cfg.get(section, 'revision')
                if not rev:
                    rev = []
                paths = dict([(k[5:], v)
                              for k, v in cfg.items(section)
                              if k.startswith('path')])
                if section in sections:
                    sections[section].root = root
                    sections[section].revs = [rev]
                    sections[section].paths.update(paths)
                else:
                    sections[section] = Forest.Tree(root=root,
                                                    revs=[rev],
                                                    paths=paths)
        if not seen_root:
            raise SnapshotError("Could not find 'root = .' in '%s'" %
                                snapfile)
        self.trees = sections.values()
        self.trees.sort(key=(lambda tree: tree.root))

    def scan(self, walkhg):
        """Scans for sub-repositories within this forest.

        This method modifies this forest in-place.  It searches within the
        forest's directories and enumerates all the repositories it finds.
        """
        trees = []
        top = self.top()
        ui = top.repo.ui
        for relpath in top.repo.forests(walkhg):
            if relpath != '.':
                abspath = os.path.join(top.root, util.localpath(relpath))
                trees.append(Forest.Tree(hg.repository(ui, abspath)))
        trees.sort(key=(lambda tree: tree.root))
        trees.insert(0, Forest.Tree(hg.repository(ui, top.root)))
        self.trees = trees

    def top(self):
        """Returns the top Forest.Tree in this forest."""
        if len(self.trees):
            return self.trees[0]
        else:
            return None

    def update(self, ui=None):
        """Gets the most recent information about repos."""
        try:
            if not ui:
                ui = self.top().repo.ui
        except:
            pass
        for tree in self.trees:
            try:
                repo = hg.repository(ui, tree.root)
            except RepoError:
                repo = None
            tree.repo = repo

    def write(self, fd, oldstyle=False):
        """Writes a snapshot file to a file descriptor."""
        counter = 1
        for tree in self.trees:
            fd.write("[tree%s]\n" % counter)
            root = relpath(self.top().root, tree.root)
            if root == os.curdir:
                root = '.'
            root = util.normpath(root)
            fd.write("root = %s\n" % root)
            if tree.revs:
                fd.write("revision = %s\n" % tree.revs[0])
            else:
                fd.write("revision = None\n")
            if not oldstyle:
                for name, path in tree.paths.items():
                    fd.write("path.%s = %s\n" % (name, path))
            else:
                fd.write("\n[tree%s.paths]\n" % counter)
                for name, path in tree.paths.items():
                    fd.write("%s = %s\n" % (name, path))
            fd.write("\n")
            counter += 1


    def __repr__(self):
        return ("<forest.Forest object - trees: %s> ") % self.trees


def qclone(ui, source, sroot, dest, rpath, opts):
    """Helper function to clone from a remote repository.

    source is the URL of the source of this repository
    dest is the directory of the destination
    rpath is the relative path of the destination
    opts are a list of options to be passed into the clone
    """
    ui.status("[%s]\n" % rpath)
    assert(dest is not None)
    destpfx = os.path.normpath(os.path.dirname(dest))
    if not os.path.exists(destpfx):
        os.makedirs(destpfx)
    repo = hg.repository(ui, source)
    mqdir = None
    assert(source is not None)
    if hg.islocal(source):
        Forest.Tree(repo=repo).die_on_mq(sroot)
    url = urltopath(repo.url())
    ui.note(_("cloning %s to %s\n") % (url, dest))
    commands.clone(ui, url, dest, **opts)
    repo = None


def clone(ui, source, dest=None, **opts):
    """make a clone of an existing forest of repositories

    Create a clone of an existing forest in a new directory.

    Look at the help text for the clone command for more information.
    """
    die_on_numeric_revs(opts['rev'])
    source = ui.expandpath(source) or source
    islocalsrc = hg.islocal(source)
    if islocalsrc:
        source = os.path.abspath(urltopath(source))
    if dest:
        if hg.islocal(dest):
            dest = os.path.normpath(dest)
        else:
            pass
    else:
        dest = hg.defaultdest(source)
    toprepo = hg.repository(ui, source)
    forests = toprepo.forests(walkhgenabled(ui, opts['walkhg']))
    for rpath in forests:
        if rpath == '.':
            rpath = ''
        if islocalsrc:
            srcpath = source
            srcpath = os.path.join(source, util.localpath(rpath))
        else:
            srcpath = '/'.join((source, rpath))
        if rpath:
            destpath = os.path.join(dest, util.localpath(rpath))
        else:
            destpath = dest
        try:
            qclone(ui=ui,
                   source=srcpath, sroot=source,
                   dest=destpath, rpath=os.path.normpath(rpath),
                   opts=opts)
        except util.Abort, err:
            ui.warn(_("skipped: %s\n") % err)
        ui.status("\n")


def fetch(ui, top, source="default", **opts):
    """pull changes from a remote forest, merge new changes if needed.

    This finds all changes from the forest at the specified path or
    URL and adds them to the local forest.

    Look at the help text for the fetch command for more information.
    """

    snapfile = opts['snapfile']
    forest = Forest(top=top, snapfile=snapfile,
                    walkhg=walkhgenabled(ui, opts['walkhg']))
    source = [source]
    try:
        import hgext.fetch as fetch
    except ImportError:
        raise util.Abort(_("could not import fetch module\n"))

    def function(tree, srcpath, opts):
        if not srcpath:
            srcpath = forest.top().getpath(source)
            if srcpath:
                rpath = util.pconvert(relpath(forest.top().root, tree.root))
                srcpath = '/'.join((srcpath, rpath))
            else:
                ui.warn(_("skipped: %s\n") %
                        _("repository %s not found") % source[0])
                return
        try:
            fetch.fetch(ui, tree.getrepo(ui), srcpath, **opts)
        except Exception, err:
            ui.warn(_("skipped: %s\n") % err)
            try:
                tree.repo.transaction().__del__()
            except AttributeError:
                pass

    @Forest.Tree.skip
    def check_mq(tree):
        tree.die_on_mq(top.root)

    forest.apply(ui, function, source, opts,
                 prehooks=[lambda tree: check_mq(tree)])


def incoming(ui, top, source="default", **opts):
    """show new changesets found in source forest

    Show new changesets found in the specified path/URL or the default
    pull location for each repository in the source forest.

    Look at the help text for the incoming command for more information.
    """
    die_on_numeric_revs(opts['rev'])
    forest = Forest(top=top, snapfile=opts['snapfile'],
                    walkhg=walkhgenabled(ui, opts['walkhg']))
    source = [source]
    opts["bundle"] = ""

    def function(tree, srcpath, opts):
        if not srcpath:
            srcpath = forest.top().getpath(source)
            if srcpath:
                rpath = util.pconvert(relpath(forest.top().root, tree.root))
                srcpath = '/'.join((srcpath, rpath))
            else:
                ui.warn(_("skipped: %s\n") %
                        _("repository %s not found") % source[0])
                return
        try:
            commands.incoming(ui, tree.repo, srcpath, **opts)
        except Exception, err:
            ui.warn(_("skipped: %s\n") % err)

    @Forest.Tree.warn
    def check_mq(tree):
        tree.die_on_mq(top.root)

    forest.apply(ui, function, source, opts,
                 prehooks=[lambda tree: check_mq(tree)])


def outgoing(ui, top, dest=None, **opts):
    """show changesets not found in destination forest

    Show changesets not found in the specified destination forest or
    the default push location.

    Look at the help text for the outgoing command for more information.
    """
    die_on_numeric_revs(opts['rev'])
    forest = Forest(top=top, snapfile=opts['snapfile'],
                    walkhg=walkhgenabled(ui, opts['walkhg']))
    if dest == None:
        dest = ["default-push", "default"]
    else:
        dest = [dest]

    def function(tree, destpath, opts):
        if not destpath:
            destpath = forest.top().getpath(dest)
            if destpath:
                rpath = util.pconvert(relpath(forest.top().root, tree.root))
                destpath = '/'.join((destpath, rpath))
            else:
                ui.warn(_("skipped: %s\n") %
                        _("repository %s not found") % dest[0])
                return
        try:
            commands.outgoing(ui, tree.repo, destpath, **opts)
        except Exception, err:
            ui.warn(_("skipped: %s\n") % err)

    @Forest.Tree.warn
    def check_mq(tree):
        tree.die_on_mq(top.root)

    forest.apply(ui, function, dest, opts,
                 prehooks=[lambda tree: check_mq(tree)])


def pull(ui, top, source="default", pathalias=None, **opts):
    """pull changes from the specified forest

    Pull changes from a remote forest to a local one.

    You may specify a snapshot file, which is generated by the fsnap
    command.  For each tree in this file, pull the specified revision
    from the specified source path.

    By default, pull new remote repositories that it discovers.  If
    you use the -p option, pull only the repositories available locally.

    Look at the help text for the pull command for more information.
    """

    die_on_numeric_revs(opts['rev'])
    if pathalias:
        # Compatibility with old 'hg fpull SNAPFILE PATH-ALIAS' syntax
        snapfile = source
        source = pathalias
    else:
        snapfile = opts['snapfile']
    source = [source]
    walkhg = walkhgenabled(ui, opts['walkhg'])
    forest = Forest(top=top, snapfile=snapfile, walkhg=walkhg)
    toproot = forest.top().root
    if not snapfile:
        # Look for new remote paths from source
        srcpath = forest.top().getpath(source) or ""
        srcrepo = hg.repository(ui, srcpath)
        srcforests = None
        try:
            srcforests = srcrepo.forests(walkhg)
        except util.Abort, err:
            ui.note(_("skipped new forests: %s\n") % err)
        if srcforests:
            ui.note(_("looking for new forests\n"))
            newrepos = [util.localpath(root) for root in srcforests]
            for tree in forest.trees:
                try:
                    newrepos.remove(relpath(toproot, tree.root))
                except Exception, err:
                    pass
            ui.note(_("found new forests: %s\n") % newrepos)
            forest.trees.extend([Forest.Tree(root=os.path.join(toproot, new))
                                 for new in newrepos])
            forest.trees.sort(key=(lambda tree: tree.root))
    opts['pull'] = True
    opts['uncompressed'] = None
    opts['noupdate'] = not opts['update']
    partial = partialenabled(ui, opts['partial'])

    def function(tree, srcpath, opts):
        if snapfile:
            opts['rev'] = tree.revs
        else:
            destpath = relpath(os.path.abspath(os.curdir), tree.root)
            rpath = util.pconvert(relpath(toproot, tree.root))
            if not srcpath:
                srcpath = forest.top().getpath(source)
                if srcpath:
                    srcpath = '/'.join((srcpath, rpath))
                else:
                    ui.warn(_("warning: %s\n") %
                            _("repository %s not found") % source[0])
                    return
            try:
                tree.getrepo(ui)
            except RepoError:
                if partial:
                    ui.warn(_("skipped: new remote repository\n"))
                else:
                    # Need to clone
                    quiet = ui.quiet
                    try:
                        ui.quiet = True # Hack to shut up qclone's ui.status()
                        qclone(ui=ui,
                               source=srcpath, sroot=source,
                               dest=destpath, rpath=rpath,
                               opts=opts)
                    except util.Abort, err:
                        ui.warn(_("skipped: %s\n") % err)
                    ui.quiet = quiet
                return
        try:
            commands.pull(ui, tree.getrepo(ui), srcpath, **opts)
        except Exception, err:
            ui.warn(_("skipped: %s\n") % err)
            if tree._repo:
                tree.repo.transaction().__del__()

    @Forest.Tree.skip
    def check_mq(tree):
        tree.die_on_mq(top.root)

    forest.apply(ui, function, source, opts,
                 prehooks=[lambda tree: check_mq(tree)])

def push(ui, top, dest=None, pathalias=None, **opts):
    """push changes to the specified forest.

    Push changes from the local forest to the given destination.

    You may specify a snapshot file, which is generated by the fsnap
    command.  For each tree in this file, push the specified revision
    to the specified destination path.

    Look at the help text for the push command for more information.
    """

    if pathalias:
        # Compatibility with old 'hg fpush SNAPFILE PATH-ALIAS' syntax
        snapfile = dest
        dest = [pathalias]
        opts['rev'] = ['tip']           # Force a push from tip
    else:
        snapfile = opts['snapfile']
        if dest:
            dest = [dest]
        else:
            dest = ["default-push", "default"]
    forest = Forest(top=top, snapfile=snapfile,
                    walkhg=walkhgenabled(ui, opts['walkhg']))

    def function(tree, destpath, opts):
        try:
            commands.push(ui, tree.getrepo(ui), destpath, **opts)
        except Exception, err:
            ui.warn(_("skipped: %s\n") % err)
            try:
                tree.repo.transaction().__del__()
            except AttributeError:
                pass

    @Forest.Tree.skip
    def check_mq(tree):
        tree.die_on_mq(top.root)

    forest.apply(ui, function, dest, opts,
                 prehooks=[lambda tree: check_mq(tree)])


def seed(ui, snapshot=None, source='default', **opts):
    """populate a forest according to a snapshot file.

    Populate an empty local forest according to a snapshot file.

    Given a snapshot file, clone any non-existant directory from the
    provided path-alias.  This defaults to cloning from the 'default'
    path.

    Unless the --tip option is set, this command will clone the
    revision specified in the snapshot file.

    Look at the help text for the clone command for more information.
    """

    snapfile = snapshot or opts['snapfile']
    if not snapfile:
        raise ParseError("fseed", _("invalid arguments"))
    forest = Forest(snapfile=snapfile)
    tip = opts['tip']
    dest = opts['root']
    if not dest:
        dest = os.curdir
        forest.trees.remove(forest.top())
    dest = os.path.normpath(dest)
    for tree in forest.trees:
        srcpath = tree.getpath([source])
        if not srcpath:
            ui.status("[%s]\n" % util.pconvert(tree.root))
            ui.warn(_("skipped: path alias %s not defined\n") % source)
            ui.status("\n")
            continue
        srcpath = urltopath(srcpath)
        if tree.root == ".":
            destpath = dest
        else:
            destpath = os.path.join(dest, tree.root)
        opts['rev'] = tree.revs
        try:
            qclone(ui=ui,
                   source=srcpath, sroot=None,
                   dest=destpath, rpath=util.pconvert(tree.root),
                   opts=opts)
        except util.Abort, err:
            ui.warn(_("skipped: %s\n") % err)
        ui.status("\n")


def snap(ui, top, snapshot=None, **opts):
    """take a snapshot of the forest and show it

    Shows the current state of the forest.

    You can use the output of this command as with the --snapfile
    option of other forest commands.

    When you provide a snapshot file, only the trees mentioned in that
    file will be shown.
    """

    snapfile = snapshot or opts['snapfile']
    tip = opts['tip']
    forest = Forest(top=top, snapfile=snapfile,
                    walkhg=walkhgenabled(ui, opts['walkhg']))
    if snapfile:
        forest.update(ui)
    for tree in forest.trees:
        tree.die_on_mq(top.root)
        if not tip:
            tree.revs = tree.working_revs()
    forest.write(ui, opts['compatible'])


def status(ui, top, *pats, **opts):
    """show changed files in the working forest

    Show status of files in this forest's repositories.

    Look at the help text for the status command for more information.
    """
    forest = Forest(top=top, walkhg=walkhgenabled(ui, opts['walkhg']))
    die_on_numeric_revs(opts['rev'])
    # Figure out which paths are relative to which roots
    files = forest.collate_files(pats)
    if files:
        # Trim which trees we're going to look at
        forest.trees = files.keys()

    class munge_ui(object):
        """This wrapper class allows us to munge the mercurial.ui.write() """
        def __init__(self, transform, ui):
            self._transform = transform
            self._ui = ui
        def write(self, *args, **opts):
            args = [self._transform(a) for a in args]
            self._ui.write(*args, **opts)
        def __getattr__(self, attrname):
            return getattr(self._ui, attrname)

    def function(tree, path, opts):
        path = util.localpath(path)
        if files:
            pats = files[tree]
        else:
            pats = ()
            if path == top.root:
                path = ''
            else:
                path = relpath(top.root, path)
            def prefix(output):
                """This function shims the root in before the filename."""
                if opts['no_status']:
                    return os.path.join(path, output)
                else:
                    prefix, filename = output.split(' ', 1)
                    return ' '.join((prefix, os.path.join(path, filename)))
            localui = munge_ui(prefix, ui)
        try:
            commands.status(localui, tree.repo, *pats, **opts)
        except RepoError, err:
            ui.warn(_("skipped: %s\n") % err)

    @Forest.Tree.warn
    def check_mq(tree):
        tree.die_on_mq(top.root)

    forest.apply(ui, function, [top.root], opts,
                 prehooks=[lambda tree: check_mq(tree)])


def tag(ui, top, name, revision=None, **opts):
    """add a tag for the current or given revision in the working forest

    Name a particular revision using <name>.

    Tags are used to name particular revisions of the repository and are
    very useful to compare different revision, to go back to significant
    earlier versions or to mark branch points as releases, etc.

    If no revision is given, the parent of the working directory is used,
    or tip if no revision is checked out.

    To facilitate version control, distribution, and merging of tags,
    they are stored as a file named ".hgtags" which is managed
    similarly to other project files and can be hand-edited if
    necessary.  The file '.hg/localtags' is used for local tags (not
    shared among repositories).
    """
    if revision is not None:
        ui.warn(_("use of 'hg ftag NAME [REV]' is deprecated, "
                  "please use 'hg ftag [-r REV] NAME' instead\n"))
        if opts['rev']:
            raise util.Abort(_("use only one form to specify the revision"))
        opts['rev'] = revision
    forest = Forest(top=top, snapfile=None,
                    walkhg=walkhgenabled(ui, opts['walkhg']))

    def function(tree, ignore, opts):
        try:
            commands.tag(ui, tree.getrepo(ui), name, rev_=None, **opts)
        except Exception, err:
            ui.warn(_("skipped: %s\n") % err)
            tree.repo.transaction().__del__()

    @Forest.Tree.skip
    def check_mq(tree):
        tree.die_on_mq(top.root)

    forest.apply(ui, function, None, opts,
                 prehooks=[lambda tree: check_mq(tree)])


def trees(ui, top, **opts):
    """show the roots of the repositories

    Show the roots of the trees in the forest.

    By default, show the absolute path of each repository.  With
    --convert, show the portable Mercurial path.
    """

    forest = Forest(top=top,
                    walkhg=walkhgenabled(ui, opts['walkhg']))
    convert = opts['convert']
    for tree in forest.trees:
        if convert:
            ui.write("%s\n" % relpath(top.root, tree.root))
        else:
            ui.write("%s\n" % util.localpath(tree.root))


def update(ui, top, revision=None, **opts):
    """update working forest

    Update the working forest to the specified revision, or the
    tip of the current branch if none is specified.

    You may specify a snapshot file, which is generated by the fsnap
    command.  For each tree in this file, update to the revision
    recorded for that tree.

    Look at the help text for the update command for more information.
    """

    snapfile = None
    if revision:
        try:
            if readconfig(revision):
                # Compatibility with old 'hg fupdate SNAPFILE' syntax
                snapfile = revision
        except ConfigError, err:
            ui.warn(_("warning: %s\n") % err)
    if snapfile is None:
        snapfile = opts['snapfile']
        opts['rev'] = revision
    forest = Forest(top=top, snapfile=snapfile,
                    walkhg=walkhgenabled(ui, opts['walkhg']))

    def function(tree, ignore, opts):
        if 'rev' in opts:
            rev = opts['rev'] or None
        else:
            rev = None
        if hasattr(rev, '__iter__'):
            rev = rev[-1]
        try:
            if rev is not None:
                commands.update(ui, tree.getrepo(ui),
                                rev=rev, clean=opts['clean'], date=opts['date'])
            else:
                commands.update(ui, tree.getrepo(ui),
                                clean=opts['clean'], date=opts['date'])
        except Exception, err:
            ui.warn(_("skipped: %s\n") % err)
            tree.repo.transaction().__del__()

    @Forest.Tree.skip
    def check_mq(tree):
        tree.die_on_mq(top.root)

    forest.apply(ui, function, None, opts,
                 prehooks=[lambda tree: check_mq(tree)])


cmdtable = {}

def uisetup(ui):
    global cmdtable
    walkhgopts = ('', 'walkhg', '',
                  _("walk repositories under '.hg' (yes/no)"))
    snapfileopts = ('', 'snapfile', '',
                    _("snapshot file generated by fsnap"))
    cmdtable = {
        "^fclone" :
            (clone,
             [walkhgopts] + cmd_options(ui, 'clone'),
             _('hg fclone [OPTION]... SOURCE [DEST]')),
        "fincoming|fin" :
            (incoming,
             [walkhgopts, snapfileopts]
             + cmd_options(ui, 'incoming', remove=('f', 'bundle')),
             _('hg fincoming [OPTION]... [SOURCE]')),
        "foutgoing|fout" :
            (outgoing,
             [walkhgopts, snapfileopts]
             + cmd_options(ui, 'outgoing', remove=('f',)),
             _('hg foutgoing [OPTION]... [DEST]')),
        "^fpull" :
            (pull,
             [('p', 'partial', False,
               _("do not pull new remote repositories")),
              walkhgopts, snapfileopts] + cmd_options(ui, 'pull', remove=('f',)),
             _('hg fpull [OPTION]... [SOURCE]')),
        "^fpush" :
            (push,
             [walkhgopts, snapfileopts] + cmd_options(ui, 'push', remove=('f',)),
             _('hg fpush [OPTION]... [DEST]')),
        "fseed" :
            (seed,
             [('', 'root', '',
               _("create root as well as children under <root>")),
              snapfileopts,
              ('t', 'tip', False,
               _("use tip instead of revisions stored in the snapshot file"))]
             + cmd_options(ui, 'clone', remove=('r',)),
             _('hg fseed [OPTION]... SNAPSHOT-FILE [PATH-ALIAS]')),
        "fsnap" :
            (snap,
             [('', 'compatible', False,
               _("write snapshot file compatible with older forest versions")),
              snapfileopts,
              ('t', 'tip', False,
               _("record tip instead of actual child revisions")),
              walkhgopts],
             _('hg fsnap [OPTION]... [SNAPSHOT-FILE]')),
        "^fstatus|fst" :
            (status,
             [walkhgopts] + cmd_options(ui, 'status'),
             _('hg fstatus [OPTION]... [FILE]...')),
        "ftag":
            (tag,
             [walkhgopts] + cmd_options(ui, 'tag'),
             _('hg ftag [-l] [-m TEXT] [-d DATE] [-u USER] [-r REV] NAME')),
        "ftrees" :
            (trees,
             [('c', 'convert', False,
               _("convert paths to mercurial representation")),
              walkhgopts],
             _('hg ftrees [OPTIONS]')),
        "^fupdate|fup|fcheckout|fco" :
            (update,
             [snapfileopts,
              ('', 'tip', False,
               _("use tip instead of revisions stored in the snapshot file")),
              walkhgopts]
             + cmd_options(ui, 'update'),
             _('hg fupdate [OPTION]...'))
        }

    try:
        import hgext.fetch
    except ImportError:
        return
    try:
        cmdtable.update({"ffetch": (fetch,
                                    [walkhgopts, snapfileopts]
                                    + cmd_options(ui, 'fetch',
                                                  remove=('bundle',),
                                                  table=hgext.fetch.cmdtable),
                                    _('hg ffetch [OPTION]... [SOURCE]'))})
    except UnknownCommand:
        return

commands.norepo += " fclone fseed"
