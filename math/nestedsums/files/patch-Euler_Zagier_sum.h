--- nestedsums/Euler_Zagier_sum.h.sav	Sat Oct  9 12:24:36 2004
+++ nestedsums/Euler_Zagier_sum.h	Sat Oct  9 12:26:33 2004
@@ -90,9 +90,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::Euler_Zagier_sum &GiNaC::ex_to<nestedsums::Euler_Zagier_sum>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::Euler_Zagier_sum &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_EULER_ZAGIER_SUM_H__
