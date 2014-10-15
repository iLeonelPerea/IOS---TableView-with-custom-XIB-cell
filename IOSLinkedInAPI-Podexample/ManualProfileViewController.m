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
@synthesize arrSelectedSkills, collSkills, lblTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [collSkills setDataSource:self];
    [collSkills setDelegate:self];
    [self setTitle:@"Profile"];
    arrSelectedSkills = [[NSMutableArray alloc] init];
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SkillObject *collectionSkillObject = [arrSelectedSkills objectAtIndex:[indexPath row]];
    NSString *strSkill = [collectionSkillObject skillName];
    CGSize size = [(NSString*)strSkill sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
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
