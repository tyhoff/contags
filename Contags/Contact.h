//
//  Contact.h
//  Contags
//
//  Created by Tyler H on 9/21/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSMutableArray *tags;

@end
