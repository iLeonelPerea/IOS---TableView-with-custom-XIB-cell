//
//  RateProductViewController.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/29/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ViewController.h"
#import "DYRateView.h"

@interface RateProductViewController : ViewController <DYRateViewDelegate>

@property (nonatomic, strong) UILabel *rateLabel;

@end
