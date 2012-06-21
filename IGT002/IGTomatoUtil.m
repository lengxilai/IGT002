//
//  IGPlanUtil.m
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGTomatoUtil.h"

@implementation IGTomatoUtil

static NSManagedObjectContext *staticMoc;

+(void)setStaticMoc:(NSManagedObjectContext*) moc
{
    staticMoc = moc;
}

+(NSManagedObjectContext*)getStaticMoc
{
    return staticMoc;
}

// 生成测试数据
+(void)createTestData{
    
    // 一个好西红柿
    [self addTomatoByValues:@"背单词" starttime:[NSDate date] endtime:[NSDate dateWithTimeIntervalSinceNow:1800]  state:YES stopreason:nil];
    // 另一个好西红柿
    [self addTomatoByValues:@"背单词" starttime:[NSDate date] endtime:[NSDate dateWithTimeIntervalSinceNow:1800]  state:YES stopreason:nil];
    // 另一个好西红柿
    [self addTomatoByValues:@"写代码" starttime:[NSDate date] endtime:[NSDate dateWithTimeIntervalSinceNow:1800]  state:YES stopreason:nil];
    // 另一个好西红柿
    [self addTomatoByValues:@"写代码" starttime:[NSDate date] endtime:[NSDate dateWithTimeIntervalSinceNow:1800]  state:YES stopreason:nil];
    
    // 一个坏西红柿
    [self addTomatoByValues:@"背单词" starttime:[NSDate date] endtime:[NSDate dateWithTimeIntervalSinceNow:1800]  state:NO stopreason:@"接电话"];
    // 另一个坏西红柿
    [self addTomatoByValues:@"背单词" starttime:[NSDate date] endtime:[NSDate dateWithTimeIntervalSinceNow:1800]  state:NO stopreason:@"吃东西"];
    // 另一个坏西红柿
    [self addTomatoByValues:@"写代码" starttime:[NSDate date] endtime:[NSDate dateWithTimeIntervalSinceNow:1800]  state:NO stopreason:@"看电视"];
    // 另一个坏西红柿
    [self addTomatoByValues:@"写代码" starttime:[NSDate date] endtime:[NSDate dateWithTimeIntervalSinceNow:1800]  state:NO stopreason:@"看电视"];
    
}

// 添加一个西红柿
+(void)addTomatoByValues:(NSString *)name starttime:(NSDate *)starttime endtime: (NSDate *)endtime state:(Boolean)state stopreason: (NSString *) reason{
    
    // 如果停止理由为空，则设定一个
    if(reason == nil || [@"" isEqualToString:reason]){
        reason = NSLocalizedString(@"未知原因",@"未知原因");
    }
    if (name == nil || [@"" isEqualToString:name]) {
        name = NSLocalizedString(@"未命名的蕃茄", @"未命名的蕃茄");
    }
    
    // 创建一个蕃茄
    Tomato *tomato = [NSEntityDescription insertNewObjectForEntityForName:@"Tomato" inManagedObjectContext:staticMoc];
    tomato.starttime = starttime;
    tomato.endtime = endtime;
    tomato.state = [NSNumber numberWithBool:state];
    
    // 取得既存蕃茄名
    TomatoName *tomatoName = [self getTomatoNameByName:name];
    // 如果取不到则新建一个
    if(tomatoName == nil){
        tomatoName = [self addTomatoNameByValues:name];
    }
    
    // 如果能取到则把件数加1
    if (state) {
        tomatoName.count = [NSNumber numberWithInt:[tomatoName.count intValue]+1];
    }
    
    // 设定蕃茄名称
    tomato.tomatoname = tomatoName;
    
    // 如果状态为非正常结束则设定停止理由
    if (!state) {
        // 取得停止理由
        StopReason *stopReason = [self getStopReasonByName:reason];
        // 如果取得不到，则新建一个
        if(stopReason == nil){
            stopReason = [self addStopReasonByValues:reason];
        }else {
            // 如果能取得到，则把件数加1
            stopReason.count = [NSNumber numberWithInt:[stopReason.count intValue]+1];
        }
        // 设定停止理由
        tomato.stopreason = stopReason;
    }
    
    // 更新日历
    Calendar *calendar = [self getCalendarByDate:starttime];
    if(calendar == nil){
        calendar = [self addCalendarByValues:starttime];
    }
    tomato.tomatodate = calendar.datetime;
    // 设定件数
    if(state){
        calendar.finished = [NSNumber numberWithInteger:[calendar.finished integerValue] + 1];
    }else {
        calendar.unfinished = [NSNumber numberWithInteger:[calendar.unfinished integerValue] + 1];
    }
    
    // 发送添加蕃茄通知
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:INFO_ADD_TOMATO object:self userInfo:nil];
    [self saveDB];
}

// 添加西红柿名
+(TomatoName*)addTomatoNameByValues:(NSString *)name{
    TomatoName *tomatoName = [NSEntityDescription insertNewObjectForEntityForName:@"TomatoName" inManagedObjectContext:staticMoc];
    tomatoName.name = name;
    tomatoName.count = [NSNumber numberWithInt:0];
    return tomatoName;
}

// 添加一个停止理由
+(StopReason*)addStopReasonByValues:(NSString *)name{
    StopReason *stopReason = [NSEntityDescription insertNewObjectForEntityForName:@"StopReason" inManagedObjectContext:staticMoc];
    stopReason.name = name;
    stopReason.count = [NSNumber numberWithInt:1];
    return stopReason;
}

