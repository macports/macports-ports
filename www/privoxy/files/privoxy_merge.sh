#!/usr/bin/env sh
# privoxy_merge.sh: merge a deployed Privoxy file into its new upstream version.
# Upstream comments and layout win; deployed settings override upstream's.
usage() { cat <<EOF
usage: ${0##*/} --new UPSTREAM_FILE --in DEPLOYED_FILE --out MERGED_FILE

Merge a deployed Privoxy file into its new upstream version. Handles
key/value files (config) and action files (*.action).

  --new FILE  new upstream file: supplies comments and layout
  --in FILE   deployed file: its settings override upstream's
  --out FILE  merged result ('-' for stdout); must differ from both inputs

Settings match by first word (key/value) or by block header (action).
Upstream-only settings are kept. Deployed-only settings go after the last
commented example of the same key, else are appended at the end.
Comments in the deployed file are dropped. Inputs are never modified.
EOF
}
set -eu; umask 077
PATH=@PREFIX@/bin:@PREFIX@/sbin:/usr/bin:/bin:/usr/sbin:/sbin
up= dep= out= t=

# Split --opt=value into --opt value, then parse.
for a; do case $a in
    --*=*) set -- "$@" "${a%%=*}" "${a#*=}";;
    *) set -- "$@" "$a";;
esac; shift; done
while [ "$#" -gt 0 ]; do case $1 in
    --new) up=${2:?--new needs a value}; shift;;
    --in) dep=${2:?--in needs a value}; shift;;
    --out) out=${2:?--out needs a value}; shift;;
    -h|--help) usage; exit 0;;
    *) usage >&2; exit 2;;
esac; shift; done
[ -n "$up" ] && [ -n "$dep" ] && [ -n "$out" ] || { usage >&2; exit 2; }
[ -f "$up" ] && [ -f "$dep" ] ||
    { echo "inputs must be regular files" >&2; exit 1; }
if [ "$out" != - ] && { [ "$out" -ef "$up" ] || [ "$out" -ef "$dep" ]; }; then
    echo "--out must differ from --new and --in" >&2; exit 1
fi

# Entries are logical lines (\ continuations joined). Key: block header
# (normalized) for action files, else first word. Deployed entries sharing
# a key form a group that replaces the upstream entries with that key.
# A deployed-only key is anchored after its last commented example upstream.
merge() { UP=$up DEP=$dep awk '
    function norm(s) {
        gsub(/[[:space:]]+/, " ", s); gsub(/\{ /, "{", s); gsub(/ \}/, "}", s)
        sub(/^ /, "", s); sub(/ $/, "", s); return s
    }
    function word(s,  a) {
        sub(/^[[:space:]]+/, "", s); split(s, a, /[[:space:]]+/); return a[1]
    }
    # Key named by a commented example line, else "".
    function ckey(s) {
        if (!match(s, /^#[[:space:]]*[A-Za-z][A-Za-z0-9_-]*/)) return ""
        s = substr(s, RSTART, RLENGTH); sub(/^#[[:space:]]*/, "", s); return s
    }
    # Load file f into r (raw text) and k (key; "" for comments), prefix p.
    function load(f, p,   l, raw, j, cur) {
        while ((getline l < f) > 0) {
            raw = l; j = ++n[p]
            if (l ~ /^[[:space:]]*(#|$)/) { r[p, j] = raw "\n"; continue }
            while (l ~ /\\[[:space:]]*$/ && (getline nx < f) > 0) {
                sub(/[[:space:]]*\\[[:space:]]*$/, " ", l)
                l = l nx; raw = raw "\n" nx
            }
            if (l ~ /^[[:space:]]*\{/) cur = norm(l)
            r[p, j] = raw "\n"; k[p, j] = (cur != "") ? cur : word(l)
        }
        close(f)
    }
    BEGIN {
        load(ENVIRON["DEP"], 1); load(ENVIRON["UP"], 2)
        for (j = 1; j <= n[2]; j++)
            if ((2, j) in k) have[k[2, j]] = 1
            else if ((c = ckey(r[2, j])) != "") anc[c] = j
        for (j = 1; j <= n[1]; j++) if ((1, j) in k) {
            key = k[1, j]; g[key] = g[key] r[1, j]
            if ((key in have) || !(key in anc)) continue
            a = anc[key]    # step past a continued comment before inserting
            while (a < n[2] && r[2, a] ~ /\\[[:space:]]*\n$/) a++
            at[a] = at[a] r[1, j]; placed[j] = 1
        }
        for (j = 1; j <= n[2]; j++) {
            if (!((2, j) in k)) { printf "%s", r[2, j] at[j]; continue }
            key = k[2, j]    # read only after the test: reads create entries
            if (!(key in g)) { printf "%s", r[2, j]; continue }
            if (!(key in done)) { printf "%s", g[key]; done[key] = 1 }
        }
        # Remaining deployed-only entries, in deployed order.
        for (j = 1; j <= n[1]; j++)
          if (((1, j) in k) && !(k[1, j] in done) && !(j in placed)) {
            if (!h++) print "\n# --- deployed settings not in upstream ---"
            printf "%s", r[1, j]
        }
    }' </dev/null; }

trap 'rm -f "$t"' EXIT; trap 'exit 130' HUP INT TERM
if [ "$out" = - ]; then merge; exit; fi
t=$(mktemp "$out.XXXXXX")
cp -p "$dep" "$t"    # inherit deployed owner and mode
merge >"$t"
[ -s "$t" ] || { echo "empty result; aborted" >&2; exit 1; }
mv -f "$t" "$out"; t=
