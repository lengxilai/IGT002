//
//  IGCoreDataUtil.m
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGCoreDataUtil.h"

@implementation IGCoreDataUtil

static NSManagedObjectContext *staticManagedObjectContext;

+(void)setStaticManagedObjectContext:(NSManagedObjectContext*) managedObjectContext
{
    staticManagedObjectContext = managedObjectContext;
}

+(NSManagedObjectContext*)getStaticManagedObjectContext
{
    return staticManagedObjectContext;
}

// 查询对象表，返回结果NSFetchedResultsController
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryCondition:(NSString *)queryCondition sortDescriptors:(NSArray*) sortDescriptors
{
    // 查询条件设置
    NSPredicate *predicate = nil;
    if(queryCondition != nil){
        predicate = [NSPredicate predicateWithFormat:queryCondition];
    }
    return [self queryForFetchedResult:entityName queryPredicate:predicate sortDescriptors:sortDescriptors];
}

+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray*) sortDescriptors
{
    return [self queryForFetchedResult:entityName queryPredicate:predicate sortDescriptors:sortDescriptors sectionNameKeyPath:nil];
}

// 查询对象表，返回结果arrayList
+(NSArray *)queryForArrayList:(NSString *)entityName queryCondition:(NSPredicate *)queryCondition sortDescriptors:(NSArray*) sortDescriptors
{
    return [self queryForArrayList:entityName queryPredicate:queryCondition sortDescriptors:sortDescriptors];
}

// 查询对象表，返回结果arrayList
+(NSArray *)queryForArrayList:(NSString *)entityName queryPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray*) sortDescriptors
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // 查询对象设置
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:staticManagedObjectContext];
    [request setEntity:entity];
    
    // 查询条件设置
    if(predicate != nil){
       // NSPredicate *predicate = [NSPredicate predicateWithFormat:queryCondition];
        [request setPredicate:predicate];
    }
    
    // 排序设置
    if(sortDescriptors != nil){
        [request setSortDescriptors:sortDescriptors];
    }
    NSError *error = nil;
    NSArray *results=[staticManagedObjectContext executeFetchRequest:request error:&error];
    return results;
}

// 查询对象表，返回结果NSFetchedResultsController
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryCondition:(NSString *)queryCondition sortDescriptors:(NSArray*) sortDescriptors sectionNameKeyPath:(NSString*)sectionKey
{
    // 查询条件设置
    NSPredicate *predicate = nil;
    if(queryCondition != nil){
        predicate = [NSPredicate predicateWithFormat:queryCondition];
    }
    return [self queryForFetchedResult:entityName queryPredicate:predicate sortDescriptors:sortDescriptors sectionNameKeyPath:sectionKey];
}

+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray*) sortDescriptors sectionNameKeyPath:(NSString*)sectionKey
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // 查询对象设置
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:staticManagedObjectContext];
    [request setEntity:entity];
    
    // 查询条件设置
    if (predicate != nil) {
        [request setPredicate:predicate];
    }
    
    // 排序设置
    if(sortDescriptors != nil){
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:staticManagedObjectContext sectionNameKeyPath:sectionKey cacheName:nil];
    
    return fetchedResultsController;
}

+(NSArray*)queryForFetchedResultByExpression:(NSString *)entityName method:(NSString*) method selectColumn:(NSString*) column keyName:(NSString*) keyName queryPredicate:(NSPredicate *)predicate
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // 查询条件设置
    if (predicate != nil) {
        [request setPredicate:predicate];
    }
    
    // 查询对象设置
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:staticManagedObjectContext];
    [request setEntity:entity];
    
    // 求和
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:column];
    NSExpression *expression = [NSExpression expressionForFunction:method arguments:[NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:keyName];
    [expressionDescription setExpression:expression];
    [expressionDescription setExpressionResultType:NSDoubleAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObjects:expressionDescription, nil]];

    [request setResultType:NSDictionaryResultType];

    NSError *error = nil;
    NSArray *fetchResult = [staticManagedObjectContext executeFetchRequest:request error:&error];

    if (error) {
        return nil;
    }
    return fetchResult;
}

@end
