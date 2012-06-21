//
//  IGTextSelector.m
//  IGT002
//
//  Created by wang chong on 12-5-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGTextSelector.h"
#import "IGCommonDefine.h"


@interface IGTextSelector ()

@end

@implementation IGTextSelector
@synthesize selectedName;
@synthesize selfDelegate;
@synthesize contents;
@synthesize title;
- (id)init
{
    self = [super init];
    if (self) {
        pickerview = [[UIPickerView alloc]  initWithFrame:CGRectMake(SELECTOR_PICKER_VIEW_X, SELECTOR_PICKER_VIEW_Y, SELECTOR_PICKER_VIEW_W, SELECTOR_PICKER_VIEW_H)];
    }
    pickerview.delegate = self;
    
    [self.view addSubview:pickerview];

    title = [[IGLabel alloc] initWithFrame:CGRectMake(SELECTOR_TITLE_X, SELECTOR_TITLE_Y, SELECTOR_TITLE_W, SELECTOR_TITLE_H)];
    title.textAlignment = UITextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor redColor];
    title.font = [UIFont systemFontOfSize:22];
    title.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:title];
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    // 完成按钮
    topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, UITextViewInputViewW, UITextViewInputViewH)];
    [topView setBarStyle:UIBarStyleBlack];    
    UIBarButtonItem*btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self  action:nil];
    
    UIBarButtonItem*doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self  action:@selector(dismissKeyBoard:)];
    NSArray*buttonsArry = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [topView setItems:buttonsArry];
    //[self.view addSubview:topView];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)showSelectorWithView:(UIView *)view withName:(NSString *)selectedItemName{

    if (contents == nil) {
        contents = [NSMutableArray arrayWithCapacity:1];
    }
    if (![contents containsObject:selectedItemName]) {
        [contents insertObject:selectedItemName atIndex:0];
    }
    
    [pickerview reloadComponent:0];
    int rowNum = [contents indexOfObject:selectedItemName];
    [pickerview selectRow:rowNum inComponent:0 animated:YES];
    IGTextField *textView = (IGTextField *)[self.view viewWithTag:(10000 + rowNum)];
    tagNum = 10000 + rowNum;
    textView.enabled = YES;
    [textView becomeFirstResponder];
    [view addSubview: self.view ];
}


#pragma mark -
#pragma mark UIPickerView data source

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    for(int i = 1;i <= [contents count];i++){
        IGTextField *textView = (IGTextField *)[self.view viewWithTag:(10000 + i)];    
        textView.enabled = NO; 
    }
    IGTextField *textView = (IGTextField *)[self.view viewWithTag:(10000 + row)];
    textView.enabled = YES;
    [textView becomeFirstResponder];

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
    return [contents count];
}


- (UIView *)pickerView:(UIPickerView *)pickerView 
			viewForRow:(NSInteger)row 
		  forComponent:(NSInteger)component 
		   reusingView:(UIView *)view{
    
    IGTextField *textField = [[IGTextField alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
	textField.text = [contents objectAtIndex:row];
    textField.textAlignment = UITextAlignmentLeft;
	textField.font = [UIFont systemFontOfSize:20];
	textField.backgroundColor = [UIColor clearColor];
    textField.tag = 10000+row;
    textField.enabled = NO;
    textField.delegate = self;
    return textField;
    
}
#pragma mark - 实现UITextFieldDｅｌｅｇａｔｅ的若干方法进行相关设置
//实现UITextFieldDｅｌｅｇａｔｅ的若干方法进行相关设置

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //currentTextField = textField;
    textField.inputAccessoryView = topView;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{;
    //currentTextField = nil;
    [textField setInputAccessoryView:nil];
}


//按下Done按钮，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    // 通知委托类调整高度
    if ([self.selfDelegate respondsToSelector:@selector(changeItem:)]) {
        [self.selfDelegate changeItem:textField.text];
    }
    [self.view removeFromSuperview];
    return YES;
}
- (void)dismissKeyBoard:(id)sender
{
    IGTextField *textView = (IGTextField *)[self.view viewWithTag:tagNum];
    [textView resignFirstResponder];
    
    [self.view removeFromSuperview];
}
@end
