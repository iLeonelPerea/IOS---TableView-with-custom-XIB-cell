//
//  MainViewController.m
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/27/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "MainViewController.h"
#import "DBManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize tblView, arrData, HUDJMProgress, productObject;

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
    self.navigationItem.title = @"Product List";
    arrData = [NSMutableArray new];
    [tblView setDelegate:self];
    [tblView setDataSource:self];
    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
    [[self tblView] registerNib:nib forCellReuseIdentifier:@"ItemCell"];
    HUDJMProgress = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUDJMProgress.textLabel.text = @"Loading";
    //[self loadProductsData];
    self.accessToken = [[NSDictionary alloc] initWithObjects:@[@"5e06dc07fda2b1e4b6ba792ba18e5d964d567cf33a575f55"] forKeys:@[@"accessToken"]];
    [self loadNewData];
}

-(void)loadNewData
{
    /*
    NSString * username = @"spree@example.com";
    NSString * password = @"spree123";
    //NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"data":@{@"spree_user":@{@"email": username, @"password": password}}}];
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"spree_user":@{@"email": username, @"password": password}}];
    [self sendData:jsonDict toService:@"authorizations" withMethod:@"POST" withAccessToken:nil toCallback:^(id result) {
        self.accessToken = [result[@"status"] isEqual:@"ok"] ? [result valueForKeyPath:@"user.spree_api_key"] : nil;
        NSLog(@"done...");
    }];
    */
    [self sendData:nil toService:@"products" withMethod:@"GET" withAccessToken:[self.accessToken objectForKey:@"accessToken"] toCallback:^(id result){
        NSLog(@"done... with dictionary: %@", result);
    }];
    
}

-(void)sendData:(NSMutableDictionary *)data toService:(NSString *)service withMethod:(NSString *)method withAccessToken:(NSString *)accessToken toCallback:(void (^)(id))callback
{
    NSURL *url = nil;
    NSMutableURLRequest *request;
    
    if(![method isEqual: @"GET"])
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://spree-demo-store.herokuapp.com/api/v1/%@", service]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://spree-demo-store.herokuapp.com/api/%@.json?token=%@", service, accessToken]];
    
    request = [NSMutableURLRequest requestWithURL:url];
    if(accessToken && data)
    {
        [data setObject:accessToken forKey:@"access_token"];
    }
    
    if(data)
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        NSLog(@"json string: %@", JSONString);
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
    }
    
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 204)
        {
            callback(@{@"success": @YES});
        }
        else if(!error && response != nil)
        {
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            callback(responseJson);
        }
        else
        {
            callback(nil);
        }
    }];
}

-(void)loadProductsData{
    [HUDJMProgress showInView:self.view];
    
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    /*
    [defaults setObject:nil forKey:@"isDataLoaded"];
    [defaults synchronize];
    return;
    */
    if(![defaults objectForKey:@"isDataLoaded"])
    {
        NSURL *url = [NSURL URLWithString:@"https://spree-demo-store.herokuapp.com/api/products.json?key=5e06dc07fda2b1e4b6ba792ba18e5d964d567cf33a575f55"];
    
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSLog(@"Cargando Datos...");
            if(!error)
            {
                NSDictionary * dictFoodsGeneral = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:nil];
                NSArray * arrFoods = [dictFoodsGeneral objectForKey:@"foods"];
                for (NSDictionary * dictFood in arrFoods)
                {
                    for(NSDictionary * dictFoodFinal in [dictFood objectForKey:@"foods"])
                    {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *documentDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                        NSString *filePathAndDirectory = [documentDirectoryPath stringByAppendingString:@"/images/thumbs/"];
                        [[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                        NSString * fileName = [NSString stringWithFormat:@"%@.jpg", [dictFoodFinal objectForKey:@"id"]];
                        NSString * fullPath = [NSString stringWithFormat:@"%@/%@", filePathAndDirectory, fileName];
                        
                        NSString *url = ([dictFoodFinal objectForKey:@"picture_thumb"] != [NSNull null])? [NSString stringWithFormat:@"%@",[dictFoodFinal objectForKey:@"picture_thumb"]]:@"";
                        if(![url isEqual:@""]){
                            [[[AsyncImageDownloader alloc] initWithFileURL:url successBlock:^(NSData *data) {
                                NSData *dataPic = [NSData dataWithData:UIImageJPEGRepresentation([UIImage imageWithData:data], 1.0f)];
                                [dataPic writeToFile:fullPath atomically:YES];
                            } failBlock:^(NSError *error) {
                                NSLog(@"Failed to download image due to %@!", error);
                            }] startDownload];
                        }
                    });
                    [arrData addObject:dictFoodFinal];
                    [DBManager insertProduct:dictFoodFinal];
                }
                }
                [defaults setObject:@"YES" forKey:@"isDataLoaded"];
                [defaults synchronize];
                NSLog(@"tu array de datos final tiene: %d registros", [arrData count]);
            }
            [HUDJMProgress dismissAfterDelay:0.1];
            [tblView reloadData];
        }];
    }
    else
    {
        // call and fill up array from DBManager
        arrData = [DBManager getProducts];
        [HUDJMProgress dismissAfterDelay:0.1];
        [tblView reloadData];
    }
}

#pragma mark - Table view data delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dictFinalProduct = [arrData objectAtIndex:indexPath.row];
    cell.lblProductName.text = ([dictFinalProduct objectForKey:@"name"]) != [NSNull null]?(![[dictFinalProduct objectForKey:@"name"] isEqual:@""])?[dictFinalProduct objectForKey:@"name"]:@"No Name":@"No Name";
    NSString *url = ([dictFinalProduct objectForKey:@"picture_thumb"] != [NSNull null])? [NSString stringWithFormat:@"%@",[dictFinalProduct objectForKey:@"picture_thumb"]]:@"";
    if(![url isEqual:@""]){
        [[[AsyncImageDownloader alloc] initWithFileURL:url successBlock:^(NSData *data) {
            [cell.loader stopAnimating];
            [cell.imgProduct setImage:[UIImage imageWithData:data]];
        } failBlock:^(NSError *error) {
            NSLog(@"Failed to download image due to %@!", error);
        }] startDownload];
    }
    else{
        [cell.imgProduct setImage:[UIImage imageNamed:@"noAvail.png"]];
        [cell.loader stopAnimating];
    }
    [cell.imgProduct setImage:[UIImage imageNamed:@"noAvail.png"]];
    [cell.loader stopAnimating];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductInfoViewController *producInfoViewController = [[ProductInfoViewController alloc] init];
    NSDictionary * currentProductDict = [arrData objectAtIndex:indexPath.row];
    productObject = [ProductObject new];
    productObject = [productObject assignProductObject:currentProductDict];
    producInfoViewController.productObject = productObject;
    [self.navigationController pushViewController:producInfoViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
