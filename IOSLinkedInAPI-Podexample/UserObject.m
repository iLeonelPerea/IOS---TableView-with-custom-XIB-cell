//
//  UserObject.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Leonel Roberto Perea Trejo on 10/7/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

@synthesize idUser, firstName, lastName, skills, company, position, feedbacks;

#pragma mark -- Custom method init
-(id)init
{
    self = [super init];
    if (self) {
        [self setIdUser:0];
        [self setFirstName:@""];
        [self setLastName:@""];
        [self setCompany:@""];
        [self setPosition:@""];
    }
    return self;
}

// Create a custom init method for object with a coder
-(id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (self) {
        [self setIdUser:[coder decodeIntForKey:@"idUser"]];
        [self setFirstName:[coder decodeObjectForKey:@"firstName"]];
        [self setLastName:[coder decodeObjectForKey:@"lastName"]];
        [self setCompany:[coder decodeObjectForKey:@"company"]];
        [self setPosition:[coder decodeObjectForKey:@"position"]];
    }
    return self;
}

#pragma mark -- Encode object method
-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeInt:idUser forKey:@"idUser"];
    [coder encodeObject:firstName forKey:@"firstName"];
    [coder encodeObject:lastName forKey:@"lastName"];
    [coder encodeObject:company forKey:@"company"];
    [coder encodeObject:position forKey:@"position"];
}

#pragma mark -- Assign object method
-(UserObject*)assignUserObject:(NSMutableDictionary*)dictUser
{
    UserObject *userObject = [[UserObject alloc] init];
    [userObject setIdUser:[[dictUser objectForKey:@"idUser"] intValue]];
    [userObject setFirstName:[dictUser objectForKey:@"firstName"]];
    [userObject setLastName:[dictUser objectForKey:@"lastName"]];
    [userObject setCompany:[dictUser objectForKey:@"company"]];
    [userObject setPosition:[dictUser objectForKey:@"position"]];
    [userObject setSkills:[dictUser objectForKey:@"skills"]];
    [userObject setFeedbacks:[dictUser objectForKey:@"feedback"]];
    return userObject;
}

@end
