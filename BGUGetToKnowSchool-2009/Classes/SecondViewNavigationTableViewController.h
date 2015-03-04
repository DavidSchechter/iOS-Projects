//
//  SecondViewNavigationTableViewController.h
//  BguWhereIsIt
//
//  Created by David Schechter on 09/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SecondViewContentPageViewController;

//UITableViewController


@interface SecondViewNavigationTableViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>{
	IBOutlet UITableView *secondNavigationTableViewController;
	NSMutableArray *washersArray;
	NSMutableDictionary *washersDetails;
	SecondViewContentPageViewController *secondViewContentPageViewController;
	
}

@property (nonatomic, retain) IBOutlet UITableView *secondNavigationTableViewController;
@property (nonatomic, retain) NSMutableArray *washersArray;
@property (nonatomic, retain) NSMutableDictionary *washersDetails;
@property (nonatomic, retain) SecondViewContentPageViewController *secondViewContentPageViewController;

@end
