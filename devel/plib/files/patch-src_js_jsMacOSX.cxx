--- src/js/jsMacOSX.cxx.orig	Thu Mar 18 18:20:07 2004
+++ src/js/jsMacOSX.cxx	Wed Sep 22 11:15:56 2004
@@ -1,7 +1,33 @@
+/*
+     PLIB - A Suite of Portable Game Libraries
+     Copyright (C) 1998,2002  Steve Baker
+
+     This library is free software; you can redistribute it and/or
+     modify it under the terms of the GNU Library General Public
+     License as published by the Free Software Foundation; either
+     version 2 of the License, or (at your option) any later version.
+
+     This library is distributed in the hope that it will be useful,
+     but WITHOUT ANY WARRANTY; without even the implied warranty of
+     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+     Library General Public License for more details.
+
+     You should have received a copy of the GNU Library General Public
+     License along with this library; if not, write to the Free Software
+     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+
+     For further information visit http://plib.sourceforge.net
+
+     $Id: patch-src_js_jsMacOSX.cxx,v 1.1 2004/09/23 03:25:39 blb Exp $
+*/
+
 #include "js.h"
 
-#ifdef UL_MAC_OSX
+#if defined (UL_MAC_OSX)
 
+#include <mach/mach.h>
+#include <IOKit/IOkitLib.h>
+#include <IOKit/hid/IOHIDLib.h>
 #include <mach/mach_error.h>
 #include <IOKit/hid/IOHIDKeys.h>
 #include <IOKit/IOCFPlugIn.h>
@@ -14,18 +40,38 @@
 #	include <Kernel/IOKit/hidsystem/IOHIDUsageTables.h>
 #endif
 
-int jsJoystick::kNumDevices = 32 ;
-int jsJoystick::numDevices = -1;
-io_object_t jsJoystick::ioDevices[kNumDevices];
+static const int kNumDevices = 32;
+static int numDevices = -1;
+static io_object_t ioDevices[kNumDevices];
+
+static int NS_hat[8] = {1, 1, 0, -1, -1, -1, 0, 1};
+static int WE_hat[8] = {0, 1, 1, 1, 0, -1, -1, -1};
+
+struct os_specific_s {
+  IOHIDDeviceInterface ** hidDev;
+  IOHIDElementCookie buttonCookies[41];
+  IOHIDElementCookie axisCookies[_JS_MAX_AXES];
+  IOHIDElementCookie hatCookies[_JS_MAX_HATS];
+  int num_hats;
+  long hat_min[_JS_MAX_HATS];
+  long hat_max[_JS_MAX_HATS];
+  
+  void enumerateElements(jsJoystick* joy, CFTypeRef element);
+  static void elementEnumerator( const void *element, void* vjs);
+  /// callback for CFArrayApply
+  void parseElement(jsJoystick* joy, CFDictionaryRef element);
+  void addAxisElement(jsJoystick* joy, CFDictionaryRef axis);
+  void addButtonElement(jsJoystick* joy, CFDictionaryRef button);
+  void addHatElement(jsJoystick* joy, CFDictionaryRef hat);
+};
 
-jsJoystick::jsJoystick(int ident) :
-	id(ident), 
-	error(JS_FALSE),
-	num_axes(0),
-	num_buttons(0)
+static void findDevices(mach_port_t);
+static CFDictionaryRef getCFProperties(io_object_t);
+
+
+void jsInit()
 {
 	if (numDevices < 0) {
-		// do first-time init (since we can't over-ride jsInit, hmm
 		numDevices = 0;
 		
 		mach_port_t masterPort;
@@ -34,33 +80,15 @@
 			ulSetError(UL_WARNING, "error getting master Mach port");
 			return;
 		}
+		
 		findDevices(masterPort);
 	}
