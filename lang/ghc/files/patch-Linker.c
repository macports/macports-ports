--- ghc/rts/Linker.c.sav	Fri Aug 15 12:00:27 2003
+++ ghc/rts/Linker.c	Tue Aug 12 10:51:17 2003
@@ -813,11 +813,17 @@
     val = lookupStrHashTable(symhash, lbl);
 
     if (val == NULL) {
+      void * sym;
 #       if defined(OBJFORMAT_ELF) || defined(OBJFORMAT_MACHO)
-	return dlsym(dl_prog_handle, lbl);
+      if (lbl[0] == '_')
+	if ((sym = dlsym(dl_prog_handle, (lbl + 1))))
+	  return sym;
+      else
+        return dlsym(dl_prog_handle, lbl);
+
 #       elif defined(OBJFORMAT_PEi386)
+
         OpenedDLL* o_dll;
-        void* sym;
         for (o_dll = opened_dlls; o_dll != NULL; o_dll = o_dll->next) {
 	  /* fprintf(stderr, "look in %s for %s\n", o_dll->name, lbl); */
            if (lbl[0] == '_') {
