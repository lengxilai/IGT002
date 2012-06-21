//
//  IGA04ViewController.m
//  IGT002
//
//  Created by wang chong on 12-5-25.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGA04ViewController.h"
#import "IGLabel.h"
#import "IGCommonDefine.h"
#import "IGTextField.h"


@interface IGA04ViewController ()

@end

@implementation IGA04ViewController
- (id)init
{
    self = [super init];
    if (self) {
        IGLabel *label = [[IGLabel alloc] initWithFrame:CGRectMake(A04_TITLE_X, A04_TITLE_Y, A04_TITLE_W, A04_TITLE_H)];
        label.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"设定", @"设定")];
        label.font = [UIFont systemFontOfSize:25];
        label.textColor = [UIColor whiteColor];
        
        listTableView = [[UITableView alloc] initWithFrame:CGRectMake(A04_TABLE_X, A04_TABLE_Y, A04_TABLE_W, A04_TABLE_H)];
        listTableView.delegate = self;
        listTableView.dataSource = self;
        listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        listTableView.backgroundColor = [UIColor clearColor];
        listTableView.scrollEnabled = NO;
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewbak.png"]];
        backgroundView.frame = CGRectMake(TABLE_BAK_X, TABLE_BAK_Y, TABLE_BAK_W, TABLE_BAK_H);
        pickerview = [[UIPickerView alloc]  init];
        pickerview.tag = SELECT_TAG;
        actionSheet=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.frame = CGRectMake(SelectViewX, SelectViewY, SelectViewW, SelectViewH);
        [self.view addSubview:backgroundView];
        [self.view addSubview:label];
        [self.view addSubview:listTableView];
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
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if(indexPath.section == 0){
        return 35;
    }else{
        return 68;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        return 6;
    }
    else {
        return 2;
    }
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
	}
    UIView *cellView = [cell viewWithTag:CELL_TAG];
    if (cellView == nil) {
        if(indexPath.section == 0){
            [self getFirstPanel:cell.contentView withRow:indexPath.row];
        }else if(indexPath.section == 1){
            [self getTripAppPanel:cell.contentView withRow:indexPath.row];
        }
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] init];
    
    UIImageView *bakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionbak.png"]];
    bakView.frame = CGRectMake(A04_SECTION_BAK_X, A04_SECTION_BAK_Y, A04_SECTION_BAK_W, A04_SECTION_BAK_H);
    [sectionView addSubview:bakView];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(A04_SECTION_IMAGE_X, A04_SECTION_IMAGE_Y, A04_SECTION_IMAGE_W, A04_SECTION_IMAGE_H)];
    iconImage.image = [UIImage imageNamed:@"smalltomato.png"];

    [sectionView addSubview:iconImage];
    
    IGLabel *sectionTitle = [[IGLabel alloc] initWithFrame:CGRectMake(A03_SECTION_TITLE_X, A04_SECTION_TITLE_Y, A04_SECTION_TITLE_W, A04_SECTION_TITLE_H)];
    sectionTitle.font = [UIFont systemFontOfSize:22];
    if (section == 0) {
        sectionTitle.text = NSLocalizedString(@"系统设置", @"系统设置");
        sectionTitle.textColor = [UIColor redColor];
    }else {
        sectionTitle.text = NSLocalizedString(@"更多应用", @"更多应用");
        sectionTitle.textColor = [UIColor redColor];
    }
    [sectionView addSubview:sectionTitle];
    
    
    return sectionView;
}