-	
-	if (ident >= numDevices) {
-		setError();
-		return;
-	}
-	
-	// get the name now too
-	CFDictionaryRef properties = getCFProperties(ioDevices[id]);
-	CFTypeRef ref = CFDictionaryGetValue (properties, CFSTR(kIOHIDProductKey));
-	if (!ref)
-		ref = CFDictionaryGetValue (properties, CFSTR("USB Product Name"));
-			
-	if (!ref || !CFStringGetCString ((CFStringRef) ref, name, 128, CFStringGetSystemEncoding ())) {
-		ulSetError(UL_WARNING, "error getting device name");
-		name[0] = '\0';
-	}
-		
-	open();
 }
 
 /** open the IOKit connection, enumerate all the HID devices, add their
 interface references to the static array. We then use the array index
 as the device number when we come to open() the joystick. */
-
-void jsJoystick::findDevices(mach_port_t masterPort)
+static void findDevices(mach_port_t masterPort)
 {
 	CFMutableDictionaryRef hidMatch = NULL;
 	IOReturn rv = kIOReturnSuccess;
@@ -79,7 +107,7 @@
 	io_object_t ioDev;
 	
 	while ((ioDev = IOIteratorNext(hidIterator))) {
-	// filter out keyboard and mouse devices
+		// filter out keyboard and mouse devices
 		CFDictionaryRef properties = getCFProperties(ioDev);
 		long usage, page;
 		
@@ -87,30 +115,63 @@
 		CFTypeRef refUsage = CFDictionaryGetValue (properties, CFSTR(kIOHIDPrimaryUsageKey));
 		CFNumberGetValue((CFNumberRef) refUsage, kCFNumberLongType, &usage);
 		CFNumberGetValue((CFNumberRef) refPage, kCFNumberLongType, &page);
-			
+		
+		// keep only joystick devices
 		if  ( (page == kHIDPage_GenericDesktop) &&
-                      ((usage == kHIDUsage_GD_Joystick) ||
-                       (usage == kHIDUsage_GD_GamePad ) ||
-                       (usage == kHIDUsage_GD_MultiAxisController) ||
-                       (usage == kHIDUsage_GD_Hatswitch) // last two necessary ?
-                      )
-                    )
-                {
-                  // add it to the array
-		  ioDevices[numDevices++] = ioDev;
-                }
+         ((usage == kHIDUsage_GD_Joystick) ||
+          (usage == kHIDUsage_GD_GamePad)
+    // || (usage == kHIDUsage_GD_MultiAxisController)
+    // || (usage == kHIDUsage_GD_Hatswitch)
+          )
+        )
+    {
+			// add it to the array
+			ioDevices[numDevices++] = ioDev;
+    }
 	}
 	
 	IOObjectRelease(hidIterator);
 }
 
+
+jsJoystick::jsJoystick(int ident) :
+	id(ident),
+	os(NULL), 
+	error(JS_FALSE),
+	num_axes(0),
+	num_buttons(0)
+{	
+	if (ident >= numDevices) {
+		setError();
+		return;
+	}
+	
+	os = new struct os_specific_s;
+	os->num_hats = 0;
+	
+	// get the name now too
+	CFDictionaryRef properties = getCFProperties(ioDevices[id]);
+	CFTypeRef ref = CFDictionaryGetValue (properties, CFSTR(kIOHIDProductKey));
+	if (!ref)
+		ref = CFDictionaryGetValue (properties, CFSTR("USB Product Name"));
+			
+	if (!ref || !CFStringGetCString ((CFStringRef) ref, name, 128, CFStringGetSystemEncoding ())) {
+		ulSetError(UL_WARNING, "error getting device name");
+		name[0] = '\0';
+	}
+	//printf("Joystick name: %s \n", name);
+	open();
+}
+
 void jsJoystick::open()
 {
+#if 0		// test already done in the constructor
 	if (id >= numDevices) {
 		ulSetError(UL_WARNING, "device index out of range in jsJoystick::open");
 		return;
 	}
-	
+#endif
+
 	// create device interface
 	IOReturn rv;
 	SInt32 score;
@@ -127,16 +188,16 @@
 	}
 	
 	HRESULT pluginResult = (*plugin)->QueryInterface(plugin, 
-		CFUUIDGetUUIDBytes(kIOHIDDeviceInterfaceID), &(LPVOID) hidDev);
+		CFUUIDGetUUIDBytes(kIOHIDDeviceInterfaceID), (LPVOID*)&(os->hidDev) );
 		
 	if (pluginResult != S_OK)
 		ulSetError(UL_WARNING, "QI-ing IO plugin to HID Device interface failed");
 
 	(*plugin)->Release(plugin); // don't leak a ref
