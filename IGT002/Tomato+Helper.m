//
//  Tomato+Helper.m
//  IGT002
//
//  Created by Ming Liu on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tomato+Helper.h"

@implementation Tomato (Helper)
-(NSString*)buildString
{
    // 开始时间～终了时间 名称 (停止理由)
    return [NSString stringWithFormat:@"%@%@%@ %@%@",
            [self.endtime stringWithFormat:@"HH:mm"],
            NSLocalizedString(@"～", @"～"),
            [self.starttime stringWithFormat:@"HH:mm"],
            ((TomatoName *)self.tomatoname).name,([self.state boolValue]?@"":
                                            [NSString stringWithFormat:@"(%@)",self.stopreason.name])
            ];
}
@end
