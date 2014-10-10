//
//  QuestionAnswerObject.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Leonel Roberto Perea Trejo on 10/10/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionAnswerObject : NSObject

@property (nonatomic, assign) int idQuestion;
@property (nonatomic, assign) int idAnswer;
@property (nonatomic, strong) NSString * answerDescription;

@end
