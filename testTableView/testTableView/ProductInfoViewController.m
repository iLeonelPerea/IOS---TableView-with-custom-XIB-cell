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
@synthesize imgProduct, lblProductName, lblProductCategory, txtProductDescription, ldrImageIndicator, btnWriteComment, receivedRateValue, receivedCommentValue, dictFinalProduct, rateView;

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
    NSString *url = ([dictFinalProduct objectForKey:@"picture"] != [NSNull null])?
        [NSString stringWithFormat:@"%@",[dictFinalProduct objectForKey:@"picture"]]:@"";
    self.lblProductName.text = ([dictFinalProduct objectForKey:@"name"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [dictFinalProduct objectForKey:@"name"]]:@"No Name";
    self.lblProductCategory.text = ([dictFinalProduct objectForKey:@"category"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [dictFinalProduct objectForKey:@"category"]]:@"No Category";
    self.txtProductDescription.text = ([dictFinalProduct objectForKey:@"description"]) != [NSNull null] ?[NSString stringWithFormat:@"%@", [dictFinalProduct objectForKey:@"description"]]:@"No Description";
    
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
    rateView.editable = YES;
    
    rateView.rate = [[dictFinalProduct objectForKey:@"rate"] intValue];
    [self.view addSubview:rateView];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (receivedRateValue) {
        [rateView setRate:receivedRateValue];
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
    rateProductViewController.rateValue = [[dictFinalProduct objectForKey:@"rate"] intValue];
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
    addCommentViewController.commentValue = [dictFinalProduct objectForKey:@"comment"];
    [self.navigationController pushViewController:addCommentViewController animated:YES];
}

#pragma mark -- Custom Delegate Methods

-(void)doSetRateValue:(int)rateValue{
    receivedRateValue = rateValue;
    [dictFinalProduct setObject:[NSString stringWithFormat:@"%d",rateValue] forKey:@"rate"];
    [DBManager updateProductRate:rateValue withId:[[dictFinalProduct objectForKey:@"remote_id"]intValue]];
    NSLog(@"cool %d that's a delegate call method: ",rateValue);
}

-(void)doSetCommentValue:(NSString*)commentValue{
    receivedCommentValue = [commentValue length];
    [DBManager updateProductComment:commentValue withId:[[dictFinalProduct objectForKey:@"remote_id"]intValue]];
    NSLog(@"cool %d that's a delegate call method: ",receivedCommentValue);
}

@end
