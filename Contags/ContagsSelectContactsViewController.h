//
//  ContagsSelectContactsViewController.h
//  Contags
//
//  Created by Tyler H on 9/22/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContagsSelectContactsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *tag;

-(void)setTagData:(NSString *)tag;

@end
