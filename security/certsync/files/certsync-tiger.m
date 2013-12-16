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
#import <AvailabilityMacros.h>

#import <unistd.h>
#import <stdio.h>

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
 * Fetch all trusted roots.
 *
 * @param outError On error, will contain an NSError instance describing the failure.
 *
 * @return Returns a (possibly empty) array of certificates on success, nil on failure.
 */
static NSArray *certificatesForTrustDomain (NSError **outError) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CFArrayRef certs = nil;
    OSStatus err;
    
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
    
    /* Extract trusted roots */
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: CFArrayGetCount(certs)];
    NSEnumerator *resultEnumerator = [(NSArray *)certs objectEnumerator];
    id certObj;
    while ((certObj = [resultEnumerator nextObject]) != nil) {
        [results addObject: certObj];
    }

    [results retain];
    [pool release];
    return [results autorelease];
}

BOOL compare_oids (const CSSM_OID *oid1, const CSSM_OID *oid2) {
    if (oid1 == NULL || oid2 == NULL)
        return NO;

    if (oid1->Length != oid2->Length)
        return NO;

    if (memcmp(oid1->Data, oid2->Data, oid1->Length) == 0)
        return YES;

    return NO;
}

static int exportCertificates (NSString *outputFile) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    /* Fetch all certificates */
    NSArray *anchors;
    NSError *error;
    OSStatus err;

    anchors = certificatesForTrustDomain(&error);
    if (anchors == nil) {
        nsfprintf(stderr, @"Failed to fetch system anchors: %@\n", error);
        [pool release];
        return EXIT_FAILURE;
    }
    
    /*
     * Perform export
     */
    CFDataRef pemData;
    
    /* Prefer the non-deprecated SecItemExport on Mac OS X >= 10.7. We use an ifdef to keep the code buildable with earlier SDKs, too. */
    nsfprintf(stderr, @"Exporting certificates from the keychain\n");
    err = SecKeychainItemExport((CFArrayRef) anchors, kSecFormatPEMSequence, kSecItemPemArmour, NULL, &pemData);
    PLCFAutorelease(pemData);

    if (err != noErr) {
        nsfprintf(stderr, @"Failed to export certificates: %@\n", [NSError errorWithDomain: NSOSStatusErrorDomain code: err userInfo:nil]);
        [pool release];
        return EXIT_FAILURE;
    }

    nsfprintf(stderr, @"Writing exported certificates\n");
    if (outputFile == nil) {
        NSString *str = [[[NSString alloc] initWithData: (NSData *) pemData encoding:NSUTF8StringEncoding] autorelease];
        nsfprintf(stdout, @"%@", str);
    } else {
        if (![(NSData *) pemData writeToFile: outputFile options: NSAtomicWrite error: &error]) {
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
    fprintf(stderr, "\t-s\t\t\tDo not exit; observe the system keychain(s) for changes and update the output file accordingly.");
    fprintf(stderr, "\t-o <output file>\tWrite the PEM certificates to the target file, rather than stdout\n");
}

#if 0
static void certsync_keychain_cb (ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    MPCertSyncConfig *config = (MPCertSyncConfig *) clientCallBackInfo;

    int ret;
    if ((ret = exportCertificates(config->userAnchors, config->outputFile)) != EXIT_SUCCESS)
        exit(ret);

    [pool release];
}
#endif

int main (int argc, char * const argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    /* Parse the command line arguments */
    BOOL runServer = NO;
    NSString *outputFile = nil;
    
    int ch;
    while ((ch = getopt(argc, argv, "hsuo:")) != -1) {
        switch (ch) {
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
        return exportCertificates(outputFile);
   
#if 0 
    /* Formulate the list of directories to observe; We use FSEvents rather than SecKeychainAddCallback(), as during testing the keychain
     * API never actually fired a callback for the target keychains. */
    FSEventStreamRef eventStream;
    {
        NSAutoreleasePool *streamPool = [[NSAutoreleasePool alloc] init];

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
        
        [streamPool release];
    }

    /* Perform an initial one-shot export, and then run forever */
    {
    NSAutoreleasePool *shotPool = [[NSAutoreleasePool alloc] init];
        int ret;
        if ((ret = exportCertificates(userAnchors, outputFile)) != EXIT_SUCCESS)
            return EXIT_FAILURE;
        [shotPool release];
    }

    CFRunLoopRun();
    FSEventStreamRelease(eventStream);
#endif
    [pool release];

    return EXIT_SUCCESS;
}

