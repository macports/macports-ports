"""
A setup file to build Frescobaldi.app with py2app.

Initial version by Henning Hraban Ramm.
"""

from setuptools import setup

APPNAME = 'frescobaldi'
APP = ['%%PREFIX%%/bin/{0}'.format(APPNAME)]
NAME = 'Frescobaldi'
VERSION = '%%VERSION%%'

plist = dict(
    CFBundleName                  = NAME,
    CFBundleDisplayName           = NAME,
    CFBundleShortVersionString    = VERSION,
    CFBundleVersion               = VERSION,
    CFBundleExecutable            = NAME,
    CFBundleIdentifier            = 'org.{0}.{0}'.format(APPNAME),
    CFBundleIconFile              = '{0}.icns'.format(APPNAME),
    NSHumanReadableCopyright      = 'Copyright 2008-2012 Wilbert Berendsen.',
    CFBundleDocumentTypes         = [
        {
            'CFBundleTypeExtensions': ['ly', 'lyi', 'ily'],
            'CFBundleTypeName':'LilyPond file',
            'CFBundleTypeRole':'Editor',
        },
        {
            'CFBundleTypeExtensions': ['tex', 'lytex', 'latex'],
            'CFBundleTypeName':'LaTeX file',
            'CFBundleTypeRole':'Editor',
        },
        {
            'CFBundleTypeExtensions': ['docbook', 'lyxml'],
            'CFBundleTypeName':'DocBook file',
            'CFBundleTypeRole':'Editor',
        },
        {
            'CFBundleTypeExtensions': ['html'],
            'CFBundleTypeName':'HTML file',
            'CFBundleTypeRole':'Editor',
            'LSItemContentTypes': ['public.html']
        },
        {
            'CFBundleTypeExtensions': ['xml'],
            'CFBundleTypeName':'XML file',
            'CFBundleTypeRole':'Editor',
            'LSItemContentTypes': ['public.xml']
        },
        {
            'CFBundleTypeExtensions': ['itely', 'tely', 'texi', 'texinfo'],
            'CFBundleTypeName':'Texinfo file',
            'CFBundleTypeRole':'Editor',
        },
        {
            'CFBundleTypeExtensions': ['scm'],
            'CFBundleTypeName':'Scheme file',
            'CFBundleTypeRole':'Editor',
        },
        {
            'CFBundleTypeExtensions': ['*'],
            'CFBundleTypeName':'Text file',
            'CFBundleTypeRole':'Editor',
            'LSItemContentTypes': ['public.text']
        }
    ]
)

OPTIONS = {
    'argv_emulation': True,
    'semi_standalone': True,
    'alias': True,
    'plist': plist,
}

setup(
    app=APP,
    name=NAME,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
