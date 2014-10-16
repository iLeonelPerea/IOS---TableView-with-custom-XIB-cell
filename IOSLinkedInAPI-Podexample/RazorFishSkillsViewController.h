//
//  RazorFishSkillsViewController.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManualProfileViewController.h"

@interface RazorFishSkillsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
// properties
@property (nonatomic, strong) NSMutableArray * arrSkills;
@property (nonatomic, strong) NSMutableArray * arrSkillsSearched;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;
@property (nonatomic, strong) IBOutlet UITableView * tblSkills;
@property (nonatomic, strong) id<iInfoDelegate> delegate;
@property (nonatomic, assign) BOOL isSearchVisible;
@property (nonatomic, assign) BOOL isSearching;

-(void)doLoadSkills:(NSMutableArray*)arrAllSkills withSelectedSkills:(NSMutableArray*)arrSelectedSkills;

@end
