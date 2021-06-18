#include "config.h"
#import "NSApplicationActivationPolicy.h"
#import <AppKit/AppKit.h>

// C "trampoline" function to invoke Objective-C method
void SetActivationPolicyProhibited ()
{
    [NSApp setActivationPolicy: NSApplicationActivationPolicyProhibited];
    return;
}
