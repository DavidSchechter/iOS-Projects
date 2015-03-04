//
//  CardObject.h
//  CanNow
//
//  Created by David Schechter on 1/22/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardObject : NSObject
{
    NSString *title;
    int idNumber;
    NSString *timeStart1;
    NSString *timeEnd1;
    NSString *timeStart2;
    NSString *timeEnd2;
    NSString *address;
    NSString *city;
    BOOL isOpen;
    NSString *image;
    NSString *website;
    NSString *sms;
    NSString *phone;
    NSString *facebook;
    NSString *youtube;
    NSString *gallery;
    NSDictionary *location;
}

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) int idNumber;
@property (strong, nonatomic) NSString *timeStart1;
@property (strong, nonatomic) NSString *timeEnd1;
@property (strong, nonatomic) NSString *timeStart2;
@property (strong, nonatomic) NSString *timeEnd2;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (assign, nonatomic) BOOL isOpen;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *sms;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *youtube;
@property (strong, nonatomic) NSString *gallery;
@property (strong, nonatomic) NSString *descriptionStr;
@property (strong, nonatomic) NSDictionary *location;



@end
