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
#import "DBManager.h"

@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController
@synthesize imgProduct, lblProductName, lblProductCategory, txtProductDescription, ldrImageIndicator, btnWriteComment, receivedCommentValue, dictFinalProduct, rateView, productObject, productDetailObject;

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
    
    NSString *url = [productObject picture];
    self.lblProductName.text = [productObject name];
    self.lblProductCategory.text = [productObject category];
    self.txtProductDescription.text = [productObject description];
    
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
    
    rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    rateView.padding = 20;
    rateView.alignment = RateViewAlignmentCenter;
    rateView.editable = NO;
    [self.view addSubview:rateView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary * dictInfo = [[NSDictionary alloc] initWithDictionary:[DBManager getProductWithId:[[dictFinalProduct objectForKey:@"remote_id"] intValue]]];
        
        if([[dictInfo objectForKey:@"comment"] length] > 0){
            [btnWriteComment setTitle:@"Edit comment" forState:UIControlStateNormal];
        }
    });

    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary * dictInfo = [[NSDictionary alloc] initWithDictionary:[DBManager getProductWithId:[productObject remote_id]]];
        productDetailObject = [ProductDetailObject new];
        productDetailObject = [productDetailObject assignProductDetailObject:dictInfo];
        rateView.rate = [[productDetailObject rate] intValue];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary * dictInfo = [[NSDictionary alloc] initWithDictionary:[DBManager getProductWithId:[[dictFinalProduct objectForKey:@"remote_id"] intValue]]];
        if([[dictInfo objectForKey:@"comment"] length] > 0){
            [btnWriteComment setTitle:@"Edit comment" forState:UIControlStateNormal];
        }
    });
}

-(void)doShowRateVC:(id)sender{
    RateProductViewController *rateProductViewController = [[RateProductViewController alloc] init];
    [rateProductViewController setDelegate:(id)self];
    rateProductViewController.productId = [productObject remote_id];
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
    addCommentViewController.productId = [[dictFinalProduct objectForKey:@"remote_id"] intValue];
    [self.navigationController pushViewController:addCommentViewController animated:YES];
}

#pragma mark -- Custom Delegate Methods

-(void)doSetRateValue:(int)rateValue{
    [DBManager updateProductRate:rateValue withId:[productObject remote_id]];
}

-(void)doSetCommentValue:(NSString*)commentValue{
    receivedCommentValue = [commentValue length];
    [DBManager updateProductComment:commentValue withId:[productObject remote_id]];
    NSLog(@"cool %d that's a delegate call method: ",receivedCommentValue);
}

@end
