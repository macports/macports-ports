--- cert/certechk.c.orig	2005-04-04 05:26:06.000000000 -0400
+++ cert/certechk.c	2005-04-04 05:26:54.000000000 -0400
@@ -331,9 +331,10 @@
 	return( CRYPT_OK );
 	}
 
+static int checkAttribute( ATTRIBUTE_CHECK_INFO *attributeCheckInfo );
+
 static int checkAttributeEntry( ATTRIBUTE_CHECK_INFO *attributeCheckInfo )
 	{
-	STATIC_FN int checkAttribute( ATTRIBUTE_CHECK_INFO *attributeCheckInfo );
 	ATTRIBUTE_LIST *attributeListPtr = attributeCheckInfo->attributeListPtr;
 	ATTRIBUTE_INFO *attributeInfoPtr = attributeCheckInfo->attributeInfoPtr;
 	ATTRIBUTE_STACK *stack = attributeCheckInfo->stack;
