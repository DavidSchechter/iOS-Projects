//
//  MapImageView.h
//  TestAgain
//
//  Created by David Schechter on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MapImageView : UIViewController <UIScrollViewDelegate>{
	
	UIImageView* imageView;
	IBOutlet UIScrollView* scrollView;
	//IBOutlet UILabel *label;
	IBOutlet UIView *myView;
	
}

//@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIView *myView;

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;



@end
