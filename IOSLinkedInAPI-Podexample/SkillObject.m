//
//  SkillObject.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Leonel Roberto Perea Trejo on 10/7/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "SkillObject.h"

@implementation SkillObject

@synthesize idSkill, skillName, skillCategoryObject, isLinkedInSkill, isSelected;

#pragma mark -- Custom init method
//Modify Init method to set defaults properties values
-(id)init
{
    self = [super init];
    if (self) {
        self.idSkill = 0;
        self.skillName = @"";
        SkillCategoryObject *newSkillCategoryObject = [[SkillCategoryObject alloc] init];
        self.skillCategoryObject = newSkillCategoryObject;
        self.isLinkedInSkill = NO;
        self.isSelected = NO;
    }
    return self;
}

//Create a customo init method for object with a coder
-(id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (self) {
        self.idSkill = [coder decodeIntForKey:@"idSkill"];
        self.skillName = [coder decodeObjectForKey:@"skillName"];
        self.isLinkedInSkill = [coder decodeBoolForKey:@"isLinkedInSkill"];
        self.isSelected = [coder decodeBoolForKey:@"isSelected"];
    }
    return self;
}

#pragma mark -- Encode method object
-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeInt:idSkill forKey:@"idSkill"];
    [coder encodeObject:skillName forKey:@"skillName"];
    [coder encodeBool:isLinkedInSkill forKey:@"isLinkedInSkill"];
    [coder encodeBool:isSelected forKey:@"isSelected"];
}

#pragma mark -- Assign object method
-(SkillObject*)assignSkillObject:(NSMutableDictionary*)dictSkill
{
    SkillObject *newSkillObject = [[SkillObject alloc] init];
    [newSkillObject setIdSkill:[[dictSkill objectForKey:@"idSkill"] intValue]];
    [newSkillObject setSkillName:([dictSkill objectForKey:@"skillName"] != [NSNull null])?[dictSkill objectForKey:@"skillName"]:@""];
    return newSkillObject;
}

@end
