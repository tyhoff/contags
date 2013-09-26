//
//  ContagsSelectTagsViewController.h
//  Contags
//
//  Created by Tyler H on 9/23/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContagsSelectTagsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Contact *contact;

-(void)setContactData:(Contact *)contact;

@end
