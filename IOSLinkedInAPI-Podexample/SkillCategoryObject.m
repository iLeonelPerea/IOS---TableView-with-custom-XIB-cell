//
//  SkillCategoryObject.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Crowd on 10/13/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "SkillCategoryObject.h"

@implementation SkillCategoryObject

@synthesize idSkillCategory, skillCategoryDescription;

#pragma mark -- Custom init method
//Modify init method to set defaults properties values
-(id)init
{
    self = [super init];
    if (self) {
        self.idSkillCategory = 0;
        self.skillCategoryDescription = @"";
    }
    return self;
}

//Create a init method with code to let store in defaults
-(id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (self) {
        self.idSkillCategory = [coder decodeIntForKey:@"idSkillCategory"];
        self.skillCategoryDescription = [coder decodeObjectForKey:@"skillCategoryDescription"];
    }
    return self;
}

#pragma mark -- Encode object method
-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeInt:idSkillCategory forKey:@"idSkillCategory"];
    [coder encodeObject:skillCategoryDescription forKey:@"skillCategoryDescription"];
}

#pragma mark -- Assign object method
-(SkillCategoryObject*)assignSkillCategoryObject:(NSMutableDictionary*)dictSkillCategory
{
    SkillCategoryObject *newSkillCategoryObject = [[SkillCategoryObject alloc] init];
    [newSkillCategoryObject setIdSkillCategory:[[dictSkillCategory objectForKey:@"idSkillCategory"] intValue]];
    [newSkillCategoryObject setSkillCategoryDescription:([dictSkillCategory objectForKey:@"skillCategoryDescription"] != [NSNull null])?[dictSkillCategory objectForKey:@"skillCategoryDescription"]:@""];
    return newSkillCategoryObject;
}

@end
