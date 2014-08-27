//
//  ProductCellTableViewCell.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/27/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCellTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *lblProductInfoId;
@property(nonatomic, strong) IBOutlet UILabel *lblProductInfoDescription;
@property(nonatomic, strong) IBOutlet UILabel *lblProductDescriptionCategory;

@end
