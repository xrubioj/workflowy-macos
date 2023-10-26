//
//  WindowReferenceHolder.h
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 16/1/16.
//  Copyright © 2016 Apps Ezy. All rights reserved.
//

#import "MainWindowController.h"

@interface WindowReferenceHolder : NSObject

+ (id)sharedManager;

- (void)addMainWindowController:(MainWindowController *)controller;
- (void)removeMainWindowController:(MainWindowController *)controller;

@end
