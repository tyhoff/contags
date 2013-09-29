//
//  ExampleAppDataObject.m
//  ViewControllerDataSharing
//
//  Created by Duncan Champney on 7/29/10.

#import "ContagsAppDataObject.h"
#import <AddressBookUI/AddressBookUI.h>
#import "Contact.h"

@interface ContagsAppDataObject ()
@property (nonatomic, assign) ABAddressBookRef addressBookRef;

@end

@implementation ContagsAppDataObject
{
    NSMutableArray *contactDatabase;
    NSArray *contactArray;
    NSMutableOrderedSet *tagBucket;
    NSInteger numTags;
    BOOL updateFlag;
    
    NSMutableArray *_listContent;
}


- (id)init
{
    self = [super init];
    if (self) {
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        [self checkAddressBookAccess];
        updateFlag = YES;
    }
    return self;
}

// Check the authorization status of our application for Address Book
-(void)checkAddressBookAccess
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess
{
    ContagsAppDataObject * __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef error)
     {
         if (granted)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf accessGrantedForAddressBook];
                 
             });
         }
     });
}

// This method is called when the user has granted access to their address book data.
-(void)accessGrantedForAddressBook
{
    if (contactDatabase == nil)
    {
        contactDatabase = [[NSMutableArray alloc] init];
    }

    contactArray = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
    int numContacts = ABAddressBookGetPersonCount(_addressBookRef);
    
    for (int i = 0; i < numContacts; i++)
    {
        ABRecordRef contactRecord = (__bridge ABRecordRef)contactArray[i];
        
        if (!contactRecord)
            continue;
        
        NSString *abFullName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(contactRecord);
        NSString *abFirstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactRecord, kABPersonFirstNameProperty);
        NSString *abLastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactRecord, kABPersonLastNameProperty);
        NSString *abNotes = (__bridge_transfer NSString *)ABRecordCopyValue(contactRecord, kABPersonNoteProperty);
        
        Contact *contact = [[Contact alloc] init];
        
        NSString *fullName;
        
        if (abFullName != nil) {
            fullName = abFullName;
        } else {
            if (abLastName != nil)
            {
                fullName = [NSString stringWithFormat:@"%@ %@", abFirstName, abLastName];
            }
        }
        
        contact.recordID = contactRecord;
        contact.fullName = fullName;
        contact.firstName = (abFirstName) ? abFirstName : @"";
        contact.lastName = (abLastName) ? abLastName : @"";
        contact.tags = [self findTagsInNotesField:abNotes];
        
        //        NSLog(@"Index: %d\nFirst Name: %@\nLast Name: %@\nNotes: %@\n",i ,  contact.firstname, contact.lastname, notes);
        
        [contactDatabase addObject:contact];
    }
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
            NSString * str = [tags[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([str isEqualToString:@""])
            {
                [tags removeObjectAtIndex:i];
            }
            else
            {
                tags[i] = str;
            }

        }
        
        return [[tags sortedArrayUsingComparator:^(id o1, id o2) {
            NSString *str1 = (NSString *)o1;
            NSString *str2 = (NSString *)o2;
            
            return [str1 compare:str2 options:NSCaseInsensitiveSearch];
        }] mutableCopy];
    }
    else
    {
        return nil;
    }
}

- (void) saveContactTagsToAddressBook:(Contact *)contact
{
    NSString *abNotes = (__bridge_transfer NSString *)ABRecordCopyValue(contact.recordID, kABPersonNoteProperty);
    
    NSString * tagsDataStr = @"";
    if ([contact.tags count])
        tagsDataStr = [NSString stringWithFormat:@"#{%@}", [contact.tags componentsJoinedByString:@", "]];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#\\{(.*)\\} *$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    if (abNotes)
    {
        // use regular expression to replace the emoji
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#\\{(.*)\\} *$"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        
        NSInteger numMatches = [regex numberOfMatchesInString:abNotes
                                                      options:0
                                                        range:NSMakeRange(0, [abNotes length])];
        
        if (numMatches <= 0)
        {
            abNotes = [abNotes stringByAppendingString:[NSString stringWithFormat:@"\n\n%@", tagsDataStr]];
        }
        else if (numMatches == 1)
        {
            abNotes = [regex stringByReplacingMatchesInString:abNotes
                                                      options:0
                                                        range:NSMakeRange(0, [abNotes length])
                                                 withTemplate:tagsDataStr];
        }
        else
        {
            NSLog(@"ERROR: Too many contags data strings in contact %@ %@. numMatches: %d\n", contact.firstName, contact.lastName, numMatches);
            return;
        }
        

    }
    else if ([tagsDataStr isEqualToString:@"#{}"])
    {
        abNotes = [regex stringByReplacingMatchesInString:abNotes
                                                  options:0
                                                    range:NSMakeRange(0, [abNotes length])
                                             withTemplate:@""];
    }
    else
    {
        abNotes = tagsDataStr;
    }
    
    abNotes = [abNotes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CFErrorRef cferror;
    ABRecordSetValue(contact.recordID, kABPersonNoteProperty, (__bridge CFTypeRef)(abNotes), &cferror);
    ABAddressBookSave(_addressBookRef, &cferror);
}

- (void)dealloc
{
    if(_addressBookRef)
    {
        CFRelease(_addressBookRef);
    }
}


@end
