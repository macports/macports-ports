--- install/install.sh		Sat Sep  1 19:54:34 2007
+++ install/install.sh		Sun Sep  2 07:10:58 2007
@@ -19,10 +19,6 @@
 
 PATH='.:/bin:/usr/bin'
 export PATH || (echo 'You must use sh to run this script'; kill $$)
-if [ ! -t 0 ] ; then
-	echo "Say 'sh install.sh', not 'sh < install.sh'"
-	exit 1
-fi
 
 ##-------------------------------------------------------
 ## The usage message.
@@ -262,9 +258,8 @@
 ##-------------------------------------------------------
 
 paths="TWBIN TWMAN TWPOLICY TWREPORT TWDB TWSITEKEYDIR TWLOCALKEYDIR"
-path2="TWBIN TWPOLICY TWREPORT TWDB TWSITEKEYDIR TWLOCALKEYDIR"
-path3="TWMAN TWDOCS"
-
+path2="TWPOLICY TWDB TWREPORT TWSITEKEYDIR TWLOCALKEYDIR"
+path3="TWBIN TWMAN TWDOCS"
 ##=======================================================
 ## User License Agreement
 ##=======================================================
@@ -279,6 +274,12 @@
 ##-------------------------------------------------------
 
 if [ "$PROMPT" = "true" ] ; then
+
+  if [ ! -t 0 ] ; then
+       echo "Say 'sh install.sh', not 'sh < install.sh'"
+       exit 1
+  fi
+
   echo
   echo "LICENSE AGREEMENT for Tripwire(R) 2.4 Open Source"
   echo
@@ -474,6 +475,14 @@
 		eval "echo \"\$${i}\""
 	fi
 done
+if [ -n "$DESTDIR" ]; then
+       echo
+       echo "Using destination root directory:"
+       echo "  $DESTDIR"
+       echo
+else
+       DESTDIR=""
+fi
 
 ##-------------------------------------------------------
 ## Display value of clobber.
@@ -514,7 +523,7 @@
 ##-------------------------------------------------------
 
 for i in $path2; do
-	eval "d=\$${i}"
+	eval "d=$DESTDIR\$${i}"
 	if [ ! -d "$d" ] ; then
 		mkdir -p "$d"
 		if [ ! -d "$d" ] ; then
@@ -530,7 +539,7 @@
 done
 
 for i in $path3; do
-	eval "d=\$${i}"
+	eval "d=$DESTDIR\$${i}"
 	if [ ! -d "$d" ] ; then
 		mkdir -p "$d"
 		if [ ! -d "$d" ] ; then
@@ -591,11 +600,11 @@
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
@@ -628,7 +637,7 @@
 ## If user has to enter a passphrase, give some
 ## advice about what is appropriate.
 ##-------------------------------------------------------
-
+if [ -z "$DESTDIR" ]; then
 if [ -z "$TW_SITE_PASS" ] || [ -z "$TW_LOCAL_PASS" ]; then
 cat << END_OF_TEXT
 
@@ -676,7 +685,7 @@
 	if [ $? -ne 0 ] ; then
 		echo "Error: site key generation failed"
 		exit 1
-        else chmod 640 "$SITE_KEY"
+        else chmod 0640 "$SITE_KEY"
 	fi
 fi
 
@@ -704,9 +713,10 @@
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
@@ -716,7 +726,7 @@
 echo "----------------------------------------------"
 echo "Generating Tripwire configuration file..."
 
-cat << END_OF_TEXT > "$TXT_CFG"
+cat << END_OF_TEXT > "$DESTDIR$TXT_CFG"
 ROOT          =$TWBIN
 POLFILE       =$POLICY_FILE
 DBFILE        =$TWDB/\$(HOSTNAME).twd
@@ -734,27 +744,27 @@
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
-
+if [ -z "$DESTDIR" ]; then
 echo
 echo "----------------------------------------------"
 echo "Creating signed configuration file..."
@@ -796,7 +806,7 @@
 fi
 
 # Set the rights properly
-chmod 640 "$CONFIG_FILE"
+chmod 0640 "$CONFIG_FILE"
 
 ##-------------------------------------------------------
 ## We keep the cleartext version around.
@@ -810,6 +820,7 @@
 that you delete this file manually after you have examined it.
 
 END_OF_TEXT
+fi
 
 ##=======================================================
 ## Modify default policy file with file locations
@@ -820,6 +831,7 @@
 echo "Customizing default policy file..."
 
 sed '/@@section GLOBAL/,/@@section FS/  {
+  s?^\(PREFIX=\).*$?\1'\""$prefix"\"';?
   s?^\(TWROOT=\).*$?TWDOCS='\""$TWDOCS"\"';?
   s?^\(TWBIN=\).*$?\1'\""$TWBIN"\"';?
   s?^\(TWPOL=\).*$?\1'\""$TWPOLICY"\"';?
@@ -828,22 +840,22 @@
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
-
+if [ -z "$DESTDIR" ]; then
 echo
 echo "----------------------------------------------"
 echo "Creating signed policy file..."
@@ -902,6 +914,7 @@
 a new signed copy of the Tripwire policy.
 
 END_OF_TEXT
+fi
 
 ##=======================================================
 ## Clean-up.
