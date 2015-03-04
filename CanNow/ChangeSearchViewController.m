//
//  ChangeSearchViewController.m
//  CanNow
//
//  Created by David Schechter on 1/19/14.
//  Copyright (c) 2014 David Schechter. All rights reserved.
//

#import "ChangeSearchViewController.h"
#import "CategoryObject.h"
#import "ResultsPageViewController.h"

@interface ChangeSearchViewController ()

@end

@implementation ChangeSearchViewController

@synthesize backButton,menuButton,radioButton1,radioButton2,radioButton3,differentDate,differentCity,differentArea,updateSearch,typesOfFields,titleToSet,urlToChange,pageToChange,openWithArea,openWithDate;


#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.idNumberStrightToCards=0;
    self.backStrightToRootView=FALSE;
    
    self.differentDate.enabled=FALSE;
    self.differentCity.enabled=FALSE;
    self.differentArea.enabled=FALSE;
    [self.radioButton1 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    [self.radioButton2 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    [self.radioButton3 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    
    [spinner startAnimating];
    spinner.hidden=NO;
    self.containerScrollView.hidden=YES;
    
    [self performSelector:@selector(loadInitalData) withObject:nil afterDelay:0.1];
}


-(void)loadInitalData
{
    NSDate *today=[NSDate date];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSDateComponents *comppnents=[cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:today];
    int weekday=[comppnents weekday];
    NSString *todayByName=@"";
    switch (weekday) {
        case 1:
            todayByName=@"יום ראשון";
            break;
        case 2:
            todayByName=@"יום שני";
            break;
        case 3:
            todayByName=@"יום שלישי";
            break;
        case 4:
            todayByName=@"יום רביעי";
            break;
        case 5:
            todayByName=@"יום חמישי";
            break;
        case 6:
            todayByName=@"יום שישי";
            break;
        case 7:
            todayByName=@"יום שבת";
            break;
            
        default:
            break;
    }
    NSString *numberOfDay=[NSString stringWithFormat:@"%d",[comppnents day]];
    int month=[comppnents month];
    NSString *monthByName=@"";
    switch (month) {
        case 1:
            monthByName=@"לינואר";
            break;
        case 2:
            monthByName=@"לפברואר";
            break;
        case 3:
            monthByName=@"למרץ";
            break;
        case 4:
            monthByName=@"לאפריל";
            break;
        case 5:
            monthByName=@"למאי";
            break;
        case 6:
            monthByName=@"ליוני";
            break;
        case 7:
            monthByName=@"ליולי";
            break;
        case 8:
            monthByName=@"לאוגוסט";
            break;
        case 9:
            monthByName=@"לספטמבר";
            break;
        case 10:
            monthByName=@"לאוקטובר";
            break;
        case 11:
            monthByName=@"לנובמבר";
            break;
        case 12:
            monthByName=@"לצדמבר";
            break;
            
        default:
            break;
    }
    NSString *numberOfYear=[NSString stringWithFormat:@"%d",[comppnents year]];
    
    //http://www.can-now.co.il/api/geolocate/0/gps_location/LATITUDE,LONGITUDE
    
    NSString* currectCity=@"";
    
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
                
                NSURL *myURL=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.can-now.co.il/api/geolocate/0/gps_location/%@,%@",lat,lang]];
                
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
                NSDictionary *dicOfLocation = [NSJSONSerialization JSONObjectWithData:response
                                                                              options:0 error:&jsonParsingError];
                currectCity=[dicOfLocation objectForKey:@"city"];
            }
        }
    }
    
    dateAndCityLabel.text=[NSString stringWithFormat:@"%@, %@ %@ %@   %@",todayByName,numberOfDay,monthByName,numberOfYear,currectCity];
    
    AppDelegate* tmp=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSDictionary *tmpdic=[tmp.bannerImagesArray objectAtIndex:2];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://www.can-now.co.il%@",[tmpdic objectForKey:@"image"]]]];
    bannerURL=[tmpdic objectForKey:@"link"];
    UIImage *bannerMOneImage = [UIImage imageWithData: imageData];
    [self.banner setBackgroundImage:bannerMOneImage forState:UIControlStateNormal];
    [self.banner addTarget:self action:@selector(openBanner) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *tmpdic2=[tmp.bannerImagesArray objectAtIndex:3];
    NSData * imageData2 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://www.can-now.co.il%@",[tmpdic2 objectForKey:@"image"]]]];
    banner2URL=[tmpdic objectForKey:@"link"];
    UIImage *bannerMOneImage2 = [UIImage imageWithData: imageData2];
    [self.banner2 setBackgroundImage:bannerMOneImage2 forState:UIControlStateNormal];
    [self.banner2 addTarget:self action:@selector(openBanner) forControlEvents:UIControlEventTouchUpInside];
    
    dpDatePicker = [[UIDatePicker alloc] init];
    dpDatePicker.datePickerMode = UIDatePickerModeDate;
    [dpDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    dpDatePicker.timeZone = [NSTimeZone defaultTimeZone];
    dpDatePicker.minuteInterval = 5;
    
    [differentDate setInputView:dpDatePicker];
    
    autocompleteCategories=[[NSMutableArray alloc] init];
    
    autocompleteUrls = [[NSMutableArray alloc] init];
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(60, 192, 205, 120) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    autocompleteTableView.separatorInset=UIEdgeInsetsZero;
    [self.view addSubview:autocompleteTableView];
    
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [self.containerScrollView addGestureRecognizer:tapScroll];
    
    if (openWithDate)
    {
        [self radioButton1Clicked:nil];
        [self textFieldShouldBeginEditing:self.differentDate];
        [self.differentDate becomeFirstResponder];
    }
    if (openWithArea)
    {
        [self radioButton3Clicked:nil];
        [self textFieldShouldBeginEditing:self.differentArea];
        [self.differentArea becomeFirstResponder];
    }
    
    [spinner stopAnimating];
    spinner.hidden = YES;
    self.containerScrollView.hidden=NO;
}

- (IBAction)backButtonClicked:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Open Banner methods

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


#pragma mark Gesture Recognise method
- (void) tapped
{
    [self.view endEditing:YES];
    [self.containerScrollView endEditing:YES];
    autocompleteTableView.hidden = YES;
    [self performSelector:@selector(moveScrollDown) withObject:nil afterDelay:0.1];
}


#pragma mark UIDatePicker Value Changed method

- (void)datePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    differentDate.text = [dateFormatter stringFromDate:dpDatePicker.date];
}

