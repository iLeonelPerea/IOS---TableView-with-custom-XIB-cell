//
//  ManualProfileViewController.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "ManualProfileViewController.h"
#import "RazorFishSkillsViewController.h"

@interface ManualProfileViewController ()

@end

@implementation ManualProfileViewController
@synthesize arrSelectedSkills, collSkills, lblTitle,
            txtFirstName, txtLastName, txtCompany, txtPosition,
            kbcontrols,
            isFirstNameValid, isLastNameValid, isCompanyValid, isPositionValid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Set controls delegates
    [txtFirstName setDelegate:self];
    [txtLastName setDelegate:self];
    [txtCompany setDelegate:self];
    [txtPosition setDelegate:self];
    [collSkills setDataSource:self];
    [collSkills setDelegate:self];
    [self setTitle:@"Profile"];
    arrSelectedSkills = [[NSMutableArray alloc] init];
    //Initialize APLKeyboardControls
    NSMutableArray *kbFields = [[NSMutableArray alloc] initWithObjects:txtFirstName,txtLastName,txtCompany,txtPosition, nil];
    kbcontrols = [[APLKeyboardControls alloc] initWithInputFields:kbFields];
    [kbcontrols setHasPreviousNext:YES];
    [[kbcontrols doneButton] setTarget:self];
    [[kbcontrols doneButton] setAction:@selector(closeMePlease:)];
    //Create a Save button into navigation bar
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doSaveUser:)];
    [[self navigationItem] setRightBarButtonItem:btnSave];
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [collSkills reloadData];
    [lblTitle setHidden:([arrSelectedSkills count] > 0)?NO:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Save button delegate
-(void)doSaveUser:(UIBarButtonItem*)sender
{
    if ([arrSelectedSkills count] > 0) {
        //Create an userObject and set it properties
        UserObject *userObject = [[UserObject alloc] init];
        [userObject setFirstName:[txtFirstName text]];
        [userObject setLastName:[txtLastName text]];
        [userObject setCompany:[txtCompany text]];
        [userObject setPosition:[txtPosition text]];
        [userObject setSkills:[arrSelectedSkills mutableCopy]];
        //Call the method to insert the user, if receive 0, the user wasn't added into DB. Specify that skills aren't from LinkedIn
        userObject = [DBManager insertUser:userObject withLinkedInSkills:NO];
        if (![userObject idUser] > 0) {
            UIAlertView *alertInsertError = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Check your information to perform the action again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
            [alertInsertError show];
        }else{
            //Create a local notification
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            [notification setFireDate:[[NSDate alloc] initWithTimeIntervalSinceNow:10]];
            [notification setAlertBody:@"Your profile has been seen"];
            [notification setSoundName:UILocalNotificationDefaultSoundName];
            [notification setHasAction:YES];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            //Returns to previous screen
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }else{
        UIAlertView *skillsAlert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Select skills (1 at least)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [skillsAlert show];
    }
}

-(void)closeMePlease:(id)sender
{
    //Hide on-screen keyboard
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtCompany resignFirstResponder];
    [txtPosition resignFirstResponder];
    //Check which fields are valid to set the error message
    NSString *msgInvalidFields = @"";
    if (!isFirstNameValid) {
        msgInvalidFields = [msgInvalidFields stringByAppendingString:@" First Name -"];
    }
    if (!isLastNameValid) {
        msgInvalidFields = [msgInvalidFields stringByAppendingString:@" Last Name" ];
    }
    if (!isCompanyValid) {
        msgInvalidFields = [msgInvalidFields stringByAppendingString:@" Company -"];
    }
    if (!isPositionValid) {
        msgInvalidFields = [msgInvalidFields stringByAppendingString:@" Position -"];
    }
    if ([msgInvalidFields length] > 1) {
        msgInvalidFields = [msgInvalidFields stringByAppendingString:@" Are Required"];
        UIAlertView *alertRequiredFields = [[UIAlertView alloc] initWithTitle:@"Attention" message:msgInvalidFields delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertRequiredFields show];
    }
    [self doEnableSaveButton];
}

#pragma mark -- Do enable Save button method
-(void)doEnableSaveButton
{
    [[[self navigationItem] rightBarButtonItem] setEnabled:(isFirstNameValid && isLastNameValid && isCompanyValid && isPositionValid)];
}

#pragma mark -- Textfield delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(IBAction)textFieldDidChange:(UITextField *)textField;
{
    if (textField == txtFirstName) {
        isFirstNameValid = ([[txtFirstName text] length] > 2);
    }
    if (textField == txtLastName) {
        isLastNameValid = ([[txtLastName text] length] > 2);
    }
    if (textField == txtCompany) {
        isCompanyValid = ([[txtCompany text] length]);
    }
    if (textField == txtPosition) {
        isPositionValid = ([[txtPosition text] length]);
    }
    [self doEnableSaveButton];
}

#pragma mark -- Set selected skills delegate
-(void)doSetSelectedSkills:(NSMutableArray*)arrReceivedSelectedSkills;
{
    //Check for selected Skills from arrReceivedSelectedSkills which cointans all the skills displayed to select by user
    [arrSelectedSkills removeAllObjects];
    for (SkillObject *skillObject in arrReceivedSelectedSkills) {
        if ([skillObject isSelected]) {
            [arrSelectedSkills addObject:skillObject];
        }
    }
}

#pragma mark -- Collection delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrSelectedSkills count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"SkillCell";
    SkillCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:strIdentifier forIndexPath:indexPath];
    SkillObject *skillObject = [arrSelectedSkills objectAtIndex:[indexPath row]];
    [[cell lblSkill] setText:[skillObject skillName]];
    [[cell btnRemove] setFrame:CGRectMake(10, 0, 40, 40)];
    [[cell btnRemove] setTag:[indexPath row]];
    [[cell btnRemove] addTarget:self action:@selector(doRemoveSkill:) forControlEvents:UIControlEventTouchUpInside];
    [[cell layer] setBorderWidth:0.6f];
    [[cell layer] setBorderColor:[[UIColor grayColor] CGColor]];
    return cell;
}

-(void)doRemoveSkill:(id)sender
{
    SkillObject *removeSkillObject = [arrSelectedSkills objectAtIndex:[(UIButton*)sender tag]];
    UIAlertView * alertRemoveSkill = [[UIAlertView alloc] initWithTitle:@"Confirmation!" message:[NSString stringWithFormat:@"Do you want to delete: %@ from skills list?",[removeSkillObject skillName]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertRemoveSkill setTag:[(UIButton*)sender tag]];
    [alertRemoveSkill show];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [(NSString*)[[arrSelectedSkills objectAtIndex:[indexPath row]] skillName] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    size.width += 34;
    return size;
}

#pragma mark -- Alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableArray *tmpArraySkills = [arrSelectedSkills mutableCopy];
        [tmpArraySkills removeObjectAtIndex:[alertView tag]];
        arrSelectedSkills = tmpArraySkills;
        [collSkills reloadData];
    }
}

#pragma mark -- Delegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(segue.identifier != nil)
    {
        RazorFishSkillsViewController * rfSVC = [segue destinationViewController];
        [rfSVC setDelegate:(id)self];
        [rfSVC doLoadSkills:[DBManager getSkills] withSelectedSkills:arrSelectedSkills];
    }
}

@end
