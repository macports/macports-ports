--- src/fault-macos-powerpc.h.orig	Wed Apr  2 12:56:20 2003
+++ src/fault-macos-powerpc.h	Tue Aug 10 21:17:54 2004
@@ -15,12 +15,14 @@
    along with this program; if not, write to the Free Software Foundation,
    Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
 
+#include <sys/ucontext.h>
 #include "fault-macos-powerpc.c"
 
-#define SIGSEGV_FAULT_HANDLER_ARGLIST  int sig, int code, struct sigcontext *scp
-#define SIGSEGV_FAULT_ADDRESS  (unsigned long) get_fault_addr (scp)
+#define SIGSEGV_FAULT_HANDLER_ARGLIST  int sig, siginfo_t *sip, struct sigcontext *scp
+#define SIGSEGV_FAULT_ADDRESS  (unsigned long) get_fault_addr (scp, sip->si_addr)
 #define SIGSEGV_FAULT_CONTEXT  scp
 #if 0
 #define SIGSEGV_FAULT_STACKPOINTER  (&((unsigned int *) scp->sc_regs)[2])[1]
 #endif
 #define SIGSEGV_FAULT_STACKPOINTER  (scp->sc_regs ? ((unsigned int *) scp->sc_regs)[3] : scp->sc_sp)
+#define SIGSEGV_FAULT_ADDRESS_FROM_SIGINFO
