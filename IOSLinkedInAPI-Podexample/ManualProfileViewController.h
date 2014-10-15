//
//  ManualProfileViewController.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iInfoDelegate <NSObject>
-(void)doSetSelectedSkills:(NSMutableArray*)arrReceivedSelectedSkills;
@end

@interface ManualProfileViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *arrSelectedSkills;
@end