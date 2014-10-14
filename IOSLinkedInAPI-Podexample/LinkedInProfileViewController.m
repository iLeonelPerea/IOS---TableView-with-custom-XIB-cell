//
//  LinkedInProfileViewController.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "LinkedInProfileViewController.h"

#define LINKEDIN_CLIENT_ID @"753l2vlirmrzay"
#define LINKEDIN_CLIENT_SECRET @"pgBfsLhgCKBCZPdn"

@interface LinkedInProfileViewController ()

@end

@implementation LinkedInProfileViewController
@synthesize accessToken, arrSkills, tblSkills, lblCurrentSkills, lblFullName, lblPosition, imgProfile, client, progressHUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * btnSave = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doSaveProfile:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    [tblSkills setDelegate:self];
    [tblSkills setDataSource:self];
    [lblCurrentSkills setHidden:YES];
    [tblSkills setHidden:YES];
    client = [self client];
    [self setTitle:@"Linked In Profile"];
    [client getAuthorizationCode:^(NSString *code) {
        [client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            accessToken = [accessTokenData objectForKey:@"access_token"];
            progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
            progressHUD.textLabel.text = @"Loading data...";
            [progressHUD showInView:self.view animated:YES];
            [self requestMe];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doSaveProfile:(id)sender
{
    NSLog(@"do save and post notification...");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:10];
    notification.alertBody = @"Feedback on your recent Razorfish interview.";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertAction = @"View";
    notification.hasAction = YES;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestMe
{
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,phonetic-last-name,location:(country:(code)),industry,distance,current-status,skills,phone-numbers,date-of-birth,main-address,positions,educations:(school-name,field-of-study,start-date,end-date,degree,activities))?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        NSDictionary * dictPositions = [result objectForKey:@"positions"];
        NSArray * arrPositions = [dictPositions objectForKey:@"values"];
        lblFullName.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"formattedName"]];
        NSDictionary * currentPosition = [arrPositions objectAtIndex:0];
        lblPosition.text = [NSString stringWithFormat:@"%@ @ %@", [currentPosition objectForKey:@"title"], [[currentPosition objectForKey:@"company"] objectForKey:@"name"]];
        arrSkills = [NSMutableArray new];
        arrSkills = [[result objectForKey:@"skills"] objectForKey:@"values"];
        [lblCurrentSkills setHidden:NO];
        [tblSkills setHidden:NO];
        [tblSkills reloadData];
        [self requestProfilePicture];
    }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"failed to fetch current user %@", error);
             }
     ];
}

-(void)requestProfilePicture
{
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/picture-urls::(original)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary * pictures) {
        NSString * profilePicURL = [pictures objectForKey:@"values"][0];
        [imgProfile setImageWithResizeURL:profilePicURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [progressHUD dismissAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"profile picture error %@", error);
    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://linkedin_oauth/success"
                                                                                    clientId:LINKEDIN_CLIENT_ID
                                                                                clientSecret:LINKEDIN_CLIENT_SECRET
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"w_messages", @"rw_company_admin", @"rw_nus", @"r_emailaddress", @"r_network", @"r_basicprofile", @"r_fullprofile", @"rw_groups", @"r_contactinfo"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

#pragma mark -- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[arrSkills count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strReusableIdentifier = @"CellSkill";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strReusableIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strReusableIdentifier];
    }
    NSDictionary * dictSkill = [arrSkills objectAtIndex:indexPath.row];
    cell.textLabel.text = [[dictSkill objectForKey:@"skill"] objectForKey:@"name"];
    
    return cell;
}
@end
