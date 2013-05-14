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
#import <AvailabilityMacros.h>

#import <unistd.h>
#import <stdio.h>

#import <objc/message.h>

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
    CFArrayRef certs = nil;
    OSStatus err;
    
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
            *outError = [NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo:nil];
        
        [pool release];
        return nil;
    }
    
    /* Extract trusted roots */
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: CFArrayGetCount(certs)];
    for (id certObj in (NSArray *) certs) {
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
            for (NSDictionary *trustProps in (NSArray *) trustSettings) {
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

    [results retain];
    [pool release];
    return [results autorelease];
}

static int exportCertificates (BOOL userAnchors, NSString *outputFile) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

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
    
    for (id certObj in result) {
        CFErrorRef cferror = NULL;
        CFStringRef subject;

#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_6
        if (SecCertificateCopyShortDescription != NULL) {
            subject = PLCFAutorelease(SecCertificateCopyShortDescription(NULL, (SecCertificateRef) certObj, &cferror));
        } else {
            subject = PLCFAutorelease(SecCertificateCopySubjectSummary((SecCertificateRef) certObj));
        }
#else
        subject = PLCFAutorelease(SecCertificateCopySubjectSummary((SecCertificateRef) certObj));
#endif

        if (subject == NULL) {
            nsfprintf(stderr, @"Failed to extract certificate description: %@\n", cferror);
            [pool release];
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
    
    /* Prefer the non-deprecated SecItemExport on Mac OS X >= 10.7. We use an ifdef to keep the code buildable with earlier SDKs, too. */
#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_6
    if (SecItemExport != NULL) {
        err = SecItemExport((CFArrayRef) anchors, kSecFormatPEMSequence, kSecItemPemArmour, NULL, &pemData);
    } else {
        err = SecKeychainItemExport((CFArrayRef) anchors, kSecFormatPEMSequence, kSecItemPemArmour, NULL, &pemData);
    }
#else
    err = SecKeychainItemExport((CFArrayRef) anchors, kSecFormatPEMSequence, kSecItemPemArmour, NULL, &pemData);
#endif
    PLCFAutorelease(pemData);

    if (err != errSecSuccess) {
        nsfprintf(stderr, @"Failed to export certificates: %@\n", [NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo:nil]);
        [pool release];
        return EXIT_FAILURE;
    }

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
    fprintf(stderr, "\t-s\t\t\tDo not exit; observe the system keychain(s) for changes and update the output file accordingly.");
    fprintf(stderr, "\t-o <output file>\tWrite the PEM certificates to the target file, rather than stdout\n");
}

static void certsync_keychain_cb (ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    MPCertSyncConfig *config = (MPCertSyncConfig *) clientCallBackInfo;

    int ret;
    if ((ret = exportCertificates(config->userAnchors, config->outputFile)) != EXIT_SUCCESS)
        exit(ret);
}

int main (int argc, char * const argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    /* Parse the command line arguments */
    BOOL userAnchors = NO;
    BOOL runServer = NO;
    NSString *outputFile = nil;
    
    int ch;
    while ((ch = getopt(argc, argv, "hsuo:")) != -1) {
        switch (ch) {
            case 'u':
                userAnchors = YES;
                break;
                
            case 's':
                runServer = YES;
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
    
    /* Perform single-shot export  */
    if (!runServer)
        return exportCertificates(userAnchors, outputFile);
    
    /* Formulate the list of directories to observe; We use FSEvents rather than SecKeychainAddCallback(), as during testing the keychain
     * API never actually fired a callback for the target keychains. */
    NSSearchPathDomainMask searchPathDomains = NSLocalDomainMask|NSSystemDomainMask;
    if (userAnchors)
        searchPathDomains |= NSUserDomainMask;

    NSArray *libraryDirectories = NSSearchPathForDirectoriesInDomains(NSAllLibrariesDirectory, searchPathDomains, YES);
    NSMutableArray *keychainDirectories = [NSMutableArray arrayWithCapacity: [libraryDirectories count]];
    for (NSString *dir in libraryDirectories) {
        [keychainDirectories addObject: [dir stringByAppendingPathComponent: @"Keychains"]];
        [keychainDirectories addObject: [dir stringByAppendingPathComponent: @"Security/Trust Settings"]];
    }

    /* Configure the listener */
    FSEventStreamRef eventStream;
    MPCertSyncConfig *config = [[[MPCertSyncConfig alloc] init] autorelease];
    config->userAnchors = userAnchors;
    config->outputFile = [outputFile retain];

    FSEventStreamContext ctx = {
        .version = 0,
        .info = config,
        .retain = CFRetain,
        .release = CFRelease,
        .copyDescription = CFCopyDescription
    };
    eventStream = FSEventStreamCreate(NULL, certsync_keychain_cb, &ctx, (CFArrayRef)keychainDirectories, kFSEventStreamEventIdSinceNow, 0.0, kFSEventStreamCreateFlagUseCFTypes);
    FSEventStreamScheduleWithRunLoop(eventStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    FSEventStreamStart(eventStream);

    /* Perform an initial one-shot export, and then run forever */
    int ret;
    if ((ret = exportCertificates(userAnchors, outputFile)) != EXIT_SUCCESS)
        return EXIT_FAILURE;
    
    CFRunLoopRun();

    FSEventStreamRelease(eventStream);
    [pool release];

    return EXIT_SUCCESS;
}

