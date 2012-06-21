//
//  IGBusinessUtil.m
//  IGT001
//
//  Created by Ming Liu on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBusinessUtil.h"

@implementation IGBusinessUtil

+(void)printSubviews:(UIView*)view
{
    if ([[view subviews] count]>0) {
        for (UIView *subView in [view subviews]) {
            [self printSubviews:subView];
        }
    }else {
        NSLog(@"view is %@. super view is: %@.", [view class], [[view superview] class]);
        if ([view isKindOfClass:[UILabel class]]) {
            NSLog(@"UILabel text is :%@.", ((UILabel*)view).text);
        }
    }
}

//返回该程序的档案目录，用来简单使用
+ (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

// 返回当日日期Date，只有年月日
+(NSDate*)getTodayDate
{
    unsigned startUnitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit; 
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 只取输入时间的年月日
    NSDateComponents *dateDC = [calendar components:startUnitFlags fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:dateDC];
    return today;
}

// 添加闹钟提醒
+(void)addAlertForDate:(NSDate*)fireDate forName:(NSString*)alertName
{   
	// 取消先前的通知
	NSArray *myArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
	for (int i=0; i<[myArray count]; i++) {
		UILocalNotification	*myUILocalNotification=[myArray objectAtIndex:i];
		if ([[[myUILocalNotification userInfo] objectForKey:@"tomatoalert"] isEqualToString:@"OK"]) {
			[[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
		}
	}
	
	// 创建本地通知
	UILocalNotification *notification = [[UILocalNotification alloc] init]; 
	notification.timeZone = [NSTimeZone defaultTimeZone]; 
	// 不重复提示
	notification.repeatInterval=0;
	notification.alertAction = alertName;
    
    // 提醒时间
	notification.fireDate = fireDate;
	notification.alertBody= [NSString stringWithFormat:
                             NSLocalizedString(@"%@，完成",@"%@，完成"),
                             alertName];
	
	[notification setSoundName:UILocalNotificationDefaultSoundName];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"OK", @"tomatoalert", nil];
	[notification setUserInfo:dict];
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消闹钟提醒
+(void)removeAlert
{
	// 取消先前的通知
	NSArray *myArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
	for (int i=0; i<[myArray count]; i++) {
		UILocalNotification	*myUILocalNotification=[myArray objectAtIndex:i];
		if ([[[myUILocalNotification userInfo] objectForKey:@"tomatoalert"] isEqualToString:@"OK"]) {
			[[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
		}
	}
}
@end
