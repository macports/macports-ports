--- qcppdialogimpl.cpp.orig	2008-03-12 16:09:50.000000000 -0500
+++ qcppdialogimpl.cpp	2009-03-28 10:13:13.000000000 -0500
@@ -243,11 +243,10 @@
    bool entryFound=false;
    QStringList devices=settings.readListEntry("/cutecom/AllDevices", &entryFound);
    if (!entryFound)
-      devices<<"/dev/ttyS0"<<"/dev/ttyS1"<<"/dev/ttyS2"<<"/dev/ttyS3";
+      devices<<DEVLIST;
 
    m_deviceCb->insertStringList(devices);
-
-   m_deviceCb->setCurrentText(settings.readEntry("/cutecom/CurrentDevice", "/dev/ttyS0"));
+   m_deviceCb->setCurrentText(settings.readEntry("/cutecom/CurrentDevice", DEFAULT_DEV));
 
    QStringList history=settings.readListEntry("/cutecom/History");
 
@@ -929,15 +928,15 @@
    case 230400:
       _baud=B230400;
       break;
-   case 460800:
-      _baud=B460800;
-      break;
-   case 576000:
-      _baud=B576000;
-      break;
-   case 921600:
-      _baud=B921600;
-      break;
+//   case 460800:
+//      _baud=B460800;
+//      break;
+//   case 576000:
+//      _baud=B576000;
+//      break;
+//   case 921600:
+//      _baud=B921600;
+//      break;
 //   case 128000:
 //      _baud=B128000;
 //      break;
