//
//  ManualProfileViewController.h
//  IOSLinkedInAPI-Podexample
//
//  Created by Omar Guzmán on 10/8/14.
//  Copyright (c) 2014 Eyben Consult ApS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <APLKeyboardControls.h>
#import "SkillObject.h"
#import "DBManager.h"
#import "SkillCell.h"

@protocol iInfoDelegate <NSObject>
-(void)doSetSelectedSkills:(NSMutableArray*)arrReceivedSelectedSkills;
@end

@interface ManualProfileViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *txtFirstName;
@property (nonatomic, strong) IBOutlet UITextField *txtLastName;
@property (nonatomic, strong) IBOutlet UITextField *txtCompany;
@property (nonatomic, strong) IBOutlet UITextField *txtPosition;
@property (nonatomic, strong) NSMutableArray *arrSelectedSkills;
@property (nonatomic, strong) IBOutlet UICollectionView *collSkills;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) APLKeyboardControls *kbcontrols;
@property (nonatomic, assign) BOOL isFirstNameValid;
@property (nonatomic, assign) BOOL isLastNameValid;
@property (nonatomic, assign) BOOL isCompanyValid;
@property (nonatomic, assign) BOOL isPositionValid;

-(IBAction)textFieldDidChange:(UITextField *)textField;
-(void)doEnableSaveButton;

@end