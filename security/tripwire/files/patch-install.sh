--- tripwire-2.3.1-2.orig/install/install.sh	Tue Apr 27 17:09:17 2004
+++ tripwire-2.3.1-2/install/install.sh	Wed Apr 28 12:04:20 2004
@@ -19,10 +19,6 @@
 
 PATH='.:/bin:/usr/bin'
 export PATH || (echo 'You must use sh to run this script'; kill $$)
-if [ ! -t 0 ] ; then
-	echo "Say 'sh install.sh', not 'sh < install.sh'"
-	exit 1
-fi
 
 ##-------------------------------------------------------
 ## The usage message.
@@ -268,8 +264,8 @@
 ##-------------------------------------------------------
 
 paths="TWBIN TWMAN TWPOLICY TWREPORT TWDB TWSITEKEYDIR TWLOCALKEYDIR"
-path2="TWBIN TWPOLICY TWREPORT TWDB TWSITEKEYDIR TWLOCALKEYDIR"
-path3="TWMAN TWDOCS"
+path2="TWPOLICY TWDB TWREPORT TWSITEKEYDIR TWLOCALKEYDIR"
+path3="TWBIN TWMAN TWDOCS"
 
 ##=======================================================
 ## User License Agreement
@@ -285,6 +281,10 @@
 ##-------------------------------------------------------
 
 if [ "$PROMPT" = "true" ] ; then
+  if [ ! -t 0 ] ; then
+	echo "Say 'sh install.sh', not 'sh < install.sh'"
+	exit 1
+  fi
   echo
   echo "LICENSE AGREEMENT for Tripwire(R) 2.3 Open Source"
   echo
@@ -479,6 +479,14 @@
 		eval "echo \"\$${i}\""
 	fi
 done
+if [ -n "$DESTDIR" ]; then
+	echo
+	echo "Using destination root directory:"
+	echo "  $DESTDIR"
+	echo
+else
+	DESTDIR=""
+fi
 
 ##-------------------------------------------------------
 ## Display value of clobber.
@@ -519,7 +527,7 @@
 ##-------------------------------------------------------
 
 for i in $path2; do
-	eval "d=\$${i}"
+	eval "d=$DESTDIR\$${i}"
 	if [ ! -d "$d" ] ; then
 		mkdir -p "$d"
 		if [ ! -d "$d" ] ; then
@@ -535,7 +543,7 @@
 done
 
 for i in $path3; do
-	eval "d=\$${i}"
+	eval "d=$DESTDIR\$${i}"
 	if [ ! -d "$d" ] ; then
 		mkdir -p "$d"
 		if [ ! -d "$d" ] ; then
@@ -598,11 +606,11 @@
 for i in $loosefiles; do
 	eval "eval \"\$$i\""
 	f=${TAR_DIR}$d/$ff
-	ff=${dd}/$ff
+	ff=$DESTDIR${dd}/$ff
 	if [ -s $ff ] && [ "$CLOBBER" = "false" ] ; then
 		echo "$ff: file already exists"
 	else
-		cp "$f" "$dd"
+		cp "$f" "$DESTDIR$dd"
                 if [ $? -eq 0 ]; then
 			echo "$ff: copied"
 			    chmod "$rr" "$ff" > /dev/null
@@ -636,6 +644,7 @@
 ## advice about what is appropriate.
 ##-------------------------------------------------------
 
+if [ -z "$DESTDIR" ]; then
 if [ -z "$TW_SITE_PASS" ] || [ -z "$TW_LOCAL_PASS" ]; then
 cat << END_OF_TEXT
 
@@ -683,7 +692,7 @@
 	if [ $? -ne 0 ] ; then
 		echo "Error: site key generation failed"
 		exit 1
-        else chmod 640 "$SITE_KEY"
+        else chmod 0640 "$SITE_KEY"
 	fi
 fi
 
@@ -711,9 +720,10 @@
 	if [ $? -ne 0 ] ; then
 		echo "Error: local key generation failed"
 		exit 1
-        else chmod 640 "$LOCAL_KEY"
+        else chmod 0640 "$LOCAL_KEY"
 	fi
 fi
+fi
 
 ##=======================================================
 ## Generate tripwire configuration file.
@@ -723,7 +733,7 @@
 echo "----------------------------------------------"
 echo "Generating Tripwire configuration file..."
 
-cat << END_OF_TEXT > "$TXT_CFG"
+cat << END_OF_TEXT > "$DESTDIR$TXT_CFG"
 ROOT          =$TWBIN
 POLFILE       =$POLICY_FILE
 DBFILE        =$TWDB/\$(HOSTNAME).twd