-	if (hidDev == NULL) return;
+	if (os->hidDev == NULL) return;
 		
 	// store the interface in this instance
-	rv = (*hidDev)->open(hidDev, 0);
+	rv = (*(os->hidDev))->open(os->hidDev, 0);
 	if (rv != kIOReturnSuccess) {
 		ulSetError(UL_WARNING, "error opening device interface");
 		return;
@@ -144,15 +205,25 @@
 	
 	CFDictionaryRef props = getCFProperties(ioDevices[id]);
 			
-	// recursively enumerate all the bits
+	// recursively enumerate all the bits (buttons, axes, hats, ...)
 	CFTypeRef topLevelElement = 
 		CFDictionaryGetValue (props, CFSTR(kIOHIDElementKey));
-	enumerateElements(topLevelElement);
-	
+	os->enumerateElements(this, topLevelElement);
 	CFRelease(props);
+	
+	// for hats to be implemented as axes: must be the last axes:
+	for (int h = 0; h<2*os->num_hats; h++)
+	{
+		int index = num_axes++;
+		dead_band [ index ] = 0.0f ;
+		saturate  [ index ] = 1.0f ;
+		center    [ index ] = 0.0f;
+		max       [ index ] = 1.0f;
+		min       [ index ] = -1.0f;
+	}
 }
 
-CFDictionaryRef jsJoystick::getCFProperties(io_object_t ioDev)
+CFDictionaryRef getCFProperties(io_object_t ioDev)
 {
 	IOReturn rv;
 	CFMutableDictionaryRef cfProperties;
@@ -190,30 +261,32 @@
 
 void jsJoystick::close()
 {
-	(*hidDev)->close(hidDev);
-}
-
-void jsJoystick::elementEnumerator( const void *element, void* vjs)
-{
-	if (CFGetTypeID((CFTypeRef) element) != CFDictionaryGetTypeID()) {
-		ulSetError(UL_FATAL, "element enumerator passed non-dictionary value");
-		return;
-	}
-	
-	static_cast<jsJoystick*>(vjs)->parseElement((CFDictionaryRef) element);		
+	if (os->hidDev != NULL)  (*(os->hidDev))->close(os->hidDev);
+	if (os) delete os;
 }
 
 /** element enumerator function : pass NULL for top-level*/
-void jsJoystick::enumerateElements(CFTypeRef element)
+void os_specific_s::enumerateElements(jsJoystick* joy, CFTypeRef element)
 {
 	assert(CFGetTypeID(element) == CFArrayGetTypeID());
 	
 	CFRange range = {0, CFArrayGetCount ((CFArrayRef)element)};
 	CFArrayApplyFunction((CFArrayRef) element, range, 
-		&jsJoystick::elementEnumerator, this);
+		&elementEnumerator, joy);
 }
 
