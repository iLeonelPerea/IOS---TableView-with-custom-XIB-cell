//
//  FeedbackObject.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Leonel Roberto Perea Trejo on 10/10/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionObject.h"
#import "QuestionAnswerObject.h"

@interface FeedbackObject : NSObject

@property (nonatomic, assign) int idFeedback;
@property (nonatomic, assign) int idUser;
@property (nonatomic, assign) int idInterview;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSMutableArray * questionObject;

@end
