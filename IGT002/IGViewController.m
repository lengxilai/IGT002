//
//  IGViewController.m
//  IGT002
//
//  Created by Ming Liu on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGViewController.h"

@implementation IGViewController
@synthesize startTime;
@synthesize perSingleDigitSec;
@synthesize perTensDigitSec;
@synthesize perSingleDigitMin;
@synthesize perTensDigitMin;

@synthesize imageView;
- (id) init{
    self = [super init];
    if(self){
        //设置上一秒为60
        perSingleDigitSec = 0;
        perTensDigitSec = 0;
        perSingleDigitMin = 5;
        perTensDigitMin = 2;
        startTime=[NSDate dateWithTimeIntervalSinceNow:1500];
     }
    return self;
}

- (void)viewDidLoad
{
    
    UIImage *miniteTen = [UIImage imageNamed:@"2.png"];
    UIImage *miniteSingle = [UIImage imageNamed:@"5.png"];
    UIImage *secondTen = [UIImage imageNamed:@"0.png"];
    UIImage *secondSingle = [UIImage imageNamed:@"0.png"];
    //分钟十位的图片
    UIImageView *miniteTenView = [[UIImageView alloc]initWithImage:miniteTen];
    miniteTenView.frame = CGRectMake(0, 10, 50, 95);
    miniteTenView.tag = 95;
    //分钟个位的图片
    UIImageView *miniteSingleView = [[UIImageView alloc]initWithImage:miniteSingle];
    miniteSingleView.frame = CGRectMake(53, 10, 50, 95);
    miniteSingleView.tag = 96;
    //秒数十位的图片
    UIImageView *secondTenView = [[UIImageView alloc]initWithImage:secondTen];
    secondTenView.frame = CGRectMake(106, 10, 50, 95);
    secondTenView.tag = 97;
    //秒数个位的图片
    UIImageView *secondSingleView = [[UIImageView alloc]initWithImage:secondSingle];
    secondSingleView.frame = CGRectMake(159, 10, 50, 95);
    secondSingleView.tag = 98;
    
    [self.view addSubview:miniteTenView];
    [self.view addSubview:miniteSingleView];
    [self.view addSubview:secondTenView];
    [self.view addSubview:secondSingleView];


    UIImageView *tomato = [[UIImageView alloc] initWithFrame:CGRectMake(10, 200, 200, 200)];
    tomato.image = [UIImage imageNamed:@"tomato.png"];
    
    UIButton *button = [UIButton buttonWithType:UIBarButtonItemStylePlain];
    button.frame = CGRectMake(50, 400, 80, 40);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"启动" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    [self.view addSubview:tomato];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//倒计时计算 显示
- (void) handleTimer: (NSTimer *) timer
{
    //取得当前时间
    NSDate *timeNow = [NSDate date];
    
    NSCalendar* clendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags =  NSMinuteCalendarUnit |NSSecondCalendarUnit;
    //开始时间（＋25分钟）与当前时间比较
    NSDateComponents *cps = [ clendar components:unitFlags fromDate:timeNow toDate:startTime  options:0];
    //取得分钟差
    NSInteger diffMin = [ cps minute ];
    //取得秒数差
    NSInteger diffSec = [ cps second ];
    
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
            UIImageView *secondSingleView = (UIImageView *)[self.view viewWithTag:98];
            secondSingleView.image = [UIImage imageNamed:singleDigitSecImagePath];
            
            [self changeImage:secondSingleView tagNum:101 image:[UIImage imageNamed:[self getSingleDigitImageName:perSingleDigitSec]]];
            perSingleDigitSec = singleDigitSec;
        }
        //十位秒数发生变化
        if(tensDigitSec != perTensDigitSec){
            NSString *tensDigitSecImagePath = [self getTensDigitImageName:diffSec];
            UIImageView *secondTenView = (UIImageView *)[self.view viewWithTag:97];
            secondTenView.image = [UIImage imageNamed:tensDigitSecImagePath];
            [self changeImage:secondTenView tagNum:102 image:[UIImage imageNamed:[self getSingleDigitImageName:perTensDigitSec]]];
            perTensDigitSec = tensDigitSec;
        }
        //个位分钟发生变化
        if(singleDigitMin != perSingleDigitMin){
            NSString *singleDigitMinImagePath = [self getSingleDigitImageName:diffMin];
            UIImageView *miniteSingleView = (UIImageView *)[self.view viewWithTag:96];
            miniteSingleView.image = [UIImage imageNamed:singleDigitMinImagePath];
            [self changeImage:miniteSingleView tagNum:103 image:[UIImage imageNamed:[self getSingleDigitImageName:perSingleDigitMin]]];
            perSingleDigitMin = singleDigitMin;
        }
        //十位分钟发生变化
        if(tensDigitMin != perTensDigitMin){
            NSString *tensDigitMinImagePath = [self getTensDigitImageName:diffMin];
            UIImageView *miniteTenView = (UIImageView *)[self.view viewWithTag:95];
            miniteTenView.image = [UIImage imageNamed:tensDigitMinImagePath];
            [self changeImage:miniteTenView tagNum:104 image:[UIImage imageNamed:[self getSingleDigitImageName:perTensDigitMin]]];
            perTensDigitMin = tensDigitMin;
        }
    }
    //如果倒计时结束
    if(diffMin == 0 && diffSec == 0){
        [timer invalidate];
    }
}
//取得个位得图片
-(NSString *) getSingleDigitImageName:(int) num{
    int remainder = num % 10;
    //[self getImagePathByNum:remainder];
    NSString *path = [NSString stringWithFormat:@"%d.png",remainder];
    return path;
}
//取得十位得图片
-(NSString *) getTensDigitImageName:(int) num{
    int remainder = num / 10;
    NSString *path = [NSString stringWithFormat:@"%d.png",remainder];
    return path;
}
//取得个位数
-(int) getSingleDigitNum:(int) num{
    int remainder = num % 10;
    //[self getImagePathByNum:remainder];
    return remainder;
}
//取得十位数
-(int) getTensDigitNum:(int) num{
    int remainder = num / 10;
    return remainder;
}

-(void) changeImage:(UIImageView *)imageView tagNum:(int)tagNum image:(UIImage *)image{
    UIImageView *coverSecondSingleView = (UIImageView *)[self.view viewWithTag:tagNum];
    if(!coverSecondSingleView){
        coverSecondSingleView = [[UIImageView alloc] initWithFrame:imageView.frame];
        coverSecondSingleView.tag = tagNum;
    }else {
        coverSecondSingleView.frame = imageView.frame;
    }
    CGRect newFrame = imageView.frame;
    newFrame.size.height = 0;
    newFrame.origin.y = 58;
    coverSecondSingleView.image = image;
    [self.view addSubview:coverSecondSingleView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    [coverSecondSingleView setFrame:newFrame];
    [UIView commitAnimations];
}
@end
