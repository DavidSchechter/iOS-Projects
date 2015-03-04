//
//  SecondViewContentPageViewController.h
//  BguWhereIsIt
//
//  Created by David Schechter on 09/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewContentPageViewController : UIViewController {
	IBOutlet UITextView *washerName;
	IBOutlet UIButton *address;
	IBOutlet NSString *location;
	IBOutlet UITextView *addText;
	IBOutlet UITextView *phones;
	IBOutlet UIButton *navToAddress;
	
}

@property (nonatomic, retain) IBOutlet UITextView *washerName;
@property (nonatomic, retain) IBOutlet UIButton *address;
@property (nonatomic, retain) IBOutlet NSString *location;
@property (nonatomic, retain) IBOutlet UITextView *addText;
@property (nonatomic, retain) IBOutlet UITextView *phones;
@property (nonatomic, retain) IBOutlet UIButton *navToAddress;



- (IBAction) openMaps;
- (IBAction) navFromCurrentLoaction;

@end
