//
//  MapImageView.m
//  TestAgain
//
//  Created by David Schechter on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapImageView.h"


@implementation MapImageView

@synthesize imageView,scrollView;
@synthesize myView;
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
	UIImage* leftImage = [UIImage imageNamed:@"map.png"];
	imageView = [[UIImageView alloc] initWithImage:leftImage];
	[imageView setFrame:CGRectMake(0, 0, 320,380)];
	
	
	//[scrollView setMaximumZoomScale:4.0f];
	
	scrollView.clipsToBounds=YES;
	scrollView.maximumZoomScale=4.0;
	scrollView.minimumZoomScale=1.0;
	scrollView.contentSize=CGSizeMake(imageView.frame.size.width,imageView.frame.size.height);
	scrollView.delegate=self;
	
	
	[scrollView addSubview:imageView];
	
	//
	//UIImage* leftImage = [UIImage imageNamed:@"map.png"];
	//imageView = [[UIImageView alloc] initWithImage:leftImage];
	//scrollView.contentSize=CGSizeMake(100, 100);
	//[scrollView addSubview:imageView];
	//imageView.backgroundColor = [UIColor whiteColor];
	//[scrollView setMaximumZoomScale:4.0f];
	//[leftView setFrame:CGRectMake(frame.origin.x, frame.origin.y+40, frame.size.width, frame.size.height-40)];
	//leftView.frame.size.height=100.00;
	//PictureView *temp=[PictureView alloc];
	//temp.view.frame=frame;
	//subview = leftView;
	//[subview setMaximumZoomScale:2.0f];
	//self.scrollView.maximumZoomScale=4.0;
	//self.scrollView.minimumZoomScale=1.0;
	//self.scrollView.clipsToBounds=YES;
	
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return imageView;
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
