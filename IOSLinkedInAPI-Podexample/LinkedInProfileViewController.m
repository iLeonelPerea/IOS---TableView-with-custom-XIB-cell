//
//  LinkedInProfileViewController.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "LinkedInProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

#define LINKEDIN_CLIENT_ID @"753l2vlirmrzay"
#define LINKEDIN_CLIENT_SECRET @"pgBfsLhgCKBCZPdn"

@interface LinkedInProfileViewController ()

@end

@implementation LinkedInProfileViewController
@synthesize accessToken, arrSkills, collSkills, lblCurrentSkills, lblFullName, lblPosition, imgProfile, client, progressHUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * btnSave = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doSaveProfile:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    client = [self client];
    [self setTitle:@"Linked In Profile"];
    //todo: check collection view logic
    [collSkills setDataSource:self];
    [collSkills setDelegate:self];
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
        //todo: add collection view logic
        [collSkills reloadData];
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

#pragma mark -- UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (NSInteger)[arrSkills count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strIdentifier = @"SkillCell";
    SkillCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:strIdentifier forIndexPath:indexPath];
    NSDictionary * dictSkill = [arrSkills objectAtIndex:indexPath.row];
    NSString * strSkill = [[dictSkill objectForKey:@"skill"] objectForKey:@"name"];
    cell.lblSkill.text = strSkill;
    [cell.btnRemove setFrame:CGRectMake(10, 0, 40, 40)];
    [cell.btnRemove setTag:indexPath.row];
    [cell.btnRemove addTarget:self action:@selector(doRemoveSkill:) forControlEvents:UIControlEventTouchUpInside];
    cell.layer.borderWidth = 0.6f;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    return cell;
}

-(void)doRemoveSkill:(id)sender
{
    NSMutableDictionary * tmpDictSkill = [arrSkills objectAtIndex:[(UIButton*)sender tag]];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Confirmation!" message:[NSString stringWithFormat:@"Are You sure You want to delete: %@ from skills list?", [[tmpDictSkill objectForKey:@"skill"] objectForKey:@"name"]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = [(UIButton*)sender tag];
    [alert show];
}

#pragma mark -- UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSMutableArray * tmpArrSkills = [arrSkills mutableCopy];
        [tmpArrSkills removeObjectAtIndex:alertView.tag];
        arrSkills = tmpArrSkills;
        [collSkills reloadData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * strSkill = [[[arrSkills objectAtIndex:indexPath.row] objectForKey:@"skill"] objectForKey:@"name"];
    CGSize size = [(NSString*)strSkill sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    size.width += 34;
    return size;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(segue.identifier != nil)
    {
        RazorFishSkillsViewController * rfSVC = [segue destinationViewController];
        [rfSVC setDelegate:(id)self];
        [rfSVC doLoadSkills:[DBManager getSkills] withSelectedSkills:nil];
    }
}
@end