-void jsJoystick::parseElement(CFDictionaryRef element)
+static void os_specific_s::elementEnumerator( const void *element, void* vjs)
+{
+	if (CFGetTypeID((CFTypeRef) element) != CFDictionaryGetTypeID()) {
+		ulSetError(UL_WARNING, "element enumerator passed non-dictionary value");
+		return;
+	}
+	
+	static_cast<jsJoystick*>(vjs)->
+		os->parseElement( static_cast<jsJoystick*>(vjs), (CFDictionaryRef) element);		
+}
+
+void os_specific_s::parseElement(jsJoystick* joy, CFDictionaryRef element)
 {
 	CFTypeRef refPage = CFDictionaryGetValue ((CFDictionaryRef) element, CFSTR(kIOHIDElementUsagePageKey));
 	CFTypeRef refUsage = CFDictionaryGetValue ((CFDictionaryRef) element, CFSTR(kIOHIDElementUsageKey));
@@ -228,7 +301,7 @@
 	case kIOHIDElementTypeInput_Misc:
 	case kIOHIDElementTypeInput_Axis:
 	case kIOHIDElementTypeInput_Button:
-		printf("got input element...");
+		//printf("got input element...");
 		CFNumberGetValue((CFNumberRef) refUsage, kCFNumberLongType, &usage);
 		CFNumberGetValue((CFNumberRef) refPage, kCFNumberLongType, &page);
 		
@@ -242,28 +315,28 @@
 				case kHIDUsage_GD_Ry:
 				case kHIDUsage_GD_Rz:
 				case kHIDUsage_GD_Slider: // for throttle / trim controls
-					printf(" axis\n");
-					addAxisElement((CFDictionaryRef) element);
+					//printf(" axis\n");
+					/*joy->os->*/addAxisElement(joy, (CFDictionaryRef) element);
 					break;
 					
 				case kHIDUsage_GD_Hatswitch:
-					printf(" hat\n");
-					addHatElement((CFDictionaryRef) element);
+					//printf(" hat\n");
+					/*joy->os->*/addHatElement(joy, (CFDictionaryRef) element);
 					break;
 					
 				default:
-					printf("input type element has weird usage (%x)\n", usage);
+					ulSetError(UL_WARNING, "input type element has weird usage (%lx)\n", usage);
 		break;
 			}					
 		} else if (page == kHIDPage_Button) {
-			printf(" button\n");
-			addButtonElement((CFDictionaryRef) element);
+			//printf(" button\n");
+			/*joy->os->*/addButtonElement(joy, (CFDictionaryRef) element);
 		} else
-			printf("input type element has weird page (%x)\n", page);
+			ulSetError(UL_WARNING, "input type element has weird usage (%lx)\n", usage);
 		break;
 
 	case kIOHIDElementTypeCollection:
-		enumerateElements(
+		/*joy->os->*/enumerateElements(joy,
 			CFDictionaryGetValue(element, CFSTR(kIOHIDElementKey))
 		);
 		break;
@@ -273,16 +346,16 @@
 	}	
 }
 
-void jsJoystick::addAxisElement(CFDictionaryRef axis)
+void os_specific_s::addAxisElement(jsJoystick* joy, CFDictionaryRef axis)
 {
 	long cookie, lmin, lmax;
 	CFNumberGetValue ((CFNumberRef)
 		CFDictionaryGetValue (axis, CFSTR(kIOHIDElementCookieKey)), 
 		kCFNumberLongType, &cookie);
 	
-	int index = num_axes++;
+	int index = joy->num_axes++;
 	
-	axisCookies[index] = (IOHIDElementCookie) cookie;
+	/*joy->os->*/axisCookies[index] = (IOHIDElementCookie) cookie;
 	
 	CFNumberGetValue ((CFNumberRef)
 		CFDictionaryGetValue (axis, CFSTR(kIOHIDElementMinKey)), 
@@ -292,28 +365,48 @@
 		CFDictionaryGetValue (axis, CFSTR(kIOHIDElementMaxKey)), 
 		kCFNumberLongType, &lmax);
 		
-	min[index] = lmin;
-	max[index] = lmax;
-	dead_band[index] = 0.0;
-	saturate[index] = 1.0;
-	center[index] = (lmax - lmin) * 0.5 + lmin;
+	joy->min[index] = lmin;
+	joy->max[index] = lmax;
+	joy->dead_band[index] = 0.0;
+	joy->saturate[index] = 1.0;
+	joy->center[index] = (lmax - lmin) * 0.5 + lmin;
 }
 
