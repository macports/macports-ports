--- cryptcfg.c.orig	2005-04-04 05:48:18.000000000 -0400
+++ cryptcfg.c	2005-04-04 05:49:25.000000000 -0400
@@ -674,7 +674,7 @@
 						   sizeofObject( strlen( optionInfoPtr->strValue ) ) );
 			writeShortInteger( &stream, fixedOptionInfoPtr->index,
 							   DEFAULT_TAG );
-			writeCharacterString( &stream, optionInfoPtr->strValue,
+			writeCharacterString( &stream, (unsigned char *)optionInfoPtr->strValue,
 								  strlen( optionInfoPtr->strValue ),
 								  BER_STRING_UTF8 );
 			continue;
