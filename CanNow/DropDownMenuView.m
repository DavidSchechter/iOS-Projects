//
//  DropDownMenuView.m
//  CanNow
//
//  Created by David Schechter on 5/11/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import "DropDownMenuView.h"
#import "CategoryObject.h"
#import "ResultsPageViewController.h"
#import "ChangeSearchViewController.h"
#import "AddBusinessViewController.h"


@interface DropDownMenuView ()

@end

@implementation DropDownMenuView

@synthesize idNumberOfCategory;
@synthesize containgViewController;
@synthesize pathToSave;


#pragma mark View init

- (DropDownMenuView*)initWithCustomFrame:(CGRect)frame andPhase:(int)currectPhase
{
    if (self == [super init])
    {
        self.frame=frame;
        [self setBackgroundColor:[UIColor blackColor]];
        self.clipsToBounds=YES;
        menuPhase=currectPhase;
    }
    return self;
}

#pragma mark Custom Scroll View Creation methods

-(void)createScrollViewArea
{
    if (menuPhase==1)
    {
        NSURL *myURL=[[NSURL alloc] initWithString:@"http://www.can-now.co.il/api/pages/"];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *response = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&responseCode error:&error];
        
        if (error==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"שגיאה" message:@"קרתה שגיאה בגישה לנתונים. אנא נסה שנית מאחור יותר" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
            [self.containgViewController.view addSubview:alert];
            [alert show];
        }
        
        NSError *jsonParsingError = nil;
        NSArray *arrayOfName = [NSJSONSerialization JSONObjectWithData:response
                                                               options:0 error:&jsonParsingError];
        businessTypesTitles=[[NSMutableArray alloc] init];
        for (int i=0;i<arrayOfName.count;i++)
        {
            NSDictionary *temp=arrayOfName[i];
            CategoryObject *tempCat=[[CategoryObject alloc] init];
            tempCat.title=[temp objectForKey:@"name"];
            tempCat.idNumber=[[temp objectForKey:@"id"] intValue];
            tempCat.numberOfCards=0;
            tempCat.numberOfSubCategories=1;
            [businessTypesTitles addObject:tempCat];
        }
    }
    else
    {
        
        NSString* buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/category/%d/",idNumberOfCategory] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSURL *myURL=[[NSURL alloc] initWithString:buildURL];
        
        
        NSURL *myURL=[NSURL URLWithString:buildURL];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *response = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&responseCode error:&error];
        
        if (error==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"שגיאה" message:@"קרתה שגיאה בגישה לנתונים. אנא נסה שנית מאחור יותר" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
            [self.containgViewController.view addSubview:alert];
            [alert show];
        }
        
        NSError *jsonParsingError = nil;
        
        NSArray *allCatergories = [NSJSONSerialization JSONObjectWithData:response
                                                                  options:0 error:&jsonParsingError];
        
        subCategoriesArray=[[NSMutableArray alloc] init];
        for (int i=0;i<allCatergories.count;i++)
        {
            NSDictionary *temp=allCatergories[i];
            CategoryObject *tempCat=[[CategoryObject alloc] init];
            tempCat.title=[temp objectForKey:@"name"];
            tempCat.idNumber=[[temp objectForKey:@"id"] intValue];
            tempCat.numberOfCards=[[temp objectForKey:@"cards"] intValue];
            tempCat.numberOfSubCategories=[[temp objectForKey:@"cats"] intValue];
            [subCategoriesArray addObject:tempCat];
        }
    }
    
    [self createBusinessCategoriesScrollView];
}

