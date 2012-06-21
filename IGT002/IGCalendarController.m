//
//  IGCalendarController.m
//  IGT002
//
//  Created by Ming Liu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGCalendarController.h"

typedef enum{
    MonthLabelTag=90,TableTitleViewTag=91,FooterRedCountTag=92,FooterGrnCountTag=93,FooterFinishiPasentTag=94,
} CalendarViewTag;

@implementation IGCalendarController

@synthesize finishForMonth,unfinishForMonth;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.scrollEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCalendar:) name:INFO_ADD_TOMATO object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - 用户操作
-(void)clickPreMonthButton:(UIButton*)button
{
    NSDateComponents *preDC = [IGDateUtil addMonth:-1 forDateComponents:dc];
    [self setDateComponents:preDC];
    [self reloadCalendar:UITableViewRowAnimationRight];
}
-(void)clickNextMonthButton:(UIButton*)button
{
    NSDateComponents *nextDC = [IGDateUtil addMonth:1 forDateComponents:dc];
    [self setDateComponents:nextDC];
    [self reloadCalendar:UITableViewRowAnimationLeft];
}

-(void)toToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    if ([dc year] != [dateComponents year] || [dc month] != [dateComponents month]) {
        [self setDateComponents:dateComponents];
        [self reloadCalendar:UITableViewRowAnimationRight];
    }
}

-(void)reloadCalendar:(UITableViewRowAnimation)animation
{
    // 初始化
    finishForMonth = 0;
    unfinishForMonth = 0;
    
    [self.tableView reloadRowsAtIndexPaths:
     [NSArray arrayWithObjects:
      [NSIndexPath indexPathForRow:0 inSection:0],
      nil]
                          withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadRowsAtIndexPaths:
     [NSArray arrayWithObjects:
      [NSIndexPath indexPathForRow:1 inSection:0],
      [NSIndexPath indexPathForRow:2 inSection:0],
      [NSIndexPath indexPathForRow:3 inSection:0],
      [NSIndexPath indexPathForRow:4 inSection:0],
      [NSIndexPath indexPathForRow:5 inSection:0],
      //[NSIndexPath indexPathForRow:6 inSection:0],
      nil]
                          withRowAnimation:animation];
    [self.tableView reloadRowsAtIndexPaths:
    [NSArray arrayWithObjects:
     [NSIndexPath indexPathForRow:6 inSection:0],
     nil]
withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 一些设定
-(void)setDateComponents:(NSDateComponents*)inputDC
{
    dc = inputDC;
    
    NSDateComponents *firstDayDC = [dc copy];
    [firstDayDC setDay:1];
    
    startWeekNum = [IGDateUtil getWeekNumberForDateComponents:firstDayDC];
    monthEndDay = [IGDateUtil getLastDayForDateComponents:firstDayDC];
}

#pragma mark - 创建View
-(UIView*)getTableTitleView
{
    if (tableTitleView != nil) {
        return tableTitleView;
    }
    tableTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, A02_TABLE_TITLE_H)];
    tableTitleView.tag = CELL_TAG;
    
    IGLabel *monthLabel = [[IGLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, A02_MONTH_LABEL_H)];
    monthLabel.tag = MonthLabelTag;
    monthLabel.font = [UIFont systemFontOfSize:24];
    monthLabel.textColor = [UIColor whiteColor];
    monthLabel.textAlignment = UITextAlignmentCenter;
    monthLabel.shadowColor = [UIColor blackColor];
    monthLabel.shadowOffset = CGSizeMake(1, 1);
    
    UIButton *preButton = [UIUtil buttonWithImage:@"pre.png" target:self selector:@selector(clickPreMonthButton:) frame:CGRectMake(A02_PRE_X, A02_PRE_Y, A02_PRE_W, A02_PRE_H)];
    [tableTitleView addSubview:preButton];
    
    UIButton *nextButton = [UIUtil buttonWithImage:@"next.png" target:self selector:@selector(clickNextMonthButton:) frame:CGRectMake(A02_NEXT_X, A02_NEXT_Y, A02_NEXT_W, A02_NEXT_H)];
    [tableTitleView addSubview:nextButton];
    
    for (int i = 1; i <= 7; i++) {
        IGLabel *week = [[IGLabel alloc] initWithFrame:CGRectMake(A02_DAY_OFFSET_X+(i-1)*A02_DAY_W, A02_MONTH_LABEL_H, A02_DAY_W, A02_WEEK_LABEL_H)];
        week.textColor = [UIColor grayColor];
        week.font = [UIFont systemFontOfSize:15];
        week.textAlignment = UITextAlignmentCenter;
        week.text = [IGDateUtil getWeekName:i];
        [tableTitleView addSubview:week];
    }
    
    [tableTitleView addSubview:monthLabel];
    return tableTitleView;
}

