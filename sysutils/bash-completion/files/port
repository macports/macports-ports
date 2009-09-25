have port && {
# helper functions for port completion
#

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
                    activate|archive|build|cat|cd|checksum|clean|compact|configure|\
                        contents|deactivate|dependents|deps|destroot|dir|distcheck|dmg|\
                        dpkg|echo|ed|edit|exit|extract|fetch|file|gohome|help|info|\
                        install|installed|lint|list|livecheck|load|location|mdmg|mirror|\
                        mpkg|outdated|patch|pkg|platform|provides|quit|rpm|search|selfupdate|\
                        srpm|submit|sync|test|trace|unarchive|uncompact|uninstall|unload|\
                        upgrade|url|usage|variants|version|work)
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
            # complete variants
	    case $mode in
		contents|uninstall)
		    # installed variants
		    COMPREPLY=( $( port installed \
			| awk '/'$port'/ { print $2 }' | tr '\r' ' ' 2> /dev/null ) )
		    COMPREPLY=( $( compgen -W '${COMPREPLY[@]}' -- $cur ) )
		    return 0
		    ;;
		activate)
		    # inactive variants
		    COMPREPLY=( $( port installed | grep -v '(active)' \
			| awk '/'$port'/ { print $2 }' | tr '\r' ' ' 2> /dev/null ) )
		    COMPREPLY=( $( compgen -W '${COMPREPLY[@]}' -- $cur ) )
		    return 0
		    ;;
		deactivate)
		    # active variants
		    COMPREPLY=( $( port installed | grep '(active)' \
			| awk '/'$port'/ { print $2 }' | tr '\r' ' ' 2> /dev/null ) )
		    COMPREPLY=( $( compgen -W '${COMPREPLY[@]}' -- $cur ) )
		    return 0
		    ;;
		*)
		    # all variants
		    COMPREPLY=( $(port $portdiropt variants $port | tr '\r' ' ' | grep -v "has no variants") )
		    COMPREPLY=( $( compgen -P'+' -W '${COMPREPLY[@]}' -- $cur ) )
		    return 0
		    ;;
	    esac

	fi

	if [ -n "$mode" ]; then
	    # complete port names
	    case $mode in
                uninstall|upgrade|contents)
		    # installed ports
		    COMPREPLY=( $( port installed \
			| sed -ne 's|^  \('$cur'[^ ]*\).*$|\1|p' | uniq ) )
		    return 0
		    ;;
		activate)
		    # inactive ports
		    COMPREPLY=( $( port installed | grep -v '(active)' \
			| sed -ne 's|^  \('$cur'[^ ]*\).*$|\1|p' | uniq ) )
		    return 0
		    ;;
		deactivate)
		    # active ports
		    COMPREPLY=( $( port installed | grep '(active)' \
			| sed -ne 's|^  \('$cur'[^ ]*\).*$|\1|p' | uniq ) )
		    return 0
		    ;;
		provides|portdir)
		    _filedir
		    return 0
		    ;;
		installed|outdated|list|sync|selfupdate)
		    # no port
		    return 0
		    ;;
		*)
    		    # all ports
		    COMPREPLY=( $( port $portdiropt list \
			| awk '/^'$cur'/ { print $1 }' | sort 2> /dev/null ) )
		    return 0
		    ;;
		esac
	fi

	COMPREPLY=( $( compgen -W '-b -c -d -f -i -k -n -o -p -q -R -s -t -u -v -x \
                                activate archive build cat cd checksum clean compact configure \
                                contents deactivate dependents deps destroot dir distcheck dmg \
                                dpkg echo ed edit exit extract fetch file gohome help info \
                                install installed lint list livecheck load location mdmg mirror \
                                mpkg outdated patch pkg platform provides quit rpm search selfupdate \
                                srpm submit sync test trace unarchive uncompact uninstall unload \
                                upgrade url usage variants version work' -- $cur ) )
	return 0
}
complete -F _port $filenames port
}
