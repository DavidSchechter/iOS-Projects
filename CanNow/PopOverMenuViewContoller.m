//
//  PopOverMenuViewContoller.m
//  CanNow
//
//  Created by David Schechter on 12/30/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//


#import "PopOverMenuViewContoller.h"
#import "UIViewController+MJPopupViewController.h"
#import "ViewController.h"

@interface PopOverMenuViewContoller ()

@end

@implementation PopOverMenuViewContoller

@synthesize favorButton,oldSearchButton,onSaleButton,aboutButton,contactButton,containingViewController;

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Previous Search methods

- (IBAction)oldSearchButtonButtonClicked:(UIButton *)sender
{
    [containingViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [self performSelector:@selector(goToLastSearch) withObject:nil afterDelay:0.5];
}

-(void)goToLastSearch
{
    ViewController *tmpController=(ViewController*)containingViewController;
    [tmpController doLastSearch];
}

#pragma mark About methods

- (IBAction)aboutButtonClicked:(UIButton *)sender
{
    [containingViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [self performSelector:@selector(goToAbout) withObject:nil afterDelay:0.5];
}

-(void)goToAbout
{
    UIViewController *about = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [containingViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [containingViewController.navigationController pushViewController:about animated:NO];
}

#pragma mark Contact methods

- (IBAction)contactButtonClicked:(UIButton *)sender
{
    [containingViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [self performSelector:@selector(goToContact) withObject:nil afterDelay:0.5];
}

-(void)goToContact
{
    UIViewController *about = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [containingViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [containingViewController.navigationController pushViewController:about animated:NO];
}

@end