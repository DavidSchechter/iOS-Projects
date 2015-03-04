//
//  ViewController.m
//  CanNow
//
//  Created by David Schechter on 12/22/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//

#import "ViewController.h"
#import "SubFieldSearchViewController.h"
//#import "UIView+AUISelectiveBorder.h"
#import "ResultsPageViewController.h"
#import "ChangeSearchViewController.h"
#import "BusinessCardViewController.h"
#import "CategoryObject.h"
#import "AddBusinessViewController.h"
#import "AppDelegate.h"
#import "UIViewController+MJPopupViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize addBusiness,searchView,dropDownMenu,whoIsAvailble,appSymbol,searchBar,searchButton,swapButton,scrollingViewArea,businessTypesTitles,businessNames;

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    CGRect frame = self.searchBar.frame;
    frame.size.height = self.searchBar.attributedPlaceholder.size.height;
    frame.size.width = self.searchBar.attributedPlaceholder.size.width;
    self.searchBar.frame = frame;
    self.searchBar.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    self.searchBar.rightViewMode = UITextFieldViewModeAlways;
    self.searchBar.delegate = self;
    if (popOverMenu==nil)
    {
        popOverMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOverMenuViewContoller"];
        popOverMenu.view.frame=CGRectMake(80, 170, 160, 140);
        popOverMenu.containingViewController=self;
    }
    byTypeSearch=TRUE;
    byNameSearch=FALSE;
    isLastSearchForCards=NO;
    isLastSearchForCategory=NO;
    isLastSearchForCategoryByBusiness=NO;
    isLastSearchForCategoryByCards=NO;
    
    [spinner startAnimating];
    spinner.hidden=NO;
    
    [self performSelector:@selector(loadInitalData) withObject:nil afterDelay:0.1];
    
}

-(void)loadInitalData
{
    NSURL *myURL=[[NSURL alloc] initWithString:@"http://www.can-now.co.il/api/pages/"];
    
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
    businessTypesTitles=[[NSMutableArray alloc] init];
    for (int i=0;i<arrayOfName.count;i++)
    {
        NSDictionary *temp=arrayOfName[i];
        CategoryObject *tempCat=[[CategoryObject alloc] init];
        tempCat.title=[temp objectForKey:@"name"];
        tempCat.idNumber=[[temp objectForKey:@"id"] intValue];
        [businessTypesTitles addObject:tempCat];
    }
    
    
    myURL=[[NSURL alloc] initWithString:@"http://www.can-now.co.il/api/searchdata/categories"];
    
    myRequest = [NSURLRequest requestWithURL:myURL];
    
    error = nil;
    responseCode = nil;
    
    response = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&responseCode error:&error];
    
    if (error==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"שגיאה" message:@"קרתה שגיאה בגישה לנתונים. אנא נסה שנית מאחור יותר" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
        [self.view addSubview:alert];
        [alert show];
    }
    
    jsonParsingError = nil;
    arrayOfName = [NSJSONSerialization JSONObjectWithData:response
                                                  options:0 error:&jsonParsingError];
    autocompleteCategories=[[NSMutableArray alloc] init];
    for (int i=0;i<arrayOfName.count;i++)
    {
        NSDictionary *temp=arrayOfName[i];
        [autocompleteCategories addObject:temp];
    }
    
    if (autocompleteBusiness==nil)
        autocompleteBusiness=[NSArray arrayWithArray:autocompleteCategories];
    
    myURL=[[NSURL alloc] initWithString:@"http://www.can-now.co.il/api/promotiondata"];
    
    myRequest = [NSURLRequest requestWithURL:myURL];
    
    error = nil;
    responseCode = nil;
    
    response = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&responseCode error:&error];
    
    if (error==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"שגיאה" message:@"קרתה שגיאה בגישה לנתונים. אנא נסה שנית מאחור יותר" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
        [self.view addSubview:alert];
        [alert show];
    }
    
    jsonParsingError = nil;
    arrayOfName = [NSJSONSerialization JSONObjectWithData:response
                                                  options:0 error:&jsonParsingError];
    promotionDataArray=[[NSMutableArray alloc] init];
    for (int i=0;i<arrayOfName.count;i++)
    {
        NSDictionary *temp=arrayOfName[i];
        [promotionDataArray addObject:temp];
    }
    
    autocompleteUrls = [[NSMutableArray alloc] init];
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(65, 141, 190, 120) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    autocompleteTableView.separatorInset=UIEdgeInsetsZero;
    [self.view addSubview:autocompleteTableView];
    
    [self createBusinessCategoriesScrollView];
    
    [spinner stopAnimating];
    spinner.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    if (scrollView.contentOffset.x < 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}

#pragma mark Change Scroll Views

- (IBAction)swapButtonClicked:(UIButton *)sender{
    if (byTypeSearch==TRUE)
    {
        self.searchBar.placeholder=@"הקלד שם של בית עסק";
        byNameSearch=TRUE;
        byTypeSearch=FALSE;
        self.scrollingViewArea.hidden=YES;
        [spinner startAnimating];
        spinner.hidden=NO;
        
        [self performSelector:@selector(changeToNames) withObject:nil afterDelay:0.1];
    }
    else
    {
        self.searchBar.placeholder=@"הקלד תחום של בתי עסק";
        byNameSearch=FALSE;
        byTypeSearch=TRUE;
        self.scrollingViewArea.hidden=YES;
        [spinner startAnimating];
        spinner.hidden=NO;
        
        [self performSelector:@selector(changeToBusiness) withObject:nil afterDelay:0.1];
    }
        
}

-(void)changeToNames
{
    for(UIView *subview in [self.scrollingViewArea subviews]) {
        [subview removeFromSuperview];
    }
    
    if (autocompleteCards==nil)
    {
    NSURL *myURL=[[NSURL alloc] initWithString:@"http://www.can-now.co.il/api/searchdata/cards"];
    
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
    autocompleteCategories=[[NSMutableArray alloc] init];
    for (int i=0;i<arrayOfName.count;i++)
    {
        NSDictionary *temp=arrayOfName[i];
        [autocompleteCategories addObject:temp];
    }
    autocompleteCards=[NSArray arrayWithArray:autocompleteCategories];
    }
    else
    {
        autocompleteCategories=[NSMutableArray arrayWithArray:autocompleteCards];
    }
    
    
    [self createBusinessNamesScrollView];
    
    [spinner stopAnimating];
    spinner.hidden = YES;
    self.scrollingViewArea.hidden=NO;
    
}

-(void)changeToBusiness
{
    for(UIView *subview in [self.scrollingViewArea subviews]) {
        [subview removeFromSuperview];
    }
    
    if (autocompleteBusiness==nil)
    {
        NSURL *myURL=[[NSURL alloc] initWithString:@"http://www.can-now.co.il/api/searchdata/categories"];
        
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
        autocompleteCategories=[[NSMutableArray alloc] init];
        for (int i=0;i<arrayOfName.count;i++)
        {
            NSDictionary *temp=arrayOfName[i];
            [autocompleteCategories addObject:temp];
        }
        autocompleteBusiness=[NSArray arrayWithArray:autocompleteCategories];
    }
    else
    {
        autocompleteCategories=[NSMutableArray arrayWithArray:autocompleteBusiness];
    }
    [self createBusinessCategoriesScrollView];
    
    [spinner stopAnimating];
    spinner.hidden = YES;
    self.scrollingViewArea.hidden=NO;
}


#pragma mark Search Button Method

-(IBAction)searchButtonClicked:(id)sender
{
    if (self.searchBar.text.length!=0)
    {
        if (byTypeSearch==TRUE)
        {
            NSData *plainData = [self.searchBar.text dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64String = [plainData base64EncodedStringWithOptions:0];
            lastSearchTitle=self.searchBar.text;
            isLastSearchForCategory=YES;
            isLastSearchForCategoryByBusiness=YES;
            [popOverMenu.oldSearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            popOverMenu.oldSearchButton.enabled=YES;
            NSString *urlToSend=[NSString stringWithFormat:@"http://www.can-now.co.il/api/searchcategory/%@",base64String];
            SubFieldSearchViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"SubFieldSearchViewController"];
            NSString* tmp=[[NSString alloc] initWithString:self.searchBar.text];
            subField.titleToSet=tmp;
            subField.customSeatchURL=urlToSend;
            subField.usingCustomSearch=YES;
            searchBar.text=@"";
            autocompleteTableView.hidden=YES;
            [searchBar resignFirstResponder];
            CATransition* transition = [CATransition animation];
            transition.duration = 0.40;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromLeft;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [self.navigationController pushViewController:subField animated:NO];
        }
        else
        {
            
            NSData *plainData = [self.searchBar.text dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64String = [plainData base64EncodedStringWithOptions:0];
            lastSearchTitle=self.searchBar.text;
            isLastSearchForCategory=YES;
            isLastSearchForCategoryByCards=YES;
            popOverMenu.oldSearchButton.titleLabel.textColor=[UIColor blackColor];
            popOverMenu.oldSearchButton.enabled=YES;
            NSString *urlToSend;
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
                        urlToSend=[NSString stringWithFormat:@"http://www.can-now.co.il/api/searchcard/%@/gps_location/%@,%@",base64String,lat,lang];
                    }
                    else
                    {
                        urlToSend=[NSString stringWithFormat:@"http://www.can-now.co.il/api/searchcard/%@",base64String];
                    }
                }
                else
                {
                     urlToSend=[NSString stringWithFormat:@"http://www.can-now.co.il/api/searchcard/%@",base64String];
                }
            }
            else
            {
                 urlToSend=[NSString stringWithFormat:@"http://www.can-now.co.il/api/searchcard/%@",base64String];
            }
            
            ResultsPageViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsPageViewController"];
            NSString* tmp=[[NSString alloc] initWithString:self.searchBar.text];
            subField.titleToSet=tmp;
            subField.customSeatchURL=urlToSend;
            subField.usingCustomSearch=YES;
            subField.prevPath=@"ראשי";
            searchBar.text=@"";
            autocompleteTableView.hidden=YES;
            [searchBar resignFirstResponder];
            CATransition* transition = [CATransition animation];
            transition.duration = 0.40;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromLeft;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [self.navigationController pushViewController:subField animated:NO];
        }
        
    }
}


#pragma mark Business Categories ScrollView and Methods

-(void) createBusinessCategoriesScrollView
{
    UIScrollView *myScroll = [[UIScrollView alloc] init];
    myScroll.frame = self.scrollingViewArea.bounds; //scroll view occupies full parent view!
    
    myScroll.backgroundColor = [UIColor whiteColor];
    
    myScroll.showsVerticalScrollIndicator = YES;    // to hide scroll indicators!
    
    myScroll.showsHorizontalScrollIndicator = NO; //by default, it shows!
    
    myScroll.scrollEnabled = YES;                 //say "NO" to disable scroll
    
    
    int xCoord=myScroll.frame.size.width/2;
    int yCoord=0;
    int buffer = 5;
    for (int i = 0; i < businessTypesTitles.count; i++)
    {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CategoryObject *tempCat=businessTypesTitles[i];
        [aButton setTitle:tempCat.title forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [aButton setBackgroundColor: [UIColor whiteColor]];
        [aButton addTarget:self action:@selector(openBusinessCategory:) forControlEvents:UIControlEventTouchUpInside];
        [aButton setTag:tempCat.idNumber];
        UIImage *tmpImg=[UIImage imageNamed:[NSString stringWithFormat:@"app_10_tableImage_%d",i]];
        [aButton setBackgroundImage:tmpImg forState:UIControlStateNormal];
        aButton.frame=CGRectMake(xCoord, yCoord, tmpImg.size.width, tmpImg.size.height);
        
        [myScroll addSubview:aButton];
        if (xCoord==(myScroll.frame.size.width/2))
        {
            xCoord=5;
        }
        else{
            if (i+1!=[businessTypesTitles count])
                xCoord=myScroll.frame.size.width/2;
            yCoord += tmpImg.size.height + buffer;
        }
        
        if (i+1==[businessTypesTitles count])
        {
            UIButton *tmpImageView=[[UIButton alloc] initWithFrame:CGRectMake(xCoord, yCoord, 300, 70)];
            AppDelegate* tmp=(AppDelegate*)[UIApplication sharedApplication].delegate;
            NSDictionary *tmpdic=[tmp.bannerImagesArray objectAtIndex:0];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://www.can-now.co.il%@",[tmpdic objectForKey:@"image"]]]];
            bannerURL=[tmpdic objectForKey:@"link"];
            UIImage *bannerMOneImage = [UIImage imageWithData: imageData];
            [tmpImageView setBackgroundImage:bannerMOneImage forState:UIControlStateNormal];
            [tmpImageView addTarget:self action:@selector(openBanner) forControlEvents:UIControlEventTouchUpInside];
            yCoord += 80;
            [myScroll addSubview:tmpImageView];
        }
        
    }
    if ([[UIScreen mainScreen] bounds].size.height>480)
    {
        [myScroll setContentSize:CGSizeMake(320, yCoord+10)];
    }
    else
    {
        [myScroll setContentSize:CGSizeMake(320, yCoord+85)];
    }
    myScroll.delegate = self;
    [myScroll setShowsHorizontalScrollIndicator:NO];
    
    [self.scrollingViewArea addSubview:myScroll];               //adding to parent view!
}

-(void) openBusinessCategory:(id)sender {
    SubFieldSearchViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"SubFieldSearchViewController"];
    UIButton* tempButton=(UIButton*)sender;
    NSString* tmp=[[NSString alloc] initWithString:tempButton.titleLabel.text];
    subField.titleToSet=tmp;
    subField.idNumberOfCategory=tempButton.tag;
    subField.usingCustomSearch=NO;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:subField animated:NO];
}

