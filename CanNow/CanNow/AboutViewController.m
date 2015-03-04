//
//  AboutViewController.m
//  CanNow
//
//  Created by David Schechter on 5/13/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(UIButton *)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
