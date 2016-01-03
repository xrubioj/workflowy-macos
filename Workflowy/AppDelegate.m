//
//  AppDelegate.m
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 17/11/15.
//  Copyright © 2015 Apps Ezy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "PreferencesWindowController.h"
#import <MASShortcut/Shortcut.h>

NSString *const kPreferenceGlobalShortcut = @"GlobalShortcut";
NSString *const kFirstRun = @"FirstRun";

@interface AppDelegate ()

@property (strong) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL darkModeOn;

@property (strong) MainWindowController *mainWindowController;
@property (strong) PreferencesWindowController *preferencesWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // http://davehiren.blogspot.com.es/2014/02/create-simple-mac-osx-application-with.html
    
    // Enable Safari debugging
    // $ defaults write com.appsezy.Workflowy WebKitDeveloperExtras -bool true
    /*
     NSDictionary *defaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"WebKitDeveloperExtras"];
     [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
     [[NSUserDefaults standardUserDefaults] synchronize];
     */
    
    [self initStatusItem];
    
    // Global shortcut libraries:
    // https://github.com/shpakovski/MASShortcut <<--- the one we used
    // https://github.com/davedelong/DDHotKey
    // https://github.com/jaz303/JFHotkeyManager

    // Should we use a fixed key combination
    /*
    MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_F2 modifierFlags:NSCommandKeyMask];
    [[MASShortcutMonitor sharedMonitor] registerShortcut:shortcut withAction:^{
        [self openWorkflowy];
    }];
    */
    
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:kPreferenceGlobalShortcut toAction:^{
         [self openWorkflowy];
     }];

    // Open preferences on first run, with a delay to allow the main window to be shown prior to
    //  preferences, so preferences show on top of it and not the other way around
    if ([self isFirstRun]) {
        [self performSelector:@selector(openPreferences:) withObject:nil afterDelay:1.0];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

- (void)applicationWillBecomeActive:(NSNotification *)notification {
    if (self.mainWindowController) {
        [self openWorkflowy];
    }
}

// ------------------------------------------------------------------------------------------------------

- (BOOL)isFirstRun {
    NSDictionary *defaults = @{ kFirstRun : @YES };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    BOOL firstRun = [[NSUserDefaults standardUserDefaults] boolForKey:kFirstRun];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kFirstRun];
    
    return firstRun;
}

// ------------------------------------------------------------------------------------------------------

- (void)setMainWindow:(NSWindowController *)windowController {
    self.mainWindowController = (MainWindowController *)windowController;
}

- (void)removeMainWindow {
    // NOTE: this is currently not used. Close event never gets called, which is ok,
    //  because currently when we close the window we really do not destroy it, and
    //  we can show it again
    self.mainWindowController = nil;
}

// ------------------------------------------------------------------------------------------------------

- (void)initStatusItem {
    
    // http://www.mactech.com/articles/mactech/Vol.22/22.02/Menulet/index.html
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setTitle:@""];
    [self.statusItem setEnabled:YES];
    [self.statusItem setToolTip:@"Workflowy"];
    
    [self.statusItem setAction:@selector(openWorkflowy:)];
    [self.statusItem setTarget:self];
    
    // Not used: http://stackoverflow.com/questions/25379525/how-to-detect-dark-mode-in-yosemite-to-change-the-status-bar-menu-icon/26472651#26472651
    // http://indiestack.com/2014/10/yosemites-dark-mode/
    NSImage *statusItemImage = [NSImage imageNamed:@"StatusImage"];
    [self.statusItem setImage:statusItemImage];
    BOOL oldBusted = (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9);
    if (!oldBusted) {
        // 10.10 or higher, so setTemplate: is safe
        [statusItemImage setTemplate:YES];
    }

}

// ------------------------------------------------------------------------------------------------------

- (IBAction)openPreferences:(id)sender {
    [self openPreferences];
}

- (void)openPreferences {
    self.preferencesWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"Preferences"];
    [self.preferencesWindowController showWindow:self];
}

- (IBAction)openWorkflowy:(id)sender {
    [self openWorkflowy];
}

- (void)openWorkflowy {
    NSRunningApplication *workflowyApp = [NSRunningApplication currentApplication];
    [workflowyApp activateWithOptions:NSApplicationActivateAllWindows|NSApplicationActivateIgnoringOtherApps];

    if (!self.mainWindowController) {
        self.mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainMenu"];
    }
    [self.mainWindowController showWindow:self];
}

@end
