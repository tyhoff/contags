//
//  Contact.m
//  Contags
//
//  Created by Tyler H on 9/21/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize firstname;
@synthesize lastname;
@synthesize tags = _tags;

- (NSArray *)tags
{
    if (_tags == nil) _tags = [[NSMutableArray alloc] init];
    return _tags;
}



@end
