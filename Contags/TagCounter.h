//
//  Tag.h
//  Contags
//
//  Created by Tyler H on 9/25/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagCounter : NSObject

@property (nonatomic, strong) NSString *str;
@property (nonatomic) NSInteger count;

-(id)initWithName:(NSString *)name NumberOfOccurences:(NSInteger)number;
-(void)incrementCount;

@end
