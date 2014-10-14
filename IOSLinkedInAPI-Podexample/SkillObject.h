//
//  SkillObject.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Leonel Roberto Perea Trejo on 10/7/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkillObject : NSObject

@property(nonatomic, assign) int idSkill;
@property(nonatomic, assign) int idCategory;
@property(nonatomic, strong) NSString * skill_name;

@end
