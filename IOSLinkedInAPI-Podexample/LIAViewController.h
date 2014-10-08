//
//  LIAViewController.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Jacob von Eyben on 16/12/13.
//  Copyright (c) 2013 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NZCircularImageView.h>
#import <JGProgressHUD.h>

@interface LIAViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString * currentAcessToken;
@property (nonatomic, strong) IBOutlet UIButton * btnConnect;
@property (nonatomic, strong) IBOutlet NZCircularImageView * imgProfile;
@property (nonatomic, strong) IBOutlet UILabel * lblFullName;
@property (nonatomic, strong) IBOutlet UILabel * lblPosition;
@property (nonatomic, strong) IBOutlet UILabel * lblCurrentSkills;
@property (nonatomic, strong) IBOutlet UIView * startView;
@property (nonatomic, strong) JGProgressHUD * progressHUD;
@property (nonatomic, strong) IBOutlet UITableView * tblSkills;
@property (nonatomic, strong) NSMutableArray * arrSkills;
@end
