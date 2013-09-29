//
//  ContactKeywordsKeywordsViewController.m
//  Contags
//
//  Created by Tyler H on 9/21/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import "ContagsTagViewController.h"
#import "ContagsSelectContactsViewController.h"
#import "AppDelegateProtocol.h"
#import "ContagsAppDataObject.h"


@interface ContagsTagViewController ()
{
    ContagsAppDataObject *contagsObject;
    NSMutableArray *_tagsList;
    UIAlertView* dialog;
}
//[secondArray removeObjectsInArray:firstArray];

@end

@implementation ContagsTagViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    contagsObject = [self getContagsDataObject];
    _tagsList = [[contagsObject getTagList] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ContagsAppDataObject *) getContagsDataObject;
{
	id<AppDelegateProtocol> delegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	return (ContagsAppDataObject*) delegate.getContagsDataObject;
}

// pop up UIAlertView with a textbox where the user inputs a tag
- (IBAction)addNewTagClicked:(id)sender {
    dialog = [[UIAlertView alloc] init];
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog setDelegate:self];
    [dialog setTitle:@"Name of tag"];
    [dialog addButtonWithTitle:@"Cancel"];
    [dialog addButtonWithTitle:@"Add"];
    [dialog textFieldAtIndex:0].delegate = self;
    [dialog show];
    
}

// responding to when the user clicks "return" on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)alertTextField {
    [[dialog textFieldAtIndex:0] resignFirstResponder];// to dismiss the keyboard.
    [dialog dismissWithClickedButtonIndex:1 animated:YES];//this is called on alertview to dismiss it.
    [self insertTagIntoTableView:[[dialog textFieldAtIndex:0] text]];
    return false;
}

// responding to when the user clicks "Add" in the UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self insertTagIntoTableView:[[dialog textFieldAtIndex:0] text]];
}

// add the text given to the list of tags
- (void) insertTagIntoTableView:(NSString *)text
{   
    NSUInteger newIndex = [_tagsList indexOfObject:text
                                     inSortedRange:(NSRange){0, [_tagsList count]}
                                           options:NSBinarySearchingInsertionIndex
                                   usingComparator:^(id o1, id o2) {
                                       NSString *str1 = (NSString *)o1;
                                       NSString *str2 = (NSString *)o2;
                                       
                                       return [str1 compare:str2 options:NSCaseInsensitiveSearch];
                                   }];
    
    [_tagsList insertObject:text atIndex:newIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newIndex inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tagsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _tagsList[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_tagsList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showContacts"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *tag = _tagsList[indexPath.row];
        [[segue destinationViewController] setTagData:tag];
    }
}

@end
