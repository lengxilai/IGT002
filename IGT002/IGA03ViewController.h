//
//  IGA03ViewController.h
//  IGT002
//
//  Created by Ming Liu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCommonDefine.h"
#import "IGTomatoUtil.h"

@class IGCoreDataUtil;

@interface IGA03ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NSFetchedResultsControllerDelegate>
{
    UITableView *listTableView;
    IGTextField *searchText;
    // 成功率
    IGLabel *precentLabel;
    
    // 红绿条长度
    float length;
    // 好西红柿总个数
    NSString *totalCountOfGoodTomato;
    // 停止原因总个数
    NSString *totalCountOfStopReason;
    // 好西红柿最大个数
    NSString *maxCountOfGoodTomato;
    // 停止原因最大个数
    NSString *maxCountOfStopReason;
    NSFetchedResultsController *fetchedResultsControllerOfGoodTomato;
    NSFetchedResultsController *fetchedResultsControllerOfStopReason;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerOfGoodTomato;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerOfStopReason;

@end
