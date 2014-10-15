//
//  ManualProfileViewController.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillObject.h"
#import "DBManager.h"
#import "SkillCell.h"

@protocol iInfoDelegate <NSObject>
-(void)doSetSelectedSkills:(NSMutableArray*)arrReceivedSelectedSkills;
@end

@interface ManualProfileViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrSelectedSkills;
@property (nonatomic, strong) IBOutlet UICollectionView *collSkills;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;

@end