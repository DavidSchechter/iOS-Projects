//
//  ViewController.h
//  CanNow
//
//  Created by David Schechter on 12/22/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PopOverMenuViewContoller.h"


@interface ViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>
{
    BOOL byTypeSearch;
    BOOL byNameSearch;
    
    IBOutlet UIView *searchView;
    
    IBOutlet UIButton *addBusiness;
    IBOutlet UIButton *dropDownMenu;
    IBOutlet UIButton *whoIsAvailble;
    IBOutlet UIButton *appSymbol;
    
    IBOutlet UITextField *searchBar;
    
    IBOutlet UIButton *searchButton;
    IBOutlet UIButton *swapButton;
    
    IBOutlet UIView *scrollingViewArea;
    
    NSMutableArray* businessTypesTitles;
    NSMutableArray* businessNames;
    
    NSMutableArray *autocompleteCategories;
    
    UITableView *autocompleteTableView;
     NSMutableArray *autocompleteUrls;
    
    NSString *bannerURL;
    
    NSMutableArray *promotionDataArray;
    
    IBOutlet UIActivityIndicatorView *spinner;
    
    NSArray *autocompleteBusiness;
    NSArray *autocompleteCards;
    
    PopOverMenuViewContoller *popOverMenu;
    
    NSString *lastSearchTitle;
    int lastSearchID;
    BOOL isLastSearchForCards;
    BOOL isLastSearchForCategory;
    BOOL isLastSearchForCategoryByBusiness;
    BOOL isLastSearchForCategoryByCards;
    
}

@property (strong, nonatomic) IBOutlet UIView *searchView;

@property (strong, nonatomic) IBOutlet UIButton *addBusiness;
@property (strong, nonatomic) IBOutlet UIButton *dropDownMenu;
@property (strong, nonatomic) IBOutlet UIButton *whoIsAvailble;
@property (strong, nonatomic) IBOutlet UIButton *appSymbol;

@property (strong, nonatomic) IBOutlet UITextField *searchBar;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *swapButton;


@property (strong, nonatomic) IBOutlet UIView *scrollingViewArea;

@property (strong, nonatomic) NSMutableArray* businessTypesTitles;
@property (strong, nonatomic) NSMutableArray* businessNames;

- (IBAction)dropDownMenuClicked:(UIButton *)sender;

- (IBAction)swapButtonClicked:(UIButton *)sender;
- (IBAction)searchButtonClicked:(id)sender;

- (IBAction)addBusinessButtonClicked:(id)sender;

- (IBAction)showPopover:(id)sender;

-(void)doLastSearch;

@end