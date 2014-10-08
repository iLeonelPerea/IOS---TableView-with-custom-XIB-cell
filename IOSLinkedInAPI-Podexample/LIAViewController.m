//
//  LIAViewController.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Jacob von Eyben on 16/12/13.
//  Copyright (c) 2013 Eyben Consult ApS. All rights reserved.
//

#import "LIAViewController.h"
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
//#import "LIALinkedInClientExampleCredentials.h"
#import "LIALinkedInApplication.h"

#define LINKEDIN_CLIENT_ID @"753l2vlirmrzay"
#define LINKEDIN_CLIENT_SECRET @"pgBfsLhgCKBCZPdn"

@interface LIAViewController ()

@end

@implementation LIAViewController {
  LIALinkedInHttpClient *_client;
}
@synthesize currentAcessToken, imgProfile, btnConnect, lblFullName, lblPosition, progressHUD, tblSkills, arrSkills, lblCurrentSkills, startView;

- (void)viewDidLoad {
  [super viewDidLoad];
    [tblSkills setDelegate:self];
    [tblSkills setDataSource:self];
    [startView setHidden:NO];
    [lblCurrentSkills setHidden:YES];
    [tblSkills setHidden:YES];
  _client = [self client];
}


- (IBAction)didTapConnectWithLinkedIn:(id)sender {
  [self.client getAuthorizationCode:^(NSString *code) {
    [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
      NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
        [startView setHidden:YES];
        progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        progressHUD.textLabel.text = @"Loading data...";
        [progressHUD showInView:self.view animated:YES];
      [self requestMeWithToken:accessToken];
    }                   failure:^(NSError *error) {
      NSLog(@"Quering accessToken failed %@", error);
    }];
  }                      cancel:^{
    NSLog(@"Authorization was cancelled by user");
  }                     failure:^(NSError *error) {
    NSLog(@"Authorization failed %@", error);
  }];
}


- (void)requestMeWithToken:(NSString *)accessToken {
    [btnConnect setHidden:YES];
    //picture urls //~/picture-urls::(original)
  //[self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation,
    //[self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,skills)?oauth2_access_token=%@&format=json", accessToken] // request only skills
    currentAcessToken = accessToken;
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,phonetic-last-name,location:(country:(code)),industry,distance,current-status,skills,phone-numbers,date-of-birth,main-address,positions,educations:(school-name,field-of-study,start-date,end-date,degree,activities))?oauth2_access_token=%@&format=json", currentAcessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
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
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/picture-urls::(original)?oauth2_access_token=%@&format=json", currentAcessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary * pictures) {
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
