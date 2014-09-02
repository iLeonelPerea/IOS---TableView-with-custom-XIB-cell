//
//  AddCommentViewController.h
//  testTableView
//
//  Created by Crowd on 8/29/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ViewController.h"
#import "ProductInfoViewController.h"
#import "DBManager.h"


@interface AddCommentViewController : ViewController <UITextViewDelegate>
@property (nonatomic, strong) NSString *commentValue;
@property (nonatomic, strong) IBOutlet UITextView *txtComment;
@property (nonatomic, strong) IBOutlet UIButton *btnSend;
@property (nonatomic, strong) id<iInfoDelegate> delegate;
@property (nonatomic, assign) int productId;

-(IBAction)doSendComment:(id)sender;



@end
