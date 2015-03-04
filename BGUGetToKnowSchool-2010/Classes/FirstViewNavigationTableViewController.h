//
//  FirstViewNavigationTableViewController.h
//  BguWhereIsIt
//
//  Created by David Schechter on 07/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FirstViewContentPageViewController;

//UITableViewController


@interface FirstViewNavigationTableViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>{
	IBOutlet UITableView *firstNavigationTableViewController;
	NSMutableArray *barsArray;
	NSMutableDictionary *barsDetails;
	FirstViewContentPageViewController *firstViewContentPageViewController;
	
}

@property (nonatomic, retain) IBOutlet UITableView *firstNavigationTableViewController;
@property (nonatomic, retain) NSMutableArray *barsArray;
@property (nonatomic, retain) NSMutableDictionary *barsDetails;
@property (nonatomic, retain) FirstViewContentPageViewController *firstViewContentPageViewController;

@end
