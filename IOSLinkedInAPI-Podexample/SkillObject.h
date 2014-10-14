//
//  SkillObject.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Leonel Roberto Perea Trejo on 10/7/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillCategoryObject.h"

@interface SkillObject : NSObject

@property (nonatomic, assign) int idSkill;
@property (nonatomic, strong) NSString *skillName;
@property (nonatomic, strong) SkillCategoryObject *skillCategoryObject;
@property (nonatomic, assign) BOOL isSelected;

@end
