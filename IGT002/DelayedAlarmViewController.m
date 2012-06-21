//
//  DelayedAlarmViewController.m
//  IGT002
//
//  Created by wang chong on 12-5-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "DelayedAlarmViewController.h"
#import "IGCommonDefine.h"
@interface DelayedAlarmViewController ()

@end

@implementation DelayedAlarmViewController

@synthesize endTime;
@synthesize startTime;
@synthesize perSingleDigitSec;
@synthesize perTensDigitSec;
@synthesize perSingleDigitMin;
@synthesize perTensDigitMin;
@synthesize timer;
@synthesize imageView;
@synthesize delaySeconds;
@synthesize alarmDelegate;

- (id) initWithFrame:(CGRect)viewFrame withDelayTime:(int)delayTime{
    self = [super init];
    if(self){
        //设置上一秒为60
        perSingleDigitSec = 0;
        perTensDigitSec = 0;
        perSingleDigitMin = [self getSingleDigitNum:delayTime];
        perTensDigitMin = [self getTensDigitNum:delayTime];
    }
    delaySeconds = delayTime * 60 + 1;
    [self.view setFrame:viewFrame];
    return self;
}

// 设定计时器的时间
-(void)setDelayTimeWithMin:(NSInteger)min withSec:(NSInteger)sec
{
    perSingleDigitSec = [self getSingleDigitNum:sec];
    perTensDigitSec = [self getTensDigitNum:sec];
    perSingleDigitMin = [self getSingleDigitNum:min];
    perTensDigitMin = [self getTensDigitNum:min];
    delaySeconds = min * 60 + sec + 1;
    
    // 以下设定时间
    // 个位秒
    UIImageView *secondSingleView = (UIImageView *)[self.view viewWithTag:SEC_SINGLE_DIGIT_TAG];
    secondSingleView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",perSingleDigitSec]];
    
    // 十位秒
    UIImageView *secondTenView = (UIImageView *)[self.view viewWithTag:SEC_TEN_DIGIT_TAG];
    secondTenView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",perTensDigitSec]];
    
    // 个位分
    UIImageView *miniteSingleView = (UIImageView *)[self.view viewWithTag:MIN_SINGLE_DIGIT_TAG];
    miniteSingleView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",perSingleDigitMin]];
    
    // 十位分
    UIImageView *miniteTenView = (UIImageView *)[self.view viewWithTag:MIN_TEN_DIGIT_TAG];
    miniteTenView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",perTensDigitMin]];
}

