//
//  IGCalendarWeekCellControllerCell.h
//  IGT002
//
//  Created by Ming Liu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCommonDefine.h"
#import "IGCoreDataUtil.h"
#import "IGTomatoUtil.h"

@interface IGCalendarWeekCellControllerCell : UITableViewCell
{
    NSInteger startDay;
    NSInteger startWeekNum;
    NSInteger monthEndDay;
    UIImage *todayBakImage;
    UIImage *sundayBakImage;
    UIImage *dayBakImage;
    UIImage *microTomatoRed;
    UIImage *microTomatoGrn;
    NSInteger month;
    NSInteger year;
    // 纪录完成蕃茄数和失败番茄数字
    NSInteger finishNum;
    NSInteger unfinishNum;
}

@property(nonatomic) NSInteger startDay;
@property(nonatomic) NSInteger startWeekNum;
@property(nonatomic) NSInteger monthEndDay;
@property(nonatomic) NSInteger month;
@property(nonatomic) NSInteger year;
@property(nonatomic) NSInteger finishNum;
@property(nonatomic) NSInteger unfinishNum;

-(void)updateCell:(NSIndexPath*)indexPath;
@end
