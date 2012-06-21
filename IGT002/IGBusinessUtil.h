//
//  IGBusinessUtil.h
//  IGT001
//
//  Created by Ming Liu on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Helper.h"
#import "IGLabel.h"

@class Tomato;
@class TomatoName;
@interface IGBusinessUtil : NSObject

+(void)printSubviews:(UIView*)view;
//返回该程序的档案目录，用来简单使用
+ (NSString *)applicationDocumentsDirectory;
+(NSDate*)getTodayDate;
+(void)addAlertForDate:(NSDate*)fireDate forName:(NSString*)alertName;
+(void)removeAlert;
@end
