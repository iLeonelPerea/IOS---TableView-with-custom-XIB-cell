//
//  MyMenuViewController.h
//  testTableView
//
//  Created by Omar Guzmán on 9/6/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMenuViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl * pageControl;
@property (nonatomic, assign) BOOL isPageControlInUse;
@property (nonatomic, strong) IBOutlet UITableView * tblMonday;
@property (nonatomic, strong) IBOutlet UITableView * tblTuesday;
@property (nonatomic, strong) IBOutlet UITableView * tblWednesday;
@property (nonatomic, strong) IBOutlet UITableView * tblThursday;
@property (nonatomic, strong) IBOutlet UITableView * tblFriday;
@property (nonatomic, strong) NSMutableArray * arrDataMonday;
@property (nonatomic, strong) NSMutableArray * arrDataTuesday;
@property (nonatomic, strong) NSMutableArray * arrDataWednesday;
@property (nonatomic, strong) NSMutableArray * arrDataThursday;
@property (nonatomic, strong) NSMutableArray * arrDataFriday;
-(IBAction)changePage;
// not in use right now
//@property (nonatomic, strong) IBOutlet UITableView * tblSaturday;
//@property (nonatomic, strong) IBOutlet UITableView * tblSunday;
@end