#pragma mark 创建各个View
//得到上半部分第一个panel
-(void)getFirstPanel:(UIView*)firstPanel withRow:(int)row{
    firstPanel.tag = CELL_TAG;
    
    if(row == 0){
        //蕃茄时间
        tomatoTimeText = [[IGTextField alloc] initWithFrame:CGRectMake(A04TomatoTimeTextX, A04TomatoTimeTextY, A04TomatoTimeTextW, A04TomatoTimeTextH)];
        
        NSString *tomatoTime = [IGTomatoUtil getConfigValueWithKey:ConfigKeyTomatoTime withDefaultValue:@"25"];
        // 设定一个tag，为了设定默认值
        tomatoTimeText.tag = [tomatoTime intValue];
        tomatoTime =  [NSString stringWithFormat:@"%@%@",tomatoTime,NSLocalizedString(@"分钟", @"分钟")];
        
        IGLabel *tomatoTimeLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A04TomatoTimeTitleLabelX, A04TomatoTimeTitleLabelY, A04TomatoTimeTitleLabelW, A04TomatoTimeTitleLabelH)];
        tomatoTimeLabel.textColor = [UIColor whiteColor];
        [firstPanel addSubview:tomatoTimeLabel];

        UIImageView *tomatoTimeBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
        tomatoTimeBackView.frame = CGRectMake(A04_TOMATO_TIME_BAK_X, A04_TOMATO_TIME_BAK_Y, A04_TOMATO_TIME_BAK_W,A04_TOMATO_TIME_BAK_H);
        [firstPanel addSubview:tomatoTimeBackView];

        tomatoTimeText.font=[UIFont systemFontOfSize:20];
        tomatoTimeText.backgroundColor = [UIColor clearColor];
        tomatoTimeText.textColor = [UIColor whiteColor];
        tomatoTimeText.text = tomatoTime;
        //点击触发事件
        UITapGestureRecognizer *singleTapTomatoTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTomatoTime:)];
        [tomatoTimeText addGestureRecognizer:singleTapTomatoTime];
        [firstPanel addSubview:tomatoTimeText];
        tomatoTimeLabel.text = NSLocalizedString(@"蕃茄时间：", @"蕃茄时间：");
    }else if(row == 1){
        //闹钟
        NSString *isAlarm = [IGTomatoUtil getConfigValueWithKey:ConfigKeyIsAlarm withDefaultValue:@"1"];

        IGLabel *alarmLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A04AlarmTitleLabelX, A04AlarmTimeTitleLabelY, A04AlarmTimeTitleLabelW, A04AlarmTimeTitleLabelH)];
        alarmLabel.textColor = [UIColor whiteColor];
        [firstPanel addSubview:alarmLabel];
        UIImageView *alarmBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
        alarmBackView.frame = CGRectMake(A04_ALARM_TIME_BAK_X, A04_ALARM_TIME_BAK_Y, A04_ALARM_TIME_BAK_W,A04_ALARM_TIME_BAK_H);
        [firstPanel addSubview:alarmBackView];
        UISwitch *alarmSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(A04AlarmSwitchX, A04AlarmSwitchY,A04AlarmSwitchW, A04AlarmSwitchH)];
        alarmSwitch.tag = A04_ALARM_TAG;
        //给switch添加一个change事件
        [alarmSwitch addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
        alarmSwitch.on = [isAlarm boolValue];
        [firstPanel addSubview:alarmSwitch];
        alarmLabel.text = NSLocalizedString(@"铃声：", @"铃声：");
    }else if(row == 2){
        //休息时间
        resetTimeText = [[IGTextField alloc] initWithFrame:CGRectMake(A04resetTimeTextX, A04resetTimeTextY, A04resetTimeTextW, A04resetTimeTextH)];
        
        NSString *restTime = [IGTomatoUtil getConfigValueWithKey:ConfigKeyRestTime withDefaultValue:@"5"];
        // 设定一个tag，为了设定默认值用
        resetTimeText.tag = [restTime intValue];
        
        restTime =  [NSString stringWithFormat:@"%@%@",restTime,NSLocalizedString(@"分钟", @"分钟")];
        IGLabel *resetTimeLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A04RestTitleLabelX, A04RestmTimeTitleLabelY, A04RestTimeTitleLabelW, A04RestmTimeTitleLabelH)]; 
        resetTimeLabel.textColor = [UIColor whiteColor];
        [firstPanel addSubview:resetTimeLabel];

        resetTimeText.delegate = self;
        resetTimeText.font=[UIFont systemFontOfSize:20];
        resetTimeText.backgroundColor = [UIColor clearColor];
        resetTimeText.text = restTime;
        resetTimeText.textColor = [UIColor whiteColor];
        //点击触发事件
        UITapGestureRecognizer *singleTapRestTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRestTime:)];
        [resetTimeText addGestureRecognizer:singleTapRestTime];
        [firstPanel addSubview:resetTimeText];
        UIImageView *restTimeBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
        restTimeBackView.frame = CGRectMake(A04_REST_TIME_BAK_X, A04_REST_TIME_BAK_Y, A04_REST_TIME_BAK_W,A04_REST_TIME_BAK_H);
        [firstPanel addSubview:restTimeBackView];
        resetTimeLabel.text = NSLocalizedString(@"休息时间：", @"休息时间：");
    }else if(row == 3){
        //是否锁屏
        NSString *isLockSceen = [IGTomatoUtil getConfigValueWithKey:ConfigKeyIsLockSceen withDefaultValue:@"1"];
        IGLabel *lockSceenLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A04LockSceenTitleLabelX, A04LockSceenTitleLabelY, A04LockSceenTitleLabelW, A04LockSceenTitleLabelH)]; 
        lockSceenLabel.textColor = [UIColor whiteColor];
        [firstPanel addSubview:lockSceenLabel];
        UIImageView *lockSceenView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
        lockSceenView.frame = CGRectMake(A04_LOCK_SCEEN_BAK_X, A04_LOCK_SCEEN_BAK_Y, A04_LOCK_SCEEN_BAK_W,A04_LOCK_SCEEN_BAK_H);
        [firstPanel addSubview:lockSceenView];
        UISwitch *lockSceenSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(A04LockSceenSwitchX, A04LockSceenSwitchY,A04LockSceenSwitchW, A04LockSceenSwitchH)];
        lockSceenSwitch.tag = A04_LOCK_SCEEN_TAG;
        //给switch添加一个change事件
        [lockSceenSwitch addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
        lockSceenSwitch.on = [isLockSceen boolValue];
        [firstPanel addSubview:lockSceenSwitch];
        lockSceenLabel.text = NSLocalizedString(@"禁止锁屏：", @"禁止锁屏：");
    }else if(row == 4){
        //联系我们
        IGLabel *contactUsLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A04ContactUsTitleLabelX, A04ContactUsTitleLabelY, A04ContactUsTitleLabelW, A04ContactUsTitleLabelH)]; 
        contactUsLabel.textColor = [UIColor whiteColor];
        [firstPanel addSubview:contactUsLabel];
        UIImageView *contactUsBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
        contactUsBackView.frame = CGRectMake(A04_CONTACT_US_BAK_X, A04_CONTACT_US_BAK_Y, A04_CONTACT_US_BAK_W,A04_CONTACT_US_BAK_H);
        [firstPanel addSubview:contactUsBackView];
        NSString *mailImageName = [self getMailImageName];
        UIButton *mailImage = [UIUtil buttonWithTitle:mailImageName target:self selector:@selector(sendMail:) frame:CGRectMake(A04MailImageX, A04MailImageY, A04MailImageW, A04MailImageH) image:nil];
        mailImage.titleLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:25];
        [firstPanel addSubview:mailImage];
        IGTextField *mailAddress = [[IGTextField alloc] initWithFrame:CGRectMake(A04MailAddressX, A04MailAddressY, A04MailAddressW, A04MailAddressH)];
        mailAddress.text = @"iguorhelp@163.com";
        mailAddress.enabled = NO;
        mailAddress.font = [UIFont systemFontOfSize:16];
        mailAddress.backgroundColor = [UIColor clearColor];
        mailAddress.textColor = [UIColor whiteColor];
        [firstPanel addSubview:mailAddress];
        contactUsLabel.text = NSLocalizedString(@"联系我们：", @"联系我们：");
    }else if(row == 5){
        //评价
        IGLabel *estimateLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A04EstimateTitleLabelX, A04EstimateTitleLabelY, A04EstimateTitleLabelW, A04EstimateTitleLabelH)]; 
        estimateLabel.textColor = [UIColor whiteColor];
        [firstPanel addSubview:estimateLabel];
        UIImageView *estimateBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
        estimateBackView.frame = CGRectMake(A04_ESTIMATE_BAK_X, A04_ESTIMATE_BAK_Y, A04_ESTIMATE_BAK_W,A04_ESTIMATE_BAK_H);
        [firstPanel addSubview:estimateBackView];
        NSString *estimate = NSLocalizedString(@"评分", @"评分");
        UIButton *estimateButton = [UIUtil buttonWithTitle:estimate target:self selector:@selector(go2CommentApp:) frame:CGRectMake(A04EstimateButtonX, A04EstimateButtonY, A04EstimateButtonW, A04EstimateButtonH) image:@"btnbak.png"];
        estimateButton.tag = TOMATO_APP_ID;
        [firstPanel addSubview:estimateButton];
        estimateLabel.text = NSLocalizedString(@"评分：", @"评分：");
    }
    //return firstPanel;
}
//更多应用
-(void)getTripAppPanel:(UIView *)moreAppPanel withRow:(int)row{
    moreAppPanel.tag = 99;
    UIImageView *moreAppImageView = [[UIImageView alloc] initWithFrame:CGRectMake(A04MoreAppImageViewX, A04MoreAppImageViewY, A04MoreAppImageViewW, A04MoreAppImageViewH)];
    [moreAppPanel addSubview:moreAppImageView];
    
    UILabel *appTravelTitle = [[UILabel alloc]initWithFrame:CGRectMake(A04MoreAppTitleX, A04MoreAppTitleY, A04MoreAppTitleW, A04MoreAppTitleH)];
    
    appTravelTitle.backgroundColor = [UIColor clearColor];
    [appTravelTitle setFont:[UIFont systemFontOfSize:18.0]];
    appTravelTitle.textColor = [UIColor whiteColor];
    [moreAppPanel addSubview:appTravelTitle];
    
    UILabel *appTravelMemo = [[UILabel alloc]initWithFrame:CGRectMake(A04MoreAppMemoX, A04MoreAppMemoY, A04MoreAppMemoW, A04MoreAppMemoH)];
    appTravelMemo.lineBreakMode = UILineBreakModeWordWrap;
    appTravelMemo.numberOfLines = 0;
    
    appTravelMemo.backgroundColor = [UIColor clearColor];
    [appTravelMemo setFont:[UIFont systemFontOfSize:12.0]];
    appTravelMemo.textColor = [UIColor whiteColor];
    [moreAppPanel addSubview:appTravelMemo];
    UIImageView *appTravelBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbak.png"]];
    if(row == 0){
        moreAppImageView.image = [UIImage imageNamed:@"tripcheckericon.png"];
        appTravelTitle.text = NSLocalizedString(@"差旅备忘", @"差旅备忘");
        appTravelMemo.text = NSLocalizedString(@"帮您检查出差旅行的行李列表，\n从此解放您的大脑！", @"帮您检查出差旅行的行李列表，\n从此解放您的大脑！");
    }else if(row == 1){
        moreAppImageView.image = [UIImage imageNamed:@"tenyeardiaryicon.png"];
        appTravelTitle.text = NSLocalizedString(@"十年微日记", @"十年微日记");
        appTravelMemo.text = NSLocalizedString(@"将10年中的每一天写在一页，\n每一页记录了10年中的同一天！", @"将10年中的每一天写在一页，\n每一页记录了10年中的同一天！");
    }
    appTravelBackView.frame = CGRectMake(A04MoreAppBackViewX,A04MoreAppBackViewY,A04MoreAppBackViewW,A04MoreAppBackViewH);
    [moreAppPanel addSubview:appTravelBackView];
    //return moreAppPanel;
}

