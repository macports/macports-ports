// Copyright 2015 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Application that finds all Xcodes installed on a given Mac and will return a
// path for a given version number.
//
// If you have 7.0, 6.4.1 and 6.3 installed the inputs will map to:
//
// 7,7.0,7.0.0 = 7.0
// 6,6.4,6.4.1 = 6.4.1
// 6.3,6.3.0 = 6.3

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>

// Simple data structure for tracking a version of Xcode (i.e. 6.4) with an URL
// to the appplication.
@interface XcodeVersionEntry : NSObject
@property(readonly) NSString *version;
@property(readonly) NSURL *url;
@end

@implementation XcodeVersionEntry

- (id)initWithVersion:(NSString *)version url:(NSURL *)url {
  if ((self = [super init])) {
    _version = version;
    _url = url;
  }
  return self;
}

- (id)description {
  return [NSString stringWithFormat:@"<%@ %p>: %@ %@",
                   [self class], self, _version, _url];
}

@end

// Searches for all available Xcodes in the system and returns a dictionary that
// maps version identifiers of any form (X, X.Y, and X.Y.Z) to the directory
// where the Xcode bundle lives.
//
// If there is a problem locating the Xcodes, prints one or more error messages
// and returns nil.
static NSMutableDictionary *FindXcodes() __attribute((ns_returns_retained)) {
  CFStringRef bundleID = CFSTR("com.apple.dt.Xcode");

  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  // hacked away everything here...
  return dict;
}

// Prints out the located Xcodes in JSON format.
static void DumpAsJson(FILE *output, NSMutableDictionary *dict) {
  fprintf(output, "{\n");
//  for (NSString *version in dict) {
//    XcodeVersionEntry *entry = dict[version];
//    fprintf(output, "\t\"%s\": \"%s\",\n",
//            version.UTF8String, entry.url.fileSystemRepresentation);
//  }
  fprintf(output, "}\n");
}

// Dumps usage information.
static void usage(FILE *output) {
  fprintf(
      output,
      "xcode-locator [-v|<version_number>]"
      "\n\n"
      "Given a version number or partial version number in x.y.z format, "
      "will attempt to return the path to the appropriate developer "
      "directory."
      "\n\n"
      "Omitting a version number will list all available versions in JSON "
      "format, alongside their paths."
      "\n\n"
      "Passing -v will list all available fully-specified version numbers "
      "along with their possible aliases and their developer directory, "
      "each on a new line. For example:"
      "\n\n"
      "7.3.1:7,7.3,7.3.1:/Applications/Xcode.app/Contents/Developer"
      "\n");
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSString *versionArg = nil;
    BOOL versionsOnly = NO;
    if (argc == 1) {
      versionArg = @"";
    } else if (argc == 2) {
      NSString *firstArg = [NSString stringWithUTF8String:argv[1]];
      if ([@"-v" isEqualToString:firstArg]) {
        versionsOnly = YES;
        versionArg = @"";
      } else {
        versionArg = firstArg;
        NSCharacterSet *versSet =
            [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        if ([versionArg rangeOfCharacterFromSet:versSet.invertedSet].length
            != 0) {
          versionArg = nil;
        }
      }
    }
    if (versionArg == nil) {
      usage(stderr);
      return 1;
    }

    NSMutableDictionary *dict = FindXcodes();
    if (dict == nil) {
      return 1;
    }

    //XcodeVersionEntry *entry = [dict objectForKey:versionArg];
    //if (entry) {
    //  printf("%s\n", entry.url.fileSystemRepresentation);
    //  return 0;
    // }

    if (versionsOnly) {
      //DumpAsVersionsOnly(stdout, dict);
    } else {
      DumpAsJson(stdout, dict);
    }
    return ([@"" isEqualToString:versionArg] ? 0 : 1);
  }
}
