//
//  ProductObject.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 9/2/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObject : NSObject

@property (nonatomic, assign) int remote_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * menu_type;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * picture;
@property (nonatomic, strong) NSString * picture_thumb;
@property (nonatomic, strong) NSString * local_thumb;
@property (nonatomic, strong) NSString * local_pic;
@property (nonatomic, strong) NSString * recommendations;
@property (nonatomic, strong) NSString * description_es;
@property (nonatomic, strong) NSString * description_he;
@property (nonatomic, strong) NSString * name_ru;
@property (nonatomic, strong) NSString * description_ru;
@property (nonatomic, strong) NSString * name_fr;
@property (nonatomic, strong) NSString * description_fr;
@property (nonatomic, strong) NSString * name_cn;
@property (nonatomic, strong) NSString * description_cn;
@property (nonatomic, strong) NSString * name_jp;
@property (nonatomic, strong) NSString * description_jp;
@property (nonatomic, strong) NSString * name_de;
@property (nonatomic, strong) NSString * description_de;
@property (nonatomic, strong) NSString * name_it;
@property (nonatomic, strong) NSString * description_it;
@property (nonatomic, strong) NSString * name_arabic;
@property (nonatomic, strong) NSString * description_arabic;
@property (nonatomic, strong) NSString * name_ir;
@property (nonatomic, strong) NSString * description_ir;
@property (nonatomic, strong) NSString * name_hi;
@property (nonatomic, strong) NSString * description_hi;
@property (nonatomic, strong) NSString * sort_id;
@property (nonatomic, strong) NSString * rate;
@property (nonatomic, strong) NSString * comment;

-(ProductObject*)assignProductObject:(NSDictionary*)dictProduct;

@end
