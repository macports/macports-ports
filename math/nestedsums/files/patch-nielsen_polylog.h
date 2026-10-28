--- nestedsums/nielsen_polylog.h.sav	Sat Oct  9 12:25:52 2004
+++ nestedsums/nielsen_polylog.h	Sat Oct  9 12:30:05 2004
@@ -76,9 +76,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::nielsen_polylog &GiNaC::ex_to<nestedsums::nielsen_polylog>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::nielsen_polylog &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_NIELSEN_POLYLOG_H__
