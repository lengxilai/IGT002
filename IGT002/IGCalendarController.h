//
//  IGCalendarController.h
//  IGT002
//
//  Created by Ming Liu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCalendarWeekCellControllerCell.h"
#import "IGCoreDataUtil.h"

@interface IGCalendarController : UITableViewController
{
    NSDateComponents *dc;
    NSInteger startWeekNum;
    NSInteger monthEndDay;
    UIView *tableTitleView;
    UIView *tableFooterView;
    
    // 本月的完成番茄数
    NSInteger finishForMonth;
    NSInteger unfinishForMonth;
}

@property(nonatomic) NSInteger finishForMonth;
@property(nonatomic) NSInteger unfinishForMonth;

-(void)setDateComponents:(NSDateComponents*)inputDC;
-(void)toToday;
@end
