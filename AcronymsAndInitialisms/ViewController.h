//
//  ViewController.h
//  AcronymsAndInitialisms
//
//  Created by David Schechter on 12/4/15.
//  Copyright © 2015 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import  "QuartzCore/QuartzCore.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate, UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    NSArray *data;
}

@property (assign, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;

- (IBAction)jsonTapped:(UIButton *)sender;

@end

