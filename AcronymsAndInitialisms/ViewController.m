//
//  ViewController.m
//  AcronymsAndInitialisms
//
//  Created by David Schechter on 12/4/15.
//  Copyright © 2015 David Schechter. All rights reserved.
//

#import "ViewController.h"

static NSString * const BaseURLString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";

@interface ViewController ()

@end

@implementation ViewController

@synthesize table,button,textField;


#pragma mark life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [[NSArray alloc] init];
    table.layer.borderWidth = 1.0;
    table.layer.cornerRadius = 5;
    table.layer.masksToBounds = YES;
    table.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.cornerRadius = 5;
    textField.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MBProgressHUDDelegate methods

- (IBAction)jsonTapped:(id)sender
{
    [textField resignFirstResponder];
    if (![self.textField.text isEqual:@""])
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        HUD.detailsLabelText = @"updating data";
        HUD.square = YES;
        
        [HUD showWhileExecuting:@selector(getData) onTarget:self withObject:nil animated:YES];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark AFNetworking methods

-(void)getData
{
    // 1
    NSString *string = [NSString stringWithFormat:@"%@?sf=%@", BaseURLString, self.textField.text];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        NSArray *tempData = (NSArray *)responseObject;
        if ([tempData count]>0)
        {
            NSDictionary *tempDic=tempData[0];
            if ([[tempDic objectForKey:@"lfs"] count]>0)
            {
                data=[tempDic objectForKey:@"lfs"];
            }
        }
        [self.table reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}

#pragma Keyboard hiding methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


#pragma mark UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    if ([data count]>0)
    {
        return [data count];
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"LongFormCell";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    NSDictionary *tempDic = data[indexPath.row];
    
    cell.textLabel.text = [tempDic objectForKey:@"lf"];
    
    return cell;
}


#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark UITextFieldDelegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)tempTextField
{
    [tempTextField resignFirstResponder];
    return YES;
}

@end
