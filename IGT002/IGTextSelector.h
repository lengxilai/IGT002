//
//  IGTextSelector.h
//  IGT002
//
//  Created by wang chong on 12-5-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGTextField.h"
@protocol IGTextSelectorDelegate

@optional
- (void)changeItem:(NSString*)textValue;
@end
@interface IGTextSelector : UIViewController<UIPickerViewDelegate,UITextFieldDelegate>{
    NSMutableArray *contents;
    UIPickerView *pickerview;
    NSString *selectedName;
    id selfDelegate;
    IGLabel *title;
    UIToolbar *topView;
    int tagNum;
}
@property (nonatomic, retain)NSString *selectedName;
-(void)showSelectorWithView:(UIView *)view withName:(NSString *)selectedName;
-(void)showSelectorWithView:(UIView *)view withName:(NSString *)selectedItemName;
@property (nonatomic, retain)id selfDelegate;
@property(nonatomic,retain) NSMutableArray *contents;
@property(nonatomic,retain) IGLabel *title;
@end
