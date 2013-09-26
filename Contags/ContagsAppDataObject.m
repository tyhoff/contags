//
//  ExampleAppDataObject.m
//  ViewControllerDataSharing
//
//  Created by Duncan Champney on 7/29/10.

#import "ContagsAppDataObject.h"
#import <AddressBookUI/AddressBookUI.h>
#import "Contact.h"


@implementation ContagsAppDataObject
{
    NSMutableArray *contactDatabase;
    NSArray *contactArray;
    NSMutableOrderedSet *tagBucket;
    NSInteger numTags;
    BOOL updateFlag;
}


- (id)init
{
    self = [super init];
    if (self) {
        [self setupContactDatabase];
        updateFlag = YES;
        
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        dict 
        
        
        
    }
    return self;
}


-(NSInteger)getTagListSize
{
    return numTags;
}

-(void)setUpdateFlag
{
    updateFlag = YES;
}

-(NSMutableArray *) getContactDatabase
{
    return contactDatabase;
}


-(NSArray *)getTagList
{
    if (updateFlag)
    {
        tagBucket = [[NSMutableOrderedSet alloc] init];
        
        for (Contact *contact in contactDatabase)
        {
            for (NSString *tag in contact.tags)
            {
                [tagBucket addObject:tag];
            }
        }
        
        numTags = [tagBucket count];
        updateFlag = NO;
    }
    return [tagBucket sortedArrayUsingComparator:^(id o1, id o2) {
        NSString *str1 = (NSString *)o1;
        NSString *str2 = (NSString *)o2;
        
        return [str1 compare:str2 options:NSCaseInsensitiveSearch];
    }];
}




-(BOOL)setupContactDatabase
{
    if (contactDatabase == nil)
    {
        contactDatabase = [[NSMutableArray alloc] init];
    }

    
    __block bool accessToContacts = NO;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            accessToContacts = YES;
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        accessToContacts = YES;
    }
    else {
        NSLog(@"No access to contacts");
        accessToContacts = NO;
    }
    
    
    
    if (accessToContacts)
    {
        contactArray = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    }
    else
    {
        contactArray = nil;
    }
    
    if (accessToContacts)
    {
        [self populateContactList];
    }
    
    CFRelease(addressBookRef);
    
    return accessToContacts;
}

//recordId = [[dict objectForKey:@"hello"] intValue];

- (void)populateContactList
{
    
    NSUInteger i = 0;
    for (i = 0; i < [contactArray count]; i++)
    {
        Contact *contact = [[Contact alloc] init];
        
        ABRecordRef contactPerson = (__bridge ABRecordRef)contactArray[i];
        
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
        NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
        NSString *notes = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonNoteProperty);
        
        contact.firstname = firstName;
        contact.lastname = lastName;
        contact.tags = [self findTagsInNotesField:notes];
        
//        NSLog(@"Index: %d\nFirst Name: %@\nLast Name: %@\nNotes: %@\n",i ,  contact.firstname, contact.lastname, notes);
        
        [contactDatabase addObject:contact];
    }
    
    [contactDatabase sortUsingComparator:^(id o1, id o2) {
        Contact *c1 = (Contact *)o1;
        Contact *c2 = (Contact *)o2;
        
        return [c1.lastname compare:c2.lastname options:NSCaseInsensitiveSearch];
    }];
}



-(NSMutableArray *)findTagsInNotesField:(NSString *)notesField
{
    if (notesField != nil)
    {
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#\\{(.*)\\} *$"
                                                                               options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                                 error:&error];
        
        NSString *firstMatch;
        
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:notesField options:0 range:NSMakeRange(0, [notesField length])];
        
        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            firstMatch = [notesField substringWithRange:rangeOfFirstMatch];
        }
        
        firstMatch = [firstMatch stringByReplacingOccurrencesOfString:@"#{" withString:@""];
        firstMatch = [firstMatch stringByReplacingOccurrencesOfString:@"}" withString:@""];
        
        tags = [[firstMatch componentsSeparatedByString:@","] mutableCopy];
        for (int i=0; i<[tags count]; i++)
        {
            tags[i] = [tags[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
        }
        
        return tags;
    }
    else
    {
        return nil;
    }
}


@end
