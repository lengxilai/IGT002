//
//  IGA02ViewController.m
//  IGT002
//
//  Created by Ming Liu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGA02ViewController.h"

@interface IGA02ViewController ()

@end

@implementation IGA02ViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        NSArray *segmentTextContent = [NSArray arrayWithObjects: 
                                       NSLocalizedString(@"日历", @"日历")
                                       , NSLocalizedString(@"列表", @"列表")
                                       , nil];
        segmentedView = [[IGUISegmentedControl alloc] initWithRectAndItems:CGRectMake(A02_SEGMENT_X, A02_SEGMENT_Y, A02_SEGMENT_W, A02_SEGMENT_H) :segmentTextContent];
        [[segmentedView leftButton] addTarget:self action:@selector(clickCalSegment:) forControlEvents:UIControlEventTouchUpInside];
        [[segmentedView rightButton] addTarget:self action:@selector(clickListSegment:) forControlEvents:UIControlEventTouchUpInside];
        
        calendarController = [[IGCalendarController alloc] initWithStyle:UITableViewStylePlain];
        calendarController.view.frame = CGRectMake(A02_TABLE_X, A02_TABLE_Y, A02_TABLE_W, A02_TABLE_H);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
        [calendarController setDateComponents:dateComponents];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewbak.png"]];
        backgroundView.frame = CGRectMake(TABLE_BAK_X, TABLE_BAK_Y, TABLE_BAK_W, TABLE_BAK_H);
        
        UIButton *todayButton = [UIUtil buttonWithTitle:NSLocalizedString(@"今天", @"今天") target:self selector:@selector(clickTodayButton:) frame:CGRectMake(A02_TODAY_X, A02_TODAY_Y, A02_TODAY_W, A02_TODAY_H) image:@"btnbak.png"];
        todayButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:todayButton];
        
        [self.view addSubview:segmentedView.view];
        [self.view addSubview:backgroundView];
        [self.view addSubview:calendarController.view];
        
        // 注册日期点击时间
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickListSegment:) name:INFO_CLICK_CALENDAR object:nil];
        
        if (tomatoListController == nil) {
            tomatoListController = [[IGTomatoListController alloc] initWithStyle:UITableViewStylePlain];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - 按钮点击
-(void)clickCalSegment:(id)sender
{
    if (segmentedView.selectedIndex == 1) {
        [segmentedView changeState];
        calendarController.view.hidden = NO;
        [tomatoListController.view removeFromSuperview];
    }
}
-(void)clickListSegment:(id)sender
{
    if (segmentedView.selectedIndex == 0) {
        [segmentedView changeState];
        if(![sender isKindOfClass:[NSNotification class]]){
            tomatoListController = [[IGTomatoListController alloc] initWithStyle:UITableViewStylePlain];
        }
        tomatoListController.view.frame = CGRectMake(A02_TABLE_X, A02_TABLE_Y, A02_TABLE_W, A02_TABLE_H);
        [self.view addSubview:tomatoListController.view];
        calendarController.view.hidden = YES;
    }
}
-(void)clickTodayButton:(UIButton*)button
{
    if (segmentedView.selectedIndex == 0) {
        [calendarController toToday];
    }
    if (segmentedView.selectedIndex == 1) {
        [tomatoListController toToday];
    }
}
@end
