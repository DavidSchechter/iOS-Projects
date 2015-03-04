//
//  SubFieldSearchViewController.h
//  CanNow
//
//  Created by David Schechter on 12/23/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import "DropDownMenuView.h"

@interface SubFieldSearchViewController : MyViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *menuButton;
    IBOutlet UINavigationItem *navBarTitle;
    NSMutableArray *subCategoriesArray;
    NSString *titleToSet;
    int idNumberOfCategory;
    DropDownMenuView *popOverMenu;
    NSString *saveCustomURL;
    NSString *bannerURL;
    
    IBOutlet UIActivityIndicatorView *spinner;
    
    IBOutlet UILabel *pathLabel;
}
    
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (assign, nonatomic) IBOutlet UITableView *tableFields;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@property (strong, nonatomic) NSMutableArray *subCategoriesArray;
@property (strong, nonatomic) NSString *titleToSet;
@property (assign, nonatomic) int idNumberOfCategory;
@property (strong, nonatomic) NSString *customSeatchURL;
@property (assign, nonatomic) BOOL usingCustomSearch;
@property (assign, nonatomic) IBOutlet UIButton *banner;
    
    
- (IBAction)backButtonClicked:(UIButton *)sender;

- (IBAction)showPopover:(id)sender;

@end