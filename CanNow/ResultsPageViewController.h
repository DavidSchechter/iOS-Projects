//
//  ResultsPageViewController.h
//  CanNow
//
//  Created by David Schechter on 12/24/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenuView.h"
#import "MyViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface ResultsPageViewController : MyViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *menuButton;
    IBOutlet UIButton *otherDateButton;
    IBOutlet UIButton *otherAreaButton;
    IBOutlet UINavigationItem *navBarTitle;
    NSMutableArray *cardsArray;
    NSString *titleToSet;
    int idNumberOfCategory;
    int numOfSubCategories;
    DropDownMenuView *popOverMenu;
    BOOL areThereMoreReuslts;
    NSString *saveCustomURL;
    
    IBOutlet UIActivityIndicatorView *spinner;
    
    IBOutlet UILabel *pathLabel;
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIButton *otherDateButton;
@property (strong, nonatomic) IBOutlet UIButton *otherAreaButton;
@property (assign, nonatomic) IBOutlet UITableView *tableFields;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@property (strong, nonatomic) NSMutableArray *cardsArray;
@property (strong, nonatomic) NSString *titleToSet;
@property (assign, nonatomic) int idNumberOfCategory;
@property (strong, nonatomic) NSString *customSeatchURL;
@property (assign, nonatomic) BOOL usingCustomSearch;
@property (assign, nonatomic) int urlOffset;
@property (strong, nonatomic) NSString *prevPath;


- (IBAction)backButtonClicked:(UIButton *)sender;

- (IBAction)changeSearchByDate:(UIButton *)sender;
- (IBAction)changeSearchByArea:(UIButton *)sender;

- (IBAction)showPopover:(id)sender;

-(void)loadResultsCustomSearch;

@end