//
//  RateProductViewController.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/29/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ViewController.h"
#import "DYRateView.h"
#import "ProductInfoViewController.h"
#import "ProductDetailObject.h"

@interface RateProductViewController : ViewController <DYRateViewDelegate>

@property (nonatomic, strong) ProductDetailObject *productDetailObject;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, assign) NSInteger rateValue;
@property (nonatomic, strong) id<iInfoDelegate> delegate;
@property (nonatomic, assign) int productId;
@property (nonatomic, strong) DYRateView *rateView;
@property (nonatomic, assign) BOOL isFirstTime;

@end
