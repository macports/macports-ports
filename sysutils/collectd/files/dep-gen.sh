#!/usr/bin/env bash
# portfile generator for collectd plugins and their dependencies

# these lists are generated from collectd's ./configure output by applying the following regex:
# s/\v\s*--enable-(\w+)\s+(.*)$/[\1]="\2"/

declare -a OPTIONS_ENABLE
OPTIONS_ENABLE=(
	match_empty_counter
	match_hashed
	match_regex
	match_timediff
	match_value
	target_notification
	target_replace
	target_scale
	target_set
	target_v5upgrade
)

declare -A PLUGINS
PLUGINS=(
	[aggregation]="Aggregation plugin"
	[amqp]="AMQP output plugin"
	[apache]="Apache httpd statistics"
	[apcups]="Statistics of UPSes by APC"
	[apple_sensors]="Apple's hardware sensors"
	[ascent]="AscentEmu player statistics"
	[battery]="Battery statistics"
	[bind]="ISC Bind nameserver statistics"
	[conntrack]="nf_conntrack statistics"
	[contextswitch]="context switch statistics"
	[cpufreq]="CPU frequency statistics"
	[cpu]="CPU usage statistics"
	[csv]="CSV output plugin"
	[curl]="CURL generic web statistics"
	[curl_json]="CouchDB statistics"
	[curl_xml]="CURL generic xml statistics"
	[dbi]="General database statistics"
	[df]="Filesystem usage statistics"
	[disk]="Disk usage statistics"
	[dns]="DNS traffic analysis"
	[email]="EMail statistics"
	[entropy]="Entropy statistics"
	[ethstat]="Stats from NIC driver"
	[exec]="Execution of external programs"
	[filecount]="Count files in directories"
	[fscache]="fscache statistics"
	[gmond]="Ganglia plugin"
	[hddtemp]="Query hddtempd"
	[interface]="Interface traffic statistics"
	[ipmi]="IPMI sensor statistics"
	[iptables]="IPTables rule counters"
	[ipvs]="IPVS connection statistics"
	[irq]="IRQ statistics"
	[java]="Embed the Java Virtual Machine"
	[libvirt]="Virtual machine statistics"
	[load]="System load"
	[logfile]="File logging plugin"
	[lpar]="AIX logical partitions statistics"
	[madwifi]="Madwifi wireless statistics"
	[mbmon]="Query mbmond"
	[md]="md (Linux software RAID) devices"
	[memcachec]="memcachec statistics"
	[memcached]="memcached statistics"
	[memory]="Memory usage"
	[modbus]="Modbus plugin"
	[multimeter]="Read multimeter values"
	[mysql]="MySQL statistics"
	[netapp]="NetApp plugin"
	[netlink]="Enhanced Linux network statistics"
	[network]="Network communication plugin"
	[nfs]="NFS statistics"
	[nginx]="nginx statistics"
	[notify_desktop]="Desktop notifications"
	[notify_email]="Email notifier"
	[ntpd]="NTPd statistics"
	[numa]="NUMA virtual memory statistics"
	[nut]="Network UPS tools statistics"
	[olsrd]="olsrd statistics"
	[onewire]="OneWire sensor statistics"
	[openvpn]="OpenVPN client statistics"
	[oracle]="Oracle plugin"
	[perl]="Embed a Perl interpreter"
	[pf]="BSD packet filter (PF) statistics"
	[pinba]="Pinba statistics"
	[ping]="Network latency statistics"
	[postgresql]="PostgreSQL database statistics"
	[powerdns]="PowerDNS statistics"
	[processes]="Process statistics"
	[protocols]="Protocol (IP, TCP, ...) statistics"
	[python]="Embed a Python interpreter"
	[redis]="Redis plugin"
	[routeros]="RouterOS plugin"
	[rrdcached]="RRDTool output plugin"
	[rrdtool]="RRDTool output plugin"
	[sensors]="lm_sensors statistics"
	[serial]="serial port traffic"
	[snmp]="SNMP querying plugin"
	[stats]="StatsD plugin"
	[swap]="Swap usage statistics"
	[syslog]="Syslog logging plugin"
	[table]="Parsing of tabular data"
	[tail]="Parsing of logfiles"
	[tail_csv]="Parsing of CSV files"
	[tape]="Tape drive statistics"
	[tcpconns]="TCP connection statistics"
	[teamspeak2]="TeamSpeak2 server statistics"
	[ted]="Read The Energy Detective values"
	[thermal]="Linux ACPI thermal zone statistics"
	[threshold]="Threshold checking plugin"
	[tokyotyrant]="TokyoTyrant database statistics"
	[unixsock]="Unixsock communication plugin"
	[uptime]="Uptime statistics"
	[users]="User statistics"
	[uuid]="UUID as hostname plugin"
	[varnish]="Varnish cache statistics"
	[vmem]="Virtual memory statistics"
	[vserver]="Linux VServer statistics"
	[wireless]="Wireless statistics"
	[write_graphite]="Graphite / Carbon output plugin"
	[write_http]="HTTP output plugin"
	[write_redis]="Redis output plugin"
	[write_mongodb]="MongoDB output plugin"
	[xmms]="XMMS statistics"
	[zfs_arc]="ZFS ARC statistics"
)

