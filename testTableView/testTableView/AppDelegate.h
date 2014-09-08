//
//  AppDelegate.h
//  testTableView
//
//  Created by Leonel Roberto Perea Trejo on 8/27/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MainViewController.h"
#import "MyMenuViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
//@property (nonatomic, strong) MainViewController * mainViewController;
@property (nonatomic, strong) MyMenuViewController * myMenuViewController;

@end