-(void) createBusinessCategoriesScrollView
{
    UIScrollView *myScroll = [[UIScrollView alloc] init];
    myScroll.frame = self.bounds; //scroll view occupies full parent view!
    
    myScroll.backgroundColor = [UIColor whiteColor];
    
    myScroll.showsVerticalScrollIndicator = YES;    // to hide scroll indicators!
    
    myScroll.showsHorizontalScrollIndicator = NO; //by default, it shows!
    
    myScroll.scrollEnabled = YES;                 //say "NO" to disable scroll
    
    
    
    NSUInteger i;
    int xCoord=0;
    int yCoord=0;
    int buttonWidth=self.frame.size.width;
    int buttonHeight=30;
    int buffer = 1;
    int count;
    NSMutableArray *tempArr;
    if (menuPhase==1)
    {
        count=businessTypesTitles.count;
        tempArr=businessTypesTitles;
    }
    else
    {
        count=subCategoriesArray.count;
        tempArr=subCategoriesArray;
    }
    for (i = 0; i < count; i++)
    {
        CategoryObject *tempCat=tempArr[i];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setTitle:tempCat.title forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [aButton setBackgroundColor: [UIColor lightGrayColor]];
        aButton.frame     = CGRectMake(xCoord, yCoord,buttonWidth,buttonHeight );
        if (!(tempCat.numberOfSubCategories==0))
            [aButton addTarget:self action:@selector(nextView:) forControlEvents:UIControlEventTouchUpInside];
        else if (!(tempCat.numberOfCards==0))
            [aButton addTarget:self action:@selector(moveToCards:) forControlEvents:UIControlEventTouchUpInside];
        else
            [aButton addTarget:self action:@selector(nothing:) forControlEvents:UIControlEventTouchUpInside];
        [aButton setTag:tempCat.idNumber];
        [myScroll addSubview:aButton];
        yCoord += buttonHeight + buffer;
        
    }
    [myScroll setContentSize:CGSizeMake(self.frame.size.width, yCoord+2)];
    [myScroll setShowsHorizontalScrollIndicator:NO];
    
    [self addSubview:myScroll];               //adding to parent view!
}


#pragma mark Custom Scroll View navigation methods

-(void) nextView:(id)sender {
    DropDownMenuView *subField = [[DropDownMenuView alloc] initWithCustomFrame:CGRectMake(0-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) andPhase:2];
    subField.containgViewController=self.containgViewController;
    UIButton* tempButton=(UIButton*)sender;
    subField.idNumberOfCategory=tempButton.tag;
    if (self.pathToSave.length!=0)
    {
        NSString *rightArrow=@"\u2190";
        subField.pathToSave=[NSString stringWithFormat:@"%@ %@ %@",self.pathToSave,rightArrow,tempButton.titleLabel.text];
    }
    else
    {
        NSString *rightArrow=@"\u2190";
        subField.pathToSave=[NSString stringWithFormat:@"ראשי %@ %@",rightArrow,tempButton.titleLabel.text];
    }
    [subField createScrollViewArea];
    [self addSubview:subField];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    subField.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [self performSelector:@selector(removePrevView) withObject:nil afterDelay:0.6];
}

-(void)removePrevView
{
    [[self.subviews objectAtIndex:0] removeFromSuperview];
}

-(void) moveToCards:(id)sender {
    
    [containgViewController showPopover:nil];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ResultsPageViewController *subField = [sb instantiateViewControllerWithIdentifier:@"ResultsPageViewController"];
    UIButton* tempButton=(UIButton*)sender;
    NSString* tmp=[[NSString alloc] initWithString:tempButton.titleLabel.text];
    subField.titleToSet=tmp;
    subField.idNumberOfCategory=tempButton.tag;
    subField.prevPath=self.pathToSave;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    UINavigationController *root=(UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if (([topController isKindOfClass:[ChangeSearchViewController class]]) ||([topController isKindOfClass:[AddBusinessViewController class]]))
        [topController dismissViewControllerAnimated:NO completion:nil];
    
    [root.view.layer addAnimation:transition forKey:kCATransition];
    
    UIViewController *homePage=[root.viewControllers objectAtIndex:0];
    [root setViewControllers:[NSArray arrayWithObjects:homePage,subField, nil] animated:YES];
}

-(void) nothing:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"אין פרטים"
                                                      message:@"אין תת קטגוריות או עסקים לקטגוריה זו"
                                                     delegate:nil
                                            cancelButtonTitle:@"אישור"
                                            otherButtonTitles:nil];
    [message show];
}

@end