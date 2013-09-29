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

#define ALPHABET_SIZE 26

@interface ContagsContactViewController ()
{
    ContagsAppDataObject *contagsObject;
    NSMutableArray *_listContent;
    NSMutableArray *_filteredListContent;
    BOOL accessToContacts;
}

@property IBOutlet UISearchBar *searchBar;

@end

@implementation ContagsContactViewController
@synthesize searchBar;

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
    
    contagsObject = [self getContagsDataObject];
    
    _listContent = [NSMutableArray arrayWithCapacity:ALPHABET_SIZE];
    _filteredListContent = [NSMutableArray arrayWithCapacity:ALPHABET_SIZE];
    
    self.searchDisplayController.searchResultsTableView.scrollEnabled = YES;
	self.searchDisplayController.searchBar.showsCancelButton = NO;
    
    [self reloadAddressBook];
}

-(void)reloadAddressBook
{
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    // Thanks Steph-Fongo!
    SEL sorter = ABPersonGetSortOrdering() == kABPersonSortByFirstName ? NSSelectorFromString(@"sorterFirstName") : NSSelectorFromString(@"sorterLastName");
    
    for (Contact *contact in [contagsObject getContactDatabase]) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:sorter];
        contact.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Contact *contact in [contagsObject getContactDatabase]) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:sorter];
        [_listContent addObject:sortedSection];
    }
    [self.tableView reloadData];
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
	} else {
        return [_listContent count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    return [[_listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredListContent count];
    } else {
        return [[_listContent objectAtIndex:section] count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		[self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"showTags" sender:[_filteredListContent objectAtIndex:indexPath.row]];
	}
	else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"showTags" sender:[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];

	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIFont *reg_font = [UIFont fontWithName:@"Helvetica" size:17];
//    UIFont *bold_font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
//    
//    Contact *contact = contagsObject.getContactDatabase[indexPath.row];
//    NSString *first = [NSString stringWithFormat:@"%@ ",contact.firstName];
//    
//    NSMutableAttributedString *name = nil;
//    NSMutableAttributedString * lastName = nil;
//    
//    if (contact.firstName)
//    {
//        name = [[NSMutableAttributedString alloc] initWithString:first];
//        [name addAttribute:NSFontAttributeName value:reg_font range:NSMakeRange(0, [contact.firstName length])];
//    }
//    
//    if (contact.lastName)
//    {
//        lastName = [[NSMutableAttributedString alloc] initWithString:contact.lastName];
//        [lastName addAttribute:NSFontAttributeName value:bold_font range:NSMakeRange(0, [contact.lastName length])];
//    }
//    
//    if (contact.firstName && contact.lastName)
//        [name appendAttributedString:lastName];
//    else if (!contact.firstName)
//        name = lastName;
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
//    cell.textLabel.attributedText = name;
//    return cell;
    
    
    
    
    
    
    Contact *contact = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
        contact = (Contact *)[_filteredListContent objectAtIndex:indexPath.row];
	else
        contact = (Contact *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSLog(@"row: %d section: %d\n", indexPath.row, indexPath.section);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactCell"];
    
    cell.textLabel.text = contact.fullName;
    return cell;
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
	[self.searchDisplayController.searchBar setShowsCancelButton:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[_filteredListContent removeAllObjects];
    for (NSArray *section in _listContent) {
        for (Contact *contact in section)
        {
            NSRange range = [contact.fullName rangeOfString:searchText options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
            if (range.location != NSNotFound) {
                [_filteredListContent addObject:contact];
            }
            
            range = [contact.getTagListString rangeOfString:searchText options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
            if (range.location != NSNotFound) {
                [_filteredListContent addObject:contact];
            }
        }
    }
}


#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
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
    ContagsSelectTagsViewController *vc = [segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"showTags"]) {
        Contact *contact = (Contact *)sender;
        [vc setContactData:contact];
    }
}

@end
