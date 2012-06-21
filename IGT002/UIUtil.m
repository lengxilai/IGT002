//
//  UIUtil.m
//  T002
//
//  Created by LiuMing on 12-2-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIUtil.h"


@implementation UIUtil
+(void)printRect:(CGRect)rect
{
    NSLog(@"x:%.2f,y:%.2f,width:%.2f,height:%.2f", rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

// 做一个按钮
+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target selector:(SEL)inSelector frame:(CGRect)frame image:(NSString*)imageName {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
	[button setTitleColor:[UIColor grayColor] forState:UIControlEventTouchDown];
	[button setFont:[UIFont boldSystemFontOfSize:18]];
	if (imageName != nil) {
		UIImage *newImage = [UIImage imageNamed:imageName];
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
	}
    [button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenDisabled = YES;
    button.adjustsImageWhenHighlighted = YES;
    [button setBackgroundColor:[UIColor clearColor]];   // in case the parent view draws with a custom color or gradient, use a transparent color
    return button;
}

// 用图片做一个按钮
+ (UIButton *)buttonWithImage:(NSString *)imageName target:(id)target selector:(SEL)inSelector frame:(CGRect)frame{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	if (imageName != nil) {
		UIImage *newImage = [UIImage imageNamed:imageName];
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
	}
    [button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenDisabled = YES;
    button.adjustsImageWhenHighlighted = YES;
    [button setBackgroundColor:[UIColor clearColor]];   // in case the parent view draws with a custom color or gradient, use a transparent color
    return button;
}
@end
