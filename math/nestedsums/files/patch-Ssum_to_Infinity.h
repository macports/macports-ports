--- nestedsums/Ssum_to_Infinity.h.sav	Sat Oct  9 12:24:46 2004
+++ nestedsums/Ssum_to_Infinity.h	Sat Oct  9 12:26:57 2004
@@ -71,9 +71,11 @@
 } // namespace nestedsums
 
   // template specialization
+namespace GiNaC {
 template<> inline const nestedsums::Ssum_to_Infinity &GiNaC::ex_to<nestedsums::Ssum_to_Infinity>(const GiNaC::ex &e)
   {
     return dynamic_cast<const nestedsums::Ssum_to_Infinity &>(*e.bp);
   }
+} // namespace GiNaC
 
 #endif // ndef __NESTEDSUMS_SSUM_TO_INFINITY_H__
