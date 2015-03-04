//
//  FirstViewNavigationTableViewController.m
//  BguWhereIsIt
//
//  Created by David Schechter on 07/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewNavigationTableViewController.h"
#import "FirstViewContentPageViewController.h"
#import "BguWhereIsItAppDelegate.h"

@implementation FirstViewNavigationTableViewController

@synthesize barsArray;
@synthesize firstViewContentPageViewController;
@synthesize barsDetails;
@synthesize firstNavigationTableViewController;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"בארים",@"רשימת בארים בבאר שבע");
	NSString *myFile = [[NSBundle mainBundle] pathForResource:@"BarList" ofType:@"plist"];
	NSMutableArray *tempArray = [[NSArray alloc] initWithContentsOfFile:myFile];
	self.barsArray = tempArray;
	[tempArray release];
	myFile = [[NSBundle mainBundle] pathForResource:@"BarDetailsList" ofType:@"plist"];
	NSMutableDictionary *tempDic = [[NSDictionary alloc] initWithContentsOfFile:myFile];
	self.barsDetails = tempDic;
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
    return [self.barsArray count];
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
	NSString *cellText = [barsArray objectAtIndex:place];
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
	if (self.firstViewContentPageViewController == nil){
		FirstViewContentPageViewController *pageContentPageViewController=
		[[FirstViewContentPageViewController alloc] 
		 initWithNibName:@"FirstViewContentPageViewController" bundle:nil];
		self.firstViewContentPageViewController = pageContentPageViewController;
		[self.firstViewContentPageViewController.pubName.text initWithString:@""];
		[pageContentPageViewController release];
	}
	firstViewContentPageViewController.title = [NSString stringWithFormat:@"%@", [barsArray objectAtIndex:row]];
	
	
	BguWhereIsItAppDelegate *delegate=(BguWhereIsItAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.firstNavigationController pushViewController:firstViewContentPageViewController animated:YES];
	
	firstViewContentPageViewController.pubName.text = [NSString stringWithFormat:@"%@", [barsArray objectAtIndex:row]];
	firstViewContentPageViewController.pubName.backgroundColor = [UIColor clearColor];
	NSString *rightDic = [NSString stringWithFormat:@"Bar%d",row+1];
	firstViewContentPageViewController.addText.text = [NSString stringWithFormat:@"%@",[[self.barsDetails valueForKey:rightDic] valueForKey:@"Address"]];
	firstViewContentPageViewController.addText.backgroundColor = [UIColor clearColor];
	firstViewContentPageViewController.location = [NSString stringWithFormat:@"%@",[[self.barsDetails valueForKey:rightDic] valueForKey:@"Loaction"]];
	firstViewContentPageViewController.phones.text = [NSString stringWithFormat:@"%@",[[self.barsDetails valueForKey:rightDic] valueForKey:@"Phone"]];
	firstViewContentPageViewController.phones.backgroundColor = [UIColor clearColor];
	firstViewContentPageViewController.shortDiscription.text = [NSString stringWithFormat:@"%@",[[self.barsDetails valueForKey:rightDic] valueForKey:@"Discription"]];
	firstViewContentPageViewController.shortDiscription.backgroundColor = [UIColor clearColor];
	[firstViewContentPageViewController.shortDiscription flashScrollIndicators];
	//firstViewContentPageViewController.navToAddress.backgroundColor = [UIColor clearColor];
	//firstViewContentPageViewController.address.backgroundColor = [UIColor clearColor];
	
	[firstNavigationTableViewController deselectRowAtIndexPath:indexPath animated:YES];
	
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
	[firstViewContentPageViewController release];
    [super dealloc];
}


@end
