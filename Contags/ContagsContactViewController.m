//
//  ContagsContactViewController.m
//  Contags
//
//  Created by Tyler H on 9/22/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import "ContagsContactViewController.h"
#import "ContagsSelectTagsViewController.h"
#import "ContagsAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "Contact.h"

@interface ContagsContactViewController ()
{
    ContagsAppDataObject *contagsObject;
    BOOL accessToContacts;
}
@end

@implementation ContagsContactViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Request authorization to Address Book
    
    contagsObject = [self getContagsDataObject];
    
}

- (ContagsAppDataObject *) getContagsDataObject;
{
	id<AppDelegateProtocol> delegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	return (ContagsAppDataObject*) delegate.getContagsDataObject;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contagsObject.getContactDatabase count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    Contact *contact = contagsObject.getContactDatabase[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstname, contact.lastname];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 [_contactObjects removeObjectAtIndex:indexPath.row];
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }
 */

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

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTags"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Contact *contact = contagsObject.getContactDatabase[indexPath.row];
        [[segue destinationViewController] setContactData:contact];
    }
}

@end
