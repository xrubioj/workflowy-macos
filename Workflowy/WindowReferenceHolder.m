//
//  WindowReferenceHolder.m
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 16/1/16.
//  Copyright © 2016 Apps Ezy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WindowReferenceHolder.h"

@interface WindowReferenceHolder ()

@property (strong) NSMutableArray<MainWindowController *> *mainWindowControllers;

@end

@implementation WindowReferenceHolder

+ (id)sharedManager {
    static WindowReferenceHolder *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self.mainWindowControllers = [[NSMutableArray alloc] init];
    return [super init];
}

- (void)addMainWindowController:(MainWindowController *)controller {
    [self.mainWindowControllers addObject:controller];
}

- (void)removeMainWindowController:(MainWindowController *)controller {
    //[self.mainWindowControllers removeObject:controller];
}

@end
