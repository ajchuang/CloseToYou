//
//  SofAAppDelegate.h
//  VFinder
//
//  Created by Alfred Huang on 2014/2/5.
//  Copyright (c) 2014年 Alfred Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SofAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;


@end
