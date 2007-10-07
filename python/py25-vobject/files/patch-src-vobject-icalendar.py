--- src/vobject/icalendar.py.orig	2006-07-14 22:23:35.000000000 -0700
+++ src/vobject/icalendar.py	2006-08-10 13:55:53.000000000 -0700
@@ -374,8 +374,17 @@
                     try:
                         dtstart = self.dtstart.value
                     except AttributeError, KeyError:
-                        # if there's no dtstart, just return None
-                        return None
+                        # Special for VTODO - try DUE property instead
+                        try:
+                            if self.name == "VTODO":
+                                dtstart = self.due.value
+                            else:
+                                # if there's no dtstart, just return None
+                                return None
+                        except AttributeError, KeyError:
+                            # if there's no due, just return None
+                            return None
+
                     # rrulestr complains about unicode, so cast to str
                     rule = dateutil.rrule.rrulestr(str(line.value),
                                                    dtstart=dtstart)
@@ -419,7 +428,16 @@
         return rruleset
 
     def setrruleset(self, rruleset):
-        dtstart = self.dtstart.value
+        
+        # Get DTSTART from component (or DUE if no DTSTART in a VTODO)
+        try:
+            dtstart = self.dtstart.value
+        except AttributeError, KeyError:
+            if self.name == "VTODO":
+                dtstart = self.due.value
+            else:
+                raise
+            
         isDate = datetime.date == type(dtstart)
         if isDate:
             dtstart = datetime.datetime(dtstart.year,dtstart.month, dtstart.day)
@@ -575,6 +593,8 @@
         if obj.value.tzinfo is None:
             obj.params['X-VOBJ-FLOATINGTIME-ALLOWED'] = ['TRUE']
         if obj.params.get('TZID'):
+            # Keep a copy of the original TZID around
+            obj.params['X-VOBJ-ORIGINAL-TZID'] = obj.params['TZID']
             del obj.params['TZID']
         return obj
 
@@ -587,6 +607,10 @@
             obj.value = dateTimeToString(obj.value, cls.forceUTC)
             if not cls.forceUTC and tzid is not None:
                 obj.tzid_param = tzid
+            if obj.params.get('X-VOBJ-ORIGINAL-TZID'):
+                if not hasattr(obj, 'tzid_param'):
+                    obj.tzid_param = obj.params['X-VOBJ-ORIGINAL-TZID']
+                del obj.params['X-VOBJ-ORIGINAL-TZID']
 
         return obj
 
@@ -607,7 +631,10 @@
         obj.value=str(obj.value)
         obj.value=parseDtstart(obj)
         if getattr(obj, 'value_param', 'DATE-TIME').upper() == 'DATE-TIME':
-            if hasattr(obj, 'tzid_param'): del obj.tzid_param
+            if hasattr(obj, 'tzid_param'):
+                # Keep a copy of the original TZID around
+                obj.params['X-VOBJ-ORIGINAL-TZID'] = obj.tzid_param
+                del obj.tzid_param
         return obj
 
     @staticmethod
