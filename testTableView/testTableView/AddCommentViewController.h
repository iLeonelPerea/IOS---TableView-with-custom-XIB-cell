//
//  AddCommentViewController.h
//  testTableView
//
//  Created by Crowd on 8/29/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "ViewController.h"

@interface AddCommentViewController : ViewController
@property (nonatomic, strong) IBOutlet UITextView *txtComment;
@property (nonatomic, strong) IBOutlet UIButton *btnSend;

-(IBAction)doSendComment:(id)sender;

@end
