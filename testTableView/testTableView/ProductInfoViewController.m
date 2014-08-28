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
@synthesize imgProduct, lblProductName, lblProductCategory, lblProductDescription;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
