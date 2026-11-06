#!/usr/bin/env bun
/**
 * Generates an mdoc(7) manual page for proton-drive from the command registry,
 * so the man page stays in step with `proton-drive --help`.
 *
 * Usage: bun ./scripts/generate-man.ts [output-file]
 *        (writes to stdout when no output file is given)
 *
 * The page date comes from SOURCE_DATE_EPOCH when it is set (see
 * https://reproducible-builds.org/specs/source-date-epoch/), otherwise from
 * the newest entry in CHANGELOG.md, so the output is reproducible for a given
 * release. Packagers building from a release tarball should set
 * SOURCE_DATE_EPOCH: the changelog entry for a release is written after the
 * release is tagged, so the tagged CHANGELOG.md still names the previous one.
 */

import path from 'node:path';

import type { Command, Option } from '../src/cli/interface';
import { COMMANDS } from '../src/commands/registry';

const GLOBAL_OPTIONS = new Set(['help', 'json', 'verbose']);

const GROUP_DESCRIPTIONS: Record<string, string> = {
    auth: 'Sign in to and out of a Proton account.',
    filesystem: 'Browse and manage files and folders.',
    sharing: 'Share files and folders with other Proton users or by URL.',
    invitation: 'Respond to invitations to items shared with you.',
    album: 'Manage photo albums.',
    photo: 'Work with the photo timeline.',
    takeout: 'Export a copy of your Drive to a local folder.',
};

const ROOTS: [string, string][] = [
    ['my-files', 'Your own files and folders, shown as My files in the Proton Drive apps.'],
    ['devices', 'Computers backed up with the Proton Drive desktop apps.'],
    ['shared-by-me', 'Items you have shared.'],
    ['shared-with-me', 'Items other people have shared with you.'],
    ['trash', 'Items moved to the trash.'],
    ['albums', 'Photo albums.'],
    ['photos', 'The photo timeline.'],
    ['photos-shared-by-me', 'Photos you have shared.'],
    ['photos-shared-with-me', 'Photos other people have shared with you.'],
    ['photos-trash', 'Photos moved to the trash.'],
];

/** Escape text for use on an mdoc text line or as a macro argument. */
function esc(text: string): string {
    return text.replace(/\\/g, '\\e');
}

