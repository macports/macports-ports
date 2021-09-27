#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2021 Frank Dean
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

#                                    - - -

# This script is designed to run with default MacPorts installations of
# 'openstreetmap-carto' and 'mod_tile'.
#
# The script creates the initial database, with a default name of 'gis' and
# creates a PostgreSQL user, with a default name of 'nobody'.  These and other
# values can be overridden by specifying them as variables on the command
# line.  E.g.
#
# sudo EXTERNAL_DATA_EXTRA_OPTIONS='--verbose' \
#      GIS_DB=osm \
#      OSM2PGSQL_RAM=4096 OSM2PGSQL_CPUS=4 ./osm_setup_db.sh
#
# Before running this script, you need to ensure that PostgreSQL has been
# configured for the 'nobody' to be able to access the 'gis' database without
# a password.  Refer to the Ident Authentication section in the PostgreSQL
# Manual, https://www.postgresql.org/docs/12/auth-ident.html to understand any
# security implications of this approach.
#
# The simplest way to configure this is to add an 'ident' method for 'gis' and
# 'nobody', most likely as the first active line of the configuration in
# /opt/local/var/db/${postgresql_version}/defaultdb/pg_hba.conf.  E.g.
#
#  - - -
#
#  # TYPE  DATABASE        USER            ADDRESS                 METHOD
#
#  local   gis             nobody                                  ident
#
#  - - -
#
# Reload the PostgreSQL server configuration after making the change.  E.g
#
# sudo port reload  postgresql12-server
#
# If the file specified by $PBF_FILENAME exists, it is imported as-is.  If it
# does not exist, it is assumed to be a file hosted at $PBF_DOWNLOAD_BASE_URL,
# e.g. monaco-latest.osm.pdf and curl is used to download it.  You may need to
# install the curl port to support this.
#
# Version 1.0 - 2021-08-22

set +e

# Enable the following line to debug the script
#set -x

PREFIX="${PREFIX:-/usr/local}"

if [ -r $PREFIX/etc/mod_tile/osm-tiles-update.conf ]; then
    source $PREFIX/etc/mod_tile/osm-tiles-update.conf
fi

GIS_DB="${GIS_DB:-gis}"
GIS_USER="${GIS_USER:-nobody}"
GIS_DB_USER="${GIS_DB_USER:-$GIS_USER}"
PG_SUPER_USER="${PG_SUPER_USER:-postgres}"
CURL_BIN="$PREFIX/bin/curl"
MD5SUM_BIN="$PREFIX/bin/gmd5sum"
OSM2PGSQL_BIN="$PREFIX/bin/osm2pgsql-lua"
PBF_DOWNLOAD_BASE_URL="${PBF_DOWNLOAD_BASE_URL:-https://download.geofabrik.de}"
PBF_FILENAME="${PBF_FILENAME:-europe/monaco-latest.osm.pbf}"
POLY_FILENAME="${POLY_FILENAME:-europe/monaco.poly}"
OSM2PGSQL_RAM="${OSM2PGSQL_RAM:-4096}"
OSM2PGSQL_CPUS="${OSM2PGSQL_CPUS:-4}"
SKIP_IMPORT="${SKIP_IMPORT:-}"
EXTERNAL_DATA_EXTRA_OPTIONS="${EXTERNAL_DATA_EXTRA_OPTIONS}"

CUT_BIN=/usr/bin/cut
GREP_BIN=/usr/bin/grep

if [ $(id -u) -ne 0 ]; then
    sudo $0
    exit 0
fi

initializeDatabase()
{
    sudo -u "$PG_SUPER_USER" "$PREFIX/bin/createuser" "$GIS_DB_USER" -DRS >/dev/null 2>&1
    sudo -u "$PG_SUPER_USER" "$PREFIX/bin/createdb" "$GIS_DB" --owner="$GIS_DB_USER" --encoding=UTF8 >/dev/null 2>&1
    cat <<EOF | sudo -u "$PG_SUPER_USER" psql "$GIS_DB" >/dev/null 2>&1
CREATE EXTENSION postgis;
CREATE EXTENSION hstore;
ALTER TABLE geometry_columns OWNER TO $GIS_DB_USER;
ALTER TABLE spatial_ref_sys OWNER TO $GIS_DB_USER;
EOF
}

readPolyFile()
{
    # Either uses the local file or attempts to download it
    sudo -u "$GIS_USER" test -r "$POLY_FILENAME"
    if  [ $? -eq 0 ]; then
	sudo -u cp "$POLY_FILENAME" "${PREFIX}/var/lib/mod_tile/region.poly"
    else
	POLY_FILE="${PREFIX}/var/lib/mod_tile/region.poly"
	sudo -u "$GIS_USER" test -x "$CURL_BIN"
	if [ $? -eq 0 ]; then
	    >&2 echo "Downloading ${PBF_DOWNLOAD_BASE_URL}/${POLY_FILENAME}..."
	    >&2 echo "Saving to $POLY_FILE"
	    sudo -u "$GIS_USER" $CURL_BIN --fail -L "${PBF_DOWNLOAD_BASE_URL}/${POLY_FILENAME}" -o "$POLY_FILE"
	    if [ $? -ne 0 ]; then
		>&2 echo "Unable to download ${POLY_FILENAME} from ${PBF_DOWNLOAD_BASE_URL}"
	    fi
	fi
    fi
}