// 点击cell事件的响应规则
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 0){
        [self go2DownloadApp:TRIP_APP_ID];
    }else if( indexPath.section == 1 && indexPath.row == 1){
       [self go2DownloadApp:DAIRY_APP_ID];
    }
}
#pragma mark - 实现UITextFieldDｅｌｅｇａｔｅ的若干方法进行相关设置
//实现UITextFieldDｅｌｅｇａｔｅ的若干方法进行相关设置

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //currentTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{;
    //currentTextField = nil;
}

//按下Done按钮，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 实现选择时间
//选择蕃茄时间
-(void)selectTomatoTime:(UIGestureRecognizer *)gestureRecognizer{
    UITextField *textField = (UITextField *)gestureRecognizer.view;
    //初始化休息时间选项
    pickerArr = [[NSArray alloc] initWithObjects:@"25",@"30",@"35",@"40",nil];
    pickerview.delegate = self;
    type = ConfigKeyTomatoTime;
    
    int index = [pickerArr indexOfObject:[NSString stringWithFormat:@"%d",textField.tag]];
    
    //picker中间就会有个条, 被选中的样子
    pickerview.showsSelectionIndicator = YES;
    [pickerview selectRow:index inComponent:0 animated:NO];
    
    [actionSheet addSubview:pickerview];
    [actionSheet showInView:[self.view superview]];
}
//选择休息时间
-(void)selectRestTime:(UIGestureRecognizer *)gestureRecognizer{
    UITextField *textField = (UITextField *)gestureRecognizer.view;
    pickerArr = [[NSArray alloc] initWithObjects:@"5",@"10",@"15",@"20",nil];
   
    pickerview.delegate = self;
    pickerview.showsSelectionIndicator = YES;
    type = ConfigKeyRestTime;
    
    int index = [pickerArr indexOfObject:[NSString stringWithFormat:@"%d",textField.tag]];
    
    [pickerview selectRow:index inComponent:0 animated:NO];
    [actionSheet addSubview:pickerview];
    [actionSheet showInView:[self.view superview]];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return 320;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArr count];
}

// 设置当前行的内容，若果行没有显示则自动释放

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    
    return [NSString stringWithFormat:@"%@%@",[pickerArr objectAtIndex:row], NSLocalizedString(@"分钟",@"分钟")];
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // TODO [pickerView removeFromSuperview]

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIPickerView *pickerView =(UIPickerView*)[actionSheet viewWithTag:SELECT_TAG];
    UITextField *textView;
    if([type isEqual:ConfigKeyRestTime]){
        textView = resetTimeText;
        config = [IGTomatoUtil getConfigInfoForKey:ConfigKeyRestTime];
    }else {
        textView = tomatoTimeText;
        config = [IGTomatoUtil getConfigInfoForKey:ConfigKeyTomatoTime];
    }
    
    int row = [pickerView selectedRowInComponent:0];
    NSString *text = [pickerArr objectAtIndex:row];
    textView.text = [NSString stringWithFormat:@"%@%@",text, NSLocalizedString(@"分钟",@"分钟")];
    textView.tag = [text intValue];
    config.value = text;
    [IGTomatoUtil saveDB];
    
}

#pragma mark - send mail
// 点击发送邮件按钮
-(void)sendMail:(UIButton*)button
{   
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
  
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
			MFMailComposeViewController *mailView = [self createMailToConnectUs];
            mailView.mailComposeDelegate = self;
            [window.rootViewController presentModalViewController:mailView animated:YES];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}