# list of required dependencies by plugin
declare -A PLUGIN_DEPS
PLUGIN_DEPS=(
	[amqp]="port:rabbitmq-c"
	[apache]="port:curl"
	[ascent]="port:curl port:libxml2"
	[bind]="port:curl port:libxml2"
	[curl]="port:curl"
	[curl_json]="port:curl port:yajl"
	[curl_xml]="port:curl port:libxml2"
	[dbi]="port:libdbi"
	[dns]="port:libpcap"
	[gmond]="port:ganglia"
	[libvirt]="port:libvirt port:libxml2"
	[memcachec]="port:libmemcached"
	[memcached]="port:libmemcached"
	[mysql]="path:lib/mysql5/mysql/libmysqlclient.dylib:mysql5"
	[network]="port:libgcrypt"
	[nginx]="port:curl"
	[notify_desktop]="port:libnotify"
	[notify_email]="port:libesmtp"
	[nut]="port:nut"
	[perl]="port:perl5.18"
	[pinba]="port:protobuf-c"
	[postgresql]="port:postgresql91"
	[python]="port:python27"
	[redis]="port:libcredis"
	[rrdcached]="port:rrdtool"
	[rrdtool]="port:rrdtool"
	[snmp]="port:net-snmp"
	[tokyotyrant]="port:tokyotyrant"
	[varnish]="port:varnish"
	[write_http]="port:curl"
	[write_riemann]="port:protobuf-c"
	[xmms]="port:xmms"
)

# list of useless modules on macOS
declare -A OSX_BLACKLIST
OSX_BLACKLIST=(
	[aquaero]=1		# requires libaquaero5, which is not available
	[cgroups]=1		# Linux only
	[conntrack]=1	# Linux only
	[cpufreq]=1		# Linux only
	[entropy]=1		# Linux only
	[fscache]=1		# Linux only
	[ipmi]=1		# requires openipmithreads, which is not available
	[iptables]=1	# Linux only
	[ipvs]=1		# Linux only
	[irq]=1			# Linux only
	[lvm]=1			# Linux only
	[madwifi]=1		# Linux only
	[md]=1			# Linux only
	[mic]=1			# Intel Many Integrated Core (Xeon Phi) only
	[modbus]=1		# requires libmodbus, which is not available
	[netapp]=1		# requires libnetapp, which is not available
	[netlink]=1		# requires libmnl, which is not available
	[nfs]=1			# Linux only
	[onewire]=1		# requires libowcapu, which is not available
	[oracle]=1		# requires libclntsh, which is not available
	[perfstat]=1	# AIX only
	[ping]=1		# requires liboping, which is not available
	[processes]=1	# No macOS support
	[protocols]=1	# Linux only
	[redis]=1		# requires libcredis, which is not available
	[routeros]=1	# requires librouteros, which is not available
	[sensors]=1		# requires libsensors, which is not available
	[serial]=1		# Linux only
	[sigrok]=1		# requires libsigrok, which is not available
	[tape]=1		# Solaris only
	[thermal]=1		# Linux only
	[vmem]=1		# Linux only
	[vserver]=1		# Linux only
	[wireless]=1	# Linux only
	[write_mongodb]=1	# requires libmongoc, which is not available
	[write_redis]=1	# requires libcredis, which is not available
	[zfs_arc]=1		# Solaris only
)

