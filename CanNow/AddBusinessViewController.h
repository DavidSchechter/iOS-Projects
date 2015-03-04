//
//  AddBusinessViewController.h
//  CanNow
//
//  Created by David Schechter on 1/25/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenuView.h"
#import "MyViewController.h"

@interface AddBusinessViewController : MyViewController<UITextFieldDelegate>{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *menuButton;
    IBOutlet UITextField *nameOfBusiness;
    IBOutlet UITextField *phoneNumberOfBusiness;
    IBOutlet UITextField *emailOfBusiness;
    IBOutlet UIButton *sendButton;
    IBOutlet UITextView *waringText;
    NSString *bannerURL;
    NSString *banner2URL;
    
    DropDownMenuView *popOverMenu;
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UITextField *nameOfBusiness;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberOfBusiness;
@property (strong, nonatomic) IBOutlet UITextField *emailOfBusiness;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UITextView *waringText;
@property (assign, nonatomic) IBOutlet UIButton *banner;
@property (assign, nonatomic) IBOutlet UIButton *banner2;


- (IBAction)backButtonClicked:(UIButton *)sender;

- (IBAction)showPopover:(id)sender;

-(IBAction)addBusinessClicked:(id)sender;


@end