//
//  IGViewController.h
//  IGT002
//
//  Created by Ming Liu on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGViewController : UIViewController{
@private
    NSDate *startTime;
    int perSingleDigitSec;
    int perTensDigitSec;
    int perSingleDigitMin;
    int perTensDigitMin;
    UIImageView *imageView;
    
}
@property (nonatomic, retain) NSDate *startTime;
@property int perSingleDigitSec;
@property int perTensDigitSec;
@property int perSingleDigitMin;
@property int perTensDigitMin;
@property (nonatomic, retain) UIImageView *imageView;

@end
