//
//  Tomato.h
//  IGT002
//
//  Created by Ming Liu on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Calendar, StopReason, TomatoName;

@interface Tomato : NSManagedObject

@property (nonatomic, retain) NSDate * endtime;
@property (nonatomic, retain) NSDate * starttime;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSDate * tomatodate;
@property (nonatomic, retain) Calendar *calendar;
@property (nonatomic, retain) TomatoName *tomatoname;
@property (nonatomic, retain) StopReason *stopreason;

@end
