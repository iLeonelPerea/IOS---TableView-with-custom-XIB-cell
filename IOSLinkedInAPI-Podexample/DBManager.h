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
//+(void)insertUser:(UserObject *)user;
//+(void)insertSkill:(UserObject *)user withSkill:(SkillObject *)skill;
+(NSMutableArray*)getSkills;
+(NSMutableArray*)getQuestions;
+(NSMutableArray*)getQuestionsAnswers:(int)idQuestion;

@end
