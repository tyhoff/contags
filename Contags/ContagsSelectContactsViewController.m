//
//  ContagsSelectContactsViewController.m
//  Contags
//
//  Created by Tyler H on 9/22/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import "ContagsSelectContactsViewController.h"
#import "AppDelegateProtocol.h"
#import "ContagsAppDataObject.h"

@interface ContagsSelectContactsViewController ()
{
    ContagsAppDataObject *contagsObject;
    NSMutableArray *allContacts;
    NSMutableArray *contactsWithTag;
    NSMutableArray *contactsWithoutTag;

}

@end

@implementation ContagsSelectContactsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)setTagData:(NSString *)tag
{
    if (_tag != tag) {
        _tag = tag;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    contagsObject = [self getContagsDataObject];
    
    allContacts = contagsObject.getContactDatabase;
    contactsWithTag = [[NSMutableArray alloc] init];
    contactsWithoutTag = [[NSMutableArray alloc] init];
    
    [self hideTabBar];
    
    for (Contact *c in allContacts)
    {
        BOOL withTag = NO;
        for (NSString * tag in c.tags)
        {
            if ([tag isEqualToString:_tag])
            {
                [contactsWithTag addObject:c];
                withTag = YES;
                break;
            }
        }
        if (withTag == NO)
        {
            [contactsWithoutTag addObject:c];
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self showTabBar];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [contagsObject.getContactDatabase count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectContactCell" forIndexPath:indexPath];
    Contact *contact = contagsObject.getContactDatabase[indexPath.row];
    
    if ([contactsWithTag containsObject:contact])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        Contact *c = [allContacts objectAtIndex:indexPath.row];
        [contactsWithoutTag removeObject:c];
        [contactsWithTag addObject:c];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        Contact *c = [allContacts objectAtIndex:indexPath.row];
        [contactsWithTag removeObject:c];
        [contactsWithoutTag addObject:c];
    }
}

- (void)hideTabBar {
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         tabFrame.origin.y = CGRectGetMaxY(window.bounds);
                         tabBar.frame = tabFrame;
                         content.frame = window.bounds;
                     }];
    
}

- (void)showTabBar {
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         tabFrame.origin.y = CGRectGetMaxY(window.bounds) - CGRectGetHeight(tabBar.frame);
                         tabBar.frame = tabFrame;
                         
                         CGRect contentFrame = content.frame;
                         contentFrame.size.height -= tabFrame.size.height;
                     }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

@end
