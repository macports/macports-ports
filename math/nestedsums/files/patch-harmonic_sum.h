--- nestedsums/harmonic_sum.h.sav	Sat Oct  9 12:25:15 2004
+++ nestedsums/harmonic_sum.h	Sat Oct  9 12:28:27 2004
@@ -91,9 +91,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::harmonic_sum &GiNaC::ex_to<nestedsums::harmonic_sum>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::harmonic_sum &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_HARMONIC_SUM_H__
