--- nestedsums/harmonic_polylog.h.sav	Sat Oct  9 12:25:05 2004
+++ nestedsums/harmonic_polylog.h	Sat Oct  9 12:28:02 2004
@@ -75,9 +75,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::harmonic_polylog &GiNaC::ex_to<nestedsums::harmonic_polylog>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::harmonic_polylog &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_HARMONIC_POLYLOG_H__
