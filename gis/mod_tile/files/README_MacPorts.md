<!-- -*- mode: markdown; -*- vim: set tw=78 ts=4 sts=0 sw=4 noet ft=markdown norl: -->

# Port—`mod_tile`

## Initial Configuration and Setup

This port primarily contains two applications, a daemon, `renderd`, which
renders map tiles from the database; and an Apache module, `mod_tile`, which
serves those tiles.

The port includes a shell script, `@PREFIX@/share/mod_tile/osm_setup_db.sh`
which largely automates the process of downloading and importing OpenStreetMap
data into a PostgreSQL database.  There are some notes at the beginning of the
script on how to use it.  Note the section that requires a small modification
to the PostgreSQL database configuration to provide the `nobody` system user
with database access permission.

By default the script imports the country of Monaco, situated on the
Mediterranean coast to the south of France.  It is recommended you experiment
with a small area until you are satisfied with the processes involved.
Depending on the power of the machine employed, processing data for larger
areas can take considerable time and resources.  Generally, SSD disks are
recommended to reduce processing times.

The script sources variables from
`@PREFIX@/etc/mod_tile/osm-tiles-update.conf`.  Update that configuration
file appropriately.

To enable the `mod_tile` module in Apache, install it with:

	$ cd @PREFIX@/lib/apache2/modules/
	$ sudo @PREFIX@/bin/apxs -a -e -n "tile" mod_tile.so
	$ sudo port reload apache2

You should complete the import process before starting the `renderd` daemon
process, otherwise it is simply going to report errors.  The `renderd` process
is started with:

	$ sudo port load mod_tile

Optionally, you can download and apply incremental updates to the database by
running an import script which can be scheduled with:

	$ sudo launchctl load -w \
	/Library/LaunchAgents/org.macports.fetch-osm-db-updates.plist

This script downloads an hourly snapshot, so it has to be run at least that
frequently to keep up-to-date.  The default installation runs it more
frequently to allow it to catch up, allowing for a little downtime.  Depending
on your requirements, it may be better not to run this process at all and just
refresh the entire region every few months or so.

The output of the various scripts and utilities are written to log files under
`@PREFIX@/var/log/renderd`.  A configuration file for `logrotate` is
deployed to `@PREFIX@/etc/logrotate.d/renderd`.  Please see the `logrotate`
man pages for further information.

## Cleanup and Starting Afresh

To delete the imported data and start afresh, delete the database and the
`mod_tile` tile cache.

As a PostgreSQL super user, drop the database (default `gis`):

	$ dropdb gis

Remove the tile cache with:

	$ sudo rm -rf @PREFIX@/var/lib/mod_tile/*

Remove the state files for incremental updates with:

	$ sudo rm -rf @PREFIX@/var/lib/mod_tile/.osmosis

## Noto Fonts

The `mapnik.xml` configuration file attempts to use Google Noto Fonts if they
are available under `@PREFIX@/lib/mapnik/fonts`.  Download the fonts and
create a symbolic to their installed location:

1.	Download a zip containing the fonts from
    <https://www.google.com/get/noto/help/install/>

		$ sudo mkdir -p /usr/local/share/fonts/noto
		$ sudo chown $USER /usr/local/share/fonts/noto
		$ cd /usr/local/share/fonts/noto
		$ unzip ~/Downloads/Noto-unhinted.zip
		$ chmod +r *.?tf
		$ sudo ln -s /usr/local/share/fonts/noto @PREFIX@/lib/mapnik/fonts

The debug information written to `@PREFIX@/var/lib/renderd/renderd.log`
during the daemon startup reports whether fonts are loaded successfully or
not.  The configuration is fundamentally a priority preference for normal,
bold and oblique fonts.  It is expected some font varieties will not be found.

## Changing the Default Database name

To use a different database name, it is necessary to modify a number of
configuration files:

- `@PREFIX@/etc/mod_tile/osm-tiles-update.conf`
- `@PREFIX@/etc/openstreetmap-carto/external-data.yml`
- `@PREFIX@/etc/openstreetmap-carto/mapnik.xml`

The `mapnik.xml` configuration file repeatedly defines the database name for
every style.  It may be easier to re-create the entire configuration file from
its original source file as follows:

1.  Make a copy of `@PREFIX@/share/openstreetmap-carto/project.mml` and edit
    the `dbname` attribute appropriately in the copy.

1.  Use `carto` to re-create `mapnik.xml` using the copy of the `project.mml`
    source file:

		$ sudo port install carto
		$ carto project.mml | sudo tee @PREFIX@/etc/openstreetmap-carto/mapnik.xml

## Useful Resources

- [mod_tile][]
- [mod_tile_switch2osm][]
- [Osmosis][]
- [OpenStreetMap][]
- [openstreetmap-carto][]
- [OSM Tile Calculator][]
- [PostGIS][]
- [PostgreSQL][]
- [switch2osm][]

[mod_tile]: https://github.com/openstreetmap/mod_tile "an Apache 2 module to deliver map tiles"
[mod_tile_switch2osm]: https://github.com/SomeoneElseOSM/mod_tile "an Apache 2 module to deliver map tiles"
[Osmosis]: https://github.com/openstreetmap/osmosis "a command line Java application for processing Open Street Map data"
[OpenStreetMap]: http://www.openstreetmap.org/ "OpenStreetMap"
[openstreetmap-carto]: https://github.com/gravitystorm/openstreetmap-carto "a general-purpose OpenStreetMap mapnik style, in CartoCSS"
[OSM Tile Calculator]: https://tools.geofabrik.de/calc/#type=geofabrik_standard&bbox=7.405088,43.720716,7.447488,43.753832 "Calculates tile size and number of tiles in given bounding box"
[PostGIS]: https://postgis.net. "Spatial and Geographic objects for PostgreSQL"
[PostgreSQL]: https://www.postgresql.org "A powerful, open source object-relational database system"
[switch2osm]: https://switch2osm.org/ "Switch2OSM—Take back control of your maps"
