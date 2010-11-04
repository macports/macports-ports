# changes to this file
# (0) this header
# (1) QT_CONFIG -> CONFIG

TEMPLATE = subdirs

SUBDIRS =

unix:contains(CONFIG, gstreamer): SUBDIRS *= gstreamer
mac:contains(CONFIG, phonon-backend): SUBDIRS *= qt7
win32:!wince*:contains(CONFIG, phonon-backend): SUBDIRS *= ds9
wince*:contains(CONFIG, phonon-backend): SUBDIRS *= waveout
wince*:contains(CONFIG, directshow): SUBDIRS *= ds9

# Note that the MMF backend is in some scenarios an important complement to the
# Helix backend: the latter requires Symbian signed capabilities, hence MMF
# provides multimedia for self signed scenarios.
symbian:contains(CONFIG, phonon-backend): SUBDIRS *= mmf
