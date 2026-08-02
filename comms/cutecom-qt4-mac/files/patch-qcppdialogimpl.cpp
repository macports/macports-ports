--- qcppdialogimpl.cpp.orig	2009-06-25 15:10:49.000000000 -0500
+++ qcppdialogimpl.cpp	2011-09-13 23:58:27.000000000 -0500
@@ -351,12 +351,12 @@
    QStringList devices=settings.value("/cutecom/AllDevices").toStringList();
    if (!entryFound)
    {
-      devices<<"/dev/ttyS0"<<"/dev/ttyS1"<<"/dev/ttyS2"<<"/dev/ttyS3";
+      devices<<DEVLIST;
    }
 
    m_deviceCb->insertItems(0, devices);
 
-   int indexOfCurrentDevice = devices.indexOf(settings.value("/cutecom/CurrentDevice", "/dev/ttyS0").toString());
+   int indexOfCurrentDevice = devices.indexOf(settings.value("/cutecom/CurrentDevice", DEFAULT_DEV).toString());
    // fprintf(stderr, "currentDEev: -%s - index: %d\n", settings.value("/cutecom/CurrentDevice", "/dev/ttyS0").toString().toLatin1().constData(), indexOfCurrentDevice);
    if (indexOfCurrentDevice!=-1)
    {
