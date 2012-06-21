//
//  IGCalendarWeekCellControllerCell.m
//  IGT002
//
//  Created by Ming Liu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGCalendarWeekCellControllerCell.h"

typedef enum{
    DayNameTag=21,DayRedTomatoTag=31,DayRedTomatoLabelTag=32,
    DayGrnTomatoTag=41,DayGrnTomatoLabelTag=42,DayBakTag=51,
} CellViewTag;

@implementation IGCalendarWeekCellControllerCell
@synthesize startDay,startWeekNum,monthEndDay,month,year,finishNum,unfinishNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (todayBakImage == nil) {
            todayBakImage = [UIImage imageNamed:@"todaybak.png"];
            sundayBakImage = [UIImage imageNamed:@"sundaybak.png"];
            dayBakImage = [UIImage imageNamed:@"daybak.png"];
            microTomatoRed = [UIImage imageNamed:@"microtomato.png"];
            microTomatoGrn = [UIImage imageNamed:@"microtomatogrn.png"];
        }
        for (int i = 1; i <= 7; i++) {
            UIView *dayView = [[UIView alloc] initWithFrame:CGRectMake(A02_DAY_OFFSET_X+(i-1)*A02_DAY_W, 0, A02_DAY_W, A02_DAY_H)];
            dayView.tag = i;
            
            UIImageView *backgroundView = [[UIImageView alloc] initWithImage:i==1?sundayBakImage:dayBakImage];
            backgroundView.tag = DayBakTag;
            [dayView addSubview:backgroundView];
            
            IGLabel *dayName = [[IGLabel alloc] initWithFrame:CGRectMake(0, 0, A02_DAY_W, A02_DAY_H*0.4)];
            dayName.tag = DayNameTag;
            dayName.font = [UIFont systemFontOfSize:18];
            dayName.textColor = [UIColor whiteColor];
            dayName.textAlignment = UITextAlignmentCenter;

            [dayView addSubview:dayName];
            
            UIImageView *redTomato = [[UIImageView alloc] initWithFrame:CGRectMake(A02_DAY_SMALL_TOMATO_X,A02_DAY_SMALL_TOMATO_RED_Y,A02_DAY_SMALL_TOMATO_W,A02_DAY_SMALL_TOMATO_H)];
            redTomato.image = microTomatoRed;
            redTomato.tag = DayRedTomatoTag;
            [dayView addSubview:redTomato];
            
            IGLabel *redCount = [[IGLabel alloc] initWithFrame:CGRectMake(A02_DAY_COUNT_X, A02_DAY_COUNT_RED_Y, A02_DAY_COUNT_W, A02_DAY_COUNT_H)];
            redCount.textAlignment = UITextAlignmentRight;
            redCount.textColor = [UIColor redColor];
            redCount.font = [UIFont systemFontOfSize:14];
            redCount.tag = DayRedTomatoLabelTag;
            [dayView addSubview:redCount];
            
            UIImageView *grnTomato = [[UIImageView alloc] initWithFrame:CGRectMake(A02_DAY_SMALL_TOMATO_X,A02_DAY_SMALL_TOMATO_GRN_Y,A02_DAY_SMALL_TOMATO_W,A02_DAY_SMALL_TOMATO_H)];
            grnTomato.image = microTomatoGrn;
            grnTomato.tag = DayGrnTomatoTag;
            [dayView addSubview:grnTomato];
            
            IGLabel *grnCount = [[IGLabel alloc] initWithFrame:CGRectMake(A02_DAY_COUNT_X, A02_DAY_COUNT_GRN_Y, A02_DAY_COUNT_W, A02_DAY_COUNT_H)];
            grnCount.textAlignment = UITextAlignmentRight;
            grnCount.textColor = [UIColor greenColor];
            grnCount.font = [UIFont systemFontOfSize:14];
            grnCount.tag = DayGrnTomatoLabelTag;
            [dayView addSubview:grnCount];
            
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [self.contentView addSubview:dayView];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell:(NSIndexPath*)indexPath
{
    
    //初始化完成蕃茄数和未完成蕃茄数字
    finishNum = 0;
    unfinishNum = 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dc = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    
    for (int i = 1; i <= 7; i++) {
        UIView *dayView = [self.contentView viewWithTag:i];
        IGLabel *dayName = (IGLabel *)[dayView viewWithTag:DayNameTag];
        UIImageView *redTomato = (UIImageView*)[dayView viewWithTag:DayRedTomatoTag];
        UIImageView *grnTomato = (UIImageView*)[dayView viewWithTag:DayGrnTomatoTag];
        IGLabel *redCount = (IGLabel *)[dayView viewWithTag:DayRedTomatoLabelTag];
        IGLabel *grnCount = (IGLabel *)[dayView viewWithTag:DayGrnTomatoLabelTag];
        UIImageView *bakImageView = (UIImageView*)[dayView viewWithTag:DayBakTag];
        
        if ((i+startDay < 1) || (i + startDay > monthEndDay)) {
            dayName.text = @"";
            redTomato.hidden = YES;
            grnTomato.hidden = YES;
            redCount.hidden = YES;
            grnCount.hidden = YES;
            if (i == 1) {
                bakImageView.image = sundayBakImage;
            }else {
                bakImageView.image = dayBakImage;
            }
            continue;
        }
        dayName.text = [NSString stringWithFormat:@"%d",i+startDay];
        
        // 取得calendar信息
        NSDateComponents *com = [[NSDateComponents alloc] init];
        com.year = year;
        com.month = month;
        com.day = i+startDay;
        Calendar *calendarDB = [IGTomatoUtil getCalendarByDate:[calendar dateFromComponents:com]];
        redTomato.hidden = NO;
        grnTomato.hidden = NO;
        redCount.hidden = NO;
        grnCount.hidden = NO;
        redCount.text = [NSString stringWithFormat:@"%d",[calendarDB.finished integerValue]];
        grnCount.text = [NSString stringWithFormat:@"%d",[calendarDB.unfinished integerValue]];
        finishNum = finishNum + [calendarDB.finished integerValue];
        unfinishNum = unfinishNum + [calendarDB.unfinished integerValue];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2TomatoListByDate:)];
        [dayView addGestureRecognizer:singleTap];
        
        // 只有有数据的时候显示蕃茄，页面有点空
//        Calendar *calendarDB = [IGTomatoUtil getCalendarByDate:[calendar dateFromComponents:com]];
//        if([calendarDB.finished intValue] > 0 || [calendarDB.unfinished intValue] > 0){
//            redTomato.hidden = NO;
//            grnTomato.hidden = NO;
//            redCount.hidden = NO;
//            grnCount.hidden = NO;
//            redCount.text = [NSString stringWithFormat:@"%d",[calendarDB.finished intValue]];
//            grnCount.text = [NSString stringWithFormat:@"%d",[calendarDB.unfinished intValue]];
//        }else {
//            redTomato.hidden = YES;
//            grnTomato.hidden = YES;
//            redCount.hidden = YES;
//            grnCount.hidden = YES;
//        }
        
        if ([dc year] == year && [dc month] == month && [dc day] == i+startDay) {
            bakImageView.image = todayBakImage;
        }else if (i == 1) {
            bakImageView.image = sundayBakImage;
        }else {
            if (bakImageView.image != dayBakImage) {
                bakImageView.image = dayBakImage;
            }
        }
    }
}

// 点击日期格子事件
- (void)go2TomatoListByDate:(UIGestureRecognizer *)gestureRecognizer 
{
    // 取得当前点击日期格
    IGLabel *dayName = (IGLabel *)[gestureRecognizer.view viewWithTag:DayNameTag];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dc = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDateComponents *com = [[NSDateComponents alloc] init];
    com.year = year;
    com.month = month;
    com.day = [dayName.text integerValue];
    NSDate *inputDate = [calendar dateFromComponents:com];

    // 发送点击通知
    NSDictionary *aUserInfo = [NSDictionary dictionaryWithObject:inputDate forKey:@"date"]; 
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:INFO_CLICK_CALENDAR object:self userInfo:aUserInfo];
}
@end
