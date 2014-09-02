//
//  AddCommentViewController.m
//  testTableView
//
//  Created by Crowd on 8/29/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController
@synthesize txtComment, btnSend, commentValue, productId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [txtComment setDelegate:self];
    [txtComment setText:(txtComment)?commentValue:@""];
    (txtComment) ? [btnSend setTitle:@"Update" forState:UIControlStateNormal]:nil;
    [btnSend setEnabled:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary * dictInfo = [[NSDictionary alloc] initWithDictionary:[DBManager getProductWithId:productId]];
        [txtComment setText: [dictInfo objectForKey:@"comment"]];
        NSLog(@"comment value: %@", [dictInfo objectForKey:@"comment"]);
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Comment Delegate

-(IBAction)doSendComment:(id)sender{
    [txtComment resignFirstResponder]; //Oculta el teclado :P
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate doSetCommentValue:txtComment.text];
}
#pragma mark -- UITextView delegate
-(void)textViewDidChange:(UITextView *)textView
{
    [btnSend setEnabled:([txtComment.text length] > 3)?YES:NO];
}

@end
