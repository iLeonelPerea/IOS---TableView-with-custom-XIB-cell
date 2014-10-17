//
//  FeedbackViewController.m
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/15/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import "FeedbackViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize arrQuestions, pageControl, vFeedback, imgProfile, lblQuestion, btnFirstAnswer, btnSecondAnswer, btnThirdAnswer, btnSkip, isPageControlInUse, directionChangePageControl, arrButtons, feedbackObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Interview feedback"];
    
    //Init Variables
    arrQuestions = [DBManager getQuestions]; //Load questions from DB
    arrButtons = [[NSMutableArray alloc] initWithObjects:btnFirstAnswer,btnSecondAnswer,btnThirdAnswer,nil];
    pageControl.currentPage = 0;
    feedbackObject = [[FeedbackObject alloc] init];
    directionChangePageControl = pageControl.currentPage;
    
    //Create Gestures L / R
    UISwipeGestureRecognizer *gestureL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromL:)];
    UISwipeGestureRecognizer *gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromR:)];
    gestureL.numberOfTouchesRequired = 1;
    gestureR.numberOfTouchesRequired = 1;
    [gestureL setDirection:UISwipeGestureRecognizerDirectionRight];
    [gestureR setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    // Add gestures to the View
    [vFeedback addGestureRecognizer:gestureL];
    [vFeedback addGestureRecognizer:gestureR];
    
    
    [imgProfile setImage:[UIImage imageNamed:@"profileLeo.jpg"]];
    [imgProfile setHidden:NO];
    
    int tagValue = 0;
    for (UIButton * btnAnswers in arrButtons) { // Hide all buttons
        [btnAnswers setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnAnswers setTag:tagValue];
        tagValue ++;
    }
    feedbackObject.idFeedback = 0;
    feedbackObject.idUser = 1;
    feedbackObject.idInterview = 1;
    feedbackObject.arrQuestions = arrQuestions;
    [self fillQuestions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidAppear:(BOOL)animated{
    //Set objects to fit screen between 3.5 and 4 inches
    [pageControl setFrame:(IS_IPHONE_5)?CGRectMake(0, 531, 320, 37):CGRectMake(0, 443, 320, 37)];
}

#pragma mark --UIButtons Actions
- (IBAction)doAnswerQuestion:(id)sender{
    // Hide all buttons
    [self doDisableButtons];
    
    // Init Variables
    QuestionObject *newQuestionObject = [arrQuestions objectAtIndex:pageControl.currentPage];
    UIButton *btnActive = (UIButton *)sender;
    
    //Set Style for State Selected
    [btnActive setSelected:YES];
    [btnActive setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnActive setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1]];
    
    //Save answer
    newQuestionObject.activeAnswer = btnActive.tag;
    
    //Save on DB
    feedbackObject.idFeedback = [DBManager insertFeedback:feedbackObject];
    [DBManager insertQuestionsAnswer:feedbackObject.idFeedback withIdQuestion:newQuestionObject.idQuestion withIdAnswer:newQuestionObject.activeAnswer+1];
}

#pragma mark --scrollView delegate
- (IBAction)doChangePage{
    if (directionChangePageControl > pageControl.currentPage) { //Left Direction
        [UIView animateWithDuration:.7 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self fillQuestions];
            [self doActivateButon];
        }completion:nil];
    }else{ // Right Direction
        [UIView animateWithDuration:.7 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self fillQuestions];
            [self doActivateButon];
        }completion:nil];
    }
    directionChangePageControl = pageControl.currentPage;
}

- (IBAction)doSkip{
    [self handleSwipeFromR:nil];
}

-(void)doActivateButon{
    // set buttons hidden
    [self doDisableButtons];
    
    // Init Variables
    QuestionObject *newQuestionObject = [arrQuestions objectAtIndex:pageControl.currentPage];
    
    if (newQuestionObject.activeAnswer != -1) {
        UIButton * newButtonActive = [arrButtons objectAtIndex:newQuestionObject.activeAnswer];
        [newButtonActive setSelected:YES];
        [newButtonActive setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1]];
    }
}

-(void)doDisableButtons{
    for (UIButton * btnAnswers in arrButtons) {
        [btnAnswers setSelected:NO];
        [btnAnswers setBackgroundColor:[UIColor grayColor]];
    }
}

#pragma mark -- SwipeGestureRecognizer delegate
- (void)handleSwipeFromR:(UISwipeGestureRecognizer *)recognizer {
    if(pageControl.currentPage < 5)
    {
        pageControl.currentPage ++;
        directionChangePageControl = 1;
        [UIView animateWithDuration:.7 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self fillQuestions];
            [self doActivateButon];
        }completion:nil];
    }
    else
    {
        pageControl.currentPage = pageControl.currentPage;
    }
}

- (void)handleSwipeFromL:(UISwipeGestureRecognizer *)recognizer {
    if(pageControl.currentPage > 0)
    {
        pageControl.currentPage --;
        directionChangePageControl = 0;
        [UIView animateWithDuration:.7 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [self fillQuestions];
            [self doActivateButon];
        }completion:nil];
    }
    else
    {
        pageControl.currentPage = pageControl.currentPage;
    }
}

#pragma mark -- LoadQuestions
- (void)fillQuestions{
    // set buttons hidden
    [self doDisableButtons];
    
    QuestionObject *questionObject = [arrQuestions objectAtIndex:pageControl.currentPage];
    int indexButton = 0; // To change the button
    [lblQuestion setText:questionObject.description];
    for (QuestionAnswerObject *questionAnswer in questionObject.arrQuestionAnswerObject) {
        [(UIButton *)[arrButtons objectAtIndex:indexButton] setTitle:questionAnswer.answerDescription forState:UIControlStateNormal]; // Change the Answer Description
        [(UIButton *)[arrButtons objectAtIndex:indexButton] setHidden:NO];
        indexButton ++;
    }
}

@end
