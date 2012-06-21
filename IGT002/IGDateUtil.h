//
//  IGDateUtil.h
//  IGT002
//
//  Created by Ming Liu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGDateUtil : NSObject
+(NSString*)getWeekName:(NSInteger)weekNumber;
+(NSInteger)getWeekNumberForDateComponents:(NSDateComponents*)dc;

+(NSInteger)getLastDayForDateComponents:(NSDateComponents*)dc;
+(NSDateComponents*)addMonth:(NSInteger)monthAdd forDateComponents:(NSDateComponents*)inputDC;
@end
