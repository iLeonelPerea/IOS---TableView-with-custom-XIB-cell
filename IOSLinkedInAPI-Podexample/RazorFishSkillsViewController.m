//
//  RazorFishSkillsViewController.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "RazorFishSkillsViewController.h"
#import "DBManager.h"

@interface RazorFishSkillsViewController ()

@end

@implementation RazorFishSkillsViewController
@synthesize tblSkills, arrSkills, arrSkillsSearched, isSearching, isSearchVisible, searchBar, viewOrigin;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem * btnSave = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doSaveSelectedSkills:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    [searchBar setDelegate:self];
    [tblSkills setDelegate:self];
    [tblSkills setDataSource:self];
    [tblSkills reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- Save button delegate
-(void)doSaveSelectedSkills:(UIBarButtonItem*)sender
{
    if ([viewOrigin isEqualToString:@"ManualViewProfileViewController"]) {
        [self.delegate doSetSelectedSkills:arrSkills];
    }
    if ([viewOrigin isEqualToString:@"LinkedInProfileViewController"]) {
        [self.linkedInDelegate doSetSelectedRazorFishSkills:arrSkills];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Load skills delegate
-(void)doLoadSkills:(NSMutableArray*)arrAllSkills withSelectedSkills:(NSMutableArray*)arrSelectedSkills;
{
    //Receive all the skills from the DB and check and mark the selected skills specified in arrSelectedSkills. Store all the skills into arrSkills to display them.
    if ([arrSelectedSkills count] > 0) {
        for (SkillObject *selectedSkilObject in arrSelectedSkills) {
            for (SkillObject *originalSkillObject in arrAllSkills) {
                ([selectedSkilObject idSkill] == [originalSkillObject idSkill])?[originalSkillObject setIsSelected:YES]:nil;
            }
        }
    }
    //arrSkills store all the skills from database and arrSkillsSearched store all or seearched skills by user
    arrSkills = [arrAllSkills mutableCopy];
    arrSkillsSearched = [arrSkills mutableCopy];
}

#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSkillsSearched count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellSkill";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //Extract SkillObject from arrSkillsSearched
    SkillObject *skillObject = [[SkillObject alloc] init];
    skillObject = [arrSkillsSearched objectAtIndex:[indexPath row]];
    
    UILabel *lblSkillName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 21)];
    [lblSkillName setText:[skillObject skillName]];
    [cell addSubview:lblSkillName];
    
    UISwitch *schSelect = [[UISwitch alloc] initWithFrame:CGRectMake(240, 5, 20, 21)];
    [schSelect setTag:[indexPath row]];
    [schSelect setOn:[skillObject isSelected]];
    [schSelect addTarget:self action:@selector(didSelectedSkill:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:schSelect];
    
    return cell;
}

#pragma mark -- Switch select skill delegate
-(void)didSelectedSkill:(id)sender
{
    UISwitch *senderSwitch = (UISwitch*)sender;
    SkillObject * selectedSkill = [arrSkillsSearched objectAtIndex:[senderSwitch tag]];
    [selectedSkill setIsSelected:[senderSwitch isOn]];
}

#pragma mark -- Search bar delegate
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    if (searchText && [searchText length] > 2) {
        [arrSkillsSearched removeAllObjects];
        for (SkillObject *skillObjectSearched in arrSkills) {
            if ([[skillObjectSearched skillName] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [arrSkillsSearched addObject:skillObjectSearched];
            }
        }
        isSearching = YES;
    }else{
        arrSkillsSearched = [arrSkills mutableCopy];
        isSearching = NO;
    }
    [tblSkills reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [[self searchBar] resignFirstResponder];
    isSearching = NO;
    arrSkillsSearched = [arrSkills mutableCopy];
    [tblSkills reloadData];
}

@end
