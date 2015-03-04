//
//  PopOverMenuViewContoller.h
//  CanNow
//
//  Created by David Schechter on 12/30/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PopOverMenuViewContoller : UIViewController{
    IBOutlet UIButton *favorButton;
    IBOutlet UIButton *oldSearchButton;
    IBOutlet UIButton *onSaleButton;
    IBOutlet UIButton *aboutButton;
    IBOutlet UIButton *contactButton;
}

@property (strong, nonatomic) IBOutlet UIButton *favorButton;
@property (strong, nonatomic) IBOutlet UIButton *oldSearchButton;
@property (strong, nonatomic) IBOutlet UIButton *onSaleButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;
@property (strong, nonatomic) UIViewController *containingViewController;


- (IBAction)aboutButtonClicked:(UIButton *)sender;
- (IBAction)contactButtonClicked:(UIButton *)sender;
- (IBAction)oldSearchButtonButtonClicked:(UIButton *)sender;


@end