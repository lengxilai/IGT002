//
//  IGTomatoListController.m
//  IGT002
//
//  Created by Ming Liu on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGTomatoListController.h"

@interface IGTomatoListController ()

@end

@implementation IGTomatoListController
@synthesize fetchedResultsController;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(A02_HEADER_VIEW_X, A02_HEADER_VIEW_Y, A02_HEADER_VIEW_W, A02_HEADER_VIEW_H)];
        
        UIImageView *bak = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbarbak.png"]];
        bak.frame = CGRectMake(A02_HEADER_BAK_X,A02_HEADER_BAK_Y,A02_HEADER_BAK_W,A02_HEADER_BAK_H);
        [headerView addSubview:bak];
        
        searchText = [[IGTextField alloc] initWithFrame:CGRectMake(A02_SEARCH_X,A02_SEARCH_Y,A02_SEARCH_W,A02_SEARCH_H)];
        searchText.textColor = [UIColor whiteColor];
        searchText.returnKeyType = UIReturnKeySearch;
        searchText.placeholder = NSLocalizedString(@"搜索蕃茄",@"搜索蕃茄");
        searchText.clearButtonMode = UITextFieldViewModeAlways;
        searchText.delegate = self;
        [headerView addSubview:searchText];
        
        self.tableView.tableHeaderView = headerView;
        
        // 注册蕃茄追加事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handAddTomato:) name:INFO_ADD_TOMATO object:nil];
        
        // 注册日期点击时间
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handFromCalendar:) name:INFO_CLICK_CALENDAR object:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    NSError *error = nil;
    if (![[self fetchedResultsController:nil] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.fetchedResultsController = nil;
    [super viewDidUnload];
}

#pragma mark 
//按下Done按钮，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self fetchedResultsController:nil];
    [self.tableView reloadData];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 创建各个View
-(UIView *)getListCellView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.tag = CELL_TAG;
    
    UIImageView *bakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
    bakView.frame = CGRectMake(A03_SECTION_BAK_X, A03_SECTION_BAK_Y, A03_SECTION_BAK_W, A03_CELL_BAK_H);
    [view addSubview:bakView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smalltomato.png"]];
    imageView.frame = CGRectMake(A02_CELL_IMAGE_X, A02_CELL_IMAGE_Y, A02_CELL_IMAGE_W, A02_CELL_IMAGE_H);
    imageView.tag = CELL_IMAGE_TAG;
    [view addSubview:imageView];
    
    IGLabel *label = [[IGLabel alloc] initWithFrame:CGRectMake(A02_CELL_TEXT_X, A02_CELL_TEXT_Y, A02_CELL_TEXT_W, A02_CELL_TEXT_H)];
    label.tag = CELL_TEXT_TAG;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
    
    return view;
}

-(void)editListCellView:(UIView*)view  withTomato:(Tomato*)tomato
{
    UIImageView *imageView = (UIImageView *)[view viewWithTag:CELL_IMAGE_TAG];
    if([tomato.state boolValue]){
        imageView.image = [UIImage imageNamed:@"smalltomato.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"smalltomatogrn.png"];
    }
    
    IGLabel *label = (IGLabel *)[view viewWithTag:CELL_TEXT_TAG];
    label.text = tomato.buildString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[fetchedResultsController sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:indexPath.section];
    Tomato *tomato = [[sectionInfo objects] objectAtIndex:indexPath.row];
    
    UIView *cellView = [cell.contentView viewWithTag:CELL_TAG];
    if (cellView == nil) {
        cellView = [self getListCellView];
        [cell.contentView addSubview:cellView];
    }
    [self editListCellView:cellView withTomato:tomato];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] init];
    
    UIImageView *bakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionbak.png"]];
    bakView.frame = CGRectMake(A03_SECTION_BAK_X, A03_SECTION_BAK_Y, A03_SECTION_BAK_W, A03_SECTION_BAK_H);
    [sectionView addSubview:bakView];
    
    IGLabel *sectionTitle = [[IGLabel alloc] initWithFrame:CGRectMake(A02_SECTION_TITLE_X, A02_SECTION_TITLE_Y, A02_SECTION_TITLE_W, A02_SECTION_TITLE_H)];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    
    // 取得section显示用tomatodate
    Tomato *tomato = [[sectionInfo objects] objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"yyyy年MM月dd日", @"yyyy年MM月dd日 日期格式")];
    NSString *dateStr = [dateFormatter stringFromDate:tomato.tomatodate];
    
    sectionTitle.font = [UIFont systemFontOfSize:22];
    sectionTitle.text = dateStr;
    sectionTitle.textColor = [UIColor whiteColor];
    [sectionView addSubview:sectionTitle];
    
    return sectionView;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
} 

//  生成列表的datasourse
- (NSFetchedResultsController *)fetchedResultsController:(NSDate*)date
{
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"starttime" ascending:NO], nil];
    // 查询关键字做成
    NSString *key = [NSString stringWithFormat:@"*%@*",searchText.text];
    
    // 查询条件做成
    NSPredicate *predicate = nil;
    if(date==nil&&[searchText.text length]>0){
        // 从名字或者原因查询
        predicate = [NSPredicate predicateWithFormat:@" (tomatoname.name LIKE %@ ) or (stopreason.name LIKE %@ )",key,key];
    }else if(date!=nil){
        // 从日期查询
        predicate = [NSPredicate predicateWithFormat:@" (tomatodate == %@)",date];
    }
    
    NSFetchedResultsController *aFetchedResultsController = 
    [IGCoreDataUtil queryForFetchedResult:@"Tomato" queryPredicate: predicate sortDescriptors:sortDescriptors sectionNameKeyPath:@"tomatodate"];
    aFetchedResultsController.delegate = self;
    fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.tableView reloadData];
    return fetchedResultsController;
} 

-(void)handAddTomato:(NSNotification *)note
{
    // 设置查询条件
    [self fetchedResultsController:nil];
}

-(void)handFromCalendar:(NSNotification *)note
{
    // 设置查询条件为空
    searchText.text = @"";
    // 设置查询条件
    [self fetchedResultsController:[note.userInfo objectForKey:@"date"]];
}
-(void)toToday
{
    // 日期变换
    unsigned startUnitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit; 
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 只取输入时间的年月日
    NSDateComponents *dateDC = [calendar components:startUnitFlags fromDate:[NSDate date]];
    
    NSDate *inputDate = [calendar dateFromComponents:dateDC];
    
    // 设置查询条件
    [self fetchedResultsController:inputDate];
}
@end
