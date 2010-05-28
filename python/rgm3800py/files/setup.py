try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

setup(name = "rgm3800py",
            description="Access Royaltek RGM-3800 and compatible GPS datalogger",
            long_description = """
			Access Royaltek RGM-3800 and compatible GPS datalogger

			With this command line utility you can:

			Dump tracks off your RGM-3800 GPS datalogger in NMEA and GPX format.
			List tracks with information.
			Configure logging format and interval.
			Check memory usage.
			Erase all tracks.
			This tool was tested with MacOS X, Linux and Windows. You only need a decent Python interpreter (version 2.4 or newer, 2.3 might also do) and a PL2303 USB driver (included in Linux, for OS X you could use this one). This tool works on non-x86 CPUs (e.g. old Powerbooks). On Windows you'll also need pywin32 and pyserial.

			If you use rgm3800py and would like to be notified about new features please subscribe to the announcement group: rgm3800py-announce (This supports RSS/Atom feeds!)

			If you have a problem or an idea for improvements please send email to petersen.karsten@gmail.com
""",
            license="""GNU General Public License""",
            version = "3",
            author = "Petersen Karsten",
            author_email = "petersen.karsten@gmail.com",
            maintainer = "Petersen Karsten",
            maintainer_email = "petersen.karsten@gmail.com",
            url = "http://code.google.com/p/rgm3800py/",
            #packages = ['rgm3800py'],
			scripts = ["rgm3800py.py"]

            )
