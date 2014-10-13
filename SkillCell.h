//
//  SkillCell.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/10/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UILabel * lblSkill;
@property (nonatomic, strong) IBOutlet UIButton * btnRemove;
@end
