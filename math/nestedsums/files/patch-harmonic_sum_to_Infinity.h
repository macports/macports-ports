--- nestedsums/harmonic_sum_to_Infinity.h.sav	Sat Oct  9 12:25:27 2004
+++ nestedsums/harmonic_sum_to_Infinity.h	Sat Oct  9 12:28:56 2004
@@ -73,9 +73,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::harmonic_sum_to_Infinity &GiNaC::ex_to<nestedsums::harmonic_sum_to_Infinity>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::harmonic_sum_to_Infinity &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_HARMONIC_SUM_TO_INFINITY_H__
