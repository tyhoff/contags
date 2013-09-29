//
//  Contact.h
//  Contags
//
//  Created by Tyler H on 9/21/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Contact : NSObject

@property ABRecordRef recordID;
@property NSInteger sectionNumber;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSMutableArray *tags;

- (NSString *)sorterFirstName;
- (NSString *)sorterLastName;
- (NSString *)getTagListString;

@end