//点击开始按钮调用的函数
-(void)start{
    startTime = [NSDate date];
    endTime = [NSDate dateWithTimeIntervalSinceNow:delaySeconds];
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.2
                                             target: self
                                           selector: @selector(handleTimer:)
                                           userInfo: nil
                                            repeats: YES];    
}
//倒计时停止
-(void)pause{
    [timer invalidate];
}
- (void)viewDidLoad
{
    
    UIImage *miniteTen = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",perTensDigitMin]];
    UIImage *miniteSingle = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",perSingleDigitMin]];
    UIImage *secondTen = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",perTensDigitSec]];
    UIImage *secondSingle = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",perSingleDigitSec]];
    UIImage *colon  = [UIImage imageNamed:@"maohao.png"];
    
    UIImageView *colonView = [[UIImageView alloc]initWithImage:colon];
    colonView.frame = CGRectMake(COLON_VIEW_X, COLON_VIEW_Y, COLON_VIEW_W, COLON_VIEW_H);
    //分钟十位的图片
    UIImageView *miniteTenView = [[UIImageView alloc]initWithImage:miniteTen];
    miniteTenView.frame = CGRectMake(MIN_TEN_DIGIT_VIEW_X, MIN_TEN_DIGIT_VIEW_Y, MIN_TEN_DIGIT_VIEW_W, MIN_TEN_DIGIT_VIEW_H);
    miniteTenView.tag = MIN_TEN_DIGIT_TAG;
    //分钟个位的图片
    UIImageView *miniteSingleView = [[UIImageView alloc]initWithImage:miniteSingle];
    miniteSingleView.frame = CGRectMake(MIN_SINGLE_DIGIT_VIEW_X, MIN_SINGLE_DIGIT_VIEW_Y, MIN_SINGLE_DIGIT_VIEW_W, MIN_SINGLE_DIGIT_VIEW_H);
    miniteSingleView.tag = MIN_SINGLE_DIGIT_TAG;
    //秒数十位的图片
    UIImageView *secondTenView = [[UIImageView alloc]initWithImage:secondTen];
    secondTenView.frame = CGRectMake(SEC_TEN_DIGIT_VIEW_X, SEC_TEN_DIGIT_VIEW_Y, SEC_TEN_DIGIT_VIEW_W, SEC_TEN_DIGIT_VIEW_H);
    secondTenView.tag = SEC_TEN_DIGIT_TAG;
    //秒数个位的图片
    UIImageView *secondSingleView = [[UIImageView alloc]initWithImage:secondSingle];
    secondSingleView.frame = CGRectMake(SEC_SINGLE_DIGIT_VIEW_X, SEC_SINGLE_DIGIT_VIEW_Y, SEC_SINGLE_DIGIT_VIEW_W, SEC_SINGLE_DIGIT_VIEW_H);
    secondSingleView.tag = SEC_SINGLE_DIGIT_TAG;
    
    [self.view addSubview:miniteTenView];
    [self.view addSubview:miniteSingleView];
    [self.view addSubview:secondTenView];
    [self.view addSubview:secondSingleView];
    [self.view addSubview:colonView];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//倒计时计算 显示
- (void) handleTimer:(NSTimer *)timer
{
    //取得当前时间
    NSDate *timeNow = [NSDate date];
    
    NSCalendar* clendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags =  NSMinuteCalendarUnit |NSSecondCalendarUnit;
    //开始时间（＋25分钟）与当前时间比较
    NSDateComponents *cps = [ clendar components:unitFlags fromDate:timeNow toDate:endTime  options:0];
    //取得分钟差
    NSInteger diffMin = [cps minute];
    //取得秒数差
    NSInteger diffSec = [cps second];
    
    //秒数十位
    int tensDigitSec = [self getTensDigitNum:diffSec];
    //秒数个位
    int singleDigitSec = [self getSingleDigitNum:diffSec];
    //分钟十位
    int tensDigitMin = [self getTensDigitNum:diffMin];
    //分钟个位
    int singleDigitMin = [self getSingleDigitNum:diffMin];
    //分钟变化标志
    bool isTimeChanged = (perTensDigitMin == tensDigitMin) &&
    (perSingleDigitMin == singleDigitMin) &&
    (perTensDigitSec == tensDigitSec) &&
    (perSingleDigitSec == singleDigitSec);
    
    //时间没变化
    if(isTimeChanged){
        
    }else {
        //个位秒数发生变化
        if(singleDigitSec != perSingleDigitSec){
            NSString *singleDigitSecImagePath = [self getSingleDigitImageName:diffSec];
            UIImageView *secondSingleView = (UIImageView *)[self.view viewWithTag:SEC_SINGLE_DIGIT_TAG];
            secondSingleView.image = [UIImage imageNamed:singleDigitSecImagePath];
            
            [self changeImage:secondSingleView tagNum:SEC_SINGLE_DIGIT_COVER_TAG image:[UIImage imageNamed:[self getSingleDigitImageName:perSingleDigitSec]]];
            perSingleDigitSec = singleDigitSec;
        }
        //十位秒数发生变化
        if(tensDigitSec != perTensDigitSec){
            NSString *tensDigitSecImagePath = [self getTensDigitImageName:diffSec];
            UIImageView *secondTenView = (UIImageView *)[self.view viewWithTag:SEC_TEN_DIGIT_TAG];
            secondTenView.image = [UIImage imageNamed:tensDigitSecImagePath];
            [self changeImage:secondTenView tagNum:SEC_TEN_DIGIT_COVER_TAG image:[UIImage imageNamed:[self getSingleDigitImageName:perTensDigitSec]]];
            perTensDigitSec = tensDigitSec;
        }
        //个位分钟发生变化
        if(singleDigitMin != perSingleDigitMin){
            NSString *singleDigitMinImagePath = [self getSingleDigitImageName:diffMin];
            UIImageView *miniteSingleView = (UIImageView *)[self.view viewWithTag:MIN_SINGLE_DIGIT_TAG];
            miniteSingleView.image = [UIImage imageNamed:singleDigitMinImagePath];
            [self changeImage:miniteSingleView tagNum:MIN_SINGLE_DIGIT_COVER_TAG image:[UIImage imageNamed:[self getSingleDigitImageName:perSingleDigitMin]]];
            perSingleDigitMin = singleDigitMin;
        }
        //十位分钟发生变化
        if(tensDigitMin != perTensDigitMin){
            NSString *tensDigitMinImagePath = [self getTensDigitImageName:diffMin];
            UIImageView *miniteTenView = (UIImageView *)[self.view viewWithTag:MIN_TEN_DIGIT_TAG];
            miniteTenView.image = [UIImage imageNamed:tensDigitMinImagePath];
            [self changeImage:miniteTenView tagNum:MIN_TEN_DIGIT_COVER_TAG image:[UIImage imageNamed:[self getSingleDigitImageName:perTensDigitMin]]];
            perTensDigitMin = tensDigitMin;
        }
    }
    //如果倒计时结束
    if(diffMin <= 0 && diffSec <= 0){
        [timer invalidate];
        // 通知委托类
        if ([self.alarmDelegate respondsToSelector:@selector(onAlarmEnd)]) {
            [self.alarmDelegate onAlarmEnd];
        }
    }
}
//取得个位得图片
-(NSString *) getSingleDigitImageName:(int) num{
    int remainder = num % 10<0 ? 0 : num % 10;
    //[self getImagePathByNum:remainder];
    NSString *path = [NSString stringWithFormat:@"%d.png",remainder];
    return path;
}
// 取得十位得图片
-(NSString *) getTensDigitImageName:(int) num{
    int remainder = num / 10 < 0 ? 0 : num / 10;
    NSString *path = [NSString stringWithFormat:@"%d.png",remainder];
    return path;
}
// 取得个位数
-(int) getSingleDigitNum:(int) num{
    int remainder = num % 10;
    //[self getImagePathByNum:remainder];
    return remainder<0?0:remainder;
}
// 取得十位数
-(int) getTensDigitNum:(int) num{
    int remainder = num / 10;
    return remainder<0?0:remainder;
}

// 变换图片
-(void) changeImage:(UIImageView *)imageView tagNum:(int)tagNum image:(UIImage *)image{
    UIImageView *coverSecondSingleView = (UIImageView *)[self.view viewWithTag:tagNum];
    if(!coverSecondSingleView){
        coverSecondSingleView = [[UIImageView alloc] initWithFrame:imageView.frame];
        coverSecondSingleView.tag = tagNum;
    }else {
        coverSecondSingleView.frame = imageView.frame;
    }
    CGRect newFrame = imageView.frame;
    newFrame.size.height = HIGHT_ZERO;
    newFrame.origin.y = HALF_Y;
    coverSecondSingleView.image = image;
    [self.view addSubview:coverSecondSingleView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    [coverSecondSingleView setFrame:newFrame];
    [UIView commitAnimations];
}
@end
