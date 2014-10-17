//
//  FeedbackViewController.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/15/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "FeedbackObject.h"
#import "QuestionObject.h"
#import "QuestionAnswerObject.h"

@interface FeedbackViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray * arrQuestions;
@property (nonatomic, strong) IBOutlet UIView *vFeedback;
@property (nonatomic, strong) IBOutlet UIImageView *imgProfile;
@property (nonatomic, strong) IBOutlet UILabel *lblQuestion;
@property (nonatomic, strong) IBOutlet UIButton *btnFirstAnswer;
@property (nonatomic, strong) IBOutlet UIButton *btnSecondAnswer;
@property (nonatomic, strong) IBOutlet UIButton *btnThirdAnswer;
@property (nonatomic, strong) NSMutableArray *arrButtons;
@property (nonatomic, strong) IBOutlet UIButton *btnSkip;
@property (nonatomic, assign) int directionChangePageControl; //0:Left 1:Rigth
@property (nonatomic, assign) BOOL isPageControlInUse;
@property (nonatomic, strong) FeedbackObject *feedbackObject;

- (IBAction)doAnswerQuestion:(id)sender;
- (IBAction)doChangePage;
- (IBAction)doSkip;

@end