# list of standard modules on macOS
declare -a OSX_STANDARD
OSX_STANDARD=(
	aggregation
	apache
	apcups
	apple_sensors
	battery
	bind
	contextswitch
	cpu
	csv
	curl
	curl_xml
	df
	disk
	email
	exec
	filecount
	hddtemp
	interface
	load
	logfile
	mbmon
	memory
	multimeter
	network
	ntpd
	olsrd
	openvpn
	rrdcached
	rrdtool
	statsd
	swap
	syslog
	table
	tail
	tail_csv
	tcpconns
	teamspeak2
	ted
	threshold
	unixsock
	uptime
	users
	uuid
	write_graphite
	write_http
)

declare -A EXTRA_CODE
read -r -d '' PERL_EXTRA <<'EOF'
    configure.args-append --with-perl=${prefix}/bin/perl5.18
EOF
read -r -d '' PYTHON_EXTRA <<'EOF'
    configure.args-append --with-python=${prefix}/bin/python2.7
EOF
read -r -d '' JAVA_EXTRA <<'EOF'
    pre-configure {
        ui_warn "Compiling with Java will probably fail; if you want to make it work, read `Configuring with libjvm' in README in the upstream git"
    }
EOF
read -r -d '' NETWORK_EXTRA <<'EOF'
    # silence a deprecation warning
    configure.cflags-append -D_GCRYPT_IN_LIBGCRYPT=1
EOF
EXTRA_CODE=(
	[perl]="$PERL_EXTRA"
	[python]="$PYTHON_EXTRA"
	[java]="$JAVA_EXTRA"
	[network]="$NETWORK_EXTRA"
)


echo "#######################################################"
echo "# WARNING: This list is generated by files/dep-gen.sh #"
echo "#          Take care when editing manually!           #"
echo "#######################################################"
echo

echo "# enable all matches and targets, disable all other plugins"
echo "configure.args-append \\"
for option in ${OPTIONS_ENABLE[@]}; do
	echo "    --enable-$option \\"
done
for plugin in ${!PLUGINS[@]}; do
	echo "    --disable-$plugin \\"
done
echo

for plugin in ${!PLUGINS[@]}; do
	if [ -z "${OSX_BLACKLIST[$plugin]}" ]; then
		printf "variant %s description {%s} {\n" "$plugin" "${PLUGINS[$plugin]}"
		printf "    configure.args-delete --disable-$plugin\n"
		printf "    configure.args-append --enable-$plugin\n"
		if [ -n "${EXTRA_CODE[$plugin]}" ]; then
			echo
			echo "    ${EXTRA_CODE[$plugin]}"
		fi
		if [ -n "${PLUGIN_DEPS[$plugin]}" ]; then
			printf "\n    depends_lib-delete %s\n" "${PLUGIN_DEPS[$plugin]}"
			printf "    depends_lib-append %s\n" "${PLUGIN_DEPS[$plugin]}"
		fi
		printf "}\n\n"
	fi
done

echo "default_variants \\"
for plugin in ${OSX_STANDARD[@]}; do
	printf "    +%s \\\\\n" "$plugin"
done
echo
