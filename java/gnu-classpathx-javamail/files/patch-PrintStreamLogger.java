--- source/gnu/mail/util/PrintStreamLogger.java	Sun Jun 13 20:10:26 2004
+++ source/gnu/mail/util/PrintStreamLogger.java.new	Tue Mar 29 17:52:56 2005
@@ -70,5 +70,9 @@
     System.err.print(": ");
     System.err.println(message);
   }
+
+  public void error(String protocol, Throwable t)
+  {
+  }
   
 }
