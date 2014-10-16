//
//  DBManager.m
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 9/1/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@implementation DBManager

#pragma mark -- DB base methods
+(BOOL)checkOrCreateDataBase{
    BOOL isDbOk;
    NSFileManager *fmngr = [[NSFileManager alloc] init];
    if([fmngr fileExistsAtPath:[DBManager getDBPath]])
    {
        isDbOk = YES;
        return isDbOk;
    }
    NSString * filePath=[[NSBundle mainBundle] pathForResource:@"razorfish" ofType:@"sqlite3"];
    NSError *error;
    isDbOk = [fmngr copyItemAtPath:filePath toPath:[NSString stringWithFormat:@"%@/Documents/razorfish.sqlite3", NSHomeDirectory()] error:&error];
    if(!isDbOk) {
        // handle the error
        NSLog(@"Error creating the database: %@", [error description]);
        
    }
    return isDbOk;
}

+(NSString*)getDBPath
{
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"razorfish.sqlite3"]];
    NSLog(@"db path: %@", databasePath);
    return databasePath;
}

+(void)finalizeStatements:(sqlite3_stmt*)stm withDB:(sqlite3*)DB
{
    sqlite3_finalize(stm);
    sqlite3_close(DB);
}

#pragma mark -- Get skills from database
//Get the skills store in local DB.
+(NSMutableArray*)getSkills
{
    sqlite3 *appDB = nil;
    sqlite3_stmt *statement;
    const char *dbPath = [[DBManager getDBPath] UTF8String] ;
    NSMutableArray *dictToReturn = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbPath, &appDB) == SQLITE_OK) {
        NSString *selectSQL = @"SELECT A.ID_SKILL, A.SKILL_NAME, A.ID_CATEGORY, B.CATEGORY_DESCRIPTION FROM SKILLS AS A LEFT JOIN SKILLS_CATEGORIES AS B ON B.ID_CATEGORY = A.ID_CATEGORY";
        const char *selectStmt = [selectSQL UTF8String];
        sqlite3_prepare_v2(appDB, selectStmt, -1, &statement, nil);
        while (sqlite3_step(statement) != SQLITE_DONE) {
            SkillObject *newSkillObject = [[SkillObject alloc] init];
            [newSkillObject setIdSkill:sqlite3_column_int(statement, 0)];
            [newSkillObject setSkillName:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]];
            SkillCategoryObject *newSkillCategoryObject =  [[SkillCategoryObject alloc] init];
            [newSkillCategoryObject setIdSkillCategory:sqlite3_column_int(statement, 2)];
            [newSkillCategoryObject setSkillCategoryDescription:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)]];
            [newSkillObject setSkillCategoryObject:newSkillCategoryObject];
            [dictToReturn addObject:newSkillObject];
        }
        [DBManager finalizeStatements:statement withDB:appDB];
    }
    
    return dictToReturn;
}

#pragma mark -- Get feedback questions from database
//Get the questions store in local DB.
+(NSMutableArray*)getQuestions
{
    sqlite3 *appDB = nil;
    sqlite3_stmt *statement;
    const char *dbPath = [[DBManager getDBPath] UTF8String] ;
    NSMutableArray *dictToReturn = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbPath, &appDB) == SQLITE_OK) {
        NSString *selectSQL = @"SELECT * FROM FEEDBACK_QUESTIONS";
        const char *selectStmt = [selectSQL UTF8String];
        sqlite3_prepare_v2(appDB, selectStmt, -1, &statement, nil);
        while (sqlite3_step(statement) != SQLITE_DONE) {
            QuestionObject *newQuestionObject = [[QuestionObject alloc] init];
            [newQuestionObject setIdQuestion:sqlite3_column_int(statement, 0)];
            [newQuestionObject setDescription:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]];
            newQuestionObject.questionAnswerObject = [self getQuestionsAnswers:newQuestionObject.idQuestion];
            [dictToReturn addObject:newQuestionObject];
        }
        [DBManager finalizeStatements:statement withDB:appDB];
    }
    return dictToReturn;
}

//Get the answers store in local DB.
+(NSMutableArray*)getQuestionsAnswers:(int)idQuestion
{
    sqlite3 *appDB = nil;
    sqlite3_stmt *statement;
    const char *dbPath = [[DBManager getDBPath] UTF8String] ;
    NSMutableArray *dictToReturn = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbPath, &appDB) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM FEEDBACK_QUESTIONS_ANSWERS WHERE ID_QUESTION = %d",idQuestion];
        const char *selectStmt = [selectSQL UTF8String];
        sqlite3_prepare_v2(appDB, selectStmt, -1, &statement, nil);
        while (sqlite3_step(statement) != SQLITE_DONE) {
            QuestionAnswerObject *newAnswerQuestionObject = [[QuestionAnswerObject alloc] init];
            [newAnswerQuestionObject setIdQuestion:sqlite3_column_int(statement, 0)];
            [newAnswerQuestionObject setIdAnswer:sqlite3_column_int(statement, 1)];
            [newAnswerQuestionObject setAnswerDescription:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)]];
            [dictToReturn addObject:newAnswerQuestionObject];
        }
        [DBManager finalizeStatements:statement withDB:appDB];
    }
    return dictToReturn;
}

/*
#pragma mark -- User methods
+(void)insertUser:(UserObject *)user{
    sqlite3 *inventoryDB = nil;
    const char *dbpath = [[DBManager getDBPath] UTF8String];
    if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
        sqlite3_stmt *statement;
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO USERS (ID_USER, FIRST_NAME, LAST_NAME) VALUES (\"%d\", \"%@\", \"%@\")", user.idUser, user.firstName, user.lastName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(inventoryDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"fiel error... %s - %d", sqlite3_errmsg(inventoryDB),user.idUser);
        }
        [DBManager finalizeStatements:statement withDB:inventoryDB];
    }
}
*/


@end
