--- libgnomeprint/gnome-print-pclc.c.org	Sun Jul 23 04:59:09 2000
+++ libgnomeprint/gnome-print-pclc.c	Sat Jun  8 17:48:30 2002
@@ -16,6 +16,8 @@
 4.  The application and the print dialog will load the
     job specific parameters */
 
+PCLJobData * jobdata;
+
 void
 pclc_new_job_data (void)
 {
