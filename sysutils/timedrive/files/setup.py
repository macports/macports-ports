from setuptools import setup, find_packages

long_desc = """Time Drive is a front-end utility for duplicity. It makes
backup to an external file server easy and efficient. Time
Drive supports WebDAV, secure WebDAV, FTP, SSH, and SCP.
It can also be configured to work with Samba.
"""

setup(name="time-drive",
      version="0.1.1",
      description="incremental backup across networks",
      long_description=long_desc,
      author="Oak Tree US",
      author_email="",
      url="http://www.oak-tree.us/blog/index.php/science-and-technology/time-drive", 
	  packages = find_packages(),
	  scripts = ['app.py',
	  			 'BackInTime_Icons_rc.py',
	  			 'backupsettings.py',
				 'duplicity_interface.py',
				 'restoredialog.py',
				 'settingsdialog.py',
				 'timedrive-backup',
				 'treesortfilter.py',
				 'ui_MainWindow.py',
				 'ui_RestoreFiles.py',
				 'ui_Settings.py',
				 'utils.py'],
	  package_data={'time-drive':["*.ui","*.sh","*.qrc"]}
      )
