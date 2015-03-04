//
//  BusinessCardViewController.m
//  CanNow
//
//  Created by David Schechter on 1/20/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import "BusinessCardViewController.h"
//#import "UIView+AUISelectiveBorder.h"
#import "LocalizedCurrentLocation.h"
#import "CategoryObject.h"
#import "ResultsPageViewController.h"

@interface BusinessCardViewController ()

@end

@implementation BusinessCardViewController

@synthesize backButton,menuButton,navBarTitle,titleToSet,idNumberOfCard,cardInfo,viewSection1,businessImage,titleRow,streetRow,cityRow,webSiteButton,viewSection2,dayRow,dateRow,hoursRow,hoursRow2,isOpenImage,viewSection3,callToButton,viewSection4,textToButton,viewSection5,showOnMapButton,viewSection6,navToButton,viewSection7,showPhotosButton,viewSection8,showVideoButton,moreInfoButton,viewsContainer,prevPath;


#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.idNumberStrightToCards=0;
    self.backStrightToRootView=FALSE;
    
    self.navBarTitle.title = self.titleToSet;
    
    NSString *rightArrow=@"\u2190";
    if (prevPath.length!=0)
        pathLabel.text=[NSString stringWithFormat:@"%@ %@ %@",prevPath,rightArrow,self.titleToSet];
    
    [spinner startAnimating];
    spinner.hidden=NO;
    self.viewsContainer.hidden=YES;
    
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
        buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/card/%d/",self.idNumberOfCard] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    NSDictionary *cardInfoData;
    if (self.usingCustomSearch)
    {
        NSArray *arrayData = [NSJSONSerialization JSONObjectWithData:response
                                                             options:0 error:&jsonParsingError];
        cardInfoData=[arrayData objectAtIndex:0];
    }
    else
    {
        cardInfoData = [NSJSONSerialization JSONObjectWithData:response
                                                       options:0 error:&jsonParsingError];
    }
    
    cardInfo=[[CardObject alloc] init];
    cardInfo.title=[cardInfoData objectForKey:@"name"];
    cardInfo.idNumber=[[cardInfoData objectForKey:@"id"] intValue];
    cardInfo.timeStart1=[cardInfoData objectForKey:@"work_time_start_1"];
    cardInfo.timeEnd1=[cardInfoData objectForKey:@"work_time_end_1"];
    cardInfo.timeStart2=[cardInfoData objectForKey:@"work_time_start_2"];
    cardInfo.timeEnd2=[cardInfoData objectForKey:@"work_time_end_2"];
    cardInfo.address=[cardInfoData objectForKey:@"address"];
    cardInfo.location=[cardInfoData objectForKey:@"location"];
    cardInfo.city=[cardInfoData objectForKey:@"city"];
    cardInfo.isOpen=[[cardInfoData objectForKey:@"is_available"] boolValue];
    cardInfo.image=[cardInfoData objectForKey:@"image"];
    cardInfo.website=[cardInfoData objectForKey:@"website"];
    if (cardInfo.website==[NSNull null])
    {
        [self.textToButton setBackgroundImage:[UIImage imageNamed:@"home_disabled.png"] forState:UIControlStateDisabled];
        self.textToButton.enabled=NO;
    }
    cardInfo.sms=[cardInfoData objectForKey:@"sms"];
    if (cardInfo.sms==[NSNull null])
    {
        [self.textToButton setBackgroundImage:[UIImage imageNamed:@"sms_disabled.png"] forState:UIControlStateDisabled];
        self.textToButton.enabled=NO;
    }
    cardInfo.phone=[cardInfoData objectForKey:@"phone"];
    if (cardInfo.phone==[NSNull null])
    {
        [self.callToButton setBackgroundImage:[UIImage imageNamed:@"phone_disabled.png"] forState:UIControlStateDisabled];
        self.callToButton.enabled=NO;
    }
    if (cardInfo.location==[NSNull null])
    {
        [self.navToButton setBackgroundImage:[UIImage imageNamed:@"map_disabled.png"] forState:UIControlStateDisabled];
        [self.showOnMapButton setBackgroundImage:[UIImage imageNamed:@"route_disabled.png"] forState:UIControlStateDisabled];
        self.showOnMapButton.enabled=NO;
        self.navToButton.enabled=NO;
    }
    if ((cardInfo.timeStart1==[NSNull null]) && (cardInfo.timeEnd1==[NSNull null]) && (cardInfo.timeStart2==[NSNull null]) && (cardInfo.timeEnd2==[NSNull null]))
    {
        timeClockImage.image=[UIImage imageNamed:@"clock_disabled.png"];
    }

    cardInfo.facebook=[cardInfoData objectForKey:@"facebook"];
    cardInfo.youtube=[cardInfoData objectForKey:@"youtube"];
    cardInfo.gallery=[cardInfoData objectForKey:@"gallery"];
    if ((cardInfo.image==[NSNull null]) || (cardInfo.gallery==[NSNull null]))
    {
        [self.showPhotosButton setBackgroundImage:[UIImage imageNamed:@"photo_disabled.png"] forState:UIControlStateDisabled];
        self.showPhotosButton.enabled=NO;
    }
    if (cardInfo.youtube==[NSNull null])
    {
        [self.showVideoButton setBackgroundImage:[UIImage imageNamed:@"photo_disabled.png"] forState:UIControlStateDisabled];
        self.showVideoButton.enabled=NO;
    }
    cardInfo.descriptionStr=[cardInfoData objectForKey:@"description"];
    
    if (prevPath.length==0)
    {
        NSString *tmpPath=[cardInfoData objectForKey:@"category"];
        NSArray *tmpPathArr=[tmpPath componentsSeparatedByString:@";"];
        NSString *rightArrow=@"\u2190";
        NSString* buildPath=@"ראשי";
        for (int i=0;i<[tmpPathArr count];i++)
        {
            if (i+1==[tmpPathArr count])
                buildPath=[NSString stringWithFormat:@"%@ %@ %@",buildPath,rightArrow,self.titleToSet];
            else
                buildPath=[NSString stringWithFormat:@"%@ %@ %@",buildPath,rightArrow,tmpPathArr[i]];
        }
        pathLabel.text=buildPath;
    }
    
    //ranking
    int ranking=[[cardInfoData objectForKey:@"ranking"] intValue];
    switch (ranking) {
        case 0:
        {
            badStar1.hidden=NO;
            badStar2.hidden=NO;
            badStar3.hidden=NO;
            badStar4.hidden=NO;
            badStar5.hidden=NO;
        }
        case 1:
        {
            goodStar1.hidden=NO;
            badStar2.hidden=NO;
            badStar3.hidden=NO;
            badStar4.hidden=NO;
            badStar5.hidden=NO;
        }
        case 2:
        {
            goodStar1.hidden=NO;
            goodStar2.hidden=NO;
            badStar3.hidden=NO;
            badStar4.hidden=NO;
            badStar5.hidden=NO;
        }
        case 3:
        {
            goodStar1.hidden=NO;
            goodStar2.hidden=NO;
            goodStar3.hidden=NO;
            badStar4.hidden=NO;
            badStar5.hidden=NO;
        }
        case 4:
        {
            goodStar1.hidden=NO;
            goodStar2.hidden=NO;
            goodStar3.hidden=NO;
            goodStar4.hidden=NO;
            badStar5.hidden=NO;
        }
        case 5:
        {
            goodStar1.hidden=NO;
            goodStar2.hidden=NO;
            goodStar3.hidden=NO;
            goodStar4.hidden=NO;
            goodStar5.hidden=NO;
        }
            break;
            
        default:
            break;
    }
    int rankByHowMany=[[cardInfoData objectForKey:@"feedback"] intValue];
    rankingLabel.text=[NSString stringWithFormat:@"(%d)",rankByHowMany];
    
    if (!(cardInfo.title==NULL))
    {
        titleRow.text=cardInfo.title;
        [titleRow setFont:[UIFont fontWithName:@"DevanagariSangamMN-Bold" size:12.0]];
        [titleRow setTextAlignment:NSTextAlignmentRight];
    }
    else
        titleRow.text=@"";
    if (!(cardInfo.address==NULL))
    {
        streetRow.text=cardInfo.address;
        [streetRow setFont:[UIFont fontWithName:@"DevanagariSangamMN" size:10.0]];
        [streetRow setTextAlignment:NSTextAlignmentRight];
    }
    else
        streetRow.text=@"";
    if (!(cardInfo.city==NULL))
    {
        cityRow.text=cardInfo.city;
        [cityRow setFont:[UIFont fontWithName:@"DevanagariSangamMN" size:10.0]];
        [cityRow setTextAlignment:NSTextAlignmentRight];
    }
    else
        cityRow.text=@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"he"];
    [dateFormatter setDateFormat:@"EEEE"];
    dayRow.text=[dateFormatter stringFromDate:[NSDate date]];
    
    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:units fromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"MMMM"];
    dateRow.text=[NSString stringWithFormat:@"%d ב%@", [components day],[dateFormatter stringFromDate:[NSDate date]]];
    if ((!(cardInfo.timeStart1==[NSNull null])) && (!(cardInfo.timeEnd1==[NSNull null])))
    {
        if ((!(cardInfo.timeStart2==[NSNull null])) && (!(cardInfo.timeEnd2==[NSNull null])))
        {
            hoursRow2.text=[NSString stringWithFormat:@"%@ - %@",cardInfo.timeStart2,cardInfo.timeEnd2];
            hoursRow.text=[NSString stringWithFormat:@"%@ - %@",cardInfo.timeStart1,cardInfo.timeEnd1];
        }
        else
        {
            hoursRow.text=[NSString stringWithFormat:@"%@ - %@",cardInfo.timeStart1,cardInfo.timeEnd1];
            hoursRow2.text=@"";
        }
    }
    else if ((!(cardInfo.timeStart2==[NSNull null])) && (!(cardInfo.timeEnd2==[NSNull null])))
    {
        hoursRow.text=[NSString stringWithFormat:@"%@ - %@",cardInfo.timeStart2,cardInfo.timeEnd2];
        hoursRow2.text=@"";
    }
    else
    {
        hoursRow.text=@"";
        hoursRow2.text=@"";
    }
    if (!(cardInfo.city==NULL))
    {
        cityRow.text=cardInfo.city;
        [cityRow setFont:[UIFont fontWithName:@"DevanagariSangamMN" size:10.0]];
        [cityRow setTextAlignment:NSTextAlignmentRight];
    }
    else
        cityRow.text=@"";
    if (cardInfo.isOpen)
        isOpenImage.image=[UIImage imageNamed:@"active.png"];
    else
        isOpenImage.image=[UIImage imageNamed:@"inactive.png"];
    
    self.descriptionView.text=cardInfo.descriptionStr;
    [self.descriptionView setTextAlignment:NSTextAlignmentRight];
    
    self.viewsContainer.hidden=NO;
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


