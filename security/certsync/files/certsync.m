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
#import <unistd.h>
#import <stdio.h>

#import <objc/message.h>

/**
 * Add CoreFoundation object to the current autorelease pool.
 *
 * @param cfObj Object to add to the current autorelease pool.
 */
CFTypeRef PLCFAutorelease (CFTypeRef cfObj) {
    /* ARC forbids the use of @selector(autorelease), so we have to get creative */
    static SEL autorelease;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        autorelease = sel_getUid("autorelease");
    });
    
    /* Cast and hand-dispatch */
    return ((CFTypeRef (*)(CFTypeRef, SEL)) objc_msgSend)(cfObj, autorelease);
}

int nsvfprintf (FILE *stream, NSString *format, va_list args) {
    int retval;
    
    NSString *str;
    str = (__bridge_transfer NSString *) CFStringCreateWithFormatAndArguments(NULL, NULL, (CFStringRef) format, args);
    retval = fprintf(stream, "%s", [str UTF8String]);
    
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
    CFArrayRef certs = nil;
    OSStatus err;
    
    /* Fetch all certificates in the given domain */
    err = SecTrustSettingsCopyCertificates(domain, &certs);
    if (err == errSecSuccess) {
        PLCFAutorelease(certs);
    } else if (err == errSecNoTrustSettings ) {
        /* No data */
        return [NSArray array];
        
    } else if (err != errSecSuccess) {
        /* Lookup failed */
        if (outError != NULL)
            *outError = [NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo:nil];
        return nil;
    }
    
    /* Extract trusted roots */
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: CFArrayGetCount(certs)];
    for (id certObj in (__bridge NSArray *) certs) {
        SecCertificateRef cert = (__bridge SecCertificateRef) certObj;
        
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
            for (NSDictionary *trustProps in (__bridge NSArray *) trustSettings) {
                CFNumberRef settingsResultNum;
                SInt32 settingsResult;
                
                settingsResultNum = (__bridge CFNumberRef) [trustProps objectForKey: (__bridge id) kSecTrustSettingsResult];
                CFNumberGetValue(settingsResultNum, kCFNumberSInt32Type, &settingsResult);
                
                /* If a root, add to the result set */
                if (settingsResult == kSecTrustSettingsResultTrustRoot || settingsResult == kSecTrustSettingsResultTrustAsRoot) {
                    [results addObject: certObj];
                    break;
                }
            }
        }
    }
    
    return results;
}

static int exportCertificates (BOOL userAnchors, NSString *outputFile) {
    /*
     * Fetch all certificates
     */
    
    NSMutableArray *anchors = [NSMutableArray array];
    NSArray *result;
    NSError *error;
    
    /* Current user */
    if (userAnchors) {
        result = certificatesForTrustDomain(kSecTrustSettingsDomainUser, &error);
        if (result != nil) {
            [anchors addObjectsFromArray: result];
        } else {
            nsfprintf(stderr, @"Failed to fetch user anchors: %@\n", error);
            return EXIT_FAILURE;
        }
    }
    
    /* Admin */
    result = certificatesForTrustDomain(kSecTrustSettingsDomainAdmin, &error);
    if (result != nil) {
        [anchors addObjectsFromArray: result];
    } else {
        nsfprintf(stderr, @"Failed to fetch admin anchors: %@\n", error);
        return EXIT_FAILURE;
    }
    
    /* System */
    result = certificatesForTrustDomain(kSecTrustSettingsDomainSystem, &error);
    if (result != nil) {
        [anchors addObjectsFromArray: result];
    } else {
        nsfprintf(stderr, @"Failed to fetch system anchors: %@\n", error);
        return EXIT_FAILURE;
    }
    
    for (id certObj in result) {
        CFErrorRef cferror;
        CFStringRef subject = SecCertificateCopyShortDescription(NULL, (__bridge SecCertificateRef) certObj, &cferror);
        if (subject == NULL) {
            nsfprintf(stderr, @"Failed to extract certificate description: %@\n", cferror);
            return EXIT_FAILURE;
        } else {
            nsfprintf(stderr, @"Extracting %@\n", subject);
        }
    }
    
    /*
     * Perform export
     */
    CFDataRef pemData;
    OSStatus err;
    
    /* Prefer the non-deprecated SecItemExport on Mac OS X >= 10.7 */
    if (NO && SecItemExport != NULL) {
        err = SecItemExport((__bridge CFArrayRef) anchors, kSecFormatPEMSequence, kSecItemPemArmour, NULL, &pemData);
    } else {
        err = SecKeychainItemExport((__bridge CFArrayRef) anchors, kSecFormatPEMSequence, kSecItemPemArmour, NULL, &pemData);
    }
    
    if (err != errSecSuccess) {
        nsfprintf(stderr, @"Failed to export certificates: %@\n", [NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo:nil]);
        return EXIT_FAILURE;
    }

    if (outputFile == nil) {
        NSString *str = [[NSString alloc] initWithData: (__bridge NSData *) pemData encoding:NSUTF8StringEncoding];
        nsfprintf(stdout, @"%@", str);
    } else {
        if (![(__bridge NSData *) pemData writeToFile: outputFile options: NSDataWritingAtomic error: &error]) {
            nsfprintf(stderr, @"Failed to write to pem output file: %@\n", error);
            return EXIT_FAILURE;
        }
    }
    
    return EXIT_SUCCESS;
}

static void usage (const char *progname) {
    fprintf(stderr, "Usage: %s [-u] [-o <output file>]\n", progname);
    fprintf(stderr, "\t-u\t\t\tInclude the current user's anchor certificates.\n");
    fprintf(stderr, "\t-o <output file>\tWrite the PEM certificates to the target file, rather than stdout\n");
}

int main (int argc, char * const argv[]) {
    @autoreleasepool {
        /* Parse the command line arguments */
        BOOL userAnchors = NO;
        NSString *outputFile = nil;
        
        int ch;
        while ((ch = getopt(argc, argv, "huo:")) != -1) {
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

        return exportCertificates(userAnchors, outputFile);
    }
}

