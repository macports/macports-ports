--- cryptkrn.c.orig	2005-04-04 05:49:55.000000000 -0400
+++ cryptkrn.c	2005-04-04 05:51:35.000000000 -0400
@@ -1108,6 +1108,10 @@
 	return( currentPerm );
 	}
 
+static int setPropertyAttribute( const int objectHandle,
+								 const CRYPT_ATTRIBUTE_TYPE attribute,
+								 void *messageDataPtr );
+
 /* Update the action permissions for an object based on the composite
    permissions for it and a dependent object.  This is a special-case
    function because it has to operate with the object table unlocked.  This
@@ -1125,9 +1129,6 @@
 static int updateDependentObjectPerms( const CRYPT_HANDLE objectHandle,
 									   const CRYPT_HANDLE dependentObject )
 	{
-	STATIC_FN int setPropertyAttribute( const int objectHandle,
-										const CRYPT_ATTRIBUTE_TYPE attribute,
-										void *messageDataPtr );
 	const OBJECT_TYPE objectType = objectTable[ objectHandle ].type;
 	const CRYPT_CONTEXT contextHandle = \
 		( objectType == OBJECT_TYPE_CONTEXT ) ? objectHandle : dependentObject;
@@ -2101,6 +2102,9 @@
 			FALSE : TRUE );
 	}
 
+static int cloneContext( const CRYPT_CONTEXT iDestContext,
+						 const CRYPT_CONTEXT iSrcContext );
+
 /* Handle an object that has been cloned and is subject to copy-on-write */
 
 static int handleAliasedObject( const int objectHandle,
@@ -2108,8 +2112,6 @@
 								const void *messageDataPtr,
 								const int messageValue )
 	{
-	STATIC_FN int cloneContext( const CRYPT_CONTEXT iDestContext,
-								const CRYPT_CONTEXT iSrcContext );
 	OBJECT_INFO *objectInfoPtr =  &objectTable[ objectHandle ];
 	CRYPT_CONTEXT originalObject = objectHandle;
 	CRYPT_CONTEXT clonedObject = objectInfoPtr->clonedObject;
