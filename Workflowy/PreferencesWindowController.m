//
//  PreferencesWindowController.m
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 31/12/15.
//  Copyright © 2015 Apps Ezy. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesWindowController.h"
#import <MASShortcut/Shortcut.h>

@interface PreferencesWindowController ()

@property (weak) IBOutlet MASShortcutView *shortcutView;

@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.shortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
}

@end