-(void)openBanner
{
    NSURL *url = [ [ NSURL alloc ] initWithString: bannerURL ];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark Business Names ScrollView and Methods

-(void) createBusinessNamesScrollView
{
    UIScrollView *myScroll = [[UIScrollView alloc] init];
    myScroll.frame = self.scrollingViewArea.bounds; //scroll view occupies full parent view!
    
    myScroll.backgroundColor = [UIColor whiteColor];
    
    myScroll.showsVerticalScrollIndicator = YES;    // to hide scroll indicators!
    
    myScroll.showsHorizontalScrollIndicator = NO; //by default, it shows!
    
    myScroll.scrollEnabled = YES;                 //say "NO" to disable scroll
    
    
    int xCoord=myScroll.frame.size.width/2;
    int yCoord=0;
    int buffer = 5;
    int len=[promotionDataArray count]+1;
    if (len%2!=0)
        len++;
    for (int i = 0; i < [promotionDataArray count]; i++)
    {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *tempDic=promotionDataArray[i];
        [aButton setTitle:[tempDic objectForKey:@"name"] forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [aButton setBackgroundColor: [UIColor whiteColor]];
        [aButton addTarget:self action:@selector(openSpecificBusiness:) forControlEvents:UIControlEventTouchUpInside];
        [aButton setTag:[[tempDic objectForKey:@"userid"] intValue] + 0x40000000];
        UIImage *tmpImg=[UIImage imageNamed:@"border.png"];
        [aButton setBackgroundImage:tmpImg forState:UIControlStateNormal];
        aButton.frame=CGRectMake(xCoord, yCoord, tmpImg.size.width, tmpImg.size.height);
        
        
        NSData * imageData2 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://www.can-now.co.il%@",[tempDic objectForKey:@"logo"]]]];
        UIImage *buttonLogoImage = [UIImage imageWithData: imageData2];
        UIImageView *buttonLogoImageView=[[UIImageView alloc] initWithImage:buttonLogoImage];
        buttonLogoImageView.frame=CGRectMake(10, 10, aButton.frame.size.width-20, aButton.frame.size.height-20);

        [aButton addSubview:buttonLogoImageView];
        
        [myScroll addSubview:aButton];
        if (xCoord==(myScroll.frame.size.width/2))
        {
            xCoord=5;
        }
        else{
            xCoord=myScroll.frame.size.width/2;
            yCoord += aButton.frame.size.height + buffer;
        }
        if (i+1==[promotionDataArray count])
        {
            if ((i+1)%2!=0)
            {
                UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [aButton setTitle:@"" forState:UIControlStateNormal];
                [aButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [aButton setBackgroundColor: [UIColor whiteColor]];
                UIImage *tmpImg=[UIImage imageNamed:@"border.png"];
                [aButton setBackgroundImage:tmpImg forState:UIControlStateNormal];
                aButton.frame=CGRectMake(xCoord, yCoord, tmpImg.size.width, tmpImg.size.height);
                [myScroll addSubview:aButton];
            }
        }
        
    }
    if ([[UIScreen mainScreen] bounds].size.height>480)
    {
        [myScroll setContentSize:CGSizeMake(320, yCoord+10)];
    }
    else
    {
        [myScroll setContentSize:CGSizeMake(320, yCoord+100)];
    }
    myScroll.delegate = self;
    [myScroll setShowsHorizontalScrollIndicator:NO];
    
    [self.scrollingViewArea addSubview:myScroll];               //adding to parent view!
}

-(void) openSpecificBusiness:(id)sender {
    ResultsPageViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsPageViewController"];
    UIButton* tempButton=(UIButton*)sender;
    NSString* tmp=[[NSString alloc] initWithString:tempButton.titleLabel.text];
    subField.titleToSet=tmp;
    subField.idNumberOfCategory=tempButton.tag;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:subField animated:NO];
}

- (IBAction)addBusinessButtonClicked:(id)sender
{
    AddBusinessViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBusinessViewController"];
    [self.navigationController presentViewController:subField animated:YES completion:nil];

}


#pragma mark Popover Methods

- (IBAction)showPopover:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self presentPopupViewController:popOverMenu animationType:0];
}

