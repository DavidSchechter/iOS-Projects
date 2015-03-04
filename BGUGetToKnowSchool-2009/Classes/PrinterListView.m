//
//  PrinterListView.m
//  TestAgain
//
//  Created by David Schechter on 06/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrinterListView.h"
#import "BguWhereIsItAppDelegate.h"

@implementation PrinterListView

@synthesize tableView,myView,printersArray,copiersArray;

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
	//[myLabel setText:@"acacac"];
	//self.myLabel.text = NSLocalizedString(@"מדפסות באוניברסיטה",@"מדפסות באוניברסיטה");
	//NSMutableArray *tempArray = [[NSArray alloc] initWithObjects:@"ברקה",@"איינשטיין",@"מנצילה",nil];
	NSString *myFile = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
	NSMutableArray *tempArray = [[NSArray alloc] initWithContentsOfFile:myFile];
	self.printersArray = tempArray;
	//[tempArray release];
	myFile = [[NSBundle mainBundle] pathForResource:@"CopierList" ofType:@"plist"];
	tempArray = [[NSArray alloc] initWithContentsOfFile:myFile];
	self.copiersArray = tempArray;
	//[tempArray release];
	//if (tableView.style==UITableViewStylePlain)
	//NSLog([NSString stringWithString:@"the style is plain"]);
	//if (tableView.style==UITableViewStyleGrouped)
	//	NSLog([NSString stringWithString:@"the style is grouped"]);
	
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	if (section==0) return @"מדפסות";
	if (section==1) return @"מכונות צילום";
	return @"other";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section==0) return [self.printersArray count];
	if (section==1) return [self.copiersArray count];
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSUInteger place=[indexPath row];
	NSString *cellText;
	if (indexPath.section==0)
	{
		cellText = [printersArray objectAtIndex:place];
	}
	if (indexPath.section==1)
	{
		cellText = [copiersArray objectAtIndex:place];
	}
	[[cell textLabel] setText:cellText];
	[[cell textLabel] setTextAlignment:UITextAlignmentRight];
    
    return cell;
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