// 发送邮件的后处理
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// 邮件发送提示信息
    NSString *message = nil;
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	switch (result)
	{
		case MFMailComposeResultCancelled:
            [window.rootViewController dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSaved:
			message = NSLocalizedString(@"邮件保存成功",@"邮件保存成功");
			break;
		case MFMailComposeResultSent:
			message = NSLocalizedString(@"邮件发送成功",@"邮件发送成功");
			break;
		case MFMailComposeResultFailed:
			message = NSLocalizedString(@"邮件发送失败",@"邮件发送失败");
			break;
		default:
			message = NSLocalizedString(@"邮件发送失败",@"邮件发送失败");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    if(message != nil){
        UIAlertView* alertMessage = [[UIAlertView alloc] 
                                     initWithTitle:NSLocalizedString(@"邮件提示",@"邮件提示")
                                     message:message   
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"完成", @"")
                                     otherButtonTitles:nil];
        [alertMessage show]; 
    }
}

// 创建邮件
-(MFMailComposeViewController*)createMailToConnectUs
{
    MFMailComposeViewController *mailView = [self createMailFrom];
    // 设置邮件主题
    NSString *titileName = NSLocalizedString(@"关于蕃茄工作法", @"关于蕃茄工作法");  
    [mailView setSubject:titileName];
    NSArray *toRecipients = [NSArray arrayWithObject: @"iguorhelp@163.com"];  

    [mailView setToRecipients: toRecipients];  
    // 设置邮件正文
	[mailView setMessageBody:[self getEmailBodyToConnectUs] isHTML:NO];
    return mailView;
}

-(NSMutableString *)getEmailBodyToConnectUs{
    
    // 邮件正文
	NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@""];
    [emailBody appendString:@"------------------------------------------------\n"];
    [emailBody appendString:@"create by iguor(www.iguor.com)"];
    return emailBody;
}

// 如果不支持MFmail的情况下直接调用系统邮件
-(void)launchMailAppOnDevice
{
	NSString *recipients = [NSString stringWithFormat:@"mailto:?subject=%@",NSLocalizedString(@"关于蕃茄工作法", @"关于蕃茄工作法")];
	NSString *body = [NSString stringWithFormat:@"&body="];
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// 创建邮件发送窗口
-(MFMailComposeViewController *)createMailFrom{
    
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    return mailView;
}
// 返回发邮件的表情文字
-(NSString*)getMailImageName{
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 5) {
        return @"\U0001F4E9";
        
    }else {
        return @"\uE103";
    }
}


// 按钮点击去评论页面
-(void)go2CommentApp:(id) sender{
//    NSLog(@"%d",[sender tag]);
    NSString *str = [NSString stringWithFormat: 
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", [sender tag]];  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
// 去下载画面
-(void)go2DownloadApp:(int) appId{
    NSString *str = [NSString stringWithFormat: 
                     @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d", 
                     appId];   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//switch 保存
-(void)onChange:(id)sender{
//    NSLog(@"%d",[sender tag]);
    int tagNum = [sender tag];
    UISwitch *switchBut = (UISwitch *)[self.view viewWithTag:tagNum];
    
    //闹钟
    if(tagNum == A04_ALARM_TAG){
        config = [IGTomatoUtil getConfigInfoForKey:ConfigKeyIsAlarm];
        
    }//锁屏
    else if(tagNum == A04_LOCK_SCEEN_TAG){
        config = [IGTomatoUtil getConfigInfoForKey:ConfigKeyIsLockSceen];
    }
    config.value = [NSString stringWithFormat:@"%d",switchBut.on];
    [IGTomatoUtil saveDB];
}

@end
