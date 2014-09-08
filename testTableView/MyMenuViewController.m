//
//  MyMenuViewController.m
//  testTableView
//
//  Created by Omar Guzmán on 9/6/14.
//  Copyright (c) 2014 Leonel Roberto Perea Trejo. All rights reserved.
//

#import "MyMenuViewController.h"

@interface MyMenuViewController ()

@end

@implementation MyMenuViewController
@synthesize isPageControlInUse, scrollView, pageControl, tblFriday, tblMonday, tblThursday, tblTuesday, tblWednesday, arrDataFriday, arrDataMonday, arrDataThursday, arrDataTuesday, arrDataWednesday;

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
    // try to store array on userDefaults
    // Example on hot to store and read array from NSUserDefaults
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults]; //defaults instance
    NSMutableArray * localArrUsers = [NSMutableArray new]; // array to store users
    int userCount = 0; // users counter
    if([defaults objectForKey:@"arrUsers"]) // ask for arrUsers from defaults
    {
        localArrUsers = [defaults objectForKey:@"arrUsers"]; // set local array with defaults array
        userCount = [localArrUsers count]; // check how many 'users' are stored on array
    }
    userCount ++; // increment users
    NSMutableDictionary * dictNewUser = [NSMutableDictionary new]; // create new user as dictionary
    [dictNewUser setObject:[NSString stringWithFormat:@"My New User %d", userCount] forKey:@"user"]; // set value for user key
    [localArrUsers addObject:dictNewUser]; // add object to local array
    [defaults setObject:localArrUsers forKey:@"arrUsers"]; // set defaults with new array
    [defaults synchronize]; // save defaults.
    isPageControlInUse = NO;
    //NSMutableArray initialization
    arrDataMonday = [NSMutableArray new];
    arrDataTuesday = [NSMutableArray new];
    arrDataWednesday = [NSMutableArray new];
    arrDataThursday = [NSMutableArray new];
    arrDataFriday = [NSMutableArray new];
    //tableView properties
    [tblMonday setDelegate:self];
    [tblMonday setDataSource:self];
    [tblTuesday setDelegate:self];
    [tblTuesday setDataSource:self];
    [tblWednesday setDelegate:self];
    [tblWednesday setDataSource:self];
    [tblThursday setDelegate:self];
    [tblThursday setDataSource:self];
    [tblFriday setDelegate:self];
    [tblFriday setDataSource:self];
    [self loadDataDays];
}

-(void)viewDidAppear:(BOOL)animated
{
    //scrollView properties
    scrollView.contentSize = CGSizeMake(1600, 540);
    [self changePage];
}

-(void)loadDataDays
{
    NSMutableDictionary * dictMonday = [NSMutableDictionary new];
    [dictMonday setObject:@"Monday" forKey:@"day"];
    NSMutableDictionary * dictTuesday = [NSMutableDictionary new];
    [dictTuesday setObject:@"Tuesday" forKey:@"day"];
    NSMutableDictionary * dictWednesday = [NSMutableDictionary new];
    [dictWednesday setObject:@"Wednesday" forKey:@"day"];
    NSMutableDictionary * dictThursday = [NSMutableDictionary new];
    [dictThursday setObject:@"Thursday" forKey:@"day"];
    NSMutableDictionary * dictFriday = [NSMutableDictionary new];
    [dictFriday setObject:@"Friday" forKey:@"day"];
    [arrDataMonday addObject:dictMonday];
    [arrDataTuesday addObject:dictTuesday];
    [arrDataWednesday addObject:dictWednesday];
    [arrDataThursday addObject:dictThursday];
    [arrDataFriday addObject:dictFriday];
}

#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger toRet;
    switch (pageControl.currentPage) {
        case 0:
            toRet = [arrDataMonday count];
            break;
        case 1:
            toRet = [arrDataTuesday count];
            break;
        case 2:
            toRet = [arrDataWednesday count];
            break;
        case 3:
            toRet = [arrDataThursday count];
            break;
        case 4:
            toRet = [arrDataFriday count];
            break;
        default:
            break;
    }
    return toRet;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"CellProduct";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSMutableDictionary * dictProduct = [NSMutableDictionary new];
    switch (pageControl.currentPage) {
        case 0:
            dictProduct = [arrDataMonday objectAtIndex:(NSUInteger)indexPath.row];
            break;
        case 1:
            dictProduct = [arrDataTuesday objectAtIndex:(NSUInteger)indexPath.row];
            break;
        case 2:
            dictProduct = [arrDataWednesday objectAtIndex:(NSUInteger)indexPath.row];
            break;
        case 3:
            dictProduct = [arrDataThursday objectAtIndex:(NSUInteger)indexPath.row];
            break;
        case 4:
            dictProduct = [arrDataFriday objectAtIndex:(NSUInteger)indexPath.row];
            break;
        default:
            break;
    }
    cell.textLabel.text = [dictProduct objectForKey:@"day"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mak -- UIScrollViewDelegate

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = scrollView.frame.size.width * pageControl.currentPage;
	frame.origin.y = scrollView.frame.origin.y;
    NSLog(@"origin.y: %2f", frame.origin.y);
	frame.size = scrollView.frame.size;
	[scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	isPageControlInUse = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!isPageControlInUse) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		pageControl.currentPage = page;
        [self doReloadData];
	}
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self doReloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isPageControlInUse = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    isPageControlInUse = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doReloadData
{
    switch (pageControl.currentPage) {
        case 0:
            [tblMonday reloadData];
            break;
        case 1:
            [tblTuesday reloadData];
            break;
        case 2:
            [tblWednesday reloadData];
            break;
        case 3:
            [tblThursday reloadData];
            break;
        case 4:
            [tblFriday reloadData];
            break;
        default:
            break;
    }
}

@end
