# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; tab-width: 4; indent-tabs-mode: nil -*-
#
# Read Git provenance from a local git-archive tarball. GitHub's "archive" and
# "tarball" downloads are supported; uploaded release assets need not contain
# this metadata. No network requests or phase hooks are added by this group.
#
# Usage (call inside a phase, after the archive has been fetched):
#   PortGroup git_archive 1.0
#   pre-build {
#       build.env-append APP_BUILD_SHA=[git_archive::commit_id]
#   }
#   destroot {
#       set commit [git_archive::commit_id]
#       # Substitute the commit into the bundle metadata here.
#   }
#
# git_archive::commit_id ?archive?       returns the full commit hash
# git_archive::short_commit_id ?archive? returns its first seven characters
# git_archive::commit_ids ?archive?     returns a dict with full and short keys
#
# An explicit relative filename is resolved against distpath; absolute paths
# are accepted. Without a filename, prefer distname + extract.suffix among the
# distfiles, then a single extract.only entry, then a sole distfile. Distfile
# site tags are stripped. Ambiguous selections fail instead of using list order
# (which may include vendored Go modules, Cargo crates, or other source inputs).
#
# Supports gzip-compressed and uncompressed tar archives, detected by magic.
# Reads only the first 1024 uncompressed bytes, as required by Git's reader.
# Missing archives, unsupported compression and missing metadata are errors.
# Results are not cached, so independent phase invocations work identically.

# The helper can be called in post-extract, before build dependencies exist.
depends_extract-append port:git

namespace eval git_archive {}

proc git_archive::archive_path {{archive {}}} {
    global distpath distfiles distname extract.suffix extract.only

    if {$archive eq {}} {
        set sources {}
        foreach entry ${distfiles} {
            lappend sources [getdistname ${entry}]
        }
        set sources [lsort -unique ${sources}]
        set conventional ${distname}${extract.suffix}
        if {[lsearch -exact ${sources} ${conventional}] >= 0} {
            set archive ${conventional}
        } elseif {[llength ${extract.only}] == 1 &&
                  [lsearch -exact ${sources} [getdistname [lindex ${extract.only} 0]]] >= 0} {
            set archive [getdistname [lindex ${extract.only} 0]]
        } elseif {[llength ${sources}] == 1} {
            set archive [lindex ${sources} 0]
        } else {
            error "git_archive: cannot identify the main source archive among distfiles; pass an explicit archive path"
        }
    }
    if {[file pathtype ${archive}] ne "absolute"} {
        set archive [file join ${distpath} ${archive}]
    }
    return ${archive}
}

proc git_archive::commit_id {{archive {}}} {
    global prefix
    set archive [git_archive::archive_path ${archive}]
    if {![file isfile ${archive}] || ![file readable ${archive}]} {
        error "git_archive: source archive is missing or unreadable: ${archive}"
    }

    set channel [open ${archive} rb]
    try {
        set magic [read ${channel} 2]
        seek ${channel} 0
        if {$magic eq "\x1f\x8b"} {
            zlib push gunzip ${channel}
        } elseif {$magic in {BZ "\xfd7" PK "\x28\xb5" "\x04\x22"}} {
            error "unsupported archive compression; expected tar or tar.gz"
        }
        set header [read ${channel} 1024]
    } on error {message options} {
        return -options ${options} "git_archive: cannot read ${archive}: ${message}"
    } finally {
        close ${channel}
    }

    # Pass a bounded header through stdin instead of piping a decompressor:
    # Git closes its input early, which would give the producer SIGPIPE.
    if {[catch {exec ${prefix}/bin/git get-tar-commit-id << ${header}} commit]} {
        error "git_archive: cannot read Git commit metadata from ${archive}: ${commit}"
    }
    set commit [string trim ${commit}]
    if {![regexp {^(?:[0-9a-f]{40}|[0-9a-f]{64})$} ${commit}]} {
        error "git_archive: missing or invalid Git commit metadata in ${archive}"
    }
    return ${commit}
}

proc git_archive::short_commit_id {{archive {}}} {
    return [string range [git_archive::commit_id ${archive}] 0 6]
}

proc git_archive::commit_ids {{archive {}}} {
    set commit [git_archive::commit_id ${archive}]
    return [dict create full ${commit} short [string range ${commit} 0 6]]
}
