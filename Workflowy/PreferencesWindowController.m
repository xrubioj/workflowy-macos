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
#import "RegisterAsLoginHelper.h"

@interface PreferencesWindowController ()

@property (weak) IBOutlet MASShortcutView *shortcutView;
@property (weak) IBOutlet NSButton *startAtLoginView;

@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.shortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
    self.startAtLoginView.state = [RegisterAsLoginHelper isLaunchAtStartup] ? NSOnState : NSOffState;
}

- (IBAction)toggleStartAtLogin:(id)sender {
    BOOL launchAtStartup = self.startAtLoginView.state == NSOnState;
    [RegisterAsLoginHelper setLaunchAtStartup:launchAtStartup];
}

@end
