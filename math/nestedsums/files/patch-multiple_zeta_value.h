--- nestedsums/multiple_zeta_value.h.sav	Sat Oct  9 12:25:45 2004
+++ nestedsums/multiple_zeta_value.h	Sat Oct  9 12:29:43 2004
@@ -84,9 +84,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::multiple_zeta_value &GiNaC::ex_to<nestedsums::multiple_zeta_value>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::multiple_zeta_value &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_MULTIPLE_ZETA_VALUE_H__
