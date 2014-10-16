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

@synthesize arrQuestions, pageControl, vFeedback, imgProfile, lblQuestion, btnFirstAnswer, btnSecondAnswer, btnThirdAnswer, btnSkip, isPageControlInUse, directionChangePageControl, arrButtons;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Interview feedback"];
    arrQuestions = [DBManager getQuestions]; //Load questions from DB
    pageControl.currentPage = 0;
    directionChangePageControl = pageControl.currentPage;
    UISwipeGestureRecognizer *gestureL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromL:)];
    gestureL.numberOfTouchesRequired = 1;
    [gestureL setDirection:UISwipeGestureRecognizerDirectionRight];
    UISwipeGestureRecognizer *gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromR:)];
    gestureR.numberOfTouchesRequired = 1;
    [gestureR setDirection:UISwipeGestureRecognizerDirectionLeft];
    // Add gestures to the View
    [vFeedback addGestureRecognizer:gestureL];
    [vFeedback addGestureRecognizer:gestureR];
    arrButtons = [[NSMutableArray alloc] initWithObjects:btnFirstAnswer,btnSecondAnswer,btnThirdAnswer,nil];
    [imgProfile setImage:[UIImage imageNamed:@"profileLeo"]];
    [imgProfile setHidden:NO];
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

#pragma mark --scrollView delegate
- (IBAction)doChangePage{
    if (directionChangePageControl > pageControl.currentPage) { //Left Direction
        [UIView animateWithDuration:.7 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self fillQuestions];
        }completion:nil];
    }else{ // Right Direction
        [UIView animateWithDuration:.7 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self fillQuestions];
        }completion:nil];
    }
    directionChangePageControl = pageControl.currentPage;
}

- (IBAction) doSkip{
    [self handleSwipeFromR:nil];
}

#pragma mark -- SwipeGestureRecognizer delegate
- (void)handleSwipeFromR:(UISwipeGestureRecognizer *)recognizer {
    if(pageControl.currentPage < 5)
    {
        pageControl.currentPage ++;
        directionChangePageControl = 1;
        [UIView animateWithDuration:.7 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self fillQuestions];
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
        }completion:nil];
    }
    else
    {
        pageControl.currentPage = pageControl.currentPage;
    }
}

#pragma mark -- LoadQuestions
- (void)fillQuestions{
    // Fill Questions from the Array of the current pageControl
    for (UIButton * btnAnswers in arrButtons) { // Hide all buttons (if one or more questions have only 2 answers)
        [btnAnswers setTitle:@"" forState:UIControlStateNormal];
        [btnAnswers setHidden:YES];
    }
    QuestionObject *questionObject = [arrQuestions objectAtIndex:pageControl.currentPage];
    int indexButton = 0; // To change the button
    [lblQuestion setText:questionObject.description];
    for (QuestionAnswerObject *questionAnswer in questionObject.arrQuestionAnswerObject) {
        [(UIButton *)[arrButtons objectAtIndex:indexButton] setTitle:questionAnswer.answerDescription forState:UIControlStateNormal]; // Change teh Answer Description
        [(UIButton *)[arrButtons objectAtIndex:indexButton] setHidden:NO];
        indexButton ++;
    }
}

@end
