//
//  AppDelegate.h
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 17/11/15.
//  Copyright © 2015 Apps Ezy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT NSString *const kPreferenceGlobalShortcut;

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void)setMainWindow:(NSWindowController *)windowController;
- (void)removeMainWindow;

@end

