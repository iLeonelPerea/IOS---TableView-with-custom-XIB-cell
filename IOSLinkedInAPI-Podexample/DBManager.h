//
//  DBManager.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 9/1/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObject.h"
#import "SkillObject.h"
#import "QuestionObject.h"
#import "QuestionAnswerObject.h"

@interface DBManager : NSObject

+(BOOL)checkOrCreateDataBase;
+(NSString*)getDBPath;
+(NSMutableArray*)getSkills;
+(UserObject*)insertUser:(UserObject*)userObject withLinkedInSkills:(BOOL)isWithLinkedInSkills;
+(void)insertUserSkills:(NSMutableArray*)arrUserSkills withUserId:(int)userId;
+(void)insertLinkedInUserSkills:(NSMutableArray*)arrLinkedInSkills;
+(NSMutableArray*)getQuestions;
+(NSMutableArray*)getQuestionsAnswers:(int)idQuestion;

@end
