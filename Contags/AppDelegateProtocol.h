//
//  AppDelegateProtocol.h
//  Contags
//
//  Created by Tyler H on 9/22/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContagsAppDataObject;

@protocol AppDelegateProtocol

- (ContagsAppDataObject *) getContagsDataObject;

@end
