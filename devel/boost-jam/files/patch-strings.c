--- strings.c.orig	2008-07-31 02:16:29.000000000 -0700
+++ strings.c	2008-07-31 02:16:47.000000000 -0700
@@ -65,7 +65,7 @@
     if ( self->value == self->opt )
     {
         self->value = (char*)BJAM_MALLOC_ATOMIC( capacity + JAM_STRING_MAGIC_SIZE );
-        self->value[0] = 0;
+        memset( self->value, '\0', capacity + JAM_STRING_MAGIC_SIZE );
         strncat( self->value, self->opt, sizeof(self->opt) );
         assert( strlen( self->value ) <= self->capacity ); /* This is a regression test */
     }
