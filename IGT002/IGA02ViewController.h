//
//  IGA02ViewController.h
//  IGT002
//
//  Created by Ming Liu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCommonDefine.h"
#import "IGCalendarController.h"
#import "IGTomatoListController.h"
@interface IGA02ViewController : UIViewController
{
    IGUISegmentedControl *segmentedView;
    IGCalendarController *calendarController;
    IGTomatoListController *tomatoListController;
}
@end
