--- src/common/chapter_parser_xml.cpp	Sat Aug 21 11:41:46 2004
+++ src/common/chapter_parser_xml.cpp	Mon Sep 27 17:13:57 2004
@@ -224,16 +224,16 @@
     pdata->data_allowed = true;
 
   } else if (!strcmp(name, "EditionManaged")) {
-    KaxEditionManaged *emanaged;
+    KaxEditionProcessed *emanaged;
 
     if (strcmp(parent_name, "EditionEntry"))
       cperror_nochild();
 
     m = static_cast<EbmlMaster *>(parent_elt);
-    if (m->FindFirstElt(KaxEditionManaged::ClassInfos, false) != NULL)
+    if (m->FindFirstElt(KaxEditionProcessed::ClassInfos, false) != NULL)
       cperror_oneinstance();
 
-    emanaged = new KaxEditionManaged;
+    emanaged = new KaxEditionProcessed;
     m->PushElement(*emanaged);
     pdata->parents->push_back(emanaged);
     pdata->data_allowed = true;
