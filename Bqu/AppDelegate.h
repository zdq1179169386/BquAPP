//
//  AppDelegate.h
//  Bqu
//
//  Created by yb on 15/10/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EAIntroView.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,EAIntroDelegate>

{
    EAIntroView *_introView;
    
    
}
@property (nonatomic, strong) UIViewController *currentController;//当前viewCtr


@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

