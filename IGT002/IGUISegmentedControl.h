//
//  IGUISegmentedControl.h
//  IGT001
//
//  Created by 鹏 李 on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGUISegmentedControl : UIViewController{
    
    UIButton *leftButton;
    UILabel *leftLabel;
    UIButton *rightButton;
    UILabel *rightLabel;
    NSInteger selectedIndex;
    NSString *leftImageString;
    NSString *rightImageString;
    UIColor *onColor;
    UIColor *offColor;
}

@property(nonatomic,retain) UIButton *leftButton;
@property(nonatomic,retain) UILabel *leftLabel;
@property(nonatomic,retain) UIButton *rightButton;
@property(nonatomic,retain) UILabel *rightLabel;
@property(nonatomic,retain) NSString *leftImageString;
@property(nonatomic,retain) NSString *rightImageString;
@property(nonatomic,retain) UIColor *onColor;
@property(nonatomic,retain) UIColor *offColor;
@property NSInteger selectedIndex;

// 初始化
-(id)initWithRectAndItems:(CGRect)frame :(NSArray *)items leftImage:(NSString*)left rightImage:(NSString*)right onColor:(UIColor*)initOnColor offColor:(UIColor*)initOffColor;
- (id)initWithRectAndItems:(CGRect)frame:(NSArray *)items;
-(void)changeState;
-(void)setState;
-(void)setFontSize:(NSInteger)fontSize;
+ (UIButton *)buttonWithImage:(CGRect)frame;
+ (UILabel *)LabelWithText:(NSString *)text frame:(CGRect)frame;
@end
