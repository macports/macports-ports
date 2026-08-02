import os
os.environ["OTB_APPLICATION_PATH"] = "@PREFIX@/lib/otb/applications"
del os

from .otbApplication import *
