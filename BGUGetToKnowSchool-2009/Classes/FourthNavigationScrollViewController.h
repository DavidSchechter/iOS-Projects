//
//  FourthNavigationScrollViewController.h
//  BguWhereIsIt
//
//  Created by David Schechter on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FourthNavigationScrollViewController : UIViewController <UIScrollViewDelegate> {
	
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl; 
	
	BOOL pageControlBeingUsed;
	
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

- (IBAction)changePage;

@end
