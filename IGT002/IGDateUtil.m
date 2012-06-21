//
//  IGDateUtil.m
//  IGT002
//
//  Created by Ming Liu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGDateUtil.h"

@implementation IGDateUtil

// 返回星期的略称
+(NSString*)getWeekName:(NSInteger)weekNumber
{
    switch (weekNumber) {
		case 1:
			return NSLocalizedString(@"周日",@"周日");
			break;
		case 2:
			return NSLocalizedString(@"周一",@"周一");
			break;
		case 3:
			return NSLocalizedString(@"周二",@"周二");
			break;
		case 4:
			return NSLocalizedString(@"周三",@"周三");
			break;
		case 5:
			return NSLocalizedString(@"周四",@"周四");
			break;
		case 6:
			return NSLocalizedString(@"周五",@"周五");
			break;
		case 7:
			return NSLocalizedString(@"周六",@"周六");
			break;
		default:
			break;
	}
}

// 按照日期返回星期几
+(NSInteger)getWeekNumberForDateComponents:(NSDateComponents*)dc
{	
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:dc];
	return [date weekday];
}

// 本月最后一天
+(NSInteger)getLastDayForDateComponents:(NSDateComponents*)dc
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:dc];
    
    NSDateComponents *m1 = [[NSDateComponents alloc] init];
    [m1 setMonth:1];
    // 下月第一天
    NSDate *mplus1Date = [calendar dateByAddingComponents:m1 toDate:date options:0];
    
    NSDateComponents *d1 = [[NSDateComponents alloc] init];
    [d1 setDay:-1];
    // 本月最后一天
    NSDate *lastDayDate = [calendar dateByAddingComponents:d1 toDate:mplus1Date options:0];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:lastDayDate];
    return [dayComponents day];
}

// 返回月份加减
+(NSDateComponents*)addMonth:(NSInteger)monthAdd forDateComponents:(NSDateComponents*)inputDC
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = [calendar dateFromComponents:inputDC];
    
    NSDateComponents *m1 = [[NSDateComponents alloc] init];
    [m1 setMonth:monthAdd];
    // 下月第一天
    NSDate *resultDate = [calendar dateByAddingComponents:m1 toDate:date options:0];
    
    return [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:resultDate];
}
@end
