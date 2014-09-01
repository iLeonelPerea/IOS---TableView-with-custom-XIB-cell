//
//  RateProductViewController.m
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/29/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "RateProductViewController.h"

@interface RateProductViewController ()

@end

@implementation RateProductViewController

@synthesize rateLabel = _rateLabel, rateValue;

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
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpEditableRateView];
}

- (void)setUpEditableRateView {
    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    rateView.padding = 20;
    rateView.alignment = RateViewAlignmentCenter;
    rateView.editable = YES;
    rateView.delegate = self;
    if (rateValue) {
        [rateView setRate:rateValue];
    }
    [self.view addSubview:rateView];
    
    // Set up a label view to display rate
    self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, 20)];
    self.rateLabel.textAlignment = NSTextAlignmentCenter;
    self.rateLabel.text = @"Tap above to rate";
    [self.view addSubview:self.rateLabel];
}

#pragma mark - DYRateViewDelegate

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
    [self.delegate doSetRateValue:[rate intValue]];
    [self.navigationController popViewControllerAnimated:YES];
    self.rateLabel.text = [NSString stringWithFormat:@"Rate: %d", rate.intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
