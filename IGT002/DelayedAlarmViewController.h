//
//  DelayedAlarmViewController.h
//  IGT002
//
//  Created by wang chong on 12-5-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IGDelayedAlarmDelegate

@optional
- (void)onAlarmEnd;
@end

@interface DelayedAlarmViewController : UIViewController{@private
    NSDate *endTime;
    NSDate *startTime;
    int perSingleDigitSec;
    int perTensDigitSec;
    int perSingleDigitMin;
    int perTensDigitMin;
    UIImageView *imageView;
    NSTimer *timer;
    int delaySeconds;
    id alarmDelegate;
}
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, retain) NSDate *startTime;
@property int perSingleDigitSec;
@property int perTensDigitSec;
@property int perSingleDigitMin;
@property int perTensDigitMin;
@property int delaySeconds;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) id alarmDelegate;
- (void)start;
- (void)pause;
- (id) initWithFrame:(CGRect)viewFrame withDelayTime:(int)delayTime;
-(void)setDelayTimeWithMin:(NSInteger)min withSec:(NSInteger)sec;
@end
