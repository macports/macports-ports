--- src/js/js.h.orig	Sun Nov 30 15:16:19 2003
+++ src/js/js.h	Wed Sep 22 11:15:01 2004
@@ -32,106 +32,18 @@
 
 #define _JS_MAX_AXES 16
 #define _JS_MAX_BUTTONS 32
-
-#ifdef UL_MACINTOSH
-#  include <InputSprocket.h>
-#endif
-
-#ifdef UL_MAC_OSX
-#  include <mach/mach.h>
-#  include <IOKit/IOkitLib.h>
-#  include <IOKit/hid/IOHIDLib.h>
-#endif
-
-#ifdef UL_LINUX 
-#    include <sys/ioctl.h>
-#    include <linux/joystick.h>
-
-/* check the joystick driver version */
-
-#if defined(JS_VERSION) && JS_VERSION >= 0x010000
-#  define JS_NEW
-#endif
-#endif
+#define _JS_MAX_HATS 4
 
 #define JS_TRUE  1
 #define JS_FALSE 0
 
-#ifndef JS_RETURN
-
- /*
-   We'll put these values in and that should
-   allow the code to at least compile when there is
-   no support. The JS open routine should error out
-   and shut off all the code downstream anyway
- */
-
-  struct JS_DATA_TYPE
-  {
-    int buttons ;
-    int x ;
-    int y ;
-  } ;
-
-#  define JS_RETURN (sizeof(struct JS_DATA_TYPE))
-#endif
 
 class jsJoystick
 {
   int          id ;
-
-#if defined(UL_MACINTOSH)
-
-#define  isp_num_axis   9
-#define  isp_num_needs  41
-  ISpElementReference isp_elem  [ isp_num_needs ] ;
-  ISpNeed             isp_needs [ isp_num_needs ] ;
-
-#elif defined(UL_BSD)
+protected:
   struct os_specific_s *os ;
-#elif defined(UL_MAC_OSX)
-
-  IOHIDDeviceInterface ** hidDev;
-  static const int kNumDevices;
-  static int numDevices;
-  static io_object_t ioDevices[kNumDevices];
-
-  static void findDevices(mach_port_t);
-  static CFDictionaryRef getCFProperties(io_object_t);
-
-  void enumerateElements(CFTypeRef element);
-  /// callback for CFArrayApply
-  static void elementEnumerator( const void *element, void* vjs);
-  void parseElement(CFDictionaryRef element);
-
-  void addAxisElement(CFDictionaryRef axis);
-  void addButtonElement(CFDictionaryRef button);
-  void addHatElement(CFDictionaryRef hat);
-
-  IOHIDElementCookie buttonCookies[41];
-  IOHIDElementCookie axisCookies[_JS_MAX_AXES];
-  long minReport[_JS_MAX_AXES],
-       maxReport[_JS_MAX_AXES];
-
-#elif defined(UL_WIN32)
-  JOYCAPS      jsCaps ;
-  JOYINFOEX    js     ;
-  UINT         js_id  ;
-  bool getOEMProductName ( char *buf, int buf_sz ) ;
-#else
-
-#ifdef JS_NEW
-  js_event     js          ;
-  int          tmp_buttons ;
-  float        tmp_axes [ _JS_MAX_AXES ] ;
-# else
-  JS_DATA_TYPE js ;
-# endif
-
-  char         fname [ 128 ] ;
-  int          fd ;
-#endif
-
+  friend struct os_specific_s ;
   int          error        ;
   char         name [ 128 ] ;
   int          num_axes     ;
@@ -143,7 +55,6 @@
   float max       [ _JS_MAX_AXES ] ;
   float min       [ _JS_MAX_AXES ] ;
 
-
   void open () ;
   void close () ;
 
@@ -175,9 +86,11 @@
 
   void read    ( int *buttons, float *axes ) ;
   void rawRead ( int *buttons, float *axes ) ;
+  // bool SetForceFeedBack ( int axe, float force );
 } ;
 
 extern void jsInit () ;
 
 #endif
+
 
