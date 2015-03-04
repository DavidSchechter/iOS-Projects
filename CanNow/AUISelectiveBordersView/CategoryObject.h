utf-8;134217984Object.h
//  CanNow
//
//  Created by David Schechter on 1/22/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryObject : NSObject
{
    NSString *title;
    int idNumber;
    int numberOfSubCategories;
    int numberOfCards;
}

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) int idNumber;
@property (assign, nonatomic) int numberOfSubCategories;
@property (assign, nonatomic) int numberOfCards;

@end
