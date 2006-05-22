Index: agent/mibgroup/host/hr_storage.c
===================================================================
RCS file: /cvsroot/net-snmp/net-snmp/agent/mibgroup/host/hr_storage.c,v
retrieving revision 5.22
diff -u -p -r5.22 hr_storage.c
--- agent/mibgroup/host/hr_storage.c	31 Oct 2005 09:14:38 -0000	5.22
+++ agent/mibgroup/host/hr_storage.c	14 Feb 2006 21:00:12 -0000
@@ -732,11 +732,6 @@ really_try_next:
             case HRS_TYPE_SWAP:
                 long_return = -1;
 	        break;
-#if defined(MBSTAT_SYMBOL)
-	    case HRS_TYPE_MBUF:
-                long_return = mbstat.m_mbufs;
-                break; 
-#endif
 #elif defined(TOTAL_MEMORY_SYMBOL) || defined(USE_SYSCTL_VM)
             case HRS_TYPE_MEM:
                 long_return = memory_totals.t_rm;
