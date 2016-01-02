//
//  AppDelegate.m
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 17/11/15.
//  Copyright © 2015 Apps Ezy. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesWindowController.h"
#import <MASShortcut/Shortcut.h>

NSString *const kPreferenceGlobalShortcut = @"GlobalShortcut";

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet WebView *webView;

@property (strong) PreferencesWindowController *preferencesWindowController;

@property (strong) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL darkModeOn;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // http://davehiren.blogspot.com.es/2014/02/create-simple-mac-osx-application-with.html
    
    // Maximized
    //[self.window setIsZoomed:TRUE];
    //[self.window setTitle:@"Workflowy"];

    [self initWebView];
    
    [self initStatusItem];
    
    // TODO: window
    // http://stackoverflow.com/questions/1902618/creating-a-modal-dialog-or-window-in-cocoa-objective-c/2169521#2169521
    
    // TODO: hotkeys
    // https://github.com/shpakovski/MASShortcut <<---
    //   https://github.com/shpakovski/MASShortcut/blob/master/Demo/AppDelegate.h
    // https://github.com/davedelong/DDHotKey
    // https://github.com/jaz303/JFHotkeyManager

    /*
    MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_F2 modifierFlags:NSCommandKeyMask];
    [[MASShortcutMonitor sharedMonitor] registerShortcut:shortcut withAction:^{
        [self openWorkflowy];
    }];
    */
    
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:kPreferenceGlobalShortcut toAction:^{
         [self openWorkflowy];
     }];
    
    self.preferencesWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"Preferences"];
    [self.preferencesWindowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

- (void)initWebView {
    
    // Enable Safari debugging
    // $ defaults write com.appsezy.Workflowy WebKitDeveloperExtras -bool true
    /*
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"WebKitDeveloperExtras"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    */
    
    // http://stackoverflow.com/questions/1251561/cocoa-webview-disable-all-interaction
    // Alt: http://stackoverflow.com/questions/5995210/disabling-user-selection-in-uiwebview
    //[self.webView setUIDelegate:self];
    //[self.webView setEditingDelegate:self];

    // http://stackoverflow.com/questions/16704156/how-to-open-external-links-to-safari-chrome-browser-in-cocoa/16868088#16868088
    [self.webView setUIDelegate:self];
    [self.webView setPolicyDelegate:self];
    
    NSURL *url = [NSURL URLWithString:@"https://workflowy.com/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView.mainFrame loadRequest:urlRequest];
}

//- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element
//    defaultMenuItems:(NSArray *)defaultMenuItems {
//
//    // disable right-click context menu
//    return nil;
//}

- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange
     toDOMRange:(DOMRange *)proposedRange affinity:(NSSelectionAffinity)selectionAffinity
 stillSelecting:(BOOL)flag {
    
    // disable text selection
    return NO;
}

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    
    if ([sender isEqual:self.webView]) {
        [listener use];
    } else {
        [[NSWorkspace sharedWorkspace] openURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
        [listener ignore];
    }
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener {

    [[NSWorkspace sharedWorkspace] openURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
    [listener ignore];
}

- (WebView *)webView:(WebView *)sender createWebViewModalDialogWithRequest:(NSURLRequest *)request {
    [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    return nil;
}

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request {
    
    // HACK: This is all a hack to get around a bug/misfeature in Tiger's WebKit
    // (should be fixed in Leopard). On Javascript window.open, Tiger sends a null
    // request here, then sends a loadRequest: to the new WebView, which will
    // include a decidePolicyForNavigation (which is where we'll open our
    // external window). In Leopard, we should be getting the request here from
    // the start, and we should just be able to create a new window.
    
    WebView *newWebView = [[WebView alloc] init];
    [newWebView setUIDelegate:self];
    [newWebView setPolicyDelegate:self];
    return newWebView;
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

- (IBAction)openWorkflowy:(id)sender {
    [self openWorkflowy];
}

- (void)openWorkflowy {
    NSRunningApplication *workflowyApp = [NSRunningApplication currentApplication];
    [workflowyApp
     activateWithOptions:NSApplicationActivateAllWindows|NSApplicationActivateIgnoringOtherApps];
}

@end
