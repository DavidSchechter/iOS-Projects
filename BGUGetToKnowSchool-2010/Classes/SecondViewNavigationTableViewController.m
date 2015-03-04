//
//  SecondViewNavigationTableViewController.m
//  BguWhereIsIt
//
//  Created by David Schechter on 09/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewNavigationTableViewController.h"
#import "SecondViewContentPageViewController.h"
#import "BguWhereIsItAppDelegate.h"


@implementation SecondViewNavigationTableViewController


@synthesize washersArray;
@synthesize secondViewContentPageViewController;
@synthesize washersDetails;
@synthesize secondNavigationTableViewController;

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
	self.title = NSLocalizedString(@"מכבסות",@"רשימת מכבסות בבאר שבע");
	NSString *myFile = [[NSBundle mainBundle] pathForResource:@"WasherList" ofType:@"plist"];
	NSMutableArray *tempArray = [[NSArray alloc] initWithContentsOfFile:myFile];
	self.washersArray = tempArray;
	[tempArray release];
	myFile = [[NSBundle mainBundle] pathForResource:@"WasherDetailsList" ofType:@"plist"];
	NSMutableDictionary *tempDic = [[NSDictionary alloc] initWithContentsOfFile:myFile];
	self.washersDetails = tempDic;
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
    return [self.washersArray count];
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
	NSString *cellText = [washersArray objectAtIndex:place];
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
	if (self.secondViewContentPageViewController == nil){
		SecondViewContentPageViewController *pageContentPageViewController = [[SecondViewContentPageViewController alloc] initWithNibName:@"SecondViewContentPageViewController" bundle:nil];
		self.secondViewContentPageViewController = pageContentPageViewController;
		[self.secondViewContentPageViewController.washerName.text initWithString:@""];
		[pageContentPageViewController release];
	}
	secondViewContentPageViewController.title = [NSString stringWithFormat:@"%@", [washersArray objectAtIndex:row]];
	
	
	BguWhereIsItAppDelegate *delegate=(BguWhereIsItAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.secondNavigationController pushViewController:secondViewContentPageViewController animated:YES];
	
	secondViewContentPageViewController.washerName.text = [NSString stringWithFormat:@"%@", [washersArray objectAtIndex:row]];
	secondViewContentPageViewController.washerName.backgroundColor = [UIColor clearColor];
	NSString *rightDic = [NSString stringWithFormat:@"Washer%d",row+1];
	//NSString *tempAdd = [NSString stringWithFormat:@"%@",[[self.washersDetails valueForKey:rightDic] valueForKey:@"Address"]];
	//NSString *tempLoc = [NSString stringWithFormat:@"%@",[[self.washersDetails valueForKey:rightDic] valueForKey:@"Loaction"]];
	secondViewContentPageViewController.addText.text = [NSString stringWithFormat:@"%@",[[self.washersDetails valueForKey:rightDic] valueForKey:@"Address"]];//tempAdd;
	secondViewContentPageViewController.addText.backgroundColor = [UIColor clearColor];
	secondViewContentPageViewController.location = [NSString stringWithFormat:@"%@",[[self.washersDetails valueForKey:rightDic] valueForKey:@"Loaction"]];//tempLoc;
	secondViewContentPageViewController.phones.text = [NSString stringWithFormat:@"%@",[[self.washersDetails valueForKey:rightDic] valueForKey:@"Phone"]];//[NSString stringWithString:@"0545812122"];
	secondViewContentPageViewController.phones.backgroundColor = [UIColor clearColor];
	//secondViewContentPageViewController.shortDiscription.backgroundColor = [UIColor clearColor];
	//secondViewContentPageViewController.navToAddress.backgroundColor = [UIColor clearColor];
	//secondViewContentPageViewController.address.backgroundColor = [UIColor clearColor];
	
	[secondNavigationTableViewController deselectRowAtIndexPath:indexPath animated:YES];
	
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