#pragma mark Radio Button methods

- (IBAction)radioButton1Clicked:(UIButton *)sender{
    [self.radioButton1 setBackgroundImage:[UIImage imageNamed:@"radio_checked.png"] forState:UIControlStateNormal];
    [self.radioButton2 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    [self.radioButton3 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    self.differentDate.enabled=TRUE;
    self.differentCity.enabled=FALSE;
    self.differentArea.enabled=FALSE;
}

- (IBAction)radioButton2Clicked:(UIButton *)sender{
    [self.radioButton1 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    [self.radioButton2 setBackgroundImage:[UIImage imageNamed:@"radio_checked.png"] forState:UIControlStateNormal];
    [self.radioButton3 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    self.differentDate.enabled=FALSE;
    self.differentCity.enabled=TRUE;
    self.differentArea.enabled=FALSE;
}

- (IBAction)radioButton3Clicked:(UIButton *)sender{
    [self.radioButton1 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    [self.radioButton2 setBackgroundImage:[UIImage imageNamed:@"radio_normal.png"] forState:UIControlStateNormal];
    [self.radioButton3 setBackgroundImage:[UIImage imageNamed:@"radio_checked.png"] forState:UIControlStateNormal];
    self.differentDate.enabled=FALSE;
    self.differentCity.enabled=FALSE;
    self.differentArea.enabled=TRUE;
}

#pragma mark Update Search method

-(IBAction)updateSearchClicked:(id)sender
{
    if (self.differentDate.enabled)
    {
        NSString *tmpDate=differentDate.text;
        tmpDate=[tmpDate stringByReplacingOccurrencesOfString:@"/" withString:@""];
        self.pageToChange.customSeatchURL=[[[NSString alloc] initWithFormat:@"%@/0/date/%@",urlToChange,tmpDate] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.pageToChange loadResultsCustomSearch];
    }
    else if (self.differentCity.enabled)
    {
        self.pageToChange.customSeatchURL=[[[NSString alloc] initWithFormat:@"%@/0/city/%@",urlToChange,self.differentCity.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.pageToChange loadResultsCustomSearch];
    }
    else if (self.differentArea.enabled)
    {
        self.pageToChange.customSeatchURL=[[[NSString alloc] initWithFormat:@"%@/0/region/%@",urlToChange,self.differentArea.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.pageToChange loadResultsCustomSearch];
    }
}

#pragma mark UITextFieldDelegate methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
    [self.containerScrollView endEditing:YES];
    autocompleteTableView.hidden = YES;
    [self performSelector:@selector(moveScrollDown) withObject:nil afterDelay:0.1];
}


- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    if (textField==self.differentCity)
    {
        NSURL *myURL=[[NSURL alloc] initWithString:@"http://www.can-now.co.il/api/searchdata/cities"];
        
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
        [autocompleteCategories removeAllObjects];
        for (int i=0;i<arrayOfName.count;i++)
        {
            NSDictionary *temp=arrayOfName[i];
            [autocompleteCategories addObject:temp];
        }
        [self performSelector:@selector(moveScrollUp) withObject:nil afterDelay:0.1];
    }
    else if (textField==self.differentArea)
    {
        NSURL *myURL=[[NSURL alloc] initWithString:@"http://www.can-now.co.il/api/searchdata/regions"];
        
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
        [autocompleteCategories removeAllObjects];
        for (int i=0;i<arrayOfName.count;i++)
        {
            NSDictionary *temp=arrayOfName[i];
            [autocompleteCategories addObject:temp];
        }
        [self performSelector:@selector(moveScrollMoreUp) withObject:nil afterDelay:0.1];
    }
    return YES;
}

-(void)moveScrollUp
{
    autocompleteTableView.frame = CGRectMake(60, 192, 205, 120);
    [self.containerScrollView setContentOffset:CGPointMake(0, 65) animated:YES];
}

-(void)moveScrollMoreUp
{
    autocompleteTableView.frame = CGRectMake(60, 202, 205, 120);
    [self.containerScrollView setContentOffset:CGPointMake(0, 110) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.differentCity)
    {
        [self performSelector:@selector(moveScrollDown) withObject:nil afterDelay:0.1];
    }
    else if (textField==self.differentArea)
    {
        [self performSelector:@selector(moveScrollDown) withObject:nil afterDelay:0.1];
    }
}

-(void)moveScrollDown
{
    [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    
    if (textField==self.differentCity)
    {
    }
    else if (textField==self.differentArea)
    {
        //autocompleteTableView.frame=CGRectMake(60, 237, 200, 120);
    }
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
    
    if (self.differentCity.enabled)
    {
        self.differentCity.text=selectedCell.textLabel.text;
    }
    else if (self.differentArea.enabled)
    {
        self.differentArea.text=selectedCell.textLabel.text;
    }
    tableView.hidden=YES;
    
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


@end