#pragma mark Call To Method

- (IBAction)callTo:(UIButton *)sender{
    NSString *strURL=[[[NSString alloc] initWithFormat:@"telprompt://%@",cardInfo.phone] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *tempUrl = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:tempUrl];
}

#pragma mark Send SMS To Method

- (IBAction)smsTo:(UIButton *)sender{
    NSString *strURL=[[[NSString alloc] initWithFormat:@"sms://%@",cardInfo.sms] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *tempUrl = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:tempUrl];
}


#pragma mark Open in Map Method

- (IBAction)openMaps:(UIButton *)sender{
    
    float lat=[[cardInfo.location objectForKey:@"latitude"] floatValue];
    float lang=[[cardInfo.location objectForKey:@"longitude"] floatValue];
    NSString *strURL=[[[NSString alloc] initWithFormat:@"http://maps.apple.com/?q=%f,%f",lat,lang] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *tempUrl = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:tempUrl];
}

#pragma mark Navigate To Method

- (IBAction)navigateTo:(UIButton *)sender{
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied)
        {
            AppDelegate* tmp=[UIApplication sharedApplication].delegate;
            if (tmp.userLocation)
            {
    
                NSMutableString *wazeAppURL = [NSMutableString stringWithString:@"waze://"];
                float lat=[[cardInfo.location objectForKey:@"latitude"] floatValue];
                float lang=[[cardInfo.location objectForKey:@"longitude"] floatValue];
                BOOL canOpenWaze=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:wazeAppURL]];
                if (canOpenWaze)
                {
                    [wazeAppURL appendFormat:@"?ll=%f,%f&navigate=yes",lat,lang];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:wazeAppURL]];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"אפליקצית Waze לא מותקנת" message:@"יש להתקין Waze על מנת לנווט לבית העסק״" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
                    [self.view addSubview:alert];
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"אין נתוני מיקום" message:@"יש לאפשר גישה לנתוני מיקום עבור אפליקציה" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
                [self.view addSubview:alert];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"אין נתוני מיקום" message:@"יש לאפשר גישה לנתוני מיקום עבור אפליקציה" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
            [self.view addSubview:alert];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"אין נתוני מיקום" message:@"יש לאפשר גישה לנתוני מיקום עבור אפליקציה" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
        [self.view addSubview:alert];
        [alert show];
    }
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