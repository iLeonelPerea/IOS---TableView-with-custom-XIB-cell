//
//  ProductInfoViewController.m
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/28/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ProductInfoViewController.h"

@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController
@synthesize imgProduct, lblProductName, lblProductCategory, txtProductDescription, ldrImageIndicator;

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

-(void)doShowRateVC:(id)sender{
    RateProductViewController *rateProductViewController = [[RateProductViewController alloc] init];
    [self.navigationController pushViewController:rateProductViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
