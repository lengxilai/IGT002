//
//  IGA01ViewController.m
//  IGT002
//
//  Created by Ming Liu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGA01ViewController.h"

@interface IGA01ViewController ()

@end

// 当前状态
typedef enum{
    StateNone=0,StateStarting=1,StateEnd=2,StateRest=3,
}StateDef;

@implementation IGA01ViewController

@synthesize fetchedResultsController,textSelector;
- (id)init
{
    self = [super init];
    if (self) {
        // 蕃茄图片
        tomatoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(A01_TOMATO_X, A01_TOMATO_Y, A01_TOMATO_W, A01_TOMATO_H)];
        tomatoImageView.image = [UIImage imageNamed:@"tomato.png"];
        
        // 倒计时牌
        delayedAlarm = [[DelayedAlarmViewController alloc] initWithFrame:CGRectMake(A01_ALARM_X, A01_ALARM_Y, A01_ALARM_W, A01_ALARM_H) withDelayTime:25];
        delayedAlarm.alarmDelegate = self;
        
        NSString *tt = [IGTomatoUtil getConfigValueWithKey:ConfigKeyTomatoTime withDefaultValue:@"25"];
        [delayedAlarm setDelayTimeWithMin:[tt intValue] withSec:0];
        
        // 蕃茄名称
        tomatoTitle = [[IGLabel alloc] initWithFrame:CGRectMake(A01_TOMATO_TITLE_X, A01_TOMATO_TITLE_Y, A01_TOMATO_TITLE_W, A01_TOMATO_TITLE_H)];
        tomatoTitle.textColor = [UIColor whiteColor];
        tomatoTitle.font = [UIFont systemFontOfSize:26];
        tomatoTitle.textAlignment = UITextAlignmentCenter;
        tomatoTitle.userInteractionEnabled = YES;
        // 点击触发事件
        UITapGestureRecognizer *singleTapTomatoTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTomatoName:)];
        [tomatoTitle addGestureRecognizer:singleTapTomatoTime];
        
        // 蕃茄开始时间
        tomatoTime = [[IGLabel alloc] initWithFrame:CGRectMake(A01_TOMATO_TIME_X, A01_TOMATO_TIME_Y, A01_TOMATO_TIME_W, A01_TOMATO_TIME_H)];
        tomatoTime.textColor = [UIColor whiteColor];
        tomatoTime.textAlignment = UITextAlignmentCenter;
        tomatoTime.font = [UIFont systemFontOfSize:17];
        
        // 左边的按钮
        leftButton = [UIUtil buttonWithTitle:NSLocalizedString(@"开 始", @"开始按钮") target:self selector:@selector(clickLeftButton:) frame:CGRectMake(A01_LEFTBUTTON_X, A01_LEFTBUTTON_Y, A01_LEFTBUTTON_W, A01_LEFTBUTTON_H) image:@"greenbtnbak.png"];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:25];
        
        // 右边的按钮
        rightButton = [UIUtil buttonWithTitle:NSLocalizedString(@"停 止", @"停止按钮") target:self selector:@selector(clickRightButton:) frame:CGRectMake(A01_RIGHTBUTTON_X, A01_RIGHTBUTTON_Y, A01_RIGHTBUTTON_W, A01_RIGHTBUTTON_H) image:@"redbtnbak.png"];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:25];
        
        // 蕃茄列表
        listTableView = [[UITableView alloc] initWithFrame:CGRectMake(A01_TABLE_X, A01_TABLE_Y, A01_TABLE_W, A01_TABLE_H)];
        listTableView.delegate = self;
        listTableView.dataSource = self;
        listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        listTableView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:delayedAlarm.view];
        [self.view addSubview:tomatoImageView];
        [self.view addSubview:tomatoTitle];
        [self.view addSubview:tomatoTime];
        [self.view addSubview:leftButton];
        [self.view addSubview:rightButton];
        [self.view addSubview:listTableView];
        
        
        UIButton *helpButton = [UIUtil buttonWithImage:@"help.png" target:self selector:@selector(clickHelpButton:) frame:CGRectMake(HELP_BUTTON_X, HELP_BUTTON_Y, HELP_BUTTON_W, HELP_BUTTON_H)];
        [self.view addSubview:helpButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    tomatoTitle.text = NSLocalizedString(@"未命名蕃茄",@"未命名蕃茄");
    tomatoTime.text = [[NSDate date] stringWithFormat:@"yyyy/MM/dd HH:mm"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark 创建各个View
// 创建每个单元格
-(UIView *)getListCellView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.tag = CELL_TAG;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smalltomato.png"]];
    imageView.frame = CGRectMake(A01_CELL_IMAGE_X, A01_CELL_IMAGE_Y, A01_CELL_IMAGE_W, A01_CELL_IMAGE_H);
    imageView.tag = CELL_IMAGE_TAG;
    [view addSubview:imageView];
    
    IGLabel *label = [[IGLabel alloc] initWithFrame:CGRectMake(A01_CELL_TEXT_X, A01_CELL_TEXT_Y, A01_CELL_TEXT_W, A01_CELL_TEXT_H)];
    label.tag = CELL_TEXT_TAG;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
    
    return view;
}

// 编辑单元格
-(void)editListCellView:(UIView*)view forIndex:(NSIndexPath*)indexPath
{
    Tomato *tomato = [fetchedResultsController objectAtIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[view viewWithTag:CELL_IMAGE_TAG];
    if ([tomato.state boolValue]) {
        imageView.image = [UIImage imageNamed:@"smalltomato.png"];
    }else {
        imageView.image = [UIImage imageNamed:@"smalltomatogrn.png"];
    }
    
    IGLabel *label = (IGLabel *)[view viewWithTag:CELL_TEXT_TAG];
    label.text = [tomato buildString];
}

#pragma mark - 各种事件


-(void)clickHelpButton:(UIButton*)button
{
    if (helpViewController == nil) {
        helpViewController = [[IGA05ViewController alloc] init];
    }
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window.rootViewController presentModalViewController:helpViewController animated:YES];
}

// 输入蕃茄名字
-(void)selectTomatoName:(id)sender{
    if (state != StateStarting) {
        if (textSelector == nil) {
            textSelector = [[IGTextSelector alloc] init];
            textSelector.selfDelegate = self;
        }
        textSelector.contents = [IGTomatoUtil getTomatoNames];
        textSelector.title.text = NSLocalizedString(@"请输入蕃茄名：", @"请输入蕃茄名：");
        [textSelector showSelectorWithView:self.view withName:tomatoTitle.text];
    }
}

// TextSelector的委托函数，这里用于修改蕃茄名和停止蕃茄
- (void)changeItem:(NSString*)textValue
{
    // 如果不是开始状态，修改蕃茄名
    if (state != StateStarting) {
        tomatoTitle.text = textValue;
    }else {
        // 如果是开始状态，则停止蕃茄
        state = StateNone;
        //[delayedAlarm setDelayTimeWithMin:[tt intValue] withSec:0];
        [delayedAlarm pause];
        [IGTomatoUtil addTomatoByValues:tomatoTitle.text starttime:delayedAlarm.startTime  endtime:[NSDate date] state:NO stopreason:textValue];
        
        // 设定状态和右边按钮文字
        state = StateEnd;
        [rightButton setTitle:NSLocalizedString(@"休 息", @"休息按钮") forState:UIControlStateNormal];
    }
}

// 蕃茄时间结束
- (void)onAlarmEnd
{
    // 在进行中状态结束，添加蕃茄
    if (state == StateStarting) {
        [IGTomatoUtil addTomatoByValues:tomatoTitle.text starttime:delayedAlarm.startTime  endtime:delayedAlarm.endTime state:YES stopreason:nil];
        
        // 设定状态和右边按钮文字
        state = StateEnd;
        [rightButton setTitle:NSLocalizedString(@"休 息", @"休息按钮") forState:UIControlStateNormal];
        [self playFinished];
    }
    
    // 在休息状态结束    
    if(state == StateRest){
        state = StateEnd;
        [rightButton setTitle:NSLocalizedString(@"休 息", @"休息按钮") forState:UIControlStateNormal];
        
        // 播放结束声音
        NSString *isAlarm = [IGTomatoUtil getConfigValueWithKey:ConfigKeyIsAlarm withDefaultValue:@"1"];
        if ([isAlarm boolValue]) {
            NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"ring" ofType:@"mp3"]; 
            NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath]; 
            player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil]; 
            [player prepareToPlay];
            [player play]; 
        }
    }
}

