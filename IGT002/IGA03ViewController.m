//
//  IGA03ViewController.m
//  IGT002
//
//  Created by Ming Liu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGA03ViewController.h"

@interface IGA03ViewController ()

@end

@implementation IGA03ViewController

@synthesize fetchedResultsControllerOfGoodTomato;
@synthesize fetchedResultsControllerOfStopReason;

- (id)init
{
    self = [super init];
    if (self) {        

        [self setTotalCount];
        [self setMaxcount];
        precentLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A03_TITLE_X, A03_TITLE_Y, A03_TITLE_W, A03_TITLE_H)];
        precentLabel.text = [NSString stringWithFormat:@"%@%d%%",NSLocalizedString(@"蕃茄率：", @"蕃茄率："),[self getPercentOfDone]];
        precentLabel.font = [UIFont systemFontOfSize:25];
        precentLabel.textColor = [UIColor whiteColor];
        
        listTableView = [[UITableView alloc] initWithFrame:CGRectMake(A03_TABLE_X, A03_TABLE_Y, A03_TABLE_W, A03_TABLE_H)];
        listTableView.delegate = self;
        listTableView.dataSource = self;
        listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        listTableView.backgroundColor = [UIColor clearColor];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewbak.png"]];
        backgroundView.frame = CGRectMake(TABLE_BAK_X, TABLE_BAK_Y, TABLE_BAK_W, TABLE_BAK_H);
        
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(A02_HEADER_VIEW_X, A02_HEADER_VIEW_Y, A02_HEADER_VIEW_W, A02_HEADER_VIEW_H)];
        
        UIImageView *bak = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbarbak.png"]];
        bak.frame = CGRectMake(A02_HEADER_BAK_X,A02_HEADER_BAK_Y,A02_HEADER_BAK_W,A02_HEADER_BAK_H);
        [headerView addSubview:bak];
        
        searchText = [[IGTextField alloc] initWithFrame:CGRectMake(A02_SEARCH_X,A02_SEARCH_Y,A02_SEARCH_W,A02_SEARCH_H)];
        searchText.textColor = [UIColor whiteColor];
        searchText.returnKeyType = UIReturnKeySearch;
        searchText.placeholder = NSLocalizedString(@"搜索",@"搜索");
        searchText.clearButtonMode = UITextFieldViewModeAlways;
        searchText.delegate = self;
        [headerView addSubview:searchText];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:INFO_ADD_TOMATO object:nil];
        listTableView.tableHeaderView = headerView;
                
        [self.view addSubview:backgroundView];
        [self.view addSubview:precentLabel];
        [self.view addSubview:listTableView];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error = nil;
    if (![[self fetchedResultsControllerOfGoodTomato] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if (![[self fetchedResultsControllerOfStopReason] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark 
//按下Done按钮，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSError *error = nil;
    if (![[self fetchedResultsControllerOfGoodTomato] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if (![[self fetchedResultsControllerOfStopReason] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [listTableView reloadData];
    [textField resignFirstResponder];    
    return YES;
}

#pragma mark 创建各个View
-(UIView *)getListCellView:(NSIndexPath *)indexPath
{

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.tag = CELL_TAG;
    
    UIImageView *bakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
    bakView.frame = CGRectMake(A03_SECTION_BAK_X, A03_SECTION_BAK_Y, A03_SECTION_BAK_W, A03_CELL_BAK_H);
    [view addSubview:bakView];
    
    IGLabel *label = [[IGLabel alloc] initWithFrame:CGRectMake(A03_CELL_TEXT_X, A03_CELL_TEXT_Y, A03_CELL_TEXT_W, A03_CELL_TEXT_H)];
    label.tag = CELL_TEXT_TAG;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
    if (indexPath.section == 0) {
        TomatoName *goodTomato = (TomatoName *)[fetchedResultsControllerOfGoodTomato objectAtIndexPath:indexPath];
        length = [self getBarLength:goodTomato.count maxCount:maxCountOfGoodTomato];
    } else {
        // badtomato的fetchedResultsController的section实际只有一个，所以section要变成0
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        StopReason *stopReason = (StopReason *)[fetchedResultsControllerOfStopReason objectAtIndexPath:newIndexPath];
        length = [self getBarLength:stopReason.count maxCount:maxCountOfStopReason];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(A03_CELL_IMAGE_X, A03_CELL_IMAGE_Y, length, A03_CELL_IMAGE_H)];
    imageView.tag = CELL_IMAGE_TAG;
    [view addSubview:imageView];
    
    IGLabel *count = [[IGLabel alloc] initWithFrame:CGRectMake(A03_CELL_COUNT_X, A03_CELL_COUNT_Y, A03_CELL_COUNT_W, A03_CELL_COUNT_H)];
    count.tag = CELL_DETAIL_TAG;
    count.font = [UIFont systemFontOfSize:16];
    count.textColor = [UIColor whiteColor];
    [view addSubview:count];
    
    return view;
}

-(void)editListCellView:(UIView*)view forIndex:(NSIndexPath *)indexPath
{
    UIImageView *imageView = (UIImageView *)[view viewWithTag:CELL_IMAGE_TAG];
    IGLabel *label = (IGLabel *)[view viewWithTag:CELL_TEXT_TAG];
    label.adjustsFontSizeToFitWidth = YES;
    IGLabel *count = (IGLabel *)[view viewWithTag:CELL_DETAIL_TAG];
    if (indexPath.section == 0) {
        imageView.image = [[UIImage imageNamed:@"redbar.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        TomatoName *goodTomato = (TomatoName *)[fetchedResultsControllerOfGoodTomato objectAtIndexPath:indexPath];
        label.text = goodTomato.name;
        count.text = [self numberToString:goodTomato.count];
        length = [self getBarLength:goodTomato.count maxCount:maxCountOfGoodTomato];
    }else {
        imageView.image = [[UIImage imageNamed:@"greenbar.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        // badtomato的fetchedResultsController的section实际只有一个，所以section要变成0
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        StopReason *badTomato = (StopReason *)[fetchedResultsControllerOfStopReason objectAtIndexPath:newIndexPath];
        label.text = badTomato.name;
        count.text = [self numberToString:badTomato.count];
        length = [self getBarLength:badTomato.count maxCount:maxCountOfStopReason];
    }
    imageView.frame = CGRectMake(A03_CELL_IMAGE_X, A03_CELL_IMAGE_Y, length, A03_CELL_IMAGE_H);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tomatoRows = 0;
    if (section == 0) {
        // 取得好西红柿个数
        tomatoRows = [self getGoodTomatoRows];
        //tomatoRows = 3;
    } else {
        // 取得烂西红柿个数
        tomatoRows = [self getBadTomatoRows];
    }
    return tomatoRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"IGT02TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
//        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grntabbak.png"]];
	}
    [self setMaxcount];
    UIView *cellView = [cell.contentView viewWithTag:CELL_TAG];
    if (cellView == nil) {
        cellView = [self getListCellView:indexPath];
        [cell.contentView addSubview:cellView];
    }
    [self editListCellView:cellView forIndex:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] init];
    
    UIImageView *bakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionbak.png"]];
    bakView.frame = CGRectMake(A03_SECTION_BAK_X, A03_SECTION_BAK_Y, A03_SECTION_BAK_W, A03_SECTION_BAK_H);
    [sectionView addSubview:bakView];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(A03_SECTION_IMAGE_X, A03_SECTION_IMAGE_Y, A03_SECTION_IMAGE_W, A03_SECTION_IMAGE_H)];
    if (section == 0) {
        iconImage.image = [UIImage imageNamed:@"smalltomato.png"];
    }else {
        iconImage.image = [UIImage imageNamed:@"smalltomatogrn.png"];
    }
    [sectionView addSubview:iconImage];
    
    IGLabel *sectionTitle = [[IGLabel alloc] initWithFrame:CGRectMake(A03_SECTION_TITLE_X, A03_SECTION_TITLE_Y, A03_SECTION_TITLE_W, A03_SECTION_TITLE_H)];
    sectionTitle.font = [UIFont systemFontOfSize:22];
    [self setTotalCount];
    IGLabel *sectionCount = [[IGLabel alloc] initWithFrame:CGRectMake(A03_SECTION_COUNT_X, A03_SECTION_COUNT_Y, A03_SECTION_COUNT_W, A03_SECTION_COUNT_H)];
    if (section == 0) {
        sectionTitle.text = NSLocalizedString(@"完成蕃茄", @"完成蕃茄");
        sectionTitle.textColor = [UIColor redColor];
        sectionCount.text = [NSString stringWithFormat:@"%@%@",totalCountOfGoodTomato,NSLocalizedString(@"个", @"完成蕃茄、停止原因的个数单位")];
    }else {
        sectionTitle.text = NSLocalizedString(@"停止蕃茄", @"停止蕃茄");
        sectionTitle.textColor = [UIColor greenColor];
        sectionCount.text = [NSString stringWithFormat:@"%@%@",totalCountOfStopReason,NSLocalizedString(@"个", @"完成蕃茄、停止原因的个数单位")];
    }
    [sectionView addSubview:sectionTitle];
    
    sectionCount.textColor = [UIColor whiteColor];
    sectionCount.font = [UIFont systemFontOfSize:18];
    sectionCount.textAlignment = UITextAlignmentRight;
    [sectionView addSubview:sectionCount];
    
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

#pragma mark - fetchedResultsController
- (NSFetchedResultsController *)fetchedResultsControllerOfGoodTomato
{
    NSString *key = [NSString stringWithFormat:@"*%@*",searchText.text];
    // 查询条件做成
    NSPredicate *predicate = nil;
    if (searchText.text.length>0) {
        predicate = [NSPredicate predicateWithFormat:@" ( name like %@ ) and (count > 0) ", key];
    } else {
        predicate = [NSPredicate predicateWithFormat:@" count > 0 ", key];
    }
    
    // 排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];

    NSFetchedResultsController *aFetchedResultsController;
    aFetchedResultsController = 
    [IGCoreDataUtil queryForFetchedResult:@"TomatoName" queryPredicate:predicate sortDescriptors:sortDescriptors];
    aFetchedResultsController.delegate = self;
    fetchedResultsControllerOfGoodTomato = aFetchedResultsController;
    
    return fetchedResultsControllerOfGoodTomato;
}

- (NSFetchedResultsController *)fetchedResultsControllerOfStopReason
{
    NSString *key = [NSString stringWithFormat:@"*%@*",searchText.text];
    // 查询条件做成
    NSPredicate *predicate = nil;
    if (searchText.text.length>0) {
        predicate = [NSPredicate predicateWithFormat:@" name like %@ ", key];
    }

    // 排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchedResultsController *aFetchedResultsController;
    aFetchedResultsController = 
    [IGCoreDataUtil queryForFetchedResult:@"StopReason" queryPredicate:predicate sortDescriptors:sortDescriptors];
    aFetchedResultsController.delegate = self;
    fetchedResultsControllerOfStopReason = aFetchedResultsController;
    
    return fetchedResultsControllerOfStopReason;
}

// 分别取得总数(好苹果，烂苹果)
- (NSString *)getTotalCount:(NSString *)entityName method:(NSString*) method selectColumn:(NSString*) column keyName:(NSString*) keyName     queryPredicate:(NSPredicate *)predicate
{
    NSArray *resultArray;
    resultArray = 
    [IGTomatoUtil getTotalCount:entityName method:method selectColumn:column keyName:keyName queryPredicate:(NSPredicate *)predicate
];
    return [[resultArray objectAtIndex:0] objectForKey:@"sumOfCount"];
}

// 取得最大数(好西红柿，停止原因)
- (NSString *)getMaxCount:(NSString *)entityName method:(NSString*) method selectColumn:(NSString*) column keyName:(NSString*) keyName queryPredicate:(NSPredicate *)predicate
{
    
    NSArray *resultArray;
    resultArray = 
    [IGTomatoUtil getMaxCount:entityName method:method selectColumn:column keyName:keyName queryPredicate:(NSPredicate *)predicate];

    return [[resultArray objectAtIndex:0] objectForKey:@"maxOfCount"];
}

// 取得每行的好西红柿个数
- (NSInteger) getGoodTomatoRows {
    return [[[fetchedResultsControllerOfGoodTomato sections] objectAtIndex:0] numberOfObjects];
}
// 取得每行问题原因的个数
- (NSInteger) getBadTomatoRows {
    return [[[fetchedResultsControllerOfStopReason sections] objectAtIndex:0] numberOfObjects];
}

// number转化成string
- (NSString *) numberToString:(NSNumber *) number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    return [numberFormatter stringFromNumber:number];
}

// 取得红绿条的长度
- (float) getBarLength:(NSNumber *) number maxCount:(NSString*) maxCount{
    float lg = A03_CELL_IMAGE_W * ([number floatValue] / [maxCount floatValue]);
    return lg;
}

// 取得完成率
- (int) getPercentOfDone {
    //NSLog(@"%@", totalCountOfGoodTomato);
    //NSLog(@"%@", totalCountOfStopReason);
    if ([@"0" isEqualToString:totalCountOfGoodTomato] || [totalCountOfGoodTomato intValue] == 0) {
        return 0;
    }

    int percent = ([totalCountOfGoodTomato floatValue] / ([totalCountOfGoodTomato floatValue] + [totalCountOfStopReason floatValue]))*100;
    return percent;
}

// 初始化总数
- (void) setTotalCount {
    NSString *key = [NSString stringWithFormat:@"*%@*",searchText.text];
    // 查询条件做成
    NSPredicate *predicate = nil;
    if (searchText.text.length>0) {
        predicate = [NSPredicate predicateWithFormat:@" name like %@ ", key];
    }
    // 取得总个数
    totalCountOfGoodTomato = [self getTotalCount:@"TomatoName" method:@"sum:" selectColumn:@"count" keyName:@"sumOfCount" queryPredicate:predicate];
    totalCountOfStopReason = [self getTotalCount:@"StopReason" method:@"sum:" selectColumn:@"count" keyName:@"sumOfCount" queryPredicate:predicate];
//    NSLog(@"%@", totalCountOfGoodTomato);
//    NSLog(@"%@", totalCountOfStopReason);
    
    precentLabel.text = [NSString stringWithFormat:@"%@%d%%",NSLocalizedString(@"完成率：", @"完成率："),[self getPercentOfDone]];
}

// 初始化最大数
- (void) setMaxcount {
    // 取得最大数
    maxCountOfGoodTomato = [self getMaxCount:@"TomatoName" method:@"max:" selectColumn:@"count" keyName:@"maxOfCount" queryPredicate:nil];
    maxCountOfStopReason = [self getMaxCount:@"StopReason" method:@"max:" selectColumn:@"count" keyName:@"maxOfCount" queryPredicate:nil];
}

-(void)reload
{    

    NSError *error = nil;
    if (![[self fetchedResultsControllerOfGoodTomato] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if (![[self fetchedResultsControllerOfStopReason] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    //[self setTotalCount];
    
    [listTableView reloadData];
    
    //precentLabel.text = [NSString stringWithFormat:@"%@%d%%",NSLocalizedString(@"完成率：", @"完成率："),[self getPercentOfDone]];
}
@end
