//
//  AppDelegate.h
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 17/11/15.
//  Copyright © 2015 Apps Ezy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"
#import "PreferencesWindowController.h"

FOUNDATION_EXPORT NSString *const kPreferenceGlobalShortcut;

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (BOOL)isYosemite;

@end

