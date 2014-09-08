//
//  MainViewController.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/27/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCellTableViewCell.h"
#import "ProductInfoViewController.h"
#import "ProductObject.h"
#import <JGProgressHUD.h>
#import <AsyncImageDownloader.h>

@interface MainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) ProductObject *productObject;
@property (nonatomic, strong) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) JGProgressHUD *HUDJMProgress;
@property (nonatomic, strong) NSDictionary * accessToken;

@end
