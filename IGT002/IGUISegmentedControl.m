//
//  IGUISegmentedControl.m
//  IGT001
//
//  Created by 鹏 李 on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGUISegmentedControl.h"

@implementation IGUISegmentedControl
@synthesize leftButton,leftLabel,rightButton,rightLabel,selectedIndex,leftImageString,rightImageString,onColor,offColor;

-(id)initWithRectAndItems:(CGRect)frame :(NSArray *)items leftImage:(NSString*)left rightImage:(NSString*)right onColor:(UIColor*)initOnColor offColor:(UIColor*)initOffColor
{
    self = [super init];
    if (self) {
        self.view = [[UIView alloc] init];
        self.view.frame = frame;
        
        self.leftImageString = left;
        self.rightImageString = right;
        self.onColor = initOnColor;
        self.offColor = initOffColor;
        
//        NSLog(@"leftImageString is %@",self.leftImageString);
        
        leftButton = [IGUISegmentedControl buttonWithImage:
                      CGRectMake(0, 0, 
                                 frame.size.width/2, 
                                 frame.size.height)];
        leftButton.tag = 0;
        leftLabel = [IGUISegmentedControl LabelWithText:[items objectAtIndex:0] frame:
                     CGRectMake(0, 0, 
                                frame.size.width/2, 
                                frame.size.height)];
        [self.view addSubview:leftButton];
        [self.view addSubview:leftLabel];
        
        
        rightButton = [IGUISegmentedControl buttonWithImage:
                       CGRectMake(frame.size.width/2, 0, 
                                  frame.size.width/2, 
                                  frame.size.height)];
        rightButton.tag = 1;
        rightLabel = [IGUISegmentedControl LabelWithText:[items objectAtIndex:1] frame:
                      CGRectMake(frame.size.width/2-5, 0, 
                                 frame.size.width/2, 
                                 frame.size.height)];
        [self.view addSubview:rightButton];
        [self.view addSubview:rightLabel];
        
        // 先设定为0
        self.selectedIndex = leftButton.tag;
        [self setState];
        
        
    }
    return self;
}

- (id)initWithRectAndItems:(CGRect)frame:(NSArray *)items
{
    return [self initWithRectAndItems:frame :items leftImage:@"switch_left" rightImage:@"switch_right" onColor:[UIColor blackColor] offColor:[UIColor whiteColor]];
}

-(void)setFontSize:(NSInteger)fontSize
{
    leftLabel.font = [UIFont systemFontOfSize:fontSize];
    rightLabel.font = [UIFont systemFontOfSize:fontSize];
}

-(void)changeState
{
    if(self.selectedIndex == 0){
        self.selectedIndex = 1;
        [self setState];
        return;
    }
    
    if(self.selectedIndex == 1){
        self.selectedIndex = 0;
        [self setState];
        return;
    }
}

-(void)setState{
    
    if(self.selectedIndex == 0){
        UIImage *leftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_on.png",self.leftImageString]];
        [self.leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
        UIImage *rightImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_off.png",self.rightImageString]];
        [self.rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];

        [self.leftLabel setTextColor:self.onColor];
        [self.rightLabel setTextColor:self.offColor];
        return;
    }
    
    if(self.selectedIndex == 1){
        
        UIImage *leftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_off.png",self.leftImageString]];
        [self.leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
        UIImage *rightImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_on.png",self.rightImageString]];
        [self.rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
        
        [self.leftLabel setTextColor:self.offColor];
        [self.rightLabel setTextColor:self.onColor];
        return;
    }
}

+ (UIButton *)buttonWithImage:(CGRect)frame{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.adjustsImageWhenDisabled = YES;
    button.adjustsImageWhenHighlighted = YES;
    [button setBackgroundColor:[UIColor clearColor]];  
    return button;
}

+ (UILabel *)LabelWithText:(NSString *)text frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end
