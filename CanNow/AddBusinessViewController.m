//
//  AddBusinessViewController.m
//  CanNow
//
//  Created by David Schechter on 1/25/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import "AddBusinessViewController.h"
#import "CategoryObject.h"
#import "ResultsPageViewController.h"

@interface AddBusinessViewController ()

@end

@implementation AddBusinessViewController

@synthesize backButton,menuButton,nameOfBusiness,phoneNumberOfBusiness,emailOfBusiness,sendButton,waringText;;


#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.idNumberStrightToCards=0;
    self.backStrightToRootView=FALSE;
    
    AppDelegate* tmp=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSDictionary *tmpdic=[tmp.bannerImagesArray objectAtIndex:4];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://www.can-now.co.il%@",[tmpdic objectForKey:@"image"]]]];
    bannerURL=[tmpdic objectForKey:@"link"];
    UIImage *bannerMOneImage = [UIImage imageWithData: imageData];
    [self.banner setBackgroundImage:bannerMOneImage forState:UIControlStateNormal];
    [self.banner addTarget:self action:@selector(openBanner) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *tmpdic2=[tmp.bannerImagesArray objectAtIndex:5];
    NSData * imageData2 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://www.can-now.co.il%@",[tmpdic2 objectForKey:@"image"]]]];
    banner2URL=[tmpdic2 objectForKey:@"link"];
    UIImage *bannerMOneImage2 = [UIImage imageWithData: imageData2];
    [self.banner2 setBackgroundImage:bannerMOneImage2 forState:UIControlStateNormal];
    [self.banner2 addTarget:self action:@selector(openBanner2) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)backButtonClicked:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Open Banner Methods

-(void)openBanner
{
    NSURL *url = [ [ NSURL alloc ] initWithString: bannerURL ];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)openBanner2
{
    NSURL *url = [ [ NSURL alloc ] initWithString: banner2URL ];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark UITextFieldDelegate Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

#pragma mark Add A Business Method

-(IBAction)addBusinessClicked:(id)sender
{
    NSString *name;
    if (self.nameOfBusiness.text.length==0)
    {
        name=@"";
    }
    else
    {
        name=self.nameOfBusiness.text;
    }
    NSString *phone;
    if (self.phoneNumberOfBusiness.text.length==0)
    {
        phone=@"";
    }
    else
    {
        phone=self.phoneNumberOfBusiness.text;
    }
    NSString *email;
    if (self.emailOfBusiness.text.length==0)
    {
        email=@"";
    }
    else
    {
        email=self.emailOfBusiness.text;
    }
    NSString *urlToSend=[NSString stringWithFormat:@"http://www.can-now.co.il/api/addnewcard/0/%@/%@/%@",name,phone,email];
    
    NSURL *myURL=[[NSURL alloc] initWithString:urlToSend];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&responseCode error:&error];
    
    if (error==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"שגיאה" message:@"קרתה שגיאה בגישה לנתונים. אנא נסה שנית מאחור יותר" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
        [self.view addSubview:alert];
        [alert show];
    }
    
    NSError *jsonParsingError = nil;
    NSArray *arrayOfName = [NSJSONSerialization JSONObjectWithData:response
                                                           options:0 error:&jsonParsingError];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark PopOver Method

- (IBAction)showPopover:(id)sender
{
    if (popOverMenu==nil)
    {
        popOverMenu=[[DropDownMenuView alloc] initWithCustomFrame:CGRectMake(0, 160, 200, 322) andPhase:1];
        [popOverMenu createScrollViewArea];
        popOverMenu.containgViewController=self;
        popOverMenu.frame=CGRectMake(0, 160, 200, 0);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        popOverMenu.frame=CGRectMake(0, 160, 200, 322);
        [UIView commitAnimations];
        [self.view addSubview:popOverMenu];
    }
    else if (popOverMenu.frame.size.height==0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        popOverMenu.frame=CGRectMake(0, 160, 200, 322);
        [UIView commitAnimations];
        [self.view addSubview:popOverMenu];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        popOverMenu.frame=CGRectMake(0, 160, 200, 0);
        [UIView commitAnimations];
        [self.view addSubview:popOverMenu];
    }
    
}

@end