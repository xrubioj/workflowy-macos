//
//  MainWindowController.h
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 2/1/16.
//  Copyright © 2016 Apps Ezy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface MainWindowController : NSWindowController <NSWindowDelegate, WebUIDelegate, WebPolicyDelegate>

@end
