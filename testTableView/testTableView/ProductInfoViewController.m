//
//  ProductInfoViewController.m
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/28/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "AddCommentViewController.h"
#import "RateProductViewController.h"

@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController
@synthesize imgProduct, lblProductName, lblProductCategory, txtProductDescription, ldrImageIndicator, btnWriteComment, receivedRateValue, receivedCommentValue;

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
    NSString *url = ([_dictFinalProduct objectForKey:@"picture"] != [NSNull null])?
        [NSString stringWithFormat:@"%@",[_dictFinalProduct objectForKey:@"picture"]]:@"";
    self.lblProductName.text = ([_dictFinalProduct objectForKey:@"name"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [_dictFinalProduct objectForKey:@"name"]]:@"No Name";
    self.lblProductCategory.text = ([_dictFinalProduct objectForKey:@"category"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [_dictFinalProduct objectForKey:@"category"]]:@"No Category";
    self.txtProductDescription.text = ([_dictFinalProduct objectForKey:@"description"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [_dictFinalProduct objectForKey:@"description"]]:@"No Description";
    
    if(![url isEqual:@""]){
        [[[AsyncImageDownloader alloc] initWithFileURL:url successBlock:^(NSData *data) {
            [self.ldrImageIndicator stopAnimating];
            [self.imgProduct setImage:[UIImage imageWithData:data]];
        } failBlock:^(NSError *error) {
            NSLog(@"Failed to download image due to %@!", error);
        }] startDownload];
    }else{
        [self.imgProduct setImage:[UIImage imageNamed:@"noAvail.png"]];
        [self.ldrImageIndicator stopAnimating];
    }
    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (receivedRateValue) {
        UILabel * lblRateValue = [[UILabel alloc] initWithFrame:CGRectMake(40, 469, 200, 30)];
        [lblRateValue setText:[NSString stringWithFormat:@"This foods rate is: %d",receivedRateValue]];
        [self.view addSubview:lblRateValue];
    }
    if (receivedCommentValue) {
        UILabel * lblCommentValue = [[UILabel alloc] initWithFrame:CGRectMake(40, 529, 200, 30)];
        [lblCommentValue setText:[NSString stringWithFormat:@"This foods comment is: %d",receivedCommentValue]];
        [self.view addSubview:lblCommentValue];
    }
}

-(void)doShowRateVC:(id)sender{
    RateProductViewController *rateProductViewController = [[RateProductViewController alloc] init];
    [rateProductViewController setDelegate:(id)self];
    [self.navigationController pushViewController:rateProductViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doShowCommentsViewController:(id)sender
{
    AddCommentViewController *addCommentViewController = [[AddCommentViewController alloc] init];
    [addCommentViewController setDelegate:(id)self];
    [self.navigationController pushViewController:addCommentViewController animated:YES];
}

#pragma mark -- Custom Delegate Methods

-(void)doSetRateValue:(int)rateValue{
    receivedRateValue = rateValue;
    NSLog(@"cool %d that's a delegate call method: ",rateValue);
}

-(void)doSetCommentValue:(NSString*)commentValue{
    receivedCommentValue = [commentValue length];
    NSLog(@"cool %d that's a delegate call method: ",receivedCommentValue);
}

@end
