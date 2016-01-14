//
//  MainWindowController.m
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 2/1/16.
//  Copyright © 2016 Apps Ezy. All rights reserved.
//

#import "MainWindowController.h"
#import "AppDelegate.h"

static NSString *const kURL = @"https://workflowy.com/";

// Hack hack hack
static NSURL *lastURL;

@interface MainWindowController ()

@property (weak) IBOutlet WebView *webView;

@property (strong) NSURL *baseURL;

@end

@implementation MainWindowController

- (id)initWithURL:(NSURL *)url {
    
    self.baseURL = url;
    return [super initWithWindowNibName:@"MainMenu"];
}

- (void)awakeFromNib {
    AppDelegate *appDelegate = (AppDelegate *)[NSApp delegate];
    [appDelegate setMainWindow:self];

    [super awakeFromNib];
    [self initWebView];
}

/*
- (void)windowWillClose:(NSNotification *)notification {
    AppDelegate *appDelegate = (AppDelegate *)[NSApp delegate];
    [appDelegate removeMainWindow];
}
*/

- (void)initWebView {
    
    // http://stackoverflow.com/questions/1251561/cocoa-webview-disable-all-interaction
    // Alt: http://stackoverflow.com/questions/5995210/disabling-user-selection-in-uiwebview
    //[self.webView setUIDelegate:self];
    //[self.webView setEditingDelegate:self];
    
    // http://stackoverflow.com/questions/16704156/how-to-open-external-links-to-safari-chrome-browser-in-cocoa/16868088#16868088
    [self.webView setUIDelegate:self];
    [self.webView setPolicyDelegate:self];
    
    if (!self.baseURL && !lastURL) {
        self.baseURL = [NSURL URLWithString:kURL];
        NSLog(@"Opening MainWindow with default URL %@", self.baseURL);
    } else {
        if (!self.baseURL)
            self.baseURL = lastURL;
        NSLog(@"Opening MainWindow with URL %@", self.baseURL);
    }
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.baseURL];
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
        //[[NSWorkspace sharedWorkspace] openURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
        [self conditionallyOpenURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
        [listener ignore];
    }
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener {
    
    //[[NSWorkspace sharedWorkspace] openURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
    [self conditionallyOpenURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
    [listener ignore];
}

- (WebView *)webView:(WebView *)sender createWebViewModalDialogWithRequest:(NSURLRequest *)request {
    //[[NSWorkspace sharedWorkspace] openURL:[request URL]];
    [self conditionallyOpenURL:[request URL]];
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

- (BOOL)conditionallyOpenURL:(NSURL *)url {
    
    if ([url.host isEqualToString:self.baseURL.host] &&
        [url.scheme isEqualToString:self.baseURL.scheme]) {
        
        // Internal URL: open in another window
        lastURL = url;
        MainWindowController *window = [[MainWindowController alloc] initWithURL:url];
        [window showWindow:self];
        return TRUE;
    } else {
        
        // External URL: open in another application
        [[NSWorkspace sharedWorkspace] openURL:url];
        return FALSE;
        
    }
}

@end
