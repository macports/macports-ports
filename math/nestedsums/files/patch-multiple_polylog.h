--- nestedsums/multiple_polylog.h.sav	Sat Oct  9 12:25:37 2004
+++ nestedsums/multiple_polylog.h	Sat Oct  9 12:29:19 2004
@@ -89,9 +89,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::multiple_polylog &GiNaC::ex_to<nestedsums::multiple_polylog>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::multiple_polylog &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_MULTIPLE_POLYLOG_H__