@@ -741,27 +751,28 @@
 END_OF_TEXT
 
 if [ "$TWMAILMETHOD" = "SMTP" ] ; then
-cat << SMTP_TEXT >> "$TXT_CFG"
+cat << SMTP_TEXT >> "$DESTDIR$TXT_CFG"
 SMTPHOST      =${TWSMTPHOST:-mail.domain.com}
 SMTPPORT      =${TWSMTPPORT:-"25"}
 SMTP_TEXT
 else
-cat << SENDMAIL_TEXT >> "$TXT_CFG"
+cat << SENDMAIL_TEXT >> "$DESTDIR$TXT_CFG"
 MAILPROGRAM   =$TWMAILPROGRAM
 SENDMAIL_TEXT
 fi
 
-if [ ! -s "$TXT_CFG" ] ; then
-	echo "Error: unable to create $TXT_CFG"
+if [ ! -s "$DESTDIR$TXT_CFG" ] ; then
+	echo "Error: unable to create $DESTDIR$TXT_CFG"
 	exit 1
 fi
 
-chmod 640 "$TXT_CFG"
+chmod 0640 "$DESTDIR$TXT_CFG"
 
 ##=======================================================
 ## Create signed tripwire configuration file.
 ##=======================================================
 
+if [ -z "$DESTDIR" ]; then
 echo
 echo "----------------------------------------------"
 echo "Creating signed configuration file..."
@@ -803,7 +814,7 @@
 fi
 
 # Set the rights properly
-chmod 640 "$CONFIG_FILE"
+chmod 0640 "$CONFIG_FILE"
 
 ##-------------------------------------------------------
 ## We keep the cleartext version around.
@@ -817,6 +828,7 @@
 that you delete this file manually after you have examined it.
 
 END_OF_TEXT
+fi
 
 ##=======================================================
 ## Modify default policy file with file locations
@@ -827,6 +839,7 @@
 echo "Customizing default policy file..."
 
 sed '/@@section GLOBAL/,/@@section FS/  {
+  s?^\(PREFIX=\).*$?\1'\""$prefix"\"';?
   s?^\(TWROOT=\).*$?TWDOCS='\""$TWDOCS"\"';?
   s?^\(TWBIN=\).*$?\1'\""$TWBIN"\"';?
   s?^\(TWPOL=\).*$?\1'\""$TWPOLICY"\"';?
@@ -835,22 +848,23 @@
   s?^\(TWLKEY=\).*$?\1'\""$TWLOCALKEYDIR"\"';?
   s?^\(TWREPORT=\).*$?\1'\""$TWREPORT"\"';?
   s?^\(HOSTNAME=\).*$?\1'"$HOST_NAME"';?
-}' "${TWPOLICY}/${POLICYSRC}" > "${TXT_POL}.tmp"
+}' "$DESTDIR${TWPOLICY}/${POLICYSRC}" > "$DESTDIR${TXT_POL}.tmp"
 
 # copy the tmp file back over the default policy
-[ -f "${TXT_POL}" ] && cp "${TXT_POL}" "${TXT_POL}.bak"
-mv "${TXT_POL}.tmp" "${TXT_POL}"
-rm -f "${TWPOLICY}/${POLICYSRC}"
-
-# reset rights on the policy files to 640
-[ -f "${TXT_POL}" ] && chmod 640 "$TXT_POL"
-[ -f "${TXT_POL}.bak" ] && chmod 640 "${TXT_POL}.bak"
+[ -f "$DESTDIR${TXT_POL}" ] && cp "$DESTDIR${TXT_POL}" "$DESTDIR${TXT_POL}.bak"
+mv "$DESTDIR${TXT_POL}.tmp" "$DESTDIR${TXT_POL}"
+rm -f "$DESTDIR${TWPOLICY}/${POLICYSRC}"
+
+# reset rights on the policy files to 0640
+[ -f "$DESTDIR${TXT_POL}" ] && chmod 0640 "$DESTDIR$TXT_POL"
+[ -f "$DESTDIR${TXT_POL}.bak" ] && chmod 0640 "$DESTDIR${TXT_POL}.bak"
 
 
 ##=======================================================
 ## Create signed tripwire policy file.
 ##=======================================================
 
+if [ -z "$DESTDIR" ]; then
 echo
 echo "----------------------------------------------"
 echo "Creating signed policy file..."
@@ -909,6 +923,7 @@
 a new signed copy of the Tripwire policy.
 
 END_OF_TEXT
+fi
 
 ##=======================================================
 ## Clean-up.
