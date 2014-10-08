//
//  LinkedInProfileViewController.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import <NZCircularImageView.h>
#import <JGProgressHUD.h>

@interface LinkedInProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic, strong) LIALinkedInHttpClient * client;
@property (nonatomic, strong) IBOutlet NZCircularImageView * imgProfile;
@property (nonatomic, strong) IBOutlet UILabel * lblFullName;
@property (nonatomic, strong) IBOutlet UILabel * lblPosition;
@property (nonatomic, strong) IBOutlet UILabel * lblCurrentSkills;
@property (nonatomic, strong) JGProgressHUD * progressHUD;
@property (nonatomic, strong) IBOutlet UITableView * tblSkills;
@property (nonatomic, strong) NSMutableArray * arrSkills;
@end
