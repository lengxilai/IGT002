//
//  IGAppDelegate.h
//  IGT002
//
//  Created by Ming Liu on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IGMainViewController.h"
#import "IGTomatoUtil.h"
#import "IGCoreDataUtil.h"

@class IGViewController;

@interface IGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

@property (strong, nonatomic) IGMainViewController *viewController;

@end