// 播放结束声音
-(void)playFinished
{
    NSString *isAlarm = [IGTomatoUtil getConfigValueWithKey:ConfigKeyIsAlarm withDefaultValue:@"1"];
    if ([isAlarm boolValue]) {
        NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"xbwq" ofType:@"mp3"]; 
        NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath]; 
        player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil]; 
        [player prepareToPlay];
        [player play]; 
        [self performSelector:@selector(stopPlay) withObject:nil afterDelay:10];
    }
}

// 慢慢停止声音
-(void)stopPlay
{
    [NSThread detachNewThreadSelector:@selector(stopPlayThread) toTarget:self withObject:nil];
}

// 停止声音的线程
-(void)stopPlayThread
{
    if (state == StateEnd) {
        while (player.volume > 0.01) {
            [NSThread sleepForTimeInterval:0.05];
            player.volume = player.volume - 0.02;
        }
        [player stop];
    }
}

// 点击左边按钮
-(void)clickLeftButton:(UIButton*)button
{
    // 如果没有在进行，则开始
    if (state != StateStarting) {
        NSString *tt = [IGTomatoUtil getConfigValueWithKey:ConfigKeyTomatoTime withDefaultValue:@"25"];
        //NSString *tt  = @"1";
        [delayedAlarm setDelayTimeWithMin:[tt intValue] withSec:0];
        [delayedAlarm start];
        state = StateStarting;
        
        [rightButton setTitle:NSLocalizedString(@"停 止", @"停止按钮") forState:UIControlStateNormal];
        NSDate *date = delayedAlarm.startTime;
        tomatoTime.text = [date stringWithFormat:@"yyyy/MM/dd HH:mm"];
       
        [NSThread detachNewThreadSelector:@selector(startTomato) toTarget:self withObject:nil];
    }
}

