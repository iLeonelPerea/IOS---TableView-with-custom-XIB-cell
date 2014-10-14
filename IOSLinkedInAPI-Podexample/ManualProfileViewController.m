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

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Test text");
    NSLog(@"%@",arrSelectedSkills);
}

-(void)doSetSelectedSkills:(NSMutableArray*)arrReceivedSelectedSkills;
{
    arrSelectedSkills = arrReceivedSelectedSkills;
    NSLog(@"%@",arrReceivedSelectedSkills);
}

@end
