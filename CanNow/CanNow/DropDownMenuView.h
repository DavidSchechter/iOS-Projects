//
//  DropDownMenuView.h
//  CanNow
//
//  Created by David Schechter on 5/11/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"

@interface DropDownMenuView : UIView{
    NSString *urlToRequestNow;
    NSMutableArray* businessTypesTitles;
    NSMutableArray* businessNames;
    NSString *titleToSet;
    int menuPhase;
    NSMutableArray *subCategoriesArray;
}

@property (assign, nonatomic) int idNumberOfCategory;
@property (strong, nonatomic) MyViewController *containgViewController;
@property (strong, nonatomic) NSString *pathToSave;

- (DropDownMenuView*)initWithCustomFrame:(CGRect)frame andPhase:(int)currectPhase;
-(void)createScrollViewArea;

@end