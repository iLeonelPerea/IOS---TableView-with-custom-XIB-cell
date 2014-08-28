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
@synthesize imgProduct, lblProductName, lblProductCategory, txtProductDescription;

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
    [NSString stringWithFormat:@"%@",[_dictFinalProduct objectForKey:@"picture"]]:
    @"http://img1.wikia.nocookie.net/__cb20130527163652/simpsons/images/thumb/6/60/No_Image_Available.png/480px-No_Image_Available.png";
    self.lblProductName.text = ([_dictFinalProduct objectForKey:@"name"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [_dictFinalProduct objectForKey:@"name"]]:@"No Name";
    self.lblProductCategory.text = ([_dictFinalProduct objectForKey:@"category"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [_dictFinalProduct objectForKey:@"category"]]:@"No Category";
    self.txtProductDescription.text = ([_dictFinalProduct objectForKey:@"description"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [_dictFinalProduct objectForKey:@"description"]]:@"No Description";
    
    [[[AsyncImageDownloader alloc] initWithFileURL:url successBlock:^(NSData *data) {
        [self.imgProduct setImage:[UIImage imageWithData:data]];
    } failBlock:^(NSError *error) {
        NSLog(@"Failed to download image due to %@!", error);
    }] startDownload];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
