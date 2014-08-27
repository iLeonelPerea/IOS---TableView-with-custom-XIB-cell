//
//  MainViewController.m
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/27/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize tblView, arrData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tblView setDelegate:self];
    [tblView setDataSource:self];
    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
    [[self tblView] registerNib:nib forCellReuseIdentifier:@"ItemCell"];
    [self loadLoginData];
}

-(void)loadLoginData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *url = [NSURL URLWithString:@"http://jemiza.herokuapp.com/admin/login.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSDictionary *jsonDict = @{@"admin_user": @{@"email": @"omar@ievolutioned.com", @"password":@"12345678"}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Data-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",[jsonData length]] forHTTPHeaderField:@"Content-Lenght"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"Terminado login");
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:nil];
        NSDictionary *result = nil;
        if(!error && [[responseJson objectForKey:@"success"]boolValue]){
            NSDictionary *currentUser = [[NSDictionary alloc] initWithDictionary:[responseJson objectForKey:@"user"]];
            [defaults setObject:[currentUser objectForKey:@"access_token"] forKey:@"currentAccessToken"];
            [defaults synchronize];
            [self loadProductsData];
        }
        else{
            result = @{@"result": @NO};
        }
    }];
}

-(void)loadProductsData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jemiza.herokuapp.com/admin/products.json?access_token=%@", [defaults objectForKey:@"currentAccessToken"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"Terminado bajado de info");
        if(!error)
        {
            arrData = [[NSMutableArray alloc]initWithArray:[NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:nil]];
            [tblView reloadData];
        }
    }];
}

#pragma mark - Table view data delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellProduct";
    ProductCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProductCellTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dictProduct = [arrData objectAtIndex:indexPath.row];
    
    cell.lblproductInfoId.text = ([dictProduct objectForKey:@"id"])?[NSString stringWithFormat:@"%@",[dictProduct objectForKey:@"id"]]:@"noId";
    cell.lblproductInfoDescription.text = @"Aqui esta la descripción";
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
