//
//  UserObject.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Leonel Roberto Perea Trejo on 10/7/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property(nonatomic, assign) int idUser;
@property(nonatomic, strong) NSString * firstName;
@property(nonatomic, strong) NSString * lastName;
@property(nonatomic, strong) NSMutableArray * skills;

@end