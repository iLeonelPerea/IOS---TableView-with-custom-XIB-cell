//
//  DBManager.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 9/1/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+(BOOL)checkOrCreateDataBase;
+(void)insertProduct:(NSDictionary *)product;
+(void)updateProduct:(NSMutableDictionary *)product;
+(void)updateProductRate:(int)rate withId:(int)productId;
+(void)updateProductComment:(NSString*)comment withId:(int)productId;
@end
