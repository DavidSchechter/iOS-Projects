//
//  SubFieldSearchViewController.m
//  CanNow
//
//  Created by David Schechter on 12/23/13.
//  Copyright (c) 2013 David Schechter. All rights reserved.
//

#import "SubFieldSearchViewController.h"
#import "CategoryObject.h"
#import "ResultsPageViewController.h"



@implementation SubFieldSearchViewController

@synthesize backButton,menuButton,navBarTitle,subCategoriesArray,titleToSet,idNumberOfCategory,customSeatchURL,usingCustomSearch;


#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.idNumberStrightToCards=0;
    self.backStrightToRootView=FALSE;
    self.navBarTitle.title = self.titleToSet;
    
    [spinner startAnimating];
    spinner.hidden=NO;
    self.tableFields.hidden=YES;
    NSString *rightArrow=@"\u2190";
    pathLabel.text=[NSString stringWithFormat:@"ראשי %@ %@",rightArrow,self.titleToSet];
    
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
        buildURL=[[[NSString alloc] initWithFormat:@"http://www.can-now.co.il/api/category/%d/",self.idNumberOfCategory] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    AppDelegate* tmp=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSDictionary *tmpdic=[tmp.bannerImagesArray objectAtIndex:1];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http://www.can-now.co.il%@",[tmpdic objectForKey:@"image"]]]];
    UIImage *bannerMOneImage = [UIImage imageWithData: imageData];
    bannerURL=[tmpdic objectForKey:@"link"];
    [self.banner setBackgroundImage:bannerMOneImage forState:UIControlStateNormal];
    [self.banner addTarget:self action:@selector(openBanner) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    self.subCategoriesArray=[[NSMutableArray alloc] init];
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
    
    [self.tableFields reloadData];
    self.tableFields.hidden=NO;
    [spinner stopAnimating];
    spinner.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(UIButton *)sender{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)openBanner
{
    NSURL *url = [ [ NSURL alloc ] initWithString: bannerURL ];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark PopOver Methods

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
    return subCategoriesArray.count;
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
        //cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 160, 150);
    }
    //int xCoord=15;
    //int yCoord=0;
    //int buttonHeight=70;

    UIImage *tmpBorderImg=[UIImage imageNamed:@"seperation_border.png"];
    
    
    CategoryObject *tempCat=subCategoriesArray[indexPath.row];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(15, 0,tmpBorderImg.size.width,70 )];
    
    UIImage *tmpBtnImage=[UIImage imageNamed:@"enter_item.png"];
    
    
    
    UIImageView *tmpBorderImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,tmpBorderImg.size.width,tmpBorderImg.size.height)];
    tmpBorderImgView.image=tmpBorderImg;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5,aView.frame.size.width-80,70-10 )];
    
    [titleLabel setBackgroundColor: [UIColor whiteColor]];
    [titleLabel setTextColor:[UIColor blackColor]];
    
    [titleLabel setText:tempCat.title];
    [titleLabel setTextAlignment:NSTextAlignmentRight];
    titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    
    
    
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [aButton setTitle:tempCat.title forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [aButton setBackgroundImage:tmpBtnImage forState:UIControlStateNormal];
    aButton.frame     = CGRectMake(10, 15,tmpBtnImage.size.width,tmpBtnImage.size.height );
    [aButton setTag:tempCat.idNumber];
    if (!(tempCat.numberOfSubCategories==0))
    {
        [aButton addTarget:self action:@selector(hasSubCategories:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (!(tempCat.numberOfCards==0))
    {
        [aButton addTarget:self action:@selector(hasCards:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [aButton addTarget:self action:@selector(hasNothing:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [aButton setTag:tempCat.idNumber];
    
    
    [aView addSubview:tmpBorderImgView];
    [aView addSubview:titleLabel];
    [aView addSubview:aButton];
    [cell addSubview:aView];
    return cell;
}

#pragma mark UITableView Cell methods

-(void) hasSubCategories:(id)sender {
    SubFieldSearchViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"SubFieldSearchViewController"];
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

-(void) hasCards:(id)sender {
    ResultsPageViewController *subField = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsPageViewController"];
    UIButton* tempButton=(UIButton*)sender;
    NSString* tmp=[[NSString alloc] initWithString:tempButton.titleLabel.text];
    subField.titleToSet=tmp;
    subField.idNumberOfCategory=tempButton.tag;
    subField.prevPath=pathLabel.text;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.40;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:subField animated:NO];
}

-(void) hasNothing:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"אין פרטים"
                                                      message:@"אין תת קטגוריות או עסקים לקטגוריה זו"
                                                     delegate:nil
                                            cancelButtonTitle:@"אישור"
                                            otherButtonTitles:nil];
    [message show];
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


@end
