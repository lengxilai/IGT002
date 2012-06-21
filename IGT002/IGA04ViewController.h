//
//  IGA04ViewController.h
//  IGT002
//
//  Created by wang chong on 12-5-25.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "IGTomatoUtil.h"
#import "Config.h"
@class IGMainViewController;

@interface IGA04ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    @private UITableView *listTableView;
    NSArray *pickerArr;
    NSString *type;
    UIPickerView *pickerview;
    Config *config;
    IGTomatoUtil *tomatoUtil;
    IGMainViewController *mainViewController;
    UIActionSheet *actionSheet;
    IGTextField *resetTimeText;
    IGTextField *tomatoTimeText;
}
+(void)setStaticIGMainViewController:(IGMainViewController *) mainViewController;
+(IGMainViewController*)getStatiIGMainViewController;

@end
