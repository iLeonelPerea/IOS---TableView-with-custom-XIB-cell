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
@synthesize arrSelectedSkills;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Profile"];
    arrSelectedSkills = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doSetSelectedSkills:(NSMutableArray*)arrReceivedSelectedSkills;
{
    //Check for selected Skills from arrReceivedSelectedSkills which cointans all the skills displayed to select by user
    for (SkillObject *skillObject in arrReceivedSelectedSkills) {
        if ([skillObject isSelected]) {
            [arrSelectedSkills addObject:skillObject];
        }
    }
}

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
