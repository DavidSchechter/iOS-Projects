//
//  BusinessCardViewController.h
//  CanNow
//
//  Created by David Schechter on 1/20/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenuView.h"
#import "MyViewController.h"
#import "CardObject.h"

@interface BusinessCardViewController : MyViewController<UITextFieldDelegate>{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *menuButton;
    IBOutlet UINavigationItem *navBarTitle;
    NSString *titleToSet;
    int idNumberOfCard;
     DropDownMenuView *popOverMenu;
    CardObject *cardInfo;
    IBOutlet UIView *viewSection1;
    IBOutlet UIImageView *businessImage;
    IBOutlet UILabel *titleRow;
    IBOutlet UILabel *streetRow;
    IBOutlet UILabel *cityRow;
    IBOutlet UIButton *webSiteButton;
    IBOutlet UIView *viewSection2;
    IBOutlet UILabel *dayRow;
    IBOutlet UILabel *dateRow;
    IBOutlet UILabel *hoursRow;
    IBOutlet UILabel *hoursRow2;
    IBOutlet UIImageView *isOpenImage;
    IBOutlet UIView *viewSection3;
    IBOutlet UIButton *callToButton;
    IBOutlet UIView *viewSection4;
    IBOutlet UIButton *textToButton;
    IBOutlet UIView *viewSection5;
    IBOutlet UIButton *showOnMapButton;
    IBOutlet UIView *viewSection6;
    IBOutlet UIButton *navToButton;
    IBOutlet UIView *viewSection7;
    IBOutlet UIButton *showPhotosButton;
    IBOutlet UIView *viewSection8;
    IBOutlet UIButton *showVideoButton;
    IBOutlet UIButton *moreInfoButton;
    
    NSString *saveCustomURL;
    
    IBOutlet UIActivityIndicatorView *spinner;
    
    IBOutlet UILabel *pathLabel;
    
    IBOutlet UIImageView *goodStar1;
    IBOutlet UIImageView *goodStar2;
    IBOutlet UIImageView *goodStar3;
    IBOutlet UIImageView *goodStar4;
    IBOutlet UIImageView *goodStar5;
    IBOutlet UIImageView *badStar1;
    IBOutlet UIImageView *badStar2;
    IBOutlet UIImageView *badStar3;
    IBOutlet UIImageView *badStar4;
    IBOutlet UIImageView *badStar5;
    IBOutlet UILabel *rankingLabel;
    
    IBOutlet UIImageView *timeClockImage;

}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@property (strong, nonatomic) NSString *titleToSet;
@property (assign, nonatomic) int idNumberOfCard;
@property (strong, nonatomic) CardObject *cardInfo;
@property (strong, nonatomic) IBOutlet UIView *viewsContainer;
@property (strong, nonatomic) IBOutlet UIView *viewSection1;
@property (strong, nonatomic) IBOutlet UIImageView *businessImage;
@property (strong, nonatomic) IBOutlet UILabel *titleRow;
@property (strong, nonatomic) IBOutlet UILabel *streetRow;
@property (strong, nonatomic) IBOutlet UILabel *cityRow;
@property (strong, nonatomic) IBOutlet UIButton *webSiteButton;
@property (strong, nonatomic) IBOutlet UIView *viewSection2;
@property (strong, nonatomic) IBOutlet UILabel *dayRow;
@property (strong, nonatomic) IBOutlet UILabel *dateRow;
@property (strong, nonatomic) IBOutlet UILabel *hoursRow;
@property (strong, nonatomic) IBOutlet UILabel *hoursRow2;
@property (strong, nonatomic) IBOutlet UIImageView *isOpenImage;
@property (strong, nonatomic) IBOutlet UIView *viewSection3;
@property (strong, nonatomic) IBOutlet UIButton *callToButton;
@property (strong, nonatomic) IBOutlet UIView *viewSection4;
@property (strong, nonatomic) IBOutlet UIButton *textToButton;
@property (strong, nonatomic) IBOutlet UIView *viewSection5;
@property (strong, nonatomic) IBOutlet UIButton *showOnMapButton;
@property (strong, nonatomic) IBOutlet UIView *viewSection6;
@property (strong, nonatomic) IBOutlet UIButton *navToButton;
@property (strong, nonatomic) IBOutlet UIView *viewSection7;
@property (strong, nonatomic) IBOutlet UIButton *showPhotosButton;
@property (strong, nonatomic) IBOutlet UIView *viewSection8;
@property (strong, nonatomic) IBOutlet UIButton *showVideoButton;
@property (strong, nonatomic) IBOutlet UIButton *moreInfoButton;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;

@property (strong, nonatomic) NSString *customSeatchURL;
@property (assign, nonatomic) BOOL usingCustomSearch;

@property (strong, nonatomic) NSString *prevPath;




- (IBAction)backButtonClicked:(UIButton *)sender;

- (IBAction)callTo:(UIButton *)sender;
- (IBAction)smsTo:(UIButton *)sender;
- (IBAction)openMaps:(UIButton *)sender;
- (IBAction)navigateTo:(UIButton *)sender;

- (IBAction)showPopover:(id)sender;


@end
