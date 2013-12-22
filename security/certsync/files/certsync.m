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
 * Fetch all trusted roots for the given @a domain.
 *
 * @param domain The trust domain to query.
 * @param outError On error, will contain an NSError instance describing the failure.
 *
 * @return Returns a (possibly empty) array of certificates on success, nil on failure.
 */
static NSArray *certificatesForTrustDomain (SecTrustSettingsDomain domain, NSError **outError) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray *trusted = nil;
    CFArrayRef certs = nil;
    OSStatus err;
    
    /* Mac OS X >= 10.5 provides SecTrustSettingsCopyCertificates() */
    if (SecTrustSettingsCopyCertificates != NULL) {
        /* Fetch all certificates in the given domain */
        err = SecTrustSettingsCopyCertificates(domain, &certs);
        if (err == errSecSuccess) {
            PLCFAutorelease(certs);
        } else if (err == errSecNoTrustSettings ) {
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
        NSMutableArray *results = [NSMutableArray arrayWithCapacity: CFArrayGetCount(certs)];
        trusted = results;
        
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
                [results addObject: certObj];
            } else {
                /* Otherwise, walk the properties and evaluate the trust settings result */
                NSEnumerator *trustEnumerator = [(NSArray *)trustSettings objectEnumerator];
                NSDictionary *trustProps;
                while ((trustProps = [trustEnumerator nextObject]) != nil) {
                    CFNumberRef settingsResultNum;
                    SInt32 settingsResult;
                
                    settingsResultNum = (CFNumberRef) [trustProps objectForKey: (id) kSecTrustSettingsResult];
                    CFNumberGetValue(settingsResultNum, kCFNumberSInt32Type, &settingsResult);
                
                    /* If a root, add to the result set */
                    if (settingsResult == kSecTrustSettingsResultTrustRoot || settingsResult == kSecTrustSettingsResultTrustAsRoot) {
                        [results addObject: certObj];
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
        trusted = (NSArray *) certs;
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
        result = certificatesForTrustDomain(kSecTrustSettingsDomainUser, &error);
        if (result != nil) {
            [anchors addObjectsFromArray: result];
        } else {
            nsfprintf(stderr, @"Failed to fetch user anchors: %@\n", error);
            [pool release];
            return EXIT_FAILURE;
        }
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
    
    NSEnumerator *resultEnumerator = [result objectEnumerator];
    id certObj;
    while ((certObj = [resultEnumerator nextObject]) != nil) {
        NSError *subjectError = NULL;
        CFStringRef subject = NULL;
        BOOL subjectUnsupported = NO;

        if (SecCertificateCopyShortDescription != NULL /* 10.7 */) {
            subject = PLCFAutorelease(SecCertificateCopyShortDescription(NULL, (SecCertificateRef) certObj, (CFErrorRef *) &subjectError));
            
        } else if (SecCertificateCopySubjectSummary != NULL /* 10.6 */) {
            subject = PLCFAutorelease(SecCertificateCopySubjectSummary((SecCertificateRef) certObj));
            
        } else if (SecCertificateCopyCommonName != NULL /* 10.5 */) {
            if ((err = SecCertificateCopyCommonName((SecCertificateRef) certObj, &subject)) == errSecSuccess && subject != NULL) {
                PLCFAutorelease(subject);
            } else {
                /* In the case that the CN is simply unavailable, provide a more useful error code */
                if (err == errSecSuccess)
                    err = errSecNoSuchAttr;

                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"SecCertificateCopyCommonName() failed", NSLocalizedDescriptionKey, nil];
                subjectError = [NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo: userInfo];
                subject = NULL;
            }
        } else /* <= 10.4 */ {
            subjectUnsupported = YES;
        }

        if (subject == NULL) {
            /* Don't print an error if fetching the subject is unsupported on the platform (eg, <= 10.4) */
            if (!subjectUnsupported)
                nsfprintf(stderr, @"Failed to extract certificate description: %@\n", subjectError);
        } else {
            nsfprintf(stderr, @"Found %@\n", subject);
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

