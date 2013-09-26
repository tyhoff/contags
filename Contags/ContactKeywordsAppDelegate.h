//
//  ContactKeywordsAppDelegate.h
//  Contags
//
//  Created by Tyler H on 9/21/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateProtocol.h"

@interface ContactKeywordsAppDelegate : UIResponder <UIApplicationDelegate, AppDelegateProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ContagsAppDataObject* getContagsDataObject;

@end
