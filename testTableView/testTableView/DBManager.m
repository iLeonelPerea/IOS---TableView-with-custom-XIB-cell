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

+(BOOL)checkOrCreateDataBase{
    BOOL isDbOk;
    sqlite3 *inventoryDB;

    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:[DBManager getDBPath]] == NO){
        const char *dbpath = [[DBManager getDBPath] UTF8String];
        
        if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS FOODS (ID INTEGER PRIMARY KEY AUTOINCREMENT, REMOTE_ID INTEGER, NAME TEXT, DESCRIPTION TEXT, CATEGORY TEXT, MENU_TYPE TEXT, PRICE FLOAT, URL_PIC TEXT, URL_THUMB TEXT, LOCAL_THUMB TEXT, LOCAL_PIC TEXT, RECOMMENDATIONS BLOB, DESCRIPTION_ES TEXT, DESCRIPTION_HE TEXT, NAME_RU TEXT, DESCRIPTION_RU TEXT, NAME_FR TEXT, DESCRIPTION_FR TEXT, NAME_CN TEXT, DESCRIPTION_CN TEXT, NAME_JP TEXT, DESCRIPTION_JP TEXT, NAME_DE TEXT, DESCRIPTION_DE TEXT, NAME_IT TEXT, DESCRIPTION_IT TEXT, NAME_ARABIC TEXT, DESCRIPTION_ARABIC TEXT, NAME_IR TEXT, DESCRIPTION_IR TEXT, NAME_HI TEXT, DESCRIPTION_HI TEXT, SORT_ID INTEGER, RATE TEXT, COMMENT TEXT)";
            if (sqlite3_exec(inventoryDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                isDbOk = NO;
                NSLog(@"table fail...");
            }else{
                isDbOk = YES;
            }
            const char* sql_stmt_wishlists = "CREATE TABLE IF NOT EXISTS WISHLIST (ID INTEGER PRIMARY KEY AUTOINCREMENT, FOOD_ID INTEGER, FOOD_NAME TEXT, FOOD_DES TEXT, FOOD_PRICE FLOAT, FOOD_QUANTITY INTEGER, TABLE_NUM INTEGER, STATUS INTEGER, ISSUED BOOL, TOKEN_ID TEXT)";
            if (sqlite3_exec(inventoryDB, sql_stmt_wishlists, NULL, NULL, &errMsg) != SQLITE_OK) {
                isDbOk = NO;
                NSLog(@"wishlist table fail...");
            }else{
                isDbOk = YES;
            }
            //sqlite3_close(inventoryDB);
        }else{
            NSLog(@"db fail...");
            isDbOk = NO;
        }
    }else{
        isDbOk = YES; // DB already exists
    }
    [DBManager finalizeStatements:nil withDB:inventoryDB];
    return isDbOk;
}

+(void)insertProduct:(NSDictionary*)product{
    sqlite3 *inventoryDB = nil;
    sqlite3_stmt *statement;
    
    const char *dbpath = [[DBManager getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO FOODS (remote_id, name, description, category, menu_type, price, url_pic, url_thumb, local_thumb, local_pic, description_es, description_he, sort_id) VALUES (\"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%.2f\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\")", [[product objectForKey:@"id"] intValue], [product objectForKey:@"name"], [product objectForKey:@"description"], [product objectForKey:@"category"], [product objectForKey:@"menu"], ([product objectForKey:@"price"] != [NSNull null])?[[product objectForKey:@"price"] floatValue]:0, [product objectForKey:@"picture"], [product objectForKey:@"picture_thumb"], ([product objectForKey:@"picture_thumb"] != [NSNull null])?[NSString stringWithFormat:@"thumb_%@.jpg",[product objectForKey:@"id"]]: [NSNull null], ([product objectForKey:@"picture"] != [NSNull null])?[NSString stringWithFormat:@"pic_%@.jpg", [product objectForKey:@"id"]]: [NSNull null], [product objectForKey:@"description_es"], [product objectForKey:@"description_he"], [[product objectForKey:@"position"] intValue]];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(inventoryDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"fiel error... %s - %@", sqlite3_errmsg(inventoryDB),[product objectForKey:@"id"]);
        }
    }
    [DBManager finalizeStatements:statement withDB:inventoryDB];
}

+(void)updateProduct:(NSMutableDictionary *)product{
    sqlite3 *inventoryDB;
    sqlite3_stmt *statement;
    const char *dbpath = [[DBManager getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
        NSString * updateSQL = [NSString stringWithFormat:@"UPDATE FOODS SET RATE = \"%@\" , COMMENT = \"%@\" WHERE remote_id = \"%d\"", [product objectForKey:@"rate"], [product objectForKey:@"comment"], [[product objectForKey:@"id"] intValue]];
        const char *insert_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(inventoryDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"fiel error... %s - %@", sqlite3_errmsg(inventoryDB),[product objectForKey:@"id"]);
        }
    }
    [DBManager finalizeStatements:statement withDB:inventoryDB];
}

