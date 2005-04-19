have port && {
# helper functions for port completion
#
_port_installed_ports()
{
        COMPREPLY=( $( port installed | sed -ne \
        's|^  \('$cur'[^ ]*\).*$|\1|p' | uniq ) )
}

_port_active_ports()
{
        COMPREPLY=( $( port installed | grep '(active)' | sed -ne \
        's|^  \('$cur'[^ ]*\).*$|\1|p' | uniq ) )
}

_port_inactive_ports()
{
        COMPREPLY=( $( port installed | grep -v '(active)' | sed -ne \
        's|^  \('$cur'[^ ]*\).*$|\1|p' | uniq ) )
}

_port_all_ports()
{
        COMPREPLY=( $( port $portdiropt list | \
	awk '/^'$cur'/ { print $1 }' | sort 2> /dev/null ) )
}

_port_installed_variants()
{
        COMPREPLY=( $( port installed | awk '/'$port'/ { print $2 }' | tr '\r' ' ' 2> /dev/null ) )
        COMPREPLY=( $( compgen -W '${COMPREPLY[@]}' -- $cur ) )
}
_port_available_variants()
{
        COMPREPLY=( $(port variants $port | tr '\r' ' ' | grep -v "has no variants") )
        COMPREPLY=( $( compgen -P'+' -W '${COMPREPLY[@]}' -- $cur ) )
}
# port(1) completion
# 
_port()
{
        local cur prev mode count portdir portdiropt i port
		
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	count=0
	for i in ${COMP_WORDS[@]}; do
		[ $count -eq $COMP_CWORD ] && break
		# Last parameter was the portdir, now go back to mode selection
		if [ "${COMP_WORDS[((count))]}" == "$portdir" -a "$mode" == "portdir" ]; then
			mode=""
		fi
		if [ -z "$mode" ]; then
			case $i in
			-D)
				mode=portdir
				portdir=${COMP_WORDS[((count+1))]}
				portdiropt="-D $portdir"
				;;
			activate|deactivate|install|uninstall|upgrade|clean|deps|contents|variants|info|\
                        unarchive|fetch|extract|patch|configure|build|destroot|test|archive|\
			pkg|mpkg|dmg|rpmpackage|provides)
				mode=$i
				;;
			esac
		elif [  -z "$port" ]; then
		    case $mode in
		    uninstall|upgrade|contents)
			    if [ $( port installed | awk ' !/The following ports/ {print $1}' \
				| uniq | grep '^'$i'$') ]; then
				port=$i
			    fi
			    ;;
		    *)
			    if [ $(port $portdiropt list | awk '{ print $1 }' | grep '^'$i'$') ]; then
				port=$i
			    fi
			    ;;
		    esac
		fi
		count=$((++count))
	done

	if [ -n "$port" ]; then
		case $mode in
		activate|uninstall)
			_port_installed_variants
			return 0
			;;

		*)
			_port_available_variants
			return 0
			;;
		esac
	fi

	if [ -n "$mode" ]; then
		case $mode in
		# list installed ports
                uninstall|upgrade|contents)
		        if [ -z "$port" ]; then
		            _port_installed_ports
			fi
			return 0
			;;
		activate)
			_port_inactive_ports
			return 0
			;;
		deactivate)
			_port_active_ports
			return 0
			;;
		provides)
			_filedir
			return 0
			;;
		# list all ports
		*)
			if [ -z "$port" ]; then
			    _port_all_ports
			fi
			return 0
			;;

		esac
	fi

	if [[ "$cur" == -* ]]; then

		COMPREPLY=( $( compgen -W '-v -d -q -f -o -n -a -u -s -b -c -k' \
				-- $cur ) )
	else

		COMPREPLY=( $( compgen -W 'install uninstall upgrade installed outdated \
				clean list search contents deps variants info \
				unarchive fetch extract patch configure build \
                                destroot test archive activate deactivate \
                                pkg mpkg dmg rpmpackage provides' -- $cur ) )

	fi

	return 0
}
complete -F _port $filenames port
}

