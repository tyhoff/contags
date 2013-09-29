//
//  ContagsSelectTagsViewController.m
//  Contags
//
//  Created by Tyler H on 9/23/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import "ContagsSelectTagsViewController.h"
#import "AppDelegateProtocol.h"
#import "ContagsAppDataObject.h"

@interface ContagsSelectTagsViewController ()
{
    ContagsAppDataObject *contagsObject;
    NSMutableArray * nonAssociatedTags;
}
@end

@implementation ContagsSelectTagsViewController

- (void)setContactData:(Contact *)contact
{
    if (_contact != contact) {
        _contact = contact;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        nonAssociatedTags = [[NSMutableArray alloc] init];
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
    
    contagsObject = [self getContagsDataObject];
    nonAssociatedTags = [contagsObject.getTagList mutableCopy];
    [nonAssociatedTags removeObjectsInArray:_contact.tags];
    
    [self hideTabBar];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [contagsObject saveContactTagsToAddressBook:_contact];
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Associated with contact";
    else
        return @"Unassociated";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return [_contact.tags count];
    else
        return [nonAssociatedTags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectTagCell" forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [_contact.tags objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.textLabel.text = [nonAssociatedTags objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1)
    {
        NSString * removed = [nonAssociatedTags objectAtIndex:indexPath.row];
        [nonAssociatedTags removeObjectAtIndex:indexPath.row];
        
        NSUInteger toRow = [_contact.tags indexOfObject:removed
                                              inSortedRange:(NSRange){0, [_contact.tags count]}
                                                    options:NSBinarySearchingInsertionIndex
                                            usingComparator:^(id o1, id o2) {
                                                NSString *str1 = (NSString *)o1;
                                                NSString *str2 = (NSString *)o2;
                                                
                                                return [str1 compare:str2 options:NSCaseInsensitiveSearch];
                                            }];

        
        [_contact.tags insertObject:removed atIndex:toRow];

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:1]]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:toRow inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        NSString * removed = [_contact.tags objectAtIndex:indexPath.row];
        [_contact.tags removeObjectAtIndex:indexPath.row];
        
        NSUInteger toRow = [nonAssociatedTags indexOfObject:removed
                                              inSortedRange:(NSRange){0, [nonAssociatedTags count]}
                                                    options:NSBinarySearchingInsertionIndex
                                            usingComparator:^(id o1, id o2) {
                                                NSString *str1 = (NSString *)o1;
                                                NSString *str2 = (NSString *)o2;
                                                
                                                return [str1 compare:str2 options:NSCaseInsensitiveSearch];
                                            }];
        
        [nonAssociatedTags insertObject:removed atIndex:toRow];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:toRow inSection:1]]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *editable = [_contact.tags mutableCopy];
        [editable removeObjectAtIndex:indexPath.row];
        _contact.tags = [editable copy];
        
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

@end
