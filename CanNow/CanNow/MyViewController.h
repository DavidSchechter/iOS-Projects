utf-8;134217984ntroller.h
//  CanNow
//
//  Created by David Schechter on 1/25/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController{
    int idNumberStrightToCards;
    NSString *titleOfStrightToCards;
    BOOL backStrightToRootView;
}

@property (assign, nonatomic) int idNumberStrightToCards;
@property (strong, nonatomic) NSString *titleOfStrightToCards;
@property (assign, nonatomic) BOOL backStrightToRootView;

- (IBAction)showPopover:(id)sender;

@end