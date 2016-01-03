//
//  RegisterAsLoginHelper.h
//  Workflowy
//
//  Created by Xavier Rubio Jansana on 3/1/16.
//  Copyright © 2016 Apps Ezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterAsLoginHelper : NSObject

+ (BOOL)isLaunchAtStartup;
+ (void)setLaunchAtStartup:(BOOL)launchAtStartup;

@end