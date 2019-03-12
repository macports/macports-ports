--- lib/IlmCtlSimd/CtlSimdInst.cpp.orig	2014-06-03 01:11:24 UTC
+++ lib/IlmCtlSimd/CtlSimdInst.cpp
@@ -189,7 +189,7 @@ SimdInst::executePath (SimdBoolMask &mas
 	    REPLACE_EXC
 		(e, "\n" <<
 		 xcontext.fileName() << ":" <<
-		 inst->lineNumber() << ": " << e);
+		 inst->lineNumber() << ": " << e.what());
 
 	    throw e;
 	}
