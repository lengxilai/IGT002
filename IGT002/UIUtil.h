//
//  UIUtil.h
//  T002
//
//  Created by LiuMing on 12-2-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtil : NSObject {

}
+(void)printRect:(CGRect)rect;
+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target selector:(SEL)inSelector frame:(CGRect)frame image:(NSString*)imageName;
+ (UIButton *)buttonWithImage:(NSString *)imageName target:(id)target selector:(SEL)inSelector frame:(CGRect)frame;
@end
