//
//  LinkedInProfileViewController.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "LinkedInProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RazorFishSkillsViewController.h"

#define LINKEDIN_CLIENT_ID @"753l2vlirmrzay"
#define LINKEDIN_CLIENT_SECRET @"pgBfsLhgCKBCZPdn"

@interface LinkedInProfileViewController ()

@end

@implementation LinkedInProfileViewController
@synthesize accessToken, arrSkills, collSkills, lblCurrentSkills, lblFullName, lblPosition, imgProfile, client, progressHUD, userObject, arrLinkedInSkills, arrSelectedSkills;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialize UserObject
    userObject = [[UserObject alloc] init];
    //Initialize skills arrays
    arrLinkedInSkills = [[NSMutableArray alloc] init];
    arrSelectedSkills = [[NSMutableArray alloc] init];
    arrSkills = [[NSMutableArray alloc] init];
    UIBarButtonItem * btnSave = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doSaveProfile:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    client = [self client];
    [self setTitle:@"Linked In Profile"];
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

-(void)viewDidAppear:(BOOL)animated
{
    [collSkills reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Save profile delegate
-(void)doSaveProfile:(id)sender
{
    //Add the linked skills into UserObject
    [userObject setSkills:arrSkills];
    //Insert the user data into DB, specify that skills are from LinkedIn
    userObject = [DBManager insertUser:userObject withLinkedInSkills:YES];
    //Check if the insert operation was successfully, if not, display an alert to the user.
    if (![userObject idUser] > 0) {
        UIAlertView *alertInertError = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Check your information to perform the action again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertInertError show];
    }else{
        //Create a local notification to show the user that someone has seen his profile.
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:10];
        notification.alertBody = @"Feedback on your recent Razorfish interview.";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = @"View";
        notification.hasAction = YES;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)requestMe
{
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,phonetic-last-name,location:(country:(code)),industry,distance,current-status,skills,phone-numbers,date-of-birth,main-address,positions,educations:(school-name,field-of-study,start-date,end-date,degree,activities))?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
        {
            NSLog(@"current user %@", result);
            //Set the properties values to the UserObject
            userObject = [[UserObject alloc] init];
            [userObject setFirstName:[result objectForKey:@"firstName"]];
            [userObject setLastName:[result objectForKey:@"lastName"]];
            NSDictionary * dictPositions = [result objectForKey:@"positions"];
            NSArray * arrPositions = [dictPositions objectForKey:@"values"];
            NSDictionary * currentPosition = [arrPositions objectAtIndex:0];
            [userObject setCompany:[[currentPosition objectForKey:@"company"] objectForKey:@"name"]];
            [userObject setPosition:[currentPosition objectForKey:@"title"]];
            lblFullName.text = [NSString stringWithFormat:@"%@ %@",[userObject firstName],[userObject lastName]];
            lblPosition.text = [NSString stringWithFormat:@"%@ @ %@", [userObject position],[userObject company]];
            //Extract the user skills from the result dictionary
            for (NSMutableDictionary *dictSkillsValues in [[result objectForKey:@"skills"] objectForKey:@"values"]) {
                SkillObject *linkedInSkillObject = [[SkillObject alloc] init];
                [linkedInSkillObject setIdSkill:[[dictSkillsValues objectForKey:@"id"] intValue]];
                [linkedInSkillObject setSkillName:[[dictSkillsValues objectForKey:@"skill"] objectForKey:@"name"]];
                [linkedInSkillObject setIsLinkedInSkill:YES];
                [arrLinkedInSkills addObject:linkedInSkillObject];
            }
            //Copy LinkedInSkills into general Skills array
            arrSkills = [arrLinkedInSkills mutableCopy];
            [collSkills reloadData];
            [self requestProfilePicture];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
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
    return [arrSkills count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strIdentifier = @"SkillCell";
    SkillCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:strIdentifier forIndexPath:indexPath];
    //Set the SkillObject
    SkillObject *cellSkillObject = [arrSkills objectAtIndex:indexPath.row];
    [[cell lblSkill] setText:[cellSkillObject skillName]];
    [[cell btnRemove] setFrame:CGRectMake(10, 0, 40, 40)];
    [[cell btnRemove] setTag: [indexPath row]];
    [[cell btnRemove] addTarget:self action:@selector(doRemoveSkill:) forControlEvents:UIControlEventTouchUpInside];
    [[cell layer] setBorderWidth: 0.6f];
    [[cell layer] setBorderColor:[[UIColor grayColor] CGColor]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [(NSString*)[[arrSkills objectAtIndex:[indexPath row]] skillName] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    size.width += 34;
    return size;
}

-(void)doRemoveSkill:(id)sender
{
    //Ask for user confirmation to delete a skill from the list
    SkillObject * tmpSkillObject = [arrSkills objectAtIndex:[(UIButton*)sender tag]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:[NSString stringWithFormat:@"Do you want to delete: %@ from skills list?",[tmpSkillObject skillName]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert setTag:[(UIButton*)sender tag]];
    [alert show];
}

#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSMutableArray * tmpArrSkills = [arrSkills mutableCopy];
        [tmpArrSkills removeObjectAtIndex:[alertView tag]];
        arrSkills = tmpArrSkills;
        //Update orignal arrays before push the RazorFishViewController
        [arrSelectedSkills removeAllObjects];
        [arrLinkedInSkills removeAllObjects];
        for (SkillObject *tmpSkillObject in arrSkills) {
            if ([tmpSkillObject isLinkedInSkill]) {
                [arrLinkedInSkills addObject:tmpSkillObject];
            }else{
                [arrSelectedSkills addObject:tmpSkillObject];
            }
        }
        [collSkills reloadData];
    }
}

#pragma mark -- Set selected skills delegate
-(void)doSetSelectedRazorFishSkills:(NSMutableArray*)arrReceivedSelectedSkills;
{
    //Check for selected Skills from arrReceivedSelectedSkills which cointans all the skills displayed to select by user
    if ([arrReceivedSelectedSkills count] > 0) {
        //Clean the main skills array
        [arrSkills removeAllObjects];
        //Insert the skills selected by user from Razorfish to main skills array
        for (SkillObject *razorfishSkillObject in arrReceivedSelectedSkills) {
            if ([razorfishSkillObject isSelected])
            {
                [arrSkills addObject:razorfishSkillObject];
            }
        }
        //Insert the LinkedIn skills to main skills array
        for (SkillObject *linkedinSkillObject in arrLinkedInSkills) {
            [arrSkills addObject:linkedinSkillObject];
        }
    }
}

#pragma mark -- Delegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(segue.identifier != nil)
    {
        RazorFishSkillsViewController * rfSVC = [segue destinationViewController];
        [rfSVC setLinkedInDelegate:(id)self];
        [rfSVC setViewOrigin:@"LinkedInProfileViewController"];
        [rfSVC doLoadSkills:[DBManager getSkills] withSelectedSkills:arrSelectedSkills];
    }
}
@end
