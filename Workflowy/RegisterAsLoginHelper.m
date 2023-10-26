//
//  RegisterAsLoginHelper.m
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 3/1/16.
//  Copyright © 2016 Apps Ezy. All rights reserved.
//

#import "RegisterAsLoginHelper.h"

@interface RegisterAsLoginHelper ()

+ (LSSharedFileListItemRef)itemRefInLoginItems;

@end

@implementation RegisterAsLoginHelper

// Based on: http://stackoverflow.com/questions/608963/register-as-login-item-with-cocoa/20297681#20297681

+ (BOOL)isLaunchAtStartup {

    LSSharedFileListItemRef itemRef = [RegisterAsLoginHelper itemRefInLoginItems];
    BOOL isInList = itemRef != nil;
    if (itemRef != nil) CFRelease(itemRef);
    
    return isInList;
}

+ (void)setLaunchAtStartup:(BOOL)launchAtStartup {

    BOOL currentValue = [RegisterAsLoginHelper isLaunchAtStartup];
    BOOL shouldBeToggled = currentValue != launchAtStartup;
    if (!shouldBeToggled)
        return;
    
    // Get the LoginItems list.
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil) return;
    if (launchAtStartup) {
        
        // Add the app to the LoginItems list.
        CFURLRef appUrl = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        LSSharedFileListItemRef itemRef =
            LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL, NULL, appUrl, NULL, NULL);
        if (itemRef) CFRelease(itemRef);
        
    } else {
        
        // Remove the app from the LoginItems list.
        LSSharedFileListItemRef itemRef = [RegisterAsLoginHelper itemRefInLoginItems];
        LSSharedFileListItemRemove(loginItemsRef,itemRef);
        if (itemRef != nil) CFRelease(itemRef);
        
    }
    
    CFRelease(loginItemsRef);
}

+ (LSSharedFileListItemRef)itemRefInLoginItems {
    
    LSSharedFileListItemRef res = nil;
    
    // Get the app's URL.
    NSURL *bundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    // Get the LoginItems list.
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil) return nil;
    // Iterate over the LoginItems.
    NSArray *loginItems = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItemsRef, nil);
    for (id item in loginItems) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)(item);
        CFURLRef itemURLRef;
        if (LSSharedFileListItemResolve(itemRef, 0, &itemURLRef, NULL) == noErr) {
            // Again, use toll-free bridging.
            NSURL *itemURL = (__bridge NSURL *)itemURLRef;
            if ([itemURL isEqual:bundleURL]) {
                res = itemRef;
                break;
            }
        }
    }
    // Retain the LoginItem reference.
    if (res != nil) CFRetain(res);
    CFRelease(loginItemsRef);
    CFRelease((__bridge CFTypeRef)(loginItems));
    
    return res;
}

@end