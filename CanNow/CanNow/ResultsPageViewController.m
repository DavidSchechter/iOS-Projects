//
//  ResultsPageViewController.m
//  CanNow
//
//  Created by David Schechter on 12/24/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//

#import "ResultsPageViewController.h"
//#import "UIView+AUISelectiveBorder.h"
#import "CardObject.h"
#import "BusinessCardViewController.h"
#import "ChangeSearchViewController.h"
#import "CategoryObject.h"
#import "ResultsPageViewController.h"

@interface ResultsPageViewController ()

@end

@implementation ResultsPageViewController

@synthesize backButton,menuButton,otherAreaButton,otherDateButton,navBarTitle,cardsArray,titleToSet,idNumberOfCategory,customSeatchURL,urlOffset,usingCustomSearch,prevPath;

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.idNumberStrightToCards=0;
    self.backStrightToRootView=FALSE;
    self.navBarTitle.title = self.titleToSet;
    areThereMoreReuslts=NO;
    NSString *rightArrow=@"\u2190";
    pathLabel.text=[NSString stringWithFormat:@"%@ %@ %@",prevPath,rightArrow,self.titleToSet];
    self.urlOffset=0;
    if (self.usingCustomSearch)
    {
        saveCustomURL=[NSString stringWithString:self.customSeatchURL];
        self.customSeatchURL=saveCustomURL;
    }
    
    [spinner startAnimating];
    spinner.hidden=NO;
    self.tableFields.hidden=YES;
    
    [self performSelector:@selector(loadInitalData) withObject:nil afterDelay:0.1];

}

-(void)loadInitalData
{
    NSString* buildURL;
    if (self.usingCustomSearch)
    {
        saveCustomURL=[NSString stringWithString:self.customSeatchURL];
        self.customSeatchURL=saveCustomURL;
        buildURL=self.customSeatchURL;
    }
    else
    {
        if ([CLLocationManager locationServicesEnabled])
        {
            if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied)
            {
                AppDelegate* tmp=[UIApplication sharedApplication].delegate;
                if (tmp.userLocation)
                {
                    NSString *lat=[NSString stringWithFormat:@"%f",tmp.userLocation.coordinate.latitude];
                    lat = [lat stringByReplacingOccurrencesOfString:@"."
                                                         withString:@"z"];
                    NSString *lang=[NSString stringWithFormat:@"%f",tmp.userLocation.coordinate.longitude];
                    lang = [lang stringByReplacingOccurrencesOfString:@"."
                                                           withString:@"z"];
                    buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d/%d//gps_location/%@,%@",self.idNumberOfCategory,self.urlOffset,lat,lang] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
                else
                {
                    buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d/%d/",self.idNumberOfCategory,self.urlOffset] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
            }
            else
            {
                buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d/%d/",self.idNumberOfCategory,self.urlOffset] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
        else
        {
            buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d/%d/",self.idNumberOfCategory,self.urlOffset] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    
    NSURL *myURL=[NSURL URLWithString:buildURL];
    
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
    NSArray *allCatergories = [NSJSONSerialization JSONObjectWithData:response
                                                              options:0 error:&jsonParsingError];
    self.cardsArray=[[NSMutableArray alloc] init];
    for (int i=0;i<allCatergories.count;i++)
    {
        NSDictionary *temp=allCatergories[i];
        NSString *name=[temp objectForKey:@"name"];
        if ([name isEqualToString:@"more_results"])
        {
            areThereMoreReuslts=YES;
        }
        else
        {
            CardObject *tempCat=[[CardObject alloc] init];
            tempCat.title=[temp objectForKey:@"name"];
            tempCat.idNumber=[[temp objectForKey:@"id"] intValue];
            tempCat.timeStart1=[temp objectForKey:@"work_time_start_1"];
            tempCat.timeEnd1=[temp objectForKey:@"work_time_end_1"];
            tempCat.timeStart2=[temp objectForKey:@"work_time_start_2"];
            tempCat.timeEnd2=[temp objectForKey:@"work_time_end_2"];
            tempCat.address=[temp objectForKey:@"address"];
            tempCat.city=[temp objectForKey:@"city"];
            tempCat.isOpen=[[temp objectForKey:@"is_available"] boolValue];
            tempCat.image=[temp objectForKey:@"image"];
            [cardsArray addObject:tempCat];
        }
    }
    
    if (areThereMoreReuslts)
    {
        CardObject *tempCat=[[CardObject alloc] init];
        tempCat.title=@"more_results";
        tempCat.idNumber=0;
        tempCat.timeStart1=nil;
        tempCat.timeEnd1=nil;
        tempCat.timeStart2=nil;
        tempCat.timeEnd2=nil;
        tempCat.address=nil;
        tempCat.city=nil;
        tempCat.isOpen=NO;
        tempCat.image=nil;
        [cardsArray addObject:tempCat];
    }
    
    [self.tableFields reloadData];
    
    self.tableFields.hidden=NO;
    [spinner stopAnimating];
    spinner.hidden = YES;
    
}

- (IBAction)backButtonClicked:(UIButton *)sender{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Change Search methods

- (IBAction)changeSearchByDate:(UIButton *)sender
{
    ChangeSearchViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeSearchViewController"];
    subField.urlToChange=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d",self.idNumberOfCategory] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    subField.pageToChange=self;
    subField.openWithDate=YES;
    [self.navigationController presentViewController:subField animated:YES completion:nil];
}

- (IBAction)changeSearchByArea:(UIButton *)sender
{
    ChangeSearchViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeSearchViewController"];
    subField.urlToChange=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d",self.idNumberOfCategory] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    subField.pageToChange=self;
    subField.openWithArea=YES;
    [self.navigationController presentViewController:subField animated:YES completion:nil];
}

#pragma mark PopOver methods

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

#pragma mark UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return cardsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"CardsRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    CardObject *tempCat=cardsArray[indexPath.row];
    if ([tempCat.title isEqualToString:@"more_results"])
    {
        
        UIImage *tmpBorderImg=[UIImage imageNamed:@"seperation_border.png"];
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(15, 0,tmpBorderImg.size.width,70 )];
        
        UIImageView *tmpBorderImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,tmpBorderImg.size.width,tmpBorderImg.size.height)];
        tmpBorderImgView.image=tmpBorderImg;
        
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setBackgroundColor:[UIColor whiteColor]];
        
        
        [aButton setTitle:@"טען עוד תוצאות" forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        aButton.frame     = CGRectMake(0, 1,tmpBorderImg.size.width,69);
        
        [aButton setTag:tempCat.idNumber];
        if (usingCustomSearch)
        {
            [aButton addTarget:self action:@selector(loadMoreResultsForCustomSearch) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [aButton addTarget:self action:@selector(loadMoreResults) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [aView addSubview:tmpBorderImgView];
        [aView addSubview:aButton];
        [cell addSubview:aView];
        
    }
    else
    {
        UIImage *tmpBorderImg=[UIImage imageNamed:@"seperation_border.png"];
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(15, 0,tmpBorderImg.size.width,70 )];
        
        UIImage *tmpBtnImage;
        UIImage *tmpOpenImg;
        if (tempCat.isOpen)
        {
            tmpBtnImage=[UIImage imageNamed:@"enter_item.png"];
            tmpOpenImg = [UIImage imageNamed:@"active.png"];
        }
        else
        {
            tmpBtnImage=[UIImage imageNamed:@"enter_item_inactive.png"];
            tmpOpenImg = [UIImage imageNamed:@"inactive.png"];
        }
        
        
        
        UIImageView *tmpBorderImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,tmpBorderImg.size.width,tmpBorderImg.size.height)];
        tmpBorderImgView.image=tmpBorderImg;
        
        UIImageView *imageIsOpen=[[UIImageView alloc] initWithFrame:CGRectMake(270, 25,tmpOpenImg.size.width,tmpOpenImg.size.height)];
        imageIsOpen.image=tmpOpenImg;
        
        UIImage* tmpCardImg;
        if (tempCat.image==[NSNull null])
        {
            tmpCardImg=[UIImage imageNamed:@"general_logo.png"];
        }
        else
        {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://www.can-now.co.il%@",tempCat.image]]];
            tmpCardImg = [UIImage imageWithData: imageData];
        }
        UIImageView *tmpCardImageView=[[UIImageView alloc] initWithFrame:CGRectMake(270-tmpCardImg.size.width, 5,tmpCardImg.size.width,tmpCardImg.size.height)];
        tmpCardImageView.image=tmpCardImg;
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15,120,20 )];
        [titleLabel setText:tempCat.title];
        titleLabel.font=[UIFont fontWithName:@"DevanagariSangamMN-Bold" size:15.0];
        titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [titleLabel setBackgroundColor: [UIColor whiteColor]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setTextAlignment:NSTextAlignmentRight];
        
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 35,150,10 )];
        [addressLabel setText:[NSString stringWithFormat:@"%@,%@",tempCat.city,tempCat.address]];
        addressLabel.font=[UIFont fontWithName:@"DevanagariSangamMN-Bold" size:10.0];
        [addressLabel setBackgroundColor: [UIColor whiteColor]];
        [addressLabel setTextColor:[UIColor blackColor]];
        [addressLabel setTextAlignment:NSTextAlignmentRight];
        
        UILabel *openHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 45,150,10 )];
        if (!([tempCat.timeEnd2 isEqual:[NSNull null]]))
            [openHoursLabel setText:[NSString stringWithFormat:@"זמין עד: %@",tempCat.timeEnd2]];
        else  if (!([tempCat.timeEnd1 isEqual:[NSNull null]]))
            [openHoursLabel setText:[NSString stringWithFormat:@"זמין עד: %@",tempCat.timeEnd1]];
        else
            [openHoursLabel setText:@""];
        
        openHoursLabel.font=[UIFont fontWithName:@"DevanagariSangamMN-Bold" size:10.0];
        [openHoursLabel setBackgroundColor: [UIColor whiteColor]];
        [openHoursLabel setTextColor:[UIColor blackColor]];
        [openHoursLabel setTextAlignment:NSTextAlignmentRight];
        
        
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];;
        [aButton setBackgroundImage:tmpBtnImage forState:UIControlStateNormal];
        
        
        [aButton setTitle:tempCat.title forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        aButton.frame     = CGRectMake(5, 15,tmpBtnImage.size.width,tmpBtnImage.size.height);
        
        [aButton setTag:tempCat.idNumber];
        [aButton addTarget:self action:@selector(openAResult:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [aView addSubview:tmpBorderImgView];
        [aView addSubview:imageIsOpen];
        [aView addSubview:tmpCardImageView];
        [aView addSubview:titleLabel];
        [aView addSubview:addressLabel];
        [aView addSubview:openHoursLabel];
        [aView addSubview:aButton];
        [cell addSubview:aView];
    }
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark Load More Results methods

-(void)loadMoreResults
{
    self.urlOffset=self.urlOffset+20;
    NSString* buildURL;
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied)
        {
            AppDelegate* tmp=[UIApplication sharedApplication].delegate;
            if (tmp.userLocation)
            {
                NSString *lat=[NSString stringWithFormat:@"%f",tmp.userLocation.coordinate.latitude];
                lat = [lat stringByReplacingOccurrencesOfString:@"."
                                                     withString:@"z"];
                NSString *lang=[NSString stringWithFormat:@"%f",tmp.userLocation.coordinate.longitude];
                lang = [lang stringByReplacingOccurrencesOfString:@"."
                                                       withString:@"z"];
                buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d/%d//gps_location/%@,%@",self.idNumberOfCategory,self.urlOffset,lat,lang] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            else
            {
                buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d/%d/",self.idNumberOfCategory,self.urlOffset] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
        else
        {
            buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d/%d/",self.idNumberOfCategory,self.urlOffset] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    else
    {
        buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/cards/%d/%d/",self.idNumberOfCategory,self.urlOffset] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    NSURL *myURL=[NSURL URLWithString:buildURL];
    
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
    NSArray *allCatergories = [NSJSONSerialization JSONObjectWithData:response
                                                              options:0 error:&jsonParsingError];
    [self.cardsArray removeObjectAtIndex:[self.cardsArray count] -1];
    areThereMoreReuslts=NO;
    for (int i=0;i<allCatergories.count;i++)
    {
        NSDictionary *temp=allCatergories[i];
        NSString *name=[temp objectForKey:@"name"];
        if ([name isEqualToString:@"more_results"])
        {
            areThereMoreReuslts=YES;
        }
        else
        {
            CardObject *tempCat=[[CardObject alloc] init];
            tempCat.title=[temp objectForKey:@"name"];
            tempCat.idNumber=[[temp objectForKey:@"id"] intValue];
            tempCat.timeStart1=[temp objectForKey:@"work_time_start_1"];
            tempCat.timeEnd1=[temp objectForKey:@"work_time_end_1"];
            tempCat.timeStart2=[temp objectForKey:@"work_time_start_2"];
            tempCat.timeEnd2=[temp objectForKey:@"work_time_end_2"];
            tempCat.address=[temp objectForKey:@"address"];
            tempCat.city=[temp objectForKey:@"city"];
            tempCat.isOpen=[[temp objectForKey:@"is_available"] boolValue];
            tempCat.image=[temp objectForKey:@"image"];
            [cardsArray addObject:tempCat];
        }
    }
    
    if (areThereMoreReuslts)
    {
        CardObject *tempCat=[[CardObject alloc] init];
        tempCat.title=@"more_results";
        tempCat.idNumber=0;
        tempCat.timeStart1=nil;
        tempCat.timeEnd1=nil;
        tempCat.timeStart2=nil;
        tempCat.timeEnd2=nil;
        tempCat.address=nil;
        tempCat.city=nil;
        tempCat.isOpen=NO;
        tempCat.image=nil;
        [cardsArray addObject:tempCat];
    }
    
    [self.tableFields reloadData];
    
}

-(void)loadMoreResultsForCustomSearch
{
    self.urlOffset=self.urlOffset+20;
    NSRange locationToCut=[self.customSeatchURL rangeOfString:@"/0/"];
    NSString *preOffset=[self.customSeatchURL substringToIndex:locationToCut.location];
    NSString *postOffset=[self.customSeatchURL substringFromIndex:locationToCut.location+3];
    
    NSString* buildURL;
    buildURL=[[[NSString alloc] initWithFormat:@"%@/%d/%@",preOffset,self.urlOffset,postOffset] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *myURL=[NSURL URLWithString:buildURL];
    
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
    NSArray *allCatergories = [NSJSONSerialization JSONObjectWithData:response
                                                              options:0 error:&jsonParsingError];
    
    [self.cardsArray removeObjectAtIndex:[self.cardsArray count] -1];
    areThereMoreReuslts=NO;
    for (int i=0;i<allCatergories.count;i++)
    {
        NSDictionary *temp=allCatergories[i];
        NSString *name=[temp objectForKey:@"name"];
        if ([name isEqualToString:@"more_results"])
        {
            areThereMoreReuslts=YES;
        }
        else
        {
            CardObject *tempCat=[[CardObject alloc] init];
            tempCat.title=[temp objectForKey:@"name"];
            tempCat.idNumber=[[temp objectForKey:@"id"] intValue];
            tempCat.timeStart1=[temp objectForKey:@"work_time_start_1"];
            tempCat.timeEnd1=[temp objectForKey:@"work_time_end_1"];
            tempCat.timeStart2=[temp objectForKey:@"work_time_start_2"];
            tempCat.timeEnd2=[temp objectForKey:@"work_time_end_2"];
            tempCat.address=[temp objectForKey:@"address"];
            tempCat.city=[temp objectForKey:@"city"];
            tempCat.isOpen=[[temp objectForKey:@"is_available"] boolValue];
            tempCat.image=[temp objectForKey:@"image"];
            [cardsArray addObject:tempCat];
        }
    }
    
    if (areThereMoreReuslts)
    {
        CardObject *tempCat=[[CardObject alloc] init];
        tempCat.title=@"more_results";
        tempCat.idNumber=0;
        tempCat.timeStart1=nil;
        tempCat.timeEnd1=nil;
        tempCat.timeStart2=nil;
        tempCat.timeEnd2=nil;
        tempCat.address=nil;
        tempCat.city=nil;
        tempCat.isOpen=NO;
        tempCat.image=nil;
        [cardsArray addObject:tempCat];
    }
    
    [self.tableFields reloadData];
    
}


#pragma mark Load Custom Search methods

-(void)loadResultsCustomSearch
{
    usingCustomSearch=YES;
    self.urlOffset=0;
    NSRange locationToCut=[self.customSeatchURL rangeOfString:@"/0/"];
    NSString *preOffset=[self.customSeatchURL substringToIndex:locationToCut.location];
    NSString *postOffset=[self.customSeatchURL substringFromIndex:locationToCut.location+3];
    
    NSString* buildURL;
    buildURL=[[NSString alloc] initWithFormat:@"%@/%d/%@",preOffset,self.urlOffset,postOffset];
    
    NSURL *myURL=[NSURL URLWithString:buildURL];
    
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
    NSArray *allCatergories = [NSJSONSerialization JSONObjectWithData:response
                                                              options:0 error:&jsonParsingError];
    [self.cardsArray removeAllObjects];
    areThereMoreReuslts=NO;
    for (int i=0;i<allCatergories.count;i++)
    {
        NSDictionary *temp=allCatergories[i];
        NSString *name=[temp objectForKey:@"name"];
        if ([name isEqualToString:@"more_results"])
        {
            areThereMoreReuslts=YES;
        }
        else
        {
            CardObject *tempCat=[[CardObject alloc] init];
            tempCat.title=[temp objectForKey:@"name"];
            tempCat.idNumber=[[temp objectForKey:@"id"] intValue];
            tempCat.timeStart1=[temp objectForKey:@"work_time_start_1"];
            tempCat.timeEnd1=[temp objectForKey:@"work_time_end_1"];
            tempCat.timeStart2=[temp objectForKey:@"work_time_start_2"];
            tempCat.timeEnd2=[temp objectForKey:@"work_time_end_2"];
            tempCat.address=[temp objectForKey:@"address"];
            tempCat.city=[temp objectForKey:@"city"];
            tempCat.isOpen=[[temp objectForKey:@"is_available"] boolValue];
            tempCat.image=[temp objectForKey:@"image"];
            [cardsArray addObject:tempCat];
        }
    }
    
    if (areThereMoreReuslts)
    {
        CardObject *tempCat=[[CardObject alloc] init];
        tempCat.title=@"more_results";
        tempCat.idNumber=0;
        tempCat.timeStart1=nil;
        tempCat.timeEnd1=nil;
        tempCat.timeStart2=nil;
        tempCat.timeEnd2=nil;
        tempCat.address=nil;
        tempCat.city=nil;
        tempCat.isOpen=NO;
        tempCat.image=nil;
        [cardsArray addObject:tempCat];
    }
    
    saveCustomURL=[NSString stringWithString:self.customSeatchURL];
    self.customSeatchURL=saveCustomURL;
    [self.tableFields reloadData];
    
}


#pragma mark Open A Result method

-(void) openAResult:(id)sender {
    BusinessCardViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"BusinessCardViewController"];
    UIButton* tempButton=(UIButton*)sender;
    NSString* tmp=[[NSString alloc] initWithString:tempButton.titleLabel.text];
    subField.titleToSet=tmp;
    subField.idNumberOfCard=tempButton.tag;
    subField.usingCustomSearch=NO;
    subField.prevPath=pathLabel.text;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:subField animated:NO];
}

@end