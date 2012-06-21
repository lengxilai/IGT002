//
//  Calendar.h
//  IGT002
//
//  Created by 鹏 李 on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Calendar : NSManagedObject

@property (nonatomic, retain) NSDate * datetime;
@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSNumber * unfinished;

@end
