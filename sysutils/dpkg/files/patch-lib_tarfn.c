--- lib/tarfn.c.orig	Wed Jan 26 18:31:15 2005
+++ lib/tarfn.c	Wed Jan 26 19:26:19 2005
@@ -13,6 +13,9 @@
 #include <errno.h>
 #include <tarfn.h>
 
+static const char ustarMagic[] = { 'u', 's', 't', 'a', 'r', '\0', '0', '0', '\0' };
+static const char gnutarMagic[] = { 'u', 's', 't', 'a', 'r', ' ', ' ', '\0' };
+
 struct TarHeader {
 	char Name[100];
 	char Mode[8];
@@ -23,11 +26,12 @@
 	char Checksum[8];
 	char LinkFlag;
 	char LinkName[100];
-	char MagicNumber[8];
+	char MagicNumber[8]; /* POSIX: "ustar\000", GNU: "ustar  \0" (blank blank null) */
 	char UserName[32];
 	char GroupName[32];
 	char MajorDevice[8];
 	char MinorDevice[8];
+	char Prefix[155]; /* POSIX ustar header */
 };
 typedef struct TarHeader	TarHeader;
 
@@ -74,6 +78,10 @@
 	struct passwd *		passwd = NULL;
 	struct group *		group = NULL;
 	unsigned int		i;
+	char			*prefix, *name, *file;
+	size_t			prefixLen;
+	size_t			nameLen;
+	size_t			fileLen;
 	long			sum;
 	long			checksum;
 
@@ -82,7 +90,35 @@
 	if ( *h->GroupName )
 		group = getgrnam(h->GroupName);
 
-	d->Name = StoC(h->Name, sizeof(h->Name));
+	/*
+	 * Is this a ustar archive entry?
+	 * Is Prefix in use?
+	 */
+	if ((memcmp(h->MagicNumber, ustarMagic, sizeof(h->MagicNumber)) == 0) &&  h->Prefix[0]) {
+		prefixLen = strnlen(h->Prefix, sizeof(h->Prefix));
+
+		prefix = StoC(h->Prefix, prefixLen);
+		if (h->Prefix[prefixLen - 1] != '/') {
+			prefixLen++; /* Space for '/' */
+			 /* The rest of the code doesn't care if malloc fails, so we won't either */
+			prefix = realloc(prefix, prefixLen + 1); /* prefix + \0 */
+			prefix[prefixLen - 1] = '/';
+			prefix[prefixLen] = '\0';
+		}
+
+		nameLen = strnlen(h->Name, sizeof(h->Name));
+		name = StoC(h->Name, nameLen);
+
+		file = realloc(prefix, prefixLen + nameLen + 1); /* prefix + name + \0 */
+		strcat(file, name);
+
+		free(name);
+
+		d->Name = file;
+	} else {
+		d->Name = StoC(h->Name, sizeof(h->Name));
+	}
+
 	d->LinkName = StoC(h->LinkName, sizeof(h->LinkName));
 	d->Mode = (mode_t)OtoL(h->Mode, sizeof(h->Mode));
 	d->Size = (size_t)OtoL(h->Size, sizeof(h->Size));
@@ -181,7 +217,9 @@
 			}
 			/* Else, Fall Through */
 		case Directory:
-			h.Name[nameLength - 1] = '\0';
+			if (h.Name[nameLength - 1] == '/') {
+				h.Name[nameLength - 1] = '\0';
+			}
 			status = (*functions->MakeDirectory)(&h);
 			break;
 		case HardLink:
