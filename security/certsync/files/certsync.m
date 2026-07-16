/*
 * Author: Landon Fuller <landonf@plausiblelabs.com>
 * Copyright (c) 2008-2013 Plausible Labs Cooperative, Inc.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <Security/Security.h>

#import <unistd.h>
#import <stdio.h>

#import "compat.h"

/* A wrapper class that may be used to pass configuration through the
 * FSEvent callback API */
@interface MPCertSyncConfig : NSObject {
@public
    BOOL userAnchors;
    NSString *outputFile;
}
@end

@implementation MPCertSyncConfig
- (void) dealloc {
    [outputFile release];
    [super dealloc];
}
@end

/**
 * Add CoreFoundation object to the current autorelease pool.
 *
 * @param cfObj Object to add to the current autorelease pool.
 */
CFTypeRef PLCFAutorelease (CFTypeRef cfObj) {
    return [(id)cfObj autorelease];
}

int nsvfprintf (FILE *stream, NSString *format, va_list args) {
    int retval;

    NSString *str;
    str = (NSString *) CFStringCreateWithFormatAndArguments(NULL, NULL, (CFStringRef) format, args);
    retval = fprintf(stream, "%s", [str UTF8String]);
    [str release];

    return retval;
}

int nsfprintf (FILE *stream, NSString *format, ...) {
    va_list ap;
    int retval;

    va_start(ap, format);
    {
        retval = nsvfprintf(stream, format, ap);
    }
    va_end(ap);

    return retval;
}

int nsprintf (NSString *format, ...) {
    va_list ap;
    int retval;

    va_start(ap, format);
    {
        retval = nsvfprintf(stderr, format, ap);
    }
    va_end(ap);

    return retval;
}

/**
 * Wrapper method to retrieve the common name (CN) given a @code SecCertificateRef. If retrieving
 * the CN isn't supported on this platform, returns @code NO, otherwise @code YES and points the
 * given string ref @a subject to a string containing the common name. If an error occurs, subject
 * is a NULL reference and *subjectError contains more information about the type of failure.
 *
 * @param cert A SecCertificateRef to the certificate for which the CN should be retrieved
 * @param subject A pointer to a CFStringRef that will hold the CN if the retrieval is successful.
 * @param subjectError A pointer to an NSError* that will hold an error message if an error occurs.
 * @return BOOL indicating whether this system supports retrieving CNs from certificates
 */
static BOOL GetCertSubject(SecCertificateRef cert, CFStringRef *subject, NSError **subjectError) {
    if (SecCertificateCopyShortDescription != NULL /* 10.7 */) {
        *subject = PLCFAutorelease(SecCertificateCopyShortDescription(NULL, cert, (CFErrorRef *) subjectError));
        return YES;
    }

    if (SecCertificateCopySubjectSummary   != NULL /* 10.6 */) {
        *subject = PLCFAutorelease(SecCertificateCopySubjectSummary(cert));
        return YES;
    }

    if (SecCertificateCopyCommonName       != NULL /* 10.5 */) {
        OSStatus err;
        if ((err = SecCertificateCopyCommonName(cert, subject)) == errSecSuccess && *subject != NULL) {
            PLCFAutorelease(*subject);
            return YES;
        }

        /* In the case that the CN is simply unavailable, provide a more useful error code */
        if (err == errSecSuccess) {
            err = errSecNoSuchAttr;
        }

        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"SecCertificateCopyCommonName() failed", NSLocalizedDescriptionKey, nil];
        *subjectError = [NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo: userInfo];
        *subject = NULL;

        return YES;
    }

    /* <= 10.4 */
    return NO;
}

/**
 * Verify that the root certificate is trusted by the system; this filters out
 * certificates that are (1) expired, or (2) in the system keychain but marked
 * as untrusted by a system administrator (or user).
 *
 * @param cert A @code SecCertificateRef representing a certificate to be
 *             checked.
 *
 * @return Returns a BOOL indicating that the certificate is trusted (@code
 *         YES), or not (@code NO).
 */
static BOOL ValidateSystemTrust(SecCertificateRef cert) {
    OSStatus err;

    /* Create a new trust evaluation instance */
    SecTrustRef trust;
    {
        SecPolicyRef policy;
        if (SecPolicyCreateBasicX509 != NULL) /* >= 10.6 */ {
            policy = SecPolicyCreateBasicX509();
        } else /* < 10.6 */ {
            SecPolicySearchRef searchRef = NULL;
            const CSSM_OID *policyOID = &CSSMOID_APPLE_X509_BASIC;

            if ((err = SecPolicySearchCreate(CSSM_CERT_X_509v3, policyOID, NULL, &searchRef)) != errSecSuccess) {
                cssmPerror("SecPolicySearchCreate", err);
                return NO;
            }
            if ((err = SecPolicySearchCopyNext(searchRef, &policy))) {
                cssmPerror("SecPolicySearchCopyNext", err);
                return NO;
            }
        }

        if ((err = SecTrustCreateWithCertificates((CFTypeRef) cert, policy, &trust)) != errSecSuccess) {
            /* Shouldn't happen */
            nsfprintf(stderr, @"Failed to create SecTrustRef: %d\n", err);
            CFRelease(policy);
            return NO;
        }

        CFRelease(policy);
    }

    /* Allow verifying root certificates (which would otherwise be an error).
     * Without this, intermediates added as roots aren't exported. */
    {
        CSSM_APPLE_TP_ACTION_FLAGS actionFlags = CSSM_TP_ACTION_LEAF_IS_CA;
        CSSM_APPLE_TP_ACTION_DATA actionData;
        CFDataRef cfActionData = NULL;

        memset(&actionData, 0, sizeof(actionData));
        actionData.Version = CSSM_APPLE_TP_ACTION_VERSION;
        actionData.ActionFlags = actionFlags;
        cfActionData = CFDataCreate(NULL, (UInt8 *) &actionData, sizeof(actionData));
        if ((err = SecTrustSetParameters(trust, CSSM_TP_ACTION_DEFAULT, cfActionData))) {
            nsfprintf(stderr, @"Failed to set SecTrustParameters: %d\n", err);
            CFRelease(cfActionData);
            return NO;
        }
        CFRelease(cfActionData);
    }

    /* Evaluate the certificate trust */
    SecTrustResultType rt;
    if ((err = SecTrustEvaluate(trust, &rt)) != errSecSuccess) {
        nsfprintf(stderr, @"SecTrustEvaluate() failed: %d\n", err);
        CFRelease(trust);
        return NO;
    }

    CFRelease(trust);

    /* Check the result */
    switch (rt) {
        case kSecTrustResultUnspecified:
            /* Reached a trusted root */
        case kSecTrustResultProceed:
            /* User explicitly trusts */
            return YES;

        case kSecTrustResultDeny:
            /* User explicitly distrusts */
#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_7
        case kSecTrustResultConfirm:
            /* The user previously chose to ask for permission when this
             * certificate is used. This is no longer used on modern OS X. */
#endif
            //nsfprintf(stderr, @"Marked as untrustable!\n");
            return NO;

        case kSecTrustResultRecoverableTrustFailure:
            /* The chain as-is isn't trusted, but it could be trusted with some
             * minor change (such as ignoring expired certs or adding an
             * additional anchor). For certsync this likely means the cert was
             * expired, which means we don't want to export it. */
            return NO;

        case kSecTrustResultFatalTrustFailure:
            /* The chain is defective (e.g., ill-formatted). Don't export this. */
            return NO;

        default:
            /* Untrusted */
            nsfprintf(stderr, @"rt = %d\n", rt);
            cssmPerror("CSSM verify error", err);
            return NO;
    }
}

/**
 * Fetch all trusted roots for the given @a domain.
 *
 * @param domain The trust domain to query.
 * @param outError On error, will contain an NSError instance describing the failure.
 *
 * @return Returns a (possibly empty) array of certificates on success, nil on failure.
 */
static NSArray *certificatesForTrustDomain (SecTrustSettingsDomain domain, NSError **outError) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableArray *trusted = nil;
    CFArrayRef certs = nil;
    OSStatus err;

    /* Mac OS X >= 10.5 provides SecTrustSettingsCopyCertificates() */
    if (SecTrustSettingsCopyCertificates != NULL) {
        /* Fetch all certificates in the given domain */
        err = SecTrustSettingsCopyCertificates(domain, &certs);
        if (err == errSecSuccess) {
            PLCFAutorelease(certs);
        } else if (err == errSecNoTrustSettings) {
            /* No data */

            [pool release];
            return [NSArray array];
        } else if (err != errSecSuccess) {
            /* Lookup failed */
            if (outError != NULL)
                *outError = [[NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo:nil] retain];

            [pool release];
            [*outError autorelease];
            return nil;
        }

        /* Extract trusted roots */
        trusted = [NSMutableArray arrayWithCapacity: CFArrayGetCount(certs)];

        NSEnumerator *resultEnumerator = [(NSArray *)certs objectEnumerator];
        id certObj;
        while ((certObj = [resultEnumerator nextObject]) != nil) {
            SecCertificateRef cert = (SecCertificateRef) certObj;

            /* Fetch the trust settings */
            CFArrayRef trustSettings = nil;
            err = SecTrustSettingsCopyTrustSettings(cert, domain, &trustSettings);
            if (err != errSecSuccess) {
                /* Shouldn't happen */
                nsfprintf(stderr, @"Failed to fetch trust settings\n");
                continue;
            } else {
                PLCFAutorelease(trustSettings);
            }

            /* If empty, trust for everything (as per the Security Framework documentation) */
            if (CFArrayGetCount(trustSettings) == 0) {
                [trusted addObject: certObj];
            } else {
                /* Otherwise, walk the properties and evaluate the trust settings result */
                NSEnumerator *trustEnumerator = [(NSArray *)trustSettings objectEnumerator];
                NSDictionary *trustProps;
                while ((trustProps = [trustEnumerator nextObject]) != nil) {
                    CFNumberRef settingsResultNum;
                    SInt32 settingsResult;

                    settingsResultNum = (CFNumberRef) [trustProps objectForKey: (id) kSecTrustSettingsResult];
                    if (settingsResultNum == nil) {
                        /* "If this key is not present, a default value of kSecTrustSettingsResultTrustRoot is assumed." */
                        settingsResult = kSecTrustSettingsResultTrustRoot;
                    } else {
                        CFNumberGetValue(settingsResultNum, kCFNumberSInt32Type, &settingsResult);
                    }

                    /* If a root, add to the result set */
                    if (settingsResult == kSecTrustSettingsResultTrustRoot || settingsResult == kSecTrustSettingsResultTrustAsRoot) {
                        [trusted addObject: certObj];
                        break;
                    }
                }
            }
        }
    } else {
        /* Fetch all certificates in the given domain */
        err = SecTrustCopyAnchorCertificates(&certs);
        if (err == noErr) {
            PLCFAutorelease(certs);
        } else if (err == errSecTrustNotAvailable) {
            /* No data */
            [pool release];
            return [NSArray array];
        } else if (err != noErr) {
            /* Lookup failed */
            if (outError != NULL)
                *outError = [[NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo:nil] retain];

            [pool release];
            [*outError autorelease];
            return nil;
        }

        /* All certs are trusted */
        trusted = [[(NSArray *) certs mutableCopy] autorelease];
        CFRelease(certs);
    }

    /*
     * Filter out any trusted certificates that can not actually be used in verification; eg, they are expired.
     *
     * There are cases where CAs have issued new certificates using identical public keys, and the expired
     * and current CA certificates are both included in the list of trusted certificates. In such a case,
     * OpenSSL will use either of the two certificates; if that happens to be the expired certificate,
     * validation will fail.
     *
     * This step ensures that we exclude any expired or known-unusable certificates.
     *
     * We enumerate a copy of the array so that we can safely modify the original during enumeration.
     */
    NSEnumerator *trustedEnumerator = [[[trusted copy] autorelease] objectEnumerator];
    id certObj;
    while ((certObj = [trustedEnumerator nextObject]) != nil) {
        /* If self-trust validation fails, the certificate is expired or otherwise not useable */
        if (!ValidateSystemTrust((SecCertificateRef) certObj)) {
            NSError *subjectError = NULL;
            CFStringRef subject = NULL;

            if (GetCertSubject((SecCertificateRef) certObj, &subject, &subjectError)) {
                if (subject != NULL) {
                    nsfprintf(stderr, @"Removing untrusted certificate: %@\n", subject);
                } else {
                    nsfprintf(stderr, @"Failed to extract certificate description for untrusted certificate: %@\n", subjectError);
                }
            }
            [trusted removeObject: certObj];
        }
    }

    [trusted retain];
    [pool release];
    return [trusted autorelease];
}

static int exportCertificates (BOOL userAnchors, NSString *outputFile) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    /*
     * Fetch all certificates
     */

    NSMutableArray *anchors = [NSMutableArray array];
    NSArray *result;
    NSError *error;
    OSStatus err;

    /* Current user */
    if (userAnchors) {
        /* Set the keychain preference domain to user, this causes
         * ValidateSystemTrust to use the user's keychain */
        if ((err = SecKeychainSetPreferenceDomain(kSecPreferencesDomainUser)) != errSecSuccess) {
            if (SecCopyErrorMessageString != NULL) {
                /* >= 10.5 */
                CFStringRef errMsg = PLCFAutorelease(SecCopyErrorMessageString(err, NULL));
                nsfprintf(stderr, @"Failed to set keychain preference domain: %@\n", errMsg);
            } else {
                /* <= 10.4 */
                nsfprintf(stderr, @"Failed to set keychain preference domain: %d\n", err);
            }

            [pool release];
            return EXIT_FAILURE;
        }

        result = certificatesForTrustDomain(kSecTrustSettingsDomainUser, &error);
        if (result != nil) {
            [anchors addObjectsFromArray: result];
        } else {
            nsfprintf(stderr, @"Failed to fetch user anchors: %@\n", error);
            [pool release];
            return EXIT_FAILURE;
        }
    }

    /* Admin & System */
    /* Causes ValidateSystemTrust to ignore the user's keychain */
    if ((err = SecKeychainSetPreferenceDomain(kSecPreferencesDomainSystem)) != errSecSuccess) {
        if (SecCopyErrorMessageString != NULL) {
            /* >= 10.5 */
            CFStringRef errMsg = PLCFAutorelease(SecCopyErrorMessageString(err, NULL));
            nsfprintf(stderr, @"Failed to set keychain preference domain: %@\n", errMsg);
        } else {
            /* <= 10.4 */
            nsfprintf(stderr, @"Failed to set keychain preference domain: %d\n", err);
        }

        [pool release];
        return EXIT_FAILURE;
    }

    /* Admin */
    result = certificatesForTrustDomain(kSecTrustSettingsDomainAdmin, &error);
    if (result != nil) {
        [anchors addObjectsFromArray: result];
    } else {
        nsfprintf(stderr, @"Failed to fetch admin anchors: %@\n", error);
        [pool release];
        return EXIT_FAILURE;
    }

    /* System */
    result = certificatesForTrustDomain(kSecTrustSettingsDomainSystem, &error);
    if (result != nil) {
        [anchors addObjectsFromArray: result];
    } else {
        nsfprintf(stderr, @"Failed to fetch system anchors: %@\n", error);
        [pool release];
        return EXIT_FAILURE;
    }

    NSEnumerator *resultEnumerator = [anchors objectEnumerator];
    id certObj;
    while ((certObj = [resultEnumerator nextObject]) != nil) {
        NSError *subjectError = NULL;
        CFStringRef subject = NULL;

        if (GetCertSubject((SecCertificateRef) certObj, &subject, &subjectError)) {
            if (subject != NULL) {
                nsfprintf(stderr, @"Found %@\n", subject);
            } else {
                nsfprintf(stderr, @"Failed to extract certificate description: %@\n", subjectError);
            }
        }
    }

    /*
     * Perform export
     */
    CFDataRef pemData;

    /* Prefer the non-deprecated SecItemExport on Mac OS X >= 10.7. We use an ifdef to keep the code buildable with earlier SDKs, too. */
    nsfprintf(stderr, @"Exporting certificates from the keychain\n");
    if (SecItemExport != NULL) {
        err = SecItemExport((CFArrayRef) anchors, kSecFormatPEMSequence, kSecItemPemArmour, NULL, &pemData);
    } else {
        err = SecKeychainItemExport((CFArrayRef) anchors, kSecFormatPEMSequence, kSecItemPemArmour, NULL, &pemData);
    }
    PLCFAutorelease(pemData);

    if (err != errSecSuccess) {
        nsfprintf(stderr, @"Failed to export certificates: %@\n", [NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo:nil]);
        [pool release];
        return EXIT_FAILURE;
    }

    nsfprintf(stderr, @"Writing exported certificates\n");
    if (outputFile == nil) {
        NSString *str = [[[NSString alloc] initWithData: (NSData *) pemData encoding:NSUTF8StringEncoding] autorelease];
        nsfprintf(stdout, @"%@", str);
    } else {
        if (![(NSData *) pemData writeToFile: outputFile options: NSDataWritingAtomic error: &error]) {
            nsfprintf(stderr, @"Failed to write to pem output file: %@\n", error);
            [pool release];
            return EXIT_FAILURE;
        }
    }

    [pool release];
    return EXIT_SUCCESS;
}

static void usage (const char *progname) {
    fprintf(stderr, "Usage: %s [-u] [-o <output file>]\n", progname);
    fprintf(stderr, "\t-u\t\t\tInclude the current user's anchor certificates.\n");
    fprintf(stderr, "\t-o <output file>\tWrite the PEM certificates to the target file, rather than stdout\n");
}

int main (int argc, char * const argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    /* Parse the command line arguments */
    BOOL userAnchors = NO;
    NSString *outputFile = nil;

    int ch;
    while ((ch = getopt(argc, argv, "hsuo:")) != -1) {
        switch (ch) {
            case 'u':
                userAnchors = YES;
                break;

            case 'o':
                outputFile = [NSString stringWithUTF8String: optarg];
                break;

            case 'h':
                usage(argv[0]);
                exit(EXIT_SUCCESS);

            default:
                usage(argv[0]);
                exit(EXIT_FAILURE);
        }
    }
    argc -= optind;
    argv += optind;

    /* Perform export  */
    int result = exportCertificates(userAnchors, outputFile);

    [pool release];
    return result;
}