+(void)updateProductComment:(NSString *)comment withId:(int)productId
{
    sqlite3 *inventoryDB;
    sqlite3_stmt *statement;

    const char *dbpath = [[DBManager getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
        NSString * updateSQL = [NSString stringWithFormat:@"UPDATE FOODS SET COMMENT = \'%@\' WHERE remote_id = \"%d\"", comment, productId];
        const char * update_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(inventoryDB, update_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Fail error... %s - %d", sqlite3_errmsg(inventoryDB), productId);
        }
    }
    [DBManager finalizeStatements:statement withDB:inventoryDB];
}

+(void)updateProductRate:(int)rate withId:(int)productId
{
    sqlite3 *inventoryDB;
    sqlite3_stmt *statement;
    
    const char *dbpath = [[DBManager getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE FOODS SET RATE = \"%@\" WHERE remote_id = \"%d\"", [NSString stringWithFormat:@"%d", rate], productId];
        const char *insert_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(inventoryDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"fiel error... %s - %d", sqlite3_errmsg(inventoryDB), productId);
        }
    }
    [DBManager finalizeStatements:statement withDB:inventoryDB];
}

+(NSDictionary *)getProductWithId:(int)productId
{
    sqlite3 * inventoryDB;
    sqlite3_stmt * statement;
    const char * dbpath = [[DBManager getDBPath] UTF8String];
    NSMutableDictionary * dictToReturn;
    
    NSString * selectFoodSQL = [NSString stringWithFormat: @"SELECT * FROM FOODS WHERE remote_id = \"%d\"", productId];
    
    const char * select_stmt = [selectFoodSQL UTF8String];
    if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
        if(sqlite3_prepare_v2(inventoryDB, select_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            dictToReturn = [NSMutableDictionary new];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [dictToReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)] forKey:@"name"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 33))?[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 33)]:@"" forKey:@"rate"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 34))?[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 34)]:@"" forKey:@"comment"];
            }
            [DBManager finalizeStatements:statement withDB:inventoryDB];
            return dictToReturn;
        }
        else
            return nil;
    }
    else
        return nil;
}

+(NSMutableArray *)getProducts
{
    sqlite3 * inventoryDB;
    sqlite3_stmt * statement;
    const char * dbpath = [[DBManager getDBPath] UTF8String];
    NSMutableDictionary * dictToReturn;
    NSMutableArray * arrToReturn = [NSMutableArray new];
    
    NSString * selectFoodSQL = [NSString stringWithFormat: @"SELECT * FROM FOODS"];
    
    const char * select_stmt = [selectFoodSQL UTF8String];
    if (sqlite3_open(dbpath, &inventoryDB) == SQLITE_OK) {
        if(sqlite3_prepare_v2(inventoryDB, select_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                dictToReturn = [NSMutableDictionary new];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 1))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]:@"" forKey:@"remote_id"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 2))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]:@"" forKey:@"name"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 3))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]:@"" forKey:@"description"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 4))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]:@"" forKey:@"category"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 5))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]:@"" forKey:@"menu_type"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 6))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]:@"" forKey:@"price"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 7))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]:@"" forKey:@"picture"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 8))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]:@"" forKey:@"picture_thumb"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 9))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]:@"" forKey:@"local_thumb"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 10))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]:@"" forKey:@"local_pic"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 11))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)]:@"" forKey:@"recommendations"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 12))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)]:@"" forKey:@"description_es"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 13))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)]:@"" forKey:@"description_he"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 14))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)]:@"" forKey:@"name_ru"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 15))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)]:@"" forKey:@"description_ru"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 16))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)]:@"" forKey:@"name_fr"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 17))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)]:@"" forKey:@"description_fr"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 18))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)]:@"" forKey:@"name_cn"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 19))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)]:@"" forKey:@"description_cn"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 20))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)]:@"" forKey:@"name_jp"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 21))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)]:@"" forKey:@"description_jp"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 22))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)]:@"" forKey:@"name_de"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 23))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)]:@"" forKey:@"description_de"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 24))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)]:@"" forKey:@"name_it"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 25))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)]:@"" forKey:@"description_it"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 26))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)]:@"" forKey:@"name_arabic"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 27))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)]:@"" forKey:@"description_arabic"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 28))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)]:@"" forKey:@"name_ir"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 29))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)]:@"" forKey:@"description_ir"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 30))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)]:@"" forKey:@"name_hi"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 31))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)]:@"" forKey:@"description_hi"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 32))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)]:@"" forKey:@"sort_id"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 33))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)]:@"" forKey:@"rate"];
                [dictToReturn setObject:((char *)sqlite3_column_text(statement, 34))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)]:@"" forKey:@"comment"];
                [arrToReturn addObject:dictToReturn];
            }
            [DBManager finalizeStatements:statement withDB:inventoryDB];
            return arrToReturn;
        }
        else
            return nil;
    }
    else
        return nil;
}


+(NSString*)getDBPath
{
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"Inventory.sqlite3"]];
    
    return databasePath;
}

+(void)finalizeStatements:(sqlite3_stmt*)stm withDB:(sqlite3*)DB
{
    sqlite3_finalize(stm);
    sqlite3_close(DB);
}

@end