/** Emit prose: one sentence per line, as mdoc(7) expects, with line-start escaping. */
function prose(text: string): string[] {
    const lines: string[] = [];
    for (const paragraph of text.trim().split(/\n\s*\n/)) {
        const sentences = paragraph
            .replace(/\s+/g, ' ')
            .trim()
            .split(/(?<=[.!?])\s+(?=[A-Z(])/);
        if (lines.length) {
            lines.push('.Pp');
        }
        for (const sentence of sentences) {
            const line = esc(sentence);
            lines.push(/^[.']/.test(line) ? `\\&${line}` : line);
        }
    }
    return lines;
}

function metaName(longName: string): string {
    const segments = longName.split('-').filter(Boolean);
    return (segments[segments.length - 1] ?? longName).toUpperCase();
}

function optionFlag(longName: string, opt: Option): string {
    let flag = opt.short ? `Fl ${opt.short}` : `Fl -${longName}`;
    if (opt.type === 'string') {
        flag += ` Ar ${metaName(longName)}`;
        if (opt.multiple) {
            flag += ' ...';
        }
    }
    return flag;
}

function visibleOptions(command: Command): [string, Option][] {
    return Object.entries(command.options ?? {}).filter(([name]) => !GLOBAL_OPTIONS.has(name));
}

function synopsis(command: Command): string {
    const parts = [`Cm ${command.group} ${command.name}`];
    for (const [name, opt] of visibleOptions(command)) {
        const flag = optionFlag(name, opt);
        parts.push(opt.default !== undefined ? `Oo ${flag} Oc` : flag);
    }
    for (const arg of command.args ?? []) {
        parts.push(arg.endsWith('...') ? `Ar ${arg.slice(0, -3)} ...` : `Ar ${arg}`);
    }
    return parts.join(' ');
}

function optionEntry(longName: string, opt: Option): string[] {
    const lines: string[] = [];
    let head = opt.short ? `Fl ${opt.short} , Fl -${longName}` : `Fl -${longName}`;
    if (opt.type === 'string') {
        head += ` Ar ${metaName(longName)}`;
    }
    lines.push(`.It ${head}`);

    let text = opt.help?.trim() ?? '';
    if (opt.multiple) {
        text = `${text} May be repeated.`.trim();
    }
    if (opt.type !== 'boolean' && opt.default !== undefined && opt.default !== '' && !Array.isArray(opt.default)) {
        text = `${text} The default is ${opt.default}.`.trim();
    }
    if (text) {
        lines.push(...prose(text));
    }

    const values = opt.allowedValues;
    if (values?.length) {
        if (typeof values[0] === 'string') {
            lines.push(`.Ar ${metaName(longName)}`);
            lines.push('is one of');
            const list = values as string[];
            list.forEach((value, i) => {
                const sep = i === list.length - 1 ? ' .' : i === list.length - 2 ? ' or' : ' ,';
                lines.push(`.Cm ${esc(value)}${sep}`);
            });
        } else {
            lines.push(`.Ar ${metaName(longName)}`);
            lines.push('is one of:');
            lines.push('.Bl -tag -width Ds');
            for (const { value, help } of values as { value: string; help: string }[]) {
                lines.push(`.It Cm ${esc(value)}`);
                lines.push(...prose(help.endsWith('.') ? help : `${help}.`));
            }
            lines.push('.El');
        }
    }
    return lines;
}

async function manualDate(): Promise<string> {
    let date: Date;
    const epoch = process.env.SOURCE_DATE_EPOCH?.trim();
    if (epoch && /^\d+$/.test(epoch)) {
        date = new Date(Number(epoch) * 1000);
    } else {
        const changelog = await Bun.file(path.join(import.meta.dir, '../CHANGELOG.md')).text();
        const match = changelog.match(/^## cli\/v[\d.]+ \((\d{4})-(\d{2})-(\d{2})\)/m);
        if (!match) {
            throw new Error('Cannot find a release date in CHANGELOG.md; set SOURCE_DATE_EPOCH');
        }
        const [, y, m, d] = match;
        date = new Date(Date.UTC(+y!, +m! - 1, +d!));
    }
    const month = date.toLocaleString('en-GB', { month: 'long', timeZone: 'UTC' });
    return `${month} ${date.getUTCDate()}, ${date.getUTCFullYear()}`;
}

function commandsSection(commands: Command[]): string[] {
    const lines = ['.Sh COMMANDS'];
    const groups = [...new Set(commands.map((c) => c.group))];
    for (const group of groups) {
        lines.push(`.Ss ${group}`);
        if (GROUP_DESCRIPTIONS[group]) {
            lines.push(...prose(GROUP_DESCRIPTIONS[group]));
        }
        lines.push('.Bl -tag -width Ds');
        for (const command of commands.filter((c) => c.group === group)) {
            lines.push(`.It ${synopsis(command)}`);
            if (command.help) {
                lines.push(...prose(command.help));
            }
            const opts = visibleOptions(command);
            if (opts.length) {
                lines.push('.Bl -tag -width Ds');
                for (const [name, opt] of opts) {
                    lines.push(...optionEntry(name, opt));
                }
                lines.push('.El');
            }
        }
        lines.push('.El');
    }
    return lines;
}

const page: string[] = [
    `.Dd ${await manualDate()}`,
    '.Dt PROTON-DRIVE 1',
    '.Os',
    '.Sh NAME',
    '.Nm proton-drive',
    '.Nd command-line interface to Proton Drive',
    '.Sh SYNOPSIS',
    '.Nm',
    '.Nm',
    '.Ar group command',
    '.Op Fl hjv',
    '.Op Ar options',
    '.Op Ar argument ...',
    '.Nm',
    '.Cm version',
    '.Sh DESCRIPTION',
    '.Nm',
    'uploads, downloads, lists and manages files in Proton Drive, and handles sharing and invitations, with the same end-to-end encryption as the Proton Drive apps.',
    'It is intended for scripts, scheduled jobs and interactive use in a terminal; it does not keep folders synchronised in the background.',
    '.Pp',
    'Run with no arguments,',
    '.Nm',
    'starts an interactive shell that accepts the same commands; leave it with',
    '.Cm exit ,',
    '.Cm quit',
    'or end-of-file.',
    '.Pp',
    'A command is a group name followed by a command name, such as',
    '.Cm filesystem upload .',
    'Either may be shortened to any unique prefix, so',
    '.Cm fs up',
    'also works.',
    'Options must follow the command name.',
    '.Pp',
    'Sign in with',
    '.Cm auth login ,',
    'which completes the login in a web browser; no password is passed on the command line.',
    'The session is kept in the credentials store described under',
    '.Sx ENVIRONMENT .',
    '.Pp',
    'The following options are accepted by every command:',
    '.Bl -tag -width Ds',
    '.It Fl h , Fl -help',
    'Show the usage, options and arguments of the command.',
    '.It Fl j , Fl -json',
    'Write results as JSON, for processing by other programs.',
    '.It Fl v , Fl -verbose',
    'Write log messages to the console as well as to the log file.',
    'The level of detail is set by',
    '.Ev PROTON_DRIVE_LOG_LEVEL .',
    '.El',
    '.Pp',
    'The',
    '.Cm version',
    'command',
    '.Pq also Fl -version',
    'shows the versions of the command and of the Proton Drive SDK it uses.',
    ...commandsSection(COMMANDS),
    '.Sh REMOTE PATHS',
    'Paths in Proton Drive always use',
    '.Ql /',
    'as the separator, whatever the local operating system, and begin with one of these top-level folders:',
    '.Bl -tag -width Ds',
    ...ROOTS.flatMap(([root, text]) => [`.It Pa /${root}`, ...prose(text)]),
    '.El',
    '.Pp',
    'Paths use item names where these can be decrypted.',
    'Where a name cannot be decrypted, or several items share a name, the item\'s UID can be used in its place.',
    'Escape a',
    '.Ql /',
    'in a name with a backslash, as in',
    '.Pa /my-files/folder/foo\\e/bar .',
    '.Sh ENVIRONMENT',
    '.Bl -tag -width Ds',
    '.It Ev PROTON_DRIVE_CACHE_DIR',
    'If set, the cache, application data and logs are all kept in this one directory instead of the locations listed under',
    '.Sx FILES .',
    '.It Ev PROTON_DRIVE_CREDENTIALS_STORE',
    'Where the signed-in session is kept:',
    '.Cm keychain',
    '(the default) uses the operating system\'s secret store under the service name',
    '.Ql ch.proton.drive/drive-sdk-cli ;',
    '.Cm pass',
    'uses the entry',
    '.Ql ch.proton.drive/drive-sdk-cli/auth-session',
    'in',
    '.Xr pass 1 ;',
    '.Cm unsafe_file',
    'writes it unencrypted to',
    '.Pa auth-session.json',
    'in the application data directory, and is meant only for testing.',
    '.It Ev PROTON_DRIVE_LOG_LEVEL',
    'The lowest level of message written to the log:',
    '.Cm DEBUG',
    '(the default),',
    '.Cm INFO ,',
    '.Cm WARNING',
    'or',
    '.Cm ERROR .',
    '.El',
    '.Sh FILES',
    'On macOS:',
    '.Bl -tag -width Ds',
    '.It Pa ~/Library/Caches/proton-drive-cli/',
    'Encrypted caches of keys and Drive metadata.',
    '.It Pa ~/Library/Application Support/proton-drive-cli/',
    'Client identifier, configuration and event state.',
    '.It Pa ~/Library/Logs/proton-drive-cli/proton-drive.log',
    'The log file.',
    '.El',
    '.Pp',
    'On other Unix systems the same files are kept in',
    '.Pa $XDG_CACHE_HOME/proton-drive-cli ,',
    '.Pa $XDG_DATA_HOME/proton-drive-cli',
    'and',
    '.Pa $XDG_STATE_HOME/proton-drive-cli ,',
    'or under',
    '.Pa ~/.cache ,',
    '.Pa ~/.local/share',
    'and',
    '.Pa ~/.local/state',
    'when those variables are not set.',
    'To reset local state, stop',
    '.Nm',
    'and remove these directories.',
    '.Sh EXIT STATUS',
    '.Nm',
    'exits 0 on success and 1 if an error occurs.',
    'Leaving the interactive shell exits with status 2.',
    '.Sh EXAMPLES',
    'Sign in, then list the top level of your files:',
    '.Bd -literal -offset indent',
    '$ proton-drive auth login',
    '$ proton-drive filesystem list /my-files',
    '.Ed',
    '.Pp',
    'Upload a folder, merging with any existing folder of the same name and skipping files that are already there, so that an interrupted upload can be resumed by running the same command again:',
    '.Bd -literal -offset indent',
    '$ proton-drive filesystem upload -d merge -f skip \\e',
    '    ~/Documents /my-files/Backups',
    '.Ed',
    '.Pp',
    'Download a folder into the current directory:',
    '.Bd -literal -offset indent',
    '$ proton-drive filesystem download /my-files/Reports .',
    '.Ed',
    '.Pp',
    'Invite another Proton user to edit a shared folder:',
    '.Bd -literal -offset indent',
    '$ proton-drive sharing invite -u someone@example.com -r editor \\e',
    '    /my-files/Reports',
    '.Ed',
    '.Sh SEE ALSO',
    '.Xr pass 1',
    '.Pp',
    '.Lk https://proton.me/support/drive-cli "Using Proton Drive CLI"',
    '.Sh AUTHORS',
    '.An Proton AG',
];

/** Wrap text lines to 80 bytes; macro lines and literal displays are left alone. */
function wrapLines(lines: string[]): string[] {
    const out: string[] = [];
    let literal = false;
    for (const line of lines) {
        if (line.startsWith('.Bd') && line.includes('-literal')) {
            literal = true;
        } else if (line.startsWith('.Ed')) {
            literal = false;
        }
        if (literal || line.startsWith('.') || line.length <= 80) {
            out.push(line);
            continue;
        }
        let current = '';
        for (const word of line.split(' ')) {
            if (current && current.length + 1 + word.length > 80) {
                out.push(current);
                current = /^[.']/.test(word) ? `\\&${word}` : word;
            } else {
                current = current ? `${current} ${word}` : word;
            }
        }
        if (current) {
            out.push(current);
        }
    }
    return out;
}

const output = wrapLines(page).join('\n') + '\n';
const outfile = process.argv[2];
if (outfile) {
    await Bun.write(outfile, output);
} else {
    process.stdout.write(output);
}
