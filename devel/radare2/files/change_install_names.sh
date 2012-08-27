#!/bin/sh

# Be verbose.
VERBOSE=no
# Stop on path failures.
STOP=no

# This is the DESTROOT we have installed into.
# Example:
#   $ DESTROOT=/sandbox/radare2 make install
#   $ sudo change_install_names /sandbox/radare2
DESTROOT="${1}"

# find files in DESTROOT
FILES=( $(find "${DESTROOT}" -type f) )
IFS=$'\n'
# work on each file in FILES
for (( fc = 0 ; fc < ${#FILES[@]} ; fc++ ))
do
    # If we are not a file or dir we are done.
    if [[ ! -f "${FILES[$fc]}" && ! -d "${FILES[$fc]}" ]]
    then
        echo "FILE ${eError}: ${FILES[$fc]}"
        break 1
    # If we are a file lets try to fix our id. We do not bother checking file type because
    # install_name_tool harmlessly fails to work on files it is not designed to work on.
    elif [[ -f "${FILES[$fc]}" ]]
    then
        FILEID=$(echo "${FILES[$fc]}" | sed "s|^${DESTROOT}||")
        [ "$VERBOSE" == "yes" ] && echo "FILEID: ${FILEID}"
        # fix the file id.
        install_name_tool -id "${FILEID}" "${FILES[$fc]}" 2>/dev/null
    fi
    # If not a dir, look for shared libs.
    if [ ! -d "${FILES[$fc]}" ]
    then
        # Create an array of all the shared files if any.
        SHAREDLIBRARYS=( $(otool -XL "${FILES[$fc]}" | sed -e "s/^Archive.*//" | tr -d '\t' | awk '{print $1}') )
        if [[ ${#SHAREDLIBRARYS[@]} -gt 0 ]]
        then
            for (( sc = 0 ; sc < ${#SHAREDLIBRARYS[@]} ; sc++ ))
            do
                # If the shared lib path is not a full path we need to fix it.
                if [ ${SHAREDLIBRARYS[$sc]:0:1} != "/" ]
                then
                    [ "$VERBOSE" == "yes" ] && echo "${FILES[$fc]}"
                    [ "$VERBOSE" == "yes" ] && echo "${SHAREDLIBRARYS[$sc]}"
                    [ "$VERBOSE" == "yes" ] && echo "find ${DESTROOT} -not -type d -name ${SHAREDLIBRARYS[$sc]}"
                    # Try and find the lib in DESTROOT
                    FOUNDPATH=$(find ${DESTROOT} -not -type d -name ${SHAREDLIBRARYS[$sc]} | sed "s,^${DESTROOT},,")
                    echo "${FOUNDPATH}"
                    # Fix the path.
                    install_name_tool -change "${SHAREDLIBRARYS[$sc]}" "${FOUNDPATH}" "${FILES[$fc]}" 2>/dev/null
                fi
            done
            # After fix test.
            SHAREDLIBRARYS=( $(otool -XL "${FILES[$fc]}" | sed -e "s/^Archive.*//" | tr -d '\t' | awk '{print $1}') )
            for (( sc = 0 ; sc < ${#SHAREDLIBRARYS[@]} ; sc++ ))
            do
                # Look for each shared files path.
                # Also prepend DESTROOT to each path as we may be installing the path from DESTROOT now.
                if [[ ! -f "${DESTROOT}${SHAREDLIBRARYS[$sc]}" && ! -f "${SHAREDLIBRARYS[$sc]}" ]]
                then
                    echo "${FILES[$fc]}"
                    echo "${SHAREDLIBRARYS[$sc]}"
                    exit 1
                fi
            done
            [ "$VERBOSE" == "yes" ] && otool -XL "${FILES[$fc]}"
            [ "$STOP" == "yes" ] && break 2
        fi
    fi
done
unset IFS
