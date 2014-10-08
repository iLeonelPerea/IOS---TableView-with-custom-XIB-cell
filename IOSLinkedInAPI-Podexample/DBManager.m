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
    sqlite3 *inventoryDB;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //const char *dbpath = [[DBManager getDBPath] UTF8String];
    if([filemgr fileExistsAtPath:[DBManager getDBPath]] == NO){
        const char *dbpath = [[DBManager getDBPath] UTF8String];
        if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS USERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ID_USER INTEGER, FIRST_NAME TEXT, LAST_NAME TEXT); CREATE TABLE IF NOT EXISTS SKILS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ID_USER INTEGER, ID_SKILL INTEGER, SKILL TEXT);";
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
    return isDbOk;
}

+(NSString*)getDBPath
{
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"Linkedin.sqlite3"]];
    
    return databasePath;
}

+(void)finalizeStatements:(sqlite3_stmt*)stm withDB:(sqlite3*)DB
{
    sqlite3_finalize(stm);
    sqlite3_close(DB);
}

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

@end
