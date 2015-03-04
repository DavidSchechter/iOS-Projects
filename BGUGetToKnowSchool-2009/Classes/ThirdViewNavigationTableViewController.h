//
//  ThirdViewNavigationTableViewController.h
//  BguWhereIsIt
//
//  Created by David Schechter on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThirdViewContentPageViewController;

//UITableViewController


@interface ThirdViewNavigationTableViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>{
	IBOutlet UITableView *thirdNavigationTableViewController;
	NSMutableArray *supersArray;
	NSMutableDictionary *supersDetails;
	ThirdViewContentPageViewController *thirdViewContentPageViewController;
	
}

@property (nonatomic, retain) IBOutlet UITableView *thirdNavigationTableViewController;
@property (nonatomic, retain) NSMutableArray *supersArray;
@property (nonatomic, retain) NSMutableDictionary *supersDetails;
@property (nonatomic, retain) ThirdViewContentPageViewController *thirdViewContentPageViewController;

@end

