//
//  PrinterListView.h
//  TestAgain
//
//  Created by David Schechter on 06/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//UITableViewController

@interface PrinterListView : UIViewController
<UITableViewDelegate,UITableViewDataSource> {
	
	IBOutlet UITableView* tableView;
	IBOutlet UIView* myView;
	NSMutableArray *printersArray;
	NSMutableArray *copiersArray;

}

@property (nonatomic, retain) NSMutableArray *printersArray;
@property (nonatomic, retain) NSMutableArray *copiersArray;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIView* myView;

@end
