//
//  Contact.m
//  Contags
//
//  Created by Tyler H on 9/21/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize recordID = _recordID;
@synthesize sectionNumber = _sectionNumber;
@synthesize fullName = _fullName;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize phoneNumber = _phoneNumber;
@synthesize tags = _tags;

- (NSMutableArray *)tags
{
    if (_tags == nil) _tags = [[NSMutableArray alloc] init];
    return _tags;
}

- (NSString*)sorterFirstName {
    if (nil != _firstName && ![_firstName isEqualToString:@""]) {
        return _firstName;
    }
    if (nil != _lastName && ![_lastName isEqualToString:@""]) {
        return _lastName;
    }
    if (nil != _fullName && ![_fullName isEqualToString:@""]) {
        return _fullName;
    }
    return nil;
}

- (NSString*)sorterLastName {
    if (nil != _lastName && ![_lastName isEqualToString:@""]) {
        return _lastName;
    }
    if (nil != _firstName && ![_firstName isEqualToString:@""]) {
        return _firstName;
    }
    if (nil != _fullName && ![_fullName isEqualToString:@""]) {
        return _fullName;
    }
    return nil;
}


@end
