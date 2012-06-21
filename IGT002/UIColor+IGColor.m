//
//  UIColor+IGColor.m
//  IGT002
//
//  Created by Ming Liu on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+IGColor.h"

@implementation UIColor (IGColor)
+(UIColor*)redColor
{
    return [UIColor colorWithRed:(float)255/255 green:(float)(51.0f/255.0f) blue:0.0f alpha:1.0f];
}
+(UIColor*)greenColor
{
    return [UIColor colorWithRed:0.0f green:(float)(153.0f/255.0f) blue:0.0f alpha:1.0f];
}
@end
