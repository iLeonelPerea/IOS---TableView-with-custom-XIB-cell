//
//  ProductCellTableViewCell.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/27/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCellTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *lblProductName;
@property(nonatomic, strong) IBOutlet UIImageView *imgProduct;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * loader;
@end