readPbf()
{
    # Either uses the local file or attempts to download it
    cd "${PREFIX}/var/lib/mod_tile"
    sudo -u "$GIS_USER" test -r "$PBF_FILENAME"
    if  [ $? -eq 0 ]; then
	PBF_FILE="$PBF_FILENAME"
    else
	sudo -u "$GIS_USER" test -x "$CURL_BIN"
	if [ $? -eq 0 ]; then
	    PBF_FILE=$(basename "${PBF_FILENAME}")
	    >&2 echo "Downloading ${PBF_DOWNLOAD_BASE_URL}/${PBF_FILENAME}..."
	    sudo -u "$GIS_USER" $CURL_BIN --fail -L "${PBF_DOWNLOAD_BASE_URL}/${PBF_FILENAME}" -o "$PBF_FILE"
	    if [ $? -ne 0 ]; then
		>&2 echo "Unable to download ${PBF_FILENAME} from ${PBF_DOWNLOAD_BASE_URL}"
		exit 1
	    else
		sudo -u "$GIS_USER" test -x "$MD5SUM_BIN"
		if [ $? -eq 0 ]; then
		    sudo -u "$GIS_USER" $CURL_BIN --fail -L "${PBF_DOWNLOAD_BASE_URL}/${PBF_FILENAME}.md5" -o "${PBF_FILE}.md5"
		    if [ $? -eq 0 ]; then
			MD5_RESULT="$($MD5SUM_BIN -c ${PBF_FILE}.md5 2>&1 > /dev/null)"
			if [ $? -eq "0" ]; then
			    >&2 echo "${PBF_FILE} checksum OK"
			else
			    >&2 echo "Checksum failed, aborted: $MD5_RESULT"
			    exit 1
			fi
		    else
			>&2 echo "MD5 not checked-download not available for checking"
		    fi
		fi
	    fi
	fi
    fi
}

createDatabase()
{
    # Create indexes to support the style definitions from openstreetmap-carto
    sudo -u "$GIS_USER" test -r "$PBF_FILE"
    if [ $? -eq 0 ]; then
	>&2 echo "Importing from $PBF_FILE... (This can take a very long time, depending on import size and other factors)"
	sudo -u nobody "$OSM2PGSQL_BIN" -d "$GIS_DB" \
	     --create --slim  -G --hstore \
	     --tag-transform-script \
	     "$PREFIX/share/openstreetmap-carto/openstreetmap-carto.lua" \
	     -C "$OSM2PGSQL_RAM" --number-processes "$OSM2PGSQL_CPUS" \
	     -S "$PREFIX/share/openstreetmap-carto/openstreetmap-carto.style" \
	     --input-reader='pbf' \
	     "$PBF_FILE"
	if [ $? -ne 0 ]; then
	    >&2 echo "Error importing $PBF_FILE"
	    exit 1
	fi
	>&2 echo "Creating indexes... (This can also take a very long time)"
	sudo -u "$GIS_USER" psql -d "$GIS_DB" -U "$GIS_DB_USER" \
	     -f "$PREFIX/share/openstreetmap-carto/indexes.sql" >/dev/null
	if [ $? -ne 0 ]; then
	    >&2 echo "Error creating indexes in PostgreSQL"
	    exit 1
	fi
    fi
}

downloadExternalData()
{
    # Download polygons for water, icesheets and administrative boundaries
    sudo -u "$GIS_USER" test -d "$PREFIX/var/lib/openstreetmap-carto"
    if [ $? -eq 0 ]; then
	sudo -u "$GIS_USER" test -x "$PREFIX/share/openstreetmap-carto/scripts/get-external-data.py"
	if [ $? -eq 0 ]; then
	    >&2 echo "Importing external data (boundaries, water & icesheet polygons)..."
	    cd "$PREFIX/share/openstreetmap-carto"
	    sudo -u "$GIS_USER" \
		 "$PREFIX/share/openstreetmap-carto/scripts/get-external-data.py" \
		 $EXTERNAL_DATA_EXTRA_OPTIONS
	    if [ $? -ne 0 ]; then
		>&2 echo "Error downloading and importing external data"
		exit 1
	    fi
	else
	    >&2 echo "Unable to import external data – $PREFIX/share/openstreetmap-carto/scripts/get-external-data.py script does not exist or is not executable"
	fi
    else
	>&2 echo "Unable to import external data – $PREFIX/var/lib/openstreetmap-carto directory does not exist"
    fi
}

initializeIncrementalUpdates()
{
    if [ -d "$PREFIX/var/lib/mod_tile/.osmosis" ]; then
	rm -rf "$PREFIX/var/lib/mod_tile/.osmosis"
    fi
    # Save the timestamp of the PBF file as a baseline for incremental updates
    if [ -x "$PREFIX/share/mod_tile/openstreetmap-tiles-update-expire" ]; then
	if [ -x "$PREFIX/bin/osmium" ]; then
	    timestamp=$("$PREFIX/bin/osmium" fileinfo --input-format=pbf "$PBF_FILE" | "$GREP_BIN" osmosis_replication_timestamp | "$CUT_BIN" -b35-)
	    if [ -n "$timestamp" ]; then
		>&2 echo "Initializing baseline timestamp for incremental updates to '$timestamp'"
		sudo -u nobody "$PREFIX/share/mod_tile/openstreetmap-tiles-update-expire" "$timestamp"
	    else
		>&2 echo "Unable to extract timestamp from ${PBF_FILE}"
	    fi
	else
	    >&2 echo "Not initializing baseline timestamp for incremental updates as osmium is not installed"
	fi
    else
	>&2 echo "Not initializing baseline timestamp for incremental updates as the update script is not executable"
    fi
}

if [ -z "$SKIP_IMPORT" ]; then
    initializeDatabase
    readPbf
    readPolyFile
    createDatabase
    initializeIncrementalUpdates
fi
downloadExternalData
