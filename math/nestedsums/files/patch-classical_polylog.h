--- nestedsums/classical_polylog.h.sav	Sat Oct  9 12:24:53 2004
+++ nestedsums/classical_polylog.h	Sat Oct  9 12:27:43 2004
@@ -68,9 +68,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::classical_polylog &GiNaC::ex_to<nestedsums::classical_polylog>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::classical_polylog &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_CLASSICAL_POLYLOG_H__
