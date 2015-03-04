//
//  ContentPageViewController.h
//  BguWhereIsIt
//
//  Created by David Schechter on 07/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewContentPageViewController : UIViewController {
	IBOutlet UITextView *pubName;
	IBOutlet UIButton *address;
	IBOutlet NSString *location;
	IBOutlet UITextView *addText;
	IBOutlet UITextView *phones;
	IBOutlet UIButton *navToAddress;
	IBOutlet UITextView *shortDiscription;
	
}

@property (nonatomic, retain) IBOutlet UITextView *pubName;
@property (nonatomic, retain) IBOutlet UIButton *address;
@property (nonatomic, retain) IBOutlet NSString *location;
@property (nonatomic, retain) IBOutlet UITextView *addText;
@property (nonatomic, retain) IBOutlet UITextView *phones;
@property (nonatomic, retain) IBOutlet UIButton *navToAddress;
@property (nonatomic, retain) IBOutlet UITextView *shortDiscription;
 


- (IBAction) openMaps;
- (IBAction) navFromCurrentLoaction;

@end
