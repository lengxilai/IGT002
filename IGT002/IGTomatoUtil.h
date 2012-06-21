//
//  IGPlanUtil.h
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSDate+Helper.h"
#import "Tomato.h"
#import "Calendar.h"
#import "StopReason.h"
#import "TomatoName.h"
#import "IGCoreDataUtil.h"
#import "Config.h"
#import "IGCommonDefine.h"

@class IGAppDelegate;
@interface IGTomatoUtil : NSObject

+(void)setStaticMoc:(NSManagedObjectContext*) moc;
+(NSManagedObjectContext*)getStaticMoc;

// 生成测试数据
+(void)createTestData;

// 添加一个西红柿
+(void)addTomatoByValues:(NSString *)name starttime:(NSDate *)starttime endtime: (NSDate *)endtime state:(Boolean)state stopreason: (NSString *) reason;
// 添加西红柿名
+(TomatoName*)addTomatoNameByValues:(NSString *)name;
// 添加一个停止理由
+(StopReason*)addStopReasonByValues:(NSString *)name;
// 添加一个日历
+(Calendar*)addCalendarByValues:(NSDate *)date;
// 取得西红柿名
+(TomatoName*)getTomatoNameByName:(NSString *)name;
// 取得停止理由
+(StopReason*)getStopReasonByName:(NSString *)name;
// 取得日历
+(Calendar*)getCalendarByDate:(NSDate *)date;
// 取得设置信息
+(Config*)getConfigInfoForKey:(NSString*)key;
// 取得count总数（tomatoname,stopreason）
+(NSArray*)getTotalCount:(NSString *)entityName method:(NSString*) method selectColumn:(NSString*) column keyName:(NSString*) keyName queryPredicate:(NSPredicate *)predicate;
// 取得count最大（tomatoname,stopreason）
+(NSArray*)getMaxCount:(NSString *)entityName method:(NSString*) method selectColumn:(NSString*) column keyName:(NSString*) keyName queryPredicate:(NSPredicate *)predicate;
// 创建设置信息
+(Config *)createConfigForKey:(NSString*)key forValue:(NSString*)value;
// 保存数据库
+(void)saveDB;
//取得各显示项目的值  如果为空值  则插入基础数据
+(NSString *)getConfigValueWithKey:(NSString *)keyName withDefaultValue:(NSString *)defaultValue;
// 返回所有蕃茄名
+(NSMutableArray*)getTomatoNames;
// 返回所有停止原因
+(NSMutableArray*)getStopReasons;
@end
