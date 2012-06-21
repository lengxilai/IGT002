//
//  IGA01ViewController.h
//  IGT002
//
//  Created by Ming Liu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCommonDefine.h"
#import "IGTomatoUtil.h"
#import "IGTextSelector.h"
#import "IGBusinessUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "IGA05ViewController.h"

@class IGCoreDataUtil;
@class Tomato;
@class TomatoName;
@class StopReason;
@class Calendar;
@interface IGA01ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,IGDelayedAlarmDelegate,NSFetchedResultsControllerDelegate>
{
    UIImageView *tomatoImageView;
    UIButton *leftButton;
    UIButton *rightButton;
    UITableView *listTableView;
    IGLabel *tomatoTime;
    IGLabel *tomatoTitle;
    DelayedAlarmViewController *delayedAlarm;
    NSFetchedResultsController *fetchedResultsController;
    NSInteger state;
    IGTextSelector *textSelector;
    AVAudioPlayer *player;
    IGA05ViewController *helpViewController;
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,retain)IGTextSelector *textSelector;
- (void)onAlarmEnd;
-(void)playFinished;
@end
