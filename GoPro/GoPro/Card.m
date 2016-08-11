//
//  Card.m
//  GoPro
//
//  Created by Schechter, David on 8/10/16.
//  Copyright © 2016 DavidSchechter. All rights reserved.
//

#import "Card.h"

@implementation Card

- (instancetype)initWithIndex:(int)index
{
    self = [super init];
    if (self) {
        self.index = index;
    }
    return self;
}

@end