-(void)doLastSearch
{
    if (isLastSearchForCategory)
    {
        if (isLastSearchForCategoryByBusiness)
            byTypeSearch=YES;
        else if (isLastSearchForCategoryByCards)
            byNameSearch=YES;
        self.searchBar.text=lastSearchTitle;
        [self searchButtonClicked:nil];
    }
    else if (isLastSearchForCards)
    {
        BusinessCardViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"BusinessCardViewController"];
        subField.titleToSet=lastSearchTitle;
        subField.idNumberOfCard=lastSearchID;
        isLastSearchForCards=YES;
        [popOverMenu.oldSearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        popOverMenu.oldSearchButton.enabled=YES;
        CATransition* transition = [CATransition animation];
        transition.duration = 0.40;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:subField animated:NO];
    }
}

#pragma mark DropDown Methods

- (IBAction)dropDownMenuClicked:(UIButton *)sender{
    [self showPopover:sender];
}





#pragma mark UITextFieldDelegate methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchBar isFirstResponder] && [touch view] != self.searchBar) {
        [self.searchBar resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    autocompleteTableView.hidden = YES;
    [self.searchBar resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    autocompleteTableView.hidden = YES;
}


#pragma mark Autocomplete methods

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompleteUrls removeAllObjects];
    for(NSDictionary *tmpDic in autocompleteCategories) {
        NSString *curString=[tmpDic objectForKey:@"name"];
        NSRange substringRange = [curString rangeOfString:substring options:NSCaseInsensitiveSearch];
        if (substringRange.length != 0) {
            [autocompleteUrls addObject:tmpDic];
        }
    }
    [autocompleteTableView reloadData];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    if (substring.length==0)
        autocompleteTableView.hidden = YES;
    else
        autocompleteTableView.hidden = NO;
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocompleteUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 160, 150);
    }
    
    cell.textLabel.text = [[autocompleteUrls objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.textLabel setTextAlignment:NSTextAlignmentRight];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (byTypeSearch==TRUE)
    {
        searchBar.text=selectedCell.textLabel.text;
        [searchBar resignFirstResponder];
        autocompleteTableView.hidden=YES;
    }
    else if (byNameSearch==TRUE)
    {
        NSString *categoryID=[[autocompleteUrls objectAtIndex:indexPath.row] objectForKey:@"id"];
        NSString *categoryName=[[autocompleteUrls objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        searchBar.text=@"";
        autocompleteTableView.hidden=YES;
        [searchBar resignFirstResponder];
        
        BusinessCardViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"BusinessCardViewController"];
        NSString* tmp=[[NSString alloc] initWithString:categoryName];
        subField.titleToSet=tmp;
        subField.idNumberOfCard=[categoryID intValue];
        lastSearchID=[categoryID intValue];;
        lastSearchTitle=tmp;
        isLastSearchForCards=YES;
        [popOverMenu.oldSearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        popOverMenu.oldSearchButton.enabled=YES;
        CATransition* transition = [CATransition animation];
        transition.duration = 0.40;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:subField animated:NO];
    }
    
}


@end