-(UIView*)getTableFooterView
{
    if (tableFooterView != nil) {
        return tableFooterView;
    }
    tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, A02_TABLE_FOOTER_H)];
    tableFooterView.tag = CELL_TAG;
    
    UIImageView *bak = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabfootbak.png"]];
    [tableFooterView addSubview:bak];
    
    UIImageView *redTomato = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smalltomato.png"]];
    redTomato.frame =  CGRectMake(A02_FOOT_RED_TOMATO_X,A02_FOOT_TOMATO_Y,A02_FOOT_TOMATO_W,A02_FOOT_TOMATO_H);
    [tableFooterView addSubview:redTomato];
    
    IGLabel *redCount = [[IGLabel alloc] initWithFrame:CGRectMake(A02_RedCount_X, A02_FOOT_TEXT_OFFSET_Y, A02_Count_W, A02_TABLE_FOOTER_H)];
    redCount.tag = FooterRedCountTag;
    redCount.font = [UIFont systemFontOfSize:20];
    redCount.textColor = [UIColor redColor];
    redCount.adjustsFontSizeToFitWidth = YES;
    [tableFooterView addSubview:redCount];
    
    UIImageView *grnTomato = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smalltomatogrn.png"]];
    grnTomato.frame = CGRectMake(A02_FOOT_GRN_TOMATO_X,A02_FOOT_TOMATO_Y,A02_FOOT_TOMATO_W,A02_FOOT_TOMATO_H);
    [tableFooterView addSubview:grnTomato];
    
    IGLabel *grnCount = [[IGLabel alloc] initWithFrame:CGRectMake(A02_GrnCount_X, A02_FOOT_TEXT_OFFSET_Y, A02_Count_W, A02_TABLE_FOOTER_H)];
    grnCount.tag = FooterGrnCountTag;
    grnCount.font = [UIFont systemFontOfSize:20];
    grnCount.textColor = [UIColor greenColor];
    grnCount.adjustsFontSizeToFitWidth = YES;
    [tableFooterView addSubview:grnCount];
    
    IGLabel *finishPasent = [[IGLabel alloc] initWithFrame:CGRectMake(A02_FINISH_PASENT_X, A02_FOOT_TEXT_OFFSET_Y, A02_FINISH_PASENT_W, A02_TABLE_FOOTER_H)];
    finishPasent.tag = FooterFinishiPasentTag;
    finishPasent.font = [UIFont systemFontOfSize:18];
    finishPasent.textColor = [UIColor whiteColor];
    finishPasent.textAlignment = UITextAlignmentRight;
    finishPasent.shadowColor = [UIColor blackColor];
    finishPasent.shadowOffset = CGSizeMake(1, 1);
    finishPasent.adjustsFontSizeToFitWidth = YES;
    [tableFooterView addSubview:finishPasent];
    
    return tableFooterView;
}

-(void)setMonthLabel
{
    IGLabel *monthLabel = (IGLabel*)[tableTitleView viewWithTag:MonthLabelTag];
    monthLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d年%d月", @"%d年%d月"),[dc year],[dc month]];
}

-(void)editFootView
{
    IGLabel *redCount = (IGLabel *)[tableFooterView viewWithTag:FooterRedCountTag];
    redCount.text =[NSString stringWithFormat:@"%d",finishForMonth];
    
    IGLabel *grnCount = (IGLabel *)[tableFooterView viewWithTag:FooterGrnCountTag];
    grnCount.text = [NSString stringWithFormat:@"%d",unfinishForMonth];;
    
    // 蕃茄率计算
    IGLabel *finishPasent = (IGLabel *)[tableFooterView viewWithTag:FooterFinishiPasentTag];
    finishPasent.text = [NSString stringWithFormat:NSLocalizedString(@"蕃茄率:%.0f%%", @"蕃茄率:%.0f%%"),((float)finishForMonth/(float)((finishForMonth+unfinishForMonth)==0?1:(finishForMonth+unfinishForMonth)))*100];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier_CELL = @"Cell";
    static NSString *CellIdentifier_WEEK = @"CellWeek";
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_CELL];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_CELL];
        }
        
        UIView *cellView = [cell.contentView viewWithTag:CELL_TAG];
        if (cellView != nil) {
            [cellView removeFromSuperview];
        }
        [cell.contentView addSubview:[self getTableTitleView]];
        [self setMonthLabel];
    }else if (indexPath.row == 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_CELL];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_CELL];
        }
        UIView *cellView = [cell.contentView viewWithTag:CELL_TAG];
        if (cellView != nil) {
            [cellView removeFromSuperview];
        }
        [cell.contentView addSubview:[self getTableFooterView]];
        [self editFootView];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_WEEK];
        if (cell == nil) {
            cell = [[IGCalendarWeekCellControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_WEEK];
        }
        // 本月第一天的星期
        ((IGCalendarWeekCellControllerCell*)cell).startWeekNum = startWeekNum;
        // 本月最后一天日期
        ((IGCalendarWeekCellControllerCell*)cell).monthEndDay = monthEndDay;
        // 本周开始日期
        ((IGCalendarWeekCellControllerCell*)cell).startDay = (indexPath.row-1)*7-startWeekNum+1;
        ((IGCalendarWeekCellControllerCell*)cell).month = [dc month];
        ((IGCalendarWeekCellControllerCell*)cell).year = [dc year];
        [((IGCalendarWeekCellControllerCell*)cell) updateCell:indexPath];
        // 完成数目计算
        finishForMonth = finishForMonth + ((IGCalendarWeekCellControllerCell*)cell).finishNum;
        // 未完成数目计算
        unfinishForMonth = unfinishForMonth + ((IGCalendarWeekCellControllerCell*)cell).unfinishNum;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return A02_TABLE_TITLE_H;
    }else if (indexPath.row == 6) {
        return A02_TABLE_FOOTER_H;
    }else {
        return A02_DAY_H;
    }
}

@end
