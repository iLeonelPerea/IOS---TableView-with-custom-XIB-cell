//
//  ProductDetailObject.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 9/2/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDetailObject : NSObject

@property (nonatomic, strong) NSString * rate;
@property (nonatomic, strong) NSString * comment;

-(ProductDetailObject*)assignProductDetailObject:(NSDictionary*)dictProduct;

@end
