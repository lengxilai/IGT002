//
//  IGCoreDataUtil.h
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IGAppDelegate;

@interface IGCoreDataUtil : NSObject;

+(void)setStaticManagedObjectContext:(NSManagedObjectContext*) managedObjectContext;
+(NSManagedObjectContext*)getStaticManagedObjectContext;
// 查询
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryCondition:(NSString *)queryCondition sortDescriptors:(NSArray*) sortDescriptors;
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray*) sortDescriptors;
// 查询返回NSArray
+(NSArray *)queryForArrayList:(NSString *)entityName queryCondition:(NSPredicate *)queryCondition sortDescriptors:(NSArray*) sortDescriptors;
+(NSArray *)queryForArrayList:(NSString *)entityName queryPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray*) sortDescriptors;
// 查询返回NSFetchedResultsController
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryCondition:(NSString *)queryCondition sortDescriptors:(NSArray*) sortDescriptors sectionNameKeyPath:(NSString*)sectionKey;
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray*) sortDescriptors sectionNameKeyPath:(NSString*)sectionKey;
+(NSArray*)queryForFetchedResultByExpression:(NSString *)entityName method:(NSString*) method selectColumn:(NSString*) column keyName:(NSString*) keyName queryPredicate:(NSPredicate *)predicate;
@end
