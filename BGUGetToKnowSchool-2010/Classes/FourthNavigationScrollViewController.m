//
//  FourthNavigationScrollViewController.m
//  BguWhereIsIt
//
//  Created by David Schechter on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FourthNavigationScrollViewController.h"
#import "MapImageView.h"
#import "PrinterListView.h"


@implementation FourthNavigationScrollViewController


@synthesize scrollView,pageControl;

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
	[scrollView setPagingEnabled:YES];
	pageControlBeingUsed = NO;
	for (int i = 0; i < 2; i++) {
		CGRect frame;
		frame.origin.x = self.scrollView.frame.size.width * i;
		frame.origin.y = 0;//45;
		frame.size = self.scrollView.frame.size;
		frame.size.height=frame.size.height;//-45;
		UIView *subview;
		if (i==1) {
			MapImageView *temp=[[MapImageView alloc] init];
			temp.view.frame=frame;
			subview = temp.view;
		}
		else if (i==0)
		{
			PrinterListView *temp=[[PrinterListView alloc] init];
			temp.view.frame=frame;
			subview = temp.view;
		}
		else {
			subview = [[UIView alloc] initWithFrame:frame];
			subview.backgroundColor = [UIColor blueColor];
		}
		[self.scrollView addSubview:subview];
		[subview release];
	}
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);	
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = 2;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
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
	self.scrollView = nil;
	self.pageControl = nil;
}


- (void)dealloc {
	[scrollView release];
	[pageControl release];
    [super dealloc];
}


@end
