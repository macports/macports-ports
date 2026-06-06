on open theFiles
    repeat with oneFile in theFiles
        set srcPath to POSIX path of oneFile
        set tmpPath to do shell script "/usr/bin/mktemp -t remote-viewer-vv"

        do shell script "/bin/cp " & quoted form of srcPath & " " & quoted form of tmpPath
        try
            do shell script "/usr/bin/grep -q '^delete-this-file[[:space:]]*=[[:space:]]*[^0[:space:]]' " & quoted form of srcPath
            do shell script "/bin/rm -f " & quoted form of srcPath
        end try
        do shell script "@PREFIX@/bin/remote-viewer " & quoted form of tmpPath & " > /dev/null 2>&1 &"@PRIVILEGES@
    end repeat
end open

on run
    do shell script "@PREFIX@/bin/remote-viewer > /dev/null 2>&1 &"@PRIVILEGES@
end run
