//
//  ProductInfoViewController.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/28/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ViewController.h"
#import <AsyncImageDownloader.h>

@interface ProductInfoViewController : ViewController

@property (nonatomic, strong) NSMutableDictionary *dictFinalProduct;
@property(nonatomic, strong) IBOutlet UIImageView *imgProduct;
@property(nonatomic, strong) IBOutlet UILabel *lblProductName;
@property(nonatomic, strong) IBOutlet UILabel *lblProductCategory;
@property(nonatomic, strong) IBOutlet UITextView *txtProductDescription;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *ldrImageIndicator;
@property(nonatomic, strong) IBOutlet UIButton *btnWriteComment;
@property(nonatomic, assign) NSInteger receivedRateValue;
@property(nonatomic, assign) NSInteger receivedCommentValue;

-(IBAction)doShowCommentsViewController:(id)sender;


-(IBAction)doShowRateVC:(id)sender;
@end

@protocol iInfoDelegate <NSObject>

-(void)doSetRateValue:(int)rateValue;
-(void)doSetCommentValue:(NSString*)commentValue;

@end