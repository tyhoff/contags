//
//  ExampleAppDataObject.h
//  ViewControllerDataSharing
//
//  Created by Duncan Champney on 7/29/10.

#import <Foundation/Foundation.h>
#import "ContagsAppDataObject.h"
#import "Contact.h"


@interface ContagsAppDataObject : NSObject

-(NSMutableArray *)getContactDatabase;
-(void)setUpdateFlag;
-(NSMutableArray *)getTagList;
-(NSInteger)getTagListSize;
-(void)saveContactTagsToAddressBook:(Contact *)contact;

@end
