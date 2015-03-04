//
//  ContentPageViewController.m
//  BguWhereIsIt
//
//  Created by David Schechter on 07/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewContentPageViewController.h"
#import "LocalizedCurrentLocation.h"


@implementation FirstViewContentPageViewController

@synthesize pubName;
@synthesize address;
@synthesize location;
@synthesize addText;
@synthesize phones;
@synthesize navToAddress;
@synthesize shortDiscription;


- (IBAction) openMaps {
	NSString *newAdrees = [location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",newAdrees];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction) navFromCurrentLoaction{
	NSString *currentLocation=[LocalizedCurrentLocation currentLocationStringForCurrentLanguage];
 	NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@",currentLocation,location];
	NSString *newURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:newURL]];
}

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
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"simpson.png"]];
	self.view.backgroundColor = background;
	[background release];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
