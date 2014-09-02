//
//  ProductObject.m
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 9/2/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ProductObject.h"

@implementation ProductObject

@synthesize remote_id, name, description, category, menu_type, price, picture, picture_thumb, local_thumb, local_pic, recommendations, description_es, description_he, name_ru, description_ru, name_fr, description_fr, name_cn, description_cn, name_jp, description_jp, name_de, description_de, name_it, description_it, name_arabic, description_arabic, name_ir, description_ir, name_hi, description_hi, sort_id, rate, comment;

-(ProductObject*)assignProductObject:(NSMutableDictionary*)dictProduct{
    ProductObject *newProductObject = [ProductObject new];
    [newProductObject setRemote_id:[[dictProduct objectForKey:@"remote_id"] intValue]];
    [newProductObject setName:[dictProduct objectForKey:@"name"]];
    [newProductObject setDescription:[dictProduct objectForKey:@"description"]];
    [newProductObject setCategory:[dictProduct objectForKey:@"category"]];
    [newProductObject setMenu_type:[dictProduct objectForKey:@"menu_type"]];
    [newProductObject setPrice:[dictProduct objectForKey:@"price"]];
    [newProductObject setPicture:[dictProduct objectForKey:@"picture"]];
    [newProductObject setPicture_thumb:[dictProduct objectForKey:@"picture_thumb"]];
    [newProductObject setLocal_thumb:[dictProduct objectForKey:@"local_thumb"]];
    [newProductObject setLocal_pic:[dictProduct objectForKey:@"local_pic"]];
    [newProductObject setRecommendations:[dictProduct objectForKey:@"recommendations"]];
    [newProductObject setDescription_es:[dictProduct objectForKey:@"description_es"]];
    [newProductObject setDescription_he:[dictProduct objectForKey:@"description_he"]];
    [newProductObject setName_ru:[dictProduct objectForKey:@"name_ru"]];
    [newProductObject setDescription_ru:[dictProduct objectForKey:@"description_ru"]];
    [newProductObject setName_fr:[dictProduct objectForKey:@"name_fr"]];
    [newProductObject setDescription_fr:[dictProduct objectForKey:@"description_fr"]];
    [newProductObject setName_cn:[dictProduct objectForKey:@"name_cn"]];
    [newProductObject setDescription_cn:[dictProduct objectForKey:@"description_cn"]];
    [newProductObject setName_jp:[dictProduct objectForKey:@"name_jp"]];
    [newProductObject setDescription_jp:[dictProduct objectForKey:@"description_jp"]];
    [newProductObject setName_de:[dictProduct objectForKey:@"name_de"]];
    [newProductObject setDescription_de:[dictProduct objectForKey:@"description_de"]];
    [newProductObject setName_it:[dictProduct objectForKey:@"name_it"]];
    [newProductObject setDescription_it:[dictProduct objectForKey:@"description_it"]];
    [newProductObject setName_arabic:[dictProduct objectForKey:@"name_arabic"]];
    [newProductObject setDescription_arabic:[dictProduct objectForKey:@"description_arabic"]];
    [newProductObject setName_ir:[dictProduct objectForKey:@"name_ir"]];
    [newProductObject setDescription_ir:[dictProduct objectForKey:@"description_ir"]];
    [newProductObject setName_hi:[dictProduct objectForKey:@"name_hi"]];
    [newProductObject setDescription_hi:[dictProduct objectForKey:@"description_hi"]];
    [newProductObject setSort_id:[dictProduct objectForKey:@"sort_id"]];
    [newProductObject setRate:[dictProduct objectForKey:@"rate"]];
    [newProductObject setComment:[dictProduct objectForKey:@"comment"]];
    return newProductObject;
}

@end
