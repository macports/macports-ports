--- install.sh.orig	2007-05-27 23:49:11 +0200
+++ install.sh	2007-05-27 23:50:56 +0200
@@ -123,15 +123,15 @@
 if [ -d DOCS ]
 then
    echo "- installing ${DEST_DIR}${DEST_MAN}/man1/7z.1"
-   sed -e s?"{DEST_SHARE_DOC}"?"${DEST_DIR}${DEST_SHARE_DOC}/DOCS"?g man1/7z.1 > ${DEST_DIR}${DEST_MAN}/man1/7z.1
+   sed -e s?"{DEST_SHARE_DOC}"?"${DEST_SHARE_DOC}/DOCS"?g man1/7z.1 > ${DEST_DIR}${DEST_MAN}/man1/7z.1
    chmod 444 ${DEST_DIR}${DEST_MAN}/man1/7z.1
 
    echo "- installing ${DEST_DIR}${DEST_MAN}/man1/7za.1"
-   sed -e s?"{DEST_SHARE_DOC}"?"${DEST_DIR}${DEST_SHARE_DOC}/DOCS"?g man1/7za.1 > ${DEST_DIR}${DEST_MAN}/man1/7za.1
+   sed -e s?"{DEST_SHARE_DOC}"?"${DEST_SHARE_DOC}/DOCS"?g man1/7za.1 > ${DEST_DIR}${DEST_MAN}/man1/7za.1
    chmod 444 ${DEST_DIR}${DEST_MAN}/man1/7za.1
 
    echo "- installing ${DEST_DIR}${DEST_MAN}/man1/7zr.1"
-   sed -e s?"{DEST_SHARE_DOC}"?"${DEST_DIR}${DEST_SHARE_DOC}/DOCS"?g man1/7zr.1 > ${DEST_DIR}${DEST_MAN}/man1/7zr.1
+   sed -e s?"{DEST_SHARE_DOC}"?"${DEST_SHARE_DOC}/DOCS"?g man1/7zr.1 > ${DEST_DIR}${DEST_MAN}/man1/7zr.1
    chmod 444 ${DEST_DIR}${DEST_MAN}/man1/7zr.1
 else
    echo "- installing ${DEST_DIR}${DEST_MAN}/man1/7z.1"
