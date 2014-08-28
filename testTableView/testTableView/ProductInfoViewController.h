//
//  ProductInfoViewController.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/28/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ViewController.h"

@interface ProductInfoViewController : ViewController

@property (nonatomic, strong) NSMutableArray *arrData;
@property(nonatomic, strong) IBOutlet UIImageView *imgProduct;
@property(nonatomic, strong) IBOutlet UILabel *lblProductName;
@property(nonatomic, strong) IBOutlet UILabel *lblProductCategory;
@property(nonatomic, strong) IBOutlet UILabel *lblProductDescription;

@end
