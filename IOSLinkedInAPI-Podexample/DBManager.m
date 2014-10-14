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
    /*
    sqlite3 *inventoryDB;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //const char *dbpath = [[DBManager getDBPath] UTF8String];
    if([filemgr fileExistsAtPath:[DBManager getDBPath]] == NO){
        const char *dbpath = [[DBManager getDBPath] UTF8String];
        if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS USERS (ID_USER INTEGER PRIMARY KEY AUTOINCREMENT, FIRST_NAME TEXT, LAST_NAME TEXT, COMPANY TEXT, POSITION TEXT); CREATE TABLE IF NOT EXISTS USER_SKIlLS (ID_USER INTEGER, ID_SKILL INTEGER); CREATE TABLE IF NOT EXISTS FEEDBACK (ID_FEEDBACK INTEGER PRIMARY KEY AUTOINCREMENT, ID_USER INTEGER, ID_INTERVIEWER INTEGER, DATE_FEEDBACK DOUBLE); CREATE TABLE IF NOT EXISTS FEEDBACK_DETAIL (ID_FEEDBACK INTEGER, ID_QUESTION INTEGER, ID_ANSWER INTEGER); CREATE TABLE IF NOT EXISTS FEEDBACK_QUESTIONS (ID_QUESTION INTEGER PRIMARY KEY AUTOINCREMENT, QUESTION_DESCRIPTION TEXT NOT NULL); CREATE TABLE IF NOT EXISTS FEEDBACK_QUESTIONS_ANSWERS (ID_QUESTION INTEGER, ID_ANSWER INTEGER, ANSWER_DESCRIPTION TEXT NOT NULL); CREATE TABLE IF NOT EXISTS SKILLS (ID_SKILL INTEGER PRIMARY KEY AUTOINCREMENT, ID_CATEGORY INTEGER, SKILL_NAME TEXT NOT NULL); CREATE TABLE IF NOT EXISTS SKILLS_CATEGORIES (ID_CATEGORY INTEGER PRIMARY KEY AUTOINCREMENT, CATEGORY_DESCRIPTION TEXT NOT NULL);";
            if (sqlite3_exec(inventoryDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                isDbOk = NO;
                NSLog(@"table fail...");
            }else{
                isDbOk = YES;
            }
            [DBManager finalizeStatements:nil withDB:inventoryDB];
        }else{
            NSLog(@"db fail...");
            isDbOk = NO;
        }
    }else{
        isDbOk = YES; // DB already exists
    }
     */
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

#pragma mark -- Skill methods
+(void)insertSkill:(UserObject *)user withSkill:(SkillObject *)skill{
    sqlite3 *inventoryDB = nil;
    const char *dbpath = [[DBManager getDBPath] UTF8String];
    if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
        sqlite3_stmt *statement;
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO SKILLS (ID_USER, ID_SKILL, SKILL) VALUES (\"%d\", \"%d\", \"%@\")", user.idUser, skill.idSkill, skill.skill];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(inventoryDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"fiel error... %s - %d", sqlite3_errmsg(inventoryDB),user.idUser);
        }
        [DBManager finalizeStatements:statement withDB:inventoryDB];
    }
}

+(BOOL)checkIfExistSkill:(UserObject *)user withSkill:(SkillObject *)skill{
    sqlite3 *appDB;
    sqlite3_stmt *statement;
    const char *dbPath = [[DBManager getDBPath] UTF8String];
    
    NSString *selectState = [NSString stringWithFormat:@"SELECT * FROM SKILLS WHERE ID_USER = %d AND ID_SKILL = %d", user.idUser, skill.idSkill];
    const char *selectStatement = [selectState UTF8String];
    if (sqlite3_open(dbPath, &appDB) == SQLITE_OK) {
        if (sqlite3_prepare_v2(appDB, selectStatement, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                return YES;
            }
            [DBManager finalizeStatements:statement withDB:appDB];
        }else
            return NO;
    }else
        return NO;
    return NO;
}

+(NSMutableArray *)getSkills
{
    NSMutableArray * arrToRet = [NSMutableArray new];
    return arrToRet;
}*/

@end
