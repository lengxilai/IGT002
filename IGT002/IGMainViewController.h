//
//  IGMainViewController.h
//  IGT002
//
//  Created by Ming Liu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IGCommonDefine.h"
#import "IGA01ViewController.h"
#import "IGA02ViewController.h"
#import "IGA03ViewController.h"
#import "IGA04ViewController.h"

@interface IGMainViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    BOOL pageControlUsed;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (void)changePage:(id)sender;
@end
