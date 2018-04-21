--- jabberd/mio_tls.cc.orig	2007-07-16 23:20:44 UTC
+++ jabberd/mio_tls.cc
@@ -39,7 +39,6 @@
 #include <set>
 #include <string>
 #include <sstream>
-#include <gcrypt.h>
 #include <vector>
 #include <list>
 #include <iostream>
@@ -612,7 +611,7 @@ static void mio_tls_process_credentials(
 	    }
 
 	    // load OpenPGP key/certificate
-	    ret = gnutls_certificate_set_openpgp_key_file(current_credentials, pubfile, privfile);
+	    ret = gnutls_certificate_set_openpgp_key_file(current_credentials, pubfile, privfile, GNUTLS_OPENPGP_FMT_BASE64);
 	    if (ret < 0) {
 		log_error(NULL, "Error loading OpenPGP key pub=%s/priv=%s: %s", pubfile, privfile, gnutls_strerror(ret));
 		continue;
@@ -631,7 +630,7 @@ static void mio_tls_process_credentials(
 	    }
 
 	    // load the OpenPGP keyring
-	    ret = gnutls_certificate_set_openpgp_keyring_file(current_credentials, file);
+	    ret = gnutls_certificate_set_openpgp_keyring_file(current_credentials, file, GNUTLS_OPENPGP_FMT_BASE64);
 	    if (ret < 0) {
 		log_error(NULL, "Error loading OpenPGP keyring %s: %s", file, gnutls_strerror(ret));
 		continue;
@@ -640,23 +639,6 @@ static void mio_tls_process_credentials(
 	    continue;
 	}
 
-	// load GnuPG trustdb
-	if (j_strcmp(xmlnode_get_localname(cur), "trustdb") == 0) {
-	    char const *const file = xmlnode_get_data(cur);
-
-	    if (file == NULL) {
-		log_warn(NULL, "Initializing TLS subsystem: <trustdb/> element inside the TLS configuration, that does not contain a file-name.");
-		continue;
-	    }
-
-	    // load the GnuPG trustdb
-	    ret = gnutls_certificate_set_openpgp_trustdb(current_credentials, file);
-	    if (ret < 0) {
-		log_error(NULL, "Error loading GnuPG trustdb %s: %s", file, gnutls_strerror(ret));
-		continue;
-	    }
-	}
-
 	// setup protocols to use
 	if (j_strcmp(xmlnode_get_localname(cur), "protocols") == 0) {
 	    char const *const protocols_data = xmlnode_get_data(cur);
@@ -916,7 +898,7 @@ bool mio_tls_early_init() {
     /* load asn1 tree to be used by libtasn1 */
     ret = asn1_array2tree(subjectAltName_asn1_tab, &mio_tls_asn1_tree, NULL);
     if (ret != ASN1_SUCCESS) {
-	std::cerr << "Error preparing the libtasn1 library: " << libtasn1_strerror(ret) << std::endl;
+	std::cerr << "Error preparing the libtasn1 library: " << asn1_strerror(ret) << std::endl;
 	return false;
 	/* XXX we have to delete the structure on shutdown using asn1_delete_structure(&mio_tls_asn1_tree) */
     }
@@ -1302,80 +1284,32 @@ int mio_ssl_starttls(mio m, int originat
 
     // overwrite protocol priorities?
     if (mio_tls_protocols.find(identity) != mio_tls_protocols.end()) {
-	ret = gnutls_protocol_set_priority(session, mio_tls_protocols[identity]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting protocol priority: %s", gnutls_strerror(ret));
-	}
     } else if (mio_tls_protocols.find("*") != mio_tls_protocols.end()) {
-	ret = gnutls_protocol_set_priority(session, mio_tls_protocols["*"]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting protocol priority: %s", gnutls_strerror(ret));
-	}
     }
 
     // overwrite kx algorithm priorities?
     if (mio_tls_kx.find(identity) != mio_tls_kx.end()) {
-	ret = gnutls_kx_set_priority(session, mio_tls_kx[identity]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting kx algorithm priority: %s", gnutls_strerror(ret));
-	}
     } else if (mio_tls_kx.find("*") != mio_tls_kx.end()) {
-	ret = gnutls_kx_set_priority(session, mio_tls_kx["*"]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting kx algorithm priority: %s", gnutls_strerror(ret));
-	}
     }
 
     // overwrite cipher priorities?
     if (mio_tls_ciphers.find(identity) != mio_tls_ciphers.end()) {
-	ret = gnutls_cipher_set_priority(session, mio_tls_ciphers[identity]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting cipher algorithm priority: %s", gnutls_strerror(ret));
-	}
     } else if (mio_tls_ciphers.find("*") != mio_tls_ciphers.end()) {
-	ret = gnutls_cipher_set_priority(session, mio_tls_ciphers["*"]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting cipher algorithm priority: %s", gnutls_strerror(ret));
-	}
     }
 
     // overwrite certificate priorities?
     if (mio_tls_certtypes.find(identity) != mio_tls_certtypes.end()) {
-	ret = gnutls_certificate_type_set_priority(session, mio_tls_certtypes[identity]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting certificate priorities: %s", gnutls_strerror(ret));
-	}
     } else if (mio_tls_certtypes.find("*") != mio_tls_certtypes.end()) {
-	ret = gnutls_certificate_type_set_priority(session, mio_tls_certtypes["*"]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting certificate priorities: %s", gnutls_strerror(ret));
-	}
     }
 
     // overwrite mac algorithm priorities?
     if (mio_tls_mac.find(identity) != mio_tls_mac.end()) {
-	ret = gnutls_mac_set_priority(session, mio_tls_mac[identity]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting mac algorithm priorities: %s", gnutls_strerror(ret));
-	}
     } else if (mio_tls_mac.find("*") != mio_tls_mac.end()) {
-	ret = gnutls_mac_set_priority(session, mio_tls_mac["*"]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting mac algorithm priorities: %s", gnutls_strerror(ret));
-	}
     }
 
     // overwrite compression algorithm priorities?
     if (mio_tls_compression.find(identity) != mio_tls_compression.end()) {
-	ret = gnutls_compression_set_priority(session, mio_tls_compression[identity]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting compression algorithm priorities: %s", gnutls_strerror(ret));
-	}
     } else if (mio_tls_compression.find("*") != mio_tls_compression.end()) {
-	ret = gnutls_compression_set_priority(session, mio_tls_compression["*"]);
-	if (ret < 0) {
-	    log_notice(identity, "error setting compression algorithm priorities: %s", gnutls_strerror(ret));
-	}
     }
 
     /* setting certificate credentials */
@@ -1498,7 +1432,6 @@ static int mio_tls_check_openpgp(mio m, 
     const gnutls_datum_t *cert_list = NULL;
     unsigned int cert_list_size = 0;
 
-#ifdef HAVE_GNUTLS_EXTRA
     // get the certificate (it's only a single one for OpenPGP)
     cert_list = gnutls_certificate_get_peers(static_cast<gnutls_session_t>(m->ssl), &cert_list_size);
     if (cert_list == NULL || cert_list_size <= 0) {
@@ -1566,7 +1499,6 @@ static int mio_tls_check_openpgp(mio m, 
     // free memory
     gnutls_openpgp_key_deinit(pgpkey);
     pool_free(jidpool);
-#endif
     return 0;
 }
 
@@ -1684,14 +1616,14 @@ static int mio_tls_check_x509(mio m, cha
 		    /* init subjectAltName_element */
 		    ret = asn1_create_element(mio_tls_asn1_tree, "PKIX1.SubjectAltName", &subjectAltName_element);
 		    if (ret != ASN1_SUCCESS) {
-			log_warn(log_id.c_str(), "error creating asn1 element for PKIX1.SubjectAltName: %s (%s)", libtasn1_strerror(ret), cert_subject.c_str());
+			log_warn(log_id.c_str(), "error creating asn1 element for PKIX1.SubjectAltName: %s (%s)", asn1_strerror(ret), cert_subject.c_str());
 			break;
 		    }
 
 		    /* decode the extension */
 		    ret = asn1_der_decoding(&subjectAltName_element, subjectAltName, subjectAltName_size, NULL);
 		    if (ret != ASN1_SUCCESS) {
-			log_warn(log_id.c_str(), "error DER decoding subjectAltName extension: %s (%s)", libtasn1_strerror(ret), cert_subject.c_str());
+			log_warn(log_id.c_str(), "error DER decoding subjectAltName extension: %s (%s)", asn1_strerror(ret), cert_subject.c_str());
 			asn1_delete_structure(&subjectAltName_element);
 			break;
 		    }
@@ -1712,7 +1644,7 @@ static int mio_tls_check_x509(mio m, cha
 			    break;
 			}
 			if (ret != ASN1_SUCCESS) {
-			    log_notice(log_id.c_str(), "error accessing type for %s in subjectAltName: %s (%s)", cnt_string, libtasn1_strerror(ret), cert_subject.c_str());
+			    log_notice(log_id.c_str(), "error accessing type for %s in subjectAltName: %s (%s)", cnt_string, asn1_strerror(ret), cert_subject.c_str());
 			    break;
 			}
 
@@ -1732,7 +1664,7 @@ static int mio_tls_check_x509(mio m, cha
 
 				ret = asn1_read_value(subjectAltName_element, access_string, dNSName, &dNSName_len);
 				if (ret != ASN1_SUCCESS) {
-				    log_notice(log_id.c_str(), "error accessing %s in subjectAltName: %s (%s)", access_string, libtasn1_strerror(ret), cert_subject.c_str());
+				    log_notice(log_id.c_str(), "error accessing %s in subjectAltName: %s (%s)", access_string, asn1_strerror(ret), cert_subject.c_str());
 				    break;
 				}
 
@@ -1772,7 +1704,7 @@ static int mio_tls_check_x509(mio m, cha
 			    /* get the OID of the otherName */
 			    ret = asn1_read_value(subjectAltName_element, access_string_type, otherNameType, &otherNameType_len);
 			    if (ret != ASN1_SUCCESS) {
-				log_notice(log_id.c_str(), "error accessing type information %s in subjectAltName: %s (%s)", access_string_type, libtasn1_strerror(ret), cert_subject.c_str());
+				log_notice(log_id.c_str(), "error accessing type information %s in subjectAltName: %s (%s)", access_string_type, asn1_strerror(ret), cert_subject.c_str());
 				break;
 			    }
 
@@ -1785,7 +1717,7 @@ static int mio_tls_check_x509(mio m, cha
 			    /* get the value of the otherName */
 			    ret = asn1_read_value(subjectAltName_element, access_string_value, otherNameValue, &otherNameValue_len);
 			    if (ret != ASN1_SUCCESS) {
-				log_notice(log_id.c_str(), "error accessing value of othername %s in subjectAltName: %s (%s)", access_string_value, libtasn1_strerror(ret), cert_subject.c_str());
+				log_notice(log_id.c_str(), "error accessing value of othername %s in subjectAltName: %s (%s)", access_string_value, asn1_strerror(ret), cert_subject.c_str());
 				break;
 			    }
 
@@ -1799,21 +1731,21 @@ static int mio_tls_check_x509(mio m, cha
 
 				ret = asn1_create_element(mio_tls_asn1_tree, "PKIX1.DirectoryString", &directoryString_element);
 				if (ret != ASN1_SUCCESS) {
-				    log_notice(log_id.c_str(), "error creating DirectoryString element: %s (%s)", libtasn1_strerror(ret), cert_subject.c_str());
+				    log_notice(log_id.c_str(), "error creating DirectoryString element: %s (%s)", asn1_strerror(ret), cert_subject.c_str());
 				    asn1_delete_structure(&directoryString_element);
 				    break;
 				}
 
 				ret = asn1_der_decoding(&directoryString_element, otherNameValue, otherNameValue_len, NULL);
 				if (ret != ASN1_SUCCESS) {
-				    log_notice(log_id.c_str(), "error decoding DirectoryString: %s (%s)", libtasn1_strerror(ret), cert_subject.c_str());
+				    log_notice(log_id.c_str(), "error decoding DirectoryString: %s (%s)", asn1_strerror(ret), cert_subject.c_str());
 				    asn1_delete_structure(&directoryString_element);
 				    break;
 				}
 
 				ret = asn1_read_value(directoryString_element, "utf8String", thisIdOnXMPPaddr, &thisIdOnXMPPaddr_len);
 				if (ret != ASN1_SUCCESS) {
-				    log_notice(log_id.c_str(), "error accessing utf8String of DirectoryString: %s (%s)", libtasn1_strerror(ret), cert_subject.c_str());
+				    log_notice(log_id.c_str(), "error accessing utf8String of DirectoryString: %s (%s)", asn1_strerror(ret), cert_subject.c_str());
 				    asn1_delete_structure(&directoryString_element);
 				    break;
 				}
