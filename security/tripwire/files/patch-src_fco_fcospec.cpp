--- src/fco/fcospec.cpp.orig	2005-09-16 13:12:38.000000000 +1000
+++ src/fco/fcospec.cpp	2013-03-08 07:54:32.000000000 +1100
@@ -51,6 +51,7 @@
 class cDefaultSpecMask : public iFCOSpecMask
 {
 public:
+	cDefaultSpecMask(){};
 	virtual const TSTRING& GetName() const;
 	virtual bool Accept(const iFCO* pFCO) const;
 private:
