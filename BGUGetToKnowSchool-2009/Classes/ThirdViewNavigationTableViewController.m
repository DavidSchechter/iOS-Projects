//
//  ThirdViewNavigationTableViewController.m
//  BguWhereIsIt
//
//  Created by David Schechter on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewNavigationTableViewController.h"
#import "ThirdViewContentPageViewController.h"
#import "BguWhereIsItAppDelegate.h"


@implementation ThirdViewNavigationTableViewController

@synthesize supersArray;
@synthesize thirdViewContentPageViewController;
@synthesize supersDetails;
@synthesize thirdNavigationTableViewController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"סופרים/מכולות",@"רשימת סופרים/מכולות בבאר שבע");
	NSString *myFile = [[NSBundle mainBundle] pathForResource:@"SuperList" ofType:@"plist"];
	NSMutableArray *tempArray = [[NSArray alloc] initWithContentsOfFile:myFile];
	self.supersArray = tempArray;
	[tempArray release];
	myFile = [[NSBundle mainBundle] pathForResource:@"SuperDetailsList" ofType:@"plist"];
	NSMutableDictionary *tempDic = [[NSDictionary alloc] initWithContentsOfFile:myFile];
	self.supersDetails = tempDic;
	[tempDic release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.supersArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSUInteger place=[indexPath row];
	NSString *cellText = [supersArray objectAtIndex:place];
	[[cell textLabel] setText:cellText];
	[[cell textLabel] setTextAlignment:UITextAlignmentRight];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	NSInteger row = [indexPath row];
	if (self.thirdViewContentPageViewController == nil){
		ThirdViewContentPageViewController *pageContentPageViewController = [[ThirdViewContentPageViewController alloc] initWithNibName:@"ThirdViewContentPageViewController" bundle:nil];
		self.thirdViewContentPageViewController = pageContentPageViewController;
		[self.thirdViewContentPageViewController.superName.text initWithString:@""];
		[pageContentPageViewController release];
	}
	thirdViewContentPageViewController.title = [NSString stringWithFormat:@"%@", [supersArray objectAtIndex:row]];
	
	
	BguWhereIsItAppDelegate *delegate=(BguWhereIsItAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.thirdNavigationController pushViewController:thirdViewContentPageViewController animated:YES];
	
	thirdViewContentPageViewController.superName.text = [NSString stringWithFormat:@"%@", [supersArray objectAtIndex:row]];
	thirdViewContentPageViewController.superName.backgroundColor = [UIColor clearColor];
	NSString *rightDic = [NSString stringWithFormat:@"Super%d",row+1];
	//NSString *tempAdd = [NSString stringWithFormat:@"%@",[[self.washersDetails valueForKey:rightDic] valueForKey:@"Address"]];
	//NSString *tempLoc = [NSString stringWithFormat:@"%@",[[self.washersDetails valueForKey:rightDic] valueForKey:@"Loaction"]];
	thirdViewContentPageViewController.addText.text = [NSString stringWithFormat:@"%@",[[self.supersDetails valueForKey:rightDic] valueForKey:@"Address"]];//tempAdd;
	thirdViewContentPageViewController.addText.backgroundColor = [UIColor clearColor];
	thirdViewContentPageViewController.location = [NSString stringWithFormat:@"%@",[[self.supersDetails valueForKey:rightDic] valueForKey:@"Loaction"]];//tempLoc;
	thirdViewContentPageViewController.phones.text = [NSString stringWithFormat:@"%@",[[self.supersDetails valueForKey:rightDic] valueForKey:@"Phone"]];//[NSString stringWithString:@"0545812122"];
	thirdViewContentPageViewController.phones.backgroundColor = [UIColor clearColor];
	//secondViewContentPageViewController.shortDiscription.backgroundColor = [UIColor clearColor];
	//secondViewContentPageViewController.navToAddress.backgroundColor = [UIColor clearColor];
	//secondViewContentPageViewController.address.backgroundColor = [UIColor clearColor];
	
	[thirdNavigationTableViewController deselectRowAtIndexPath:indexPath animated:YES];
	
}






- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