-void jsJoystick::addButtonElement(CFDictionaryRef button)
+void os_specific_s::addButtonElement(jsJoystick* joy, CFDictionaryRef button)
 {
 	long cookie;
 	CFNumberGetValue ((CFNumberRef)
 		CFDictionaryGetValue (button, CFSTR(kIOHIDElementCookieKey)), 
 		kCFNumberLongType, &cookie);
 		
-	buttonCookies[num_buttons++] = (IOHIDElementCookie) cookie;
+	/*joy->os->*/buttonCookies[joy->num_buttons++] = (IOHIDElementCookie) cookie;
 	// anything else for buttons?
 }
 
-void jsJoystick::addHatElement(CFDictionaryRef button)
+void os_specific_s::addHatElement(jsJoystick* joy, CFDictionaryRef hat)
 {
-	//hatCookies[num_hats++] = (IOHIDElementCookie) cookie;
+	long cookie, lmin, lmax;
+	CFNumberGetValue ((CFNumberRef)
+		CFDictionaryGetValue (hat, CFSTR(kIOHIDElementCookieKey)), 
+		kCFNumberLongType, &cookie);
+		
+	int index = /*joy->*/num_hats++;
+
+	/*joy->os->*/hatCookies[index] = (IOHIDElementCookie) cookie;
+	
+	CFNumberGetValue ((CFNumberRef)
+		CFDictionaryGetValue (hat, CFSTR(kIOHIDElementMinKey)), 
+		kCFNumberLongType, &lmin);
+		
+	CFNumberGetValue ((CFNumberRef)
+		CFDictionaryGetValue (hat, CFSTR(kIOHIDElementMaxKey)), 
+		kCFNumberLongType, &lmax);
+	
+	hat_min[index] = lmin;
+	hat_max[index] = lmax;
 	// do we map hats to axes or buttons?
+	// axes; there is room for that: Buttons are limited to 32.
+	// (a joystick with 2 hats will use 16 buttons!)
 }
 
 void jsJoystick::rawRead(int *buttons, float *axes)
@@ -322,14 +415,33 @@
 	 IOHIDEventStruct hidEvent;
 	
 	for (int b=0; b<num_buttons; ++b) {
-		(*hidDev)->getElementValue(hidDev, buttonCookies[b], &hidEvent);
+		(*(os->hidDev))->getElementValue(os->hidDev, os->buttonCookies[b], &hidEvent);
 		if (hidEvent.value)
 			*buttons |= 1 << b; 
 	}
 	
-	for (int a=0; a<num_axes; ++a) {
-		(*hidDev)->getElementValue(hidDev, axisCookies[a], &hidEvent);
+	// real axes:
+	int real_num_axes = num_axes - 2*os->num_hats;
+	for (int a=0; a<real_num_axes; ++a) {
+		(*(os->hidDev))->getElementValue(os->hidDev, os->axisCookies[a], &hidEvent);
 		axes[a] = hidEvent.value;
+	}
+	
+	// hats:
+	for (int h=0; h < os->num_hats; ++h) {
+		(*(os->hidDev))->getElementValue(os->hidDev, os->hatCookies[h], &hidEvent);
+		 long result = ( hidEvent.value - os->hat_min[h] ) * 8;
+		 result /= ( os->hat_max[h] - os->hat_min[h] + 1 );
+		 if ( (result>=0) && (result<8) )
+		 {
+			 axes[h+real_num_axes+1] = NS_hat[result];
+			 axes[h+real_num_axes] = WE_hat[result];
+		 }
+		 else
+		 {
+			 axes[h+real_num_axes] = 0;
+			 axes[h+real_num_axes+1] = 0;
+		 }
 	}
 }
 