// 开始蕃茄，放在另一个线程中
-(void)startTomato
{
    
    // 停止声音
    [player stop];
    
    NSString *isAlarm = [IGTomatoUtil getConfigValueWithKey:ConfigKeyIsAlarm withDefaultValue:@"1"];
    if ([isAlarm boolValue]) {
        NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"ring" ofType:@"mp3"]; 
        NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath]; 
        player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil]; 
        [player prepareToPlay];
        [player play]; 
    }
    
    
    // 添加提醒
    [IGBusinessUtil addAlertForDate:delayedAlarm.endTime forName:tomatoTitle.text];
    
    // 禁止锁屏
    NSString *isLockSceen = [IGTomatoUtil getConfigValueWithKey:ConfigKeyIsLockSceen withDefaultValue:@"1"];
    if ([isLockSceen boolValue]) {
        // 禁止
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }else {
        // 不禁止
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}

// 点击右边按钮
-(void)clickRightButton:(UIButton*)button
{
    // 如果正在进行中或者休息中，点击停止则停止
    if (state == StateStarting) {
        
        [self alertStopReasonInput];
        
        // 如果为休息状态，则点击停止可以继续休息
    }else if (state == StateRest) {
        [delayedAlarm pause];
        state = StateEnd;
        [rightButton setTitle:NSLocalizedString(@"休 息", @"休息按钮") forState:UIControlStateNormal];
        
        // 如果为自然完成状态，点击休息可以休息
    }else if (state == StateEnd) {
        NSString *rt = [IGTomatoUtil getConfigValueWithKey:ConfigKeyRestTime withDefaultValue:@"5"];
        [delayedAlarm setDelayTimeWithMin:[rt intValue] withSec:0];
        [delayedAlarm start];
        state = StateRest;
        
        [rightButton setTitle:NSLocalizedString(@"停 止", @"停止按钮") forState:UIControlStateNormal];
        [player stop];
    }
}

// 确认是否保存模板
-(void)alertStopReasonInput {
    
    if (textSelector == nil) {
        textSelector = [[IGTextSelector alloc] init];
        textSelector.selfDelegate = self;
    }
    textSelector.contents = [IGTomatoUtil getStopReasons];
    textSelector.title.text = NSLocalizedString(@"请输入停止原因：", @"请输入停止原因：");
    [textSelector showSelectorWithView:self.view withName:NSLocalizedString(@"未知原因", @"未知原因")];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"IGT02TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grntabbak.png"]];
	}
    
    UIView *cellView = [cell.contentView viewWithTag:CELL_TAG];
    if (cellView == nil) {
        cellView = [self getListCellView];
        [cell.contentView addSubview:cellView];
    }
    [self editListCellView:cellView forIndex:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

#pragma mark - fetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    // 排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"starttime" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchedResultsController *aFetchedResultsController;
    aFetchedResultsController = 
    [IGCoreDataUtil queryForFetchedResult:@"Tomato" queryPredicate:[NSPredicate predicateWithFormat:@"tomatodate == %@",[IGBusinessUtil getTodayDate]] sortDescriptors:sortDescriptors];
    aFetchedResultsController.delegate = self;
    fetchedResultsController = aFetchedResultsController;
    
    return fetchedResultsController;
}  


// 列表编辑
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[listTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = listTableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;			
		case NSFetchedResultsChangeUpdate:
			break;			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[listTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[listTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[listTableView endUpdates];
}
@end
