//
//  IGA05ViewController.m
//  IGT002
//
//  Created by Ming Liu on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGA05ViewController.h"

@interface IGA05ViewController ()

@end

@implementation IGA05ViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbak.png"]];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewbak.png"]];
        backgroundView.frame = CGRectMake(TABLE_BAK_X, TABLE_BAK_Y, TABLE_BAK_W, TABLE_BAK_H);
        [self.view addSubview:backgroundView];
        
        IGLabel *title = [[IGLabel alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, 30)];
        title.text = NSLocalizedString(@"蕃茄工作法", @"蕃茄工作法");
        title.textColor = [UIColor redColor];
        title.font = [UIFont systemFontOfSize:21];
        title.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:title];
        
        UIButton *gobackButton = [UIUtil buttonWithImage:@"goback.png" target:self selector:@selector(clickGobackButton:) frame:CGRectMake(5, 2, 30, 30)];
        [self.view addSubview:gobackButton];
        
        NSString *help = NSLocalizedString(@"1、设定一项任务。\n2、开始一个蕃茄时间（25分钟）。\n3、蕃茄时间内请集中精力，不能做与任务无关的事情，不接受任何打扰，直到蕃茄时间结束。\n4、如果蕃茄时间内被内部或外部事情打扰，则该蕃茄时间作废，请立即停止蕃茄。\n5、一个蕃茄时间结束，请休息5分钟，每结束4个蕃茄时间，请休息15分钟。\n6、请不要将蕃茄时间用于工作以外的事情。", @"帮助说明");
        CGSize size = [help sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(HELP_TEXT_W, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        IGLabel *helpText = [[IGLabel alloc] initWithFrame:CGRectMake(HELP_TEXT_X, TABLE_BAK_Y, HELP_TEXT_W, size.height)];
        helpText.textColor = [UIColor whiteColor];
        helpText.text = help;
        helpText.lineBreakMode = UILineBreakModeWordWrap;
        helpText.numberOfLines = 0;
        [self.view addSubview:helpText];
    }
    return self;
}
-(void)clickGobackButton:(UIButton*)button
{
    [self dismissModalViewControllerAnimated:YES];
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

@end
