//
//  Tag.m
//  Contags
//
//  Created by Tyler H on 9/25/13.
//  Copyright (c) 2013 tyler. All rights reserved.
//

#import "TagCounter.h"

@implementation TagCounter

@synthesize str;
@synthesize count;

-(id)initWithName:(NSString *)name NumberOfOccurences:(NSInteger)number;
{
    self = [super init];
    if (self) {
        str = name;
        count = number;
    }
    return self;
}

-(void)incrementCount
{
    count++;
}

@end
