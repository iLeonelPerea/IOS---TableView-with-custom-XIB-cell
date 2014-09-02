//
//  ProductDetailObject.m
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 9/2/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ProductDetailObject.h"

@implementation ProductDetailObject

@synthesize rate, comment;

-(ProductDetailObject*)assignProductDetailObject:(NSDictionary*)dictProduct{
    ProductDetailObject *newProductDetailObject = [ProductDetailObject new];
    [newProductDetailObject setRate:[dictProduct objectForKey:@"rate"]];
    [newProductDetailObject setComment:[dictProduct objectForKey:@"comment"]];
    return newProductDetailObject;
}

@end
