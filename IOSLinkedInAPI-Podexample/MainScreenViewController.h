//
//  MainScreenViewController.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackViewController.h"

@interface MainScreenViewController : UIViewController
// Methods
- (IBAction)didTapConnectWithLinkedIn:(id)sender;
- (void)doOpenFeedbackView;
@end
