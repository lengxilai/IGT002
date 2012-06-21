//
//  IGTomatoListController.h
//  IGT002
//
//  Created by Ming Liu on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCommonDefine.h"
#import "IGCoreDataUtil.h"
#import "Calendar.h"

@interface IGTomatoListController : UITableViewController<UITextFieldDelegate>
{
    IGTextField *searchText;
   NSFetchedResultsController *fetchedResultsController;
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void)toToday;
@end