// 添加一个日历
+(Calendar*)addCalendarByValues:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 只取输入时间的年月日
    NSDateComponents *dateDC = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                           fromDate:date];
    NSDate *inputDate = [calendar dateFromComponents:dateDC];
    
    Calendar *newCalendar = [NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:staticMoc];
    newCalendar.datetime =  inputDate;
    newCalendar.finished = [NSNumber numberWithInt:0];
    newCalendar.unfinished = [NSNumber numberWithInt:0];
    return newCalendar;
}

+(NSMutableArray*)getTomatoNames
{
    NSArray* tomatoNames = [IGCoreDataUtil queryForArrayList:@"TomatoName" queryCondition:nil sortDescriptors:nil];
    NSMutableArray* result;
    if ([tomatoNames count] > 0) {
        if (result == nil) {
            result = [NSMutableArray arrayWithCapacity:[tomatoNames count]];
        }
        for (int i = 0; i < [tomatoNames count]; i++) {
            TomatoName *tomatoName = [tomatoNames objectAtIndex:i];
            [result addObject:tomatoName.name];
        }
    }
    return result;
}

+(NSMutableArray*)getStopReasons
{
    NSArray* stopReasons = [IGCoreDataUtil queryForArrayList:@"StopReason" queryCondition:nil sortDescriptors:nil];
    NSMutableArray* result;
    if ([stopReasons count] > 0) {
        if (result == nil) {
            result = [NSMutableArray arrayWithCapacity:[stopReasons count]];
        }
        for (int i = 0; i < [stopReasons count]; i++) {
            StopReason *stopReason = [stopReasons objectAtIndex:i];
            [result addObject:stopReason.name];
        }
    }
    return result;
}

// 取得西红柿名
+(TomatoName*)getTomatoNameByName:(NSString *)name{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" (name == %@ )",name];
    
    NSArray *returnValue = 
    [IGCoreDataUtil queryForArrayList:@"TomatoName" queryCondition:predicate sortDescriptors:nil];
    
    if([returnValue count] == 0){
        return nil;
    }
    return (TomatoName *)[returnValue objectAtIndex:0];
}

// 取得停止理由
+(StopReason*)getStopReasonByName:(NSString *)name{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" (name == %@ )",name];
    
    NSArray *returnValue = 
    [IGCoreDataUtil queryForArrayList:@"StopReason" queryCondition:predicate sortDescriptors:nil];
    
    if([returnValue count] == 0){
        return nil;
    }
    return (StopReason *)[returnValue objectAtIndex:0];
}

// 取得日历表
+(Calendar*)getCalendarByDate:(NSDate *)date{
    
    unsigned startUnitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit; 
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 只取输入时间的年月日
    NSDateComponents *dateDC = [calendar components:startUnitFlags fromDate:date];
    
    NSDate *inputDate = [calendar dateFromComponents:dateDC];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"( datetime >= %@ ) AND ( datetime <= %@ )",inputDate,inputDate];
    
    NSArray *returnValue = 
    [IGCoreDataUtil queryForArrayList:@"Calendar" queryCondition:predicate sortDescriptors:nil];
    
    if([returnValue count] == 0){
        return nil;
    }
    return (Calendar *)[returnValue objectAtIndex:0];
}

// 保存数据库
+(void)saveDB{
    NSError *error = nil;
    if (![[self getStaticMoc] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

+(Config*)getConfigInfoForKey:(NSString*)key
{
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Config" inManagedObjectContext:[self getStaticMoc]];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"key = %@", key];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *array = [[self getStaticMoc] executeFetchRequest:request error:&error];
	if (array != nil && [array count] > 0)
	{
		Config *config = [array objectAtIndex:0];
		return config;
	}else {
		return nil;
	}
}

// 按照表，字段进行求和
+(NSArray*)getTotalCount:(NSString *)entityName method:(NSString*) method selectColumn:(NSString*) column keyName:(NSString*) keyName queryPredicate:(NSPredicate *)predicate
{
	return [IGCoreDataUtil queryForFetchedResultByExpression:entityName method:method selectColumn:column keyName:keyName queryPredicate:(NSPredicate *)predicate];
}

// 按照表，字段进行取最大
+(NSArray*)getMaxCount:(NSString *)entityName method:(NSString*) method selectColumn:(NSString*) column keyName:(NSString*) keyName queryPredicate:(NSPredicate *)predicate
{
	return [IGCoreDataUtil queryForFetchedResultByExpression:entityName method:method selectColumn:column keyName:keyName queryPredicate:(NSPredicate *)predicate];
}

+(Config *)createConfigForKey:(NSString*)key forValue:(NSString*)value
{
    Config *newConfig = (Config*)[[Config alloc] initWithEntity:[NSEntityDescription entityForName:@"Config" inManagedObjectContext:[self getStaticMoc]] insertIntoManagedObjectContext:[self getStaticMoc]];
    newConfig.key = key;
    newConfig.value = value;
    [self saveDB];
    return newConfig;
}
//取得各显示项目的值  如果为空值  则插入基础数据
+(NSString *)getConfigValueWithKey:(NSString *)keyName withDefaultValue:(NSString *)defaultValue{
    Config *config =[IGTomatoUtil getConfigInfoForKey:keyName];
    if (config == nil) {
        [IGTomatoUtil createConfigForKey:keyName forValue:defaultValue];
        return defaultValue;
    }else{
        return config.value;
    }
}
@end
