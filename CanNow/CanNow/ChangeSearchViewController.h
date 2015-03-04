//
//  ChangeSearchViewController.h
//  CanNow
//
//  Created by David Schechter on 1/19/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import "ResultsPageViewController.h"
#import "DropDownMenuView.h"

@interface ChangeSearchViewController : MyViewController<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *menuButton;
    IBOutlet UIButton *updateSearch;
    IBOutlet UIButton *radioButton1;
    IBOutlet UIButton *radioButton2;
    IBOutlet UIButton *radioButton3;
    IBOutlet UITextField *differentDate;
    IBOutlet UITextField *differentCity;
    IBOutlet UITextField *differentArea;
    NSMutableArray *typesOfFields;
    NSString *titleToSet;
    UIDatePicker *dpDatePicker;
    
    NSMutableArray *autocompleteCategories;
    UITableView *autocompleteTableView;
    NSMutableArray *autocompleteUrls;
    
    DropDownMenuView *popOverMenu;
    
    NSString *bannerURL;
    NSString *banner2URL;
    
    IBOutlet UILabel *dateAndCityLabel;
    
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (strong, nonatomic) IBOutlet UIScrollView *containerScrollView;


@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIButton *updateSearch;
@property (strong, nonatomic) IBOutlet UIButton *radioButton1;
@property (strong, nonatomic) IBOutlet UIButton *radioButton2;
@property (strong, nonatomic) IBOutlet UIButton *radioButton3;
@property (strong, nonatomic) IBOutlet UITextField *differentDate;
@property (strong, nonatomic) IBOutlet UITextField *differentCity;
@property (strong, nonatomic) IBOutlet UITextField *differentArea;
@property (strong, nonatomic) NSMutableArray *typesOfFields;
@property (strong, nonatomic) NSString *titleToSet;
@property (strong, nonatomic) NSString *urlToChange;
@property (strong, nonatomic) ResultsPageViewController *pageToChange;
@property (strong, nonatomic) IBOutlet UIButton *banner;
@property (strong, nonatomic) IBOutlet UIButton *banner2;
@property (assign, nonatomic) BOOL openWithDate;
@property (assign, nonatomic) BOOL openWithArea;


- (IBAction)backButtonClicked:(UIButton *)sender;
-(IBAction)updateSearchClicked:(id)sender;

- (IBAction)showPopover:(id)sender;


@end
