//
//  BSAppDelegate.m
//  Expenses
//
//  Created by Borja Arias Drake on 21/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSAppDelegate.h"
#import "CoreDataStackHelper.h"
#import "BSBaseExpensesSummaryViewController.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "BSGreenTheme.h"
#import "BSConstants.h"
#import "BSCoreDataFixturesManager.h"

@implementation BSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Core Data Helper
    self.coreDataHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType
                                                                     resourceName:@"Expenses"
                                                                        extension:@"momd"
                                                              persistentStoreName:@"expensesDataBase"];
 


    // Theme
    self.themeManager = [BSThemeManager manager];
    self.themeManager.theme = [[BSGreenTheme alloc] init];
    [self.themeManager applyTheme];

    
    // Apply fixtures
    BSCoreDataController *coreDataController = [[BSCoreDataController alloc] init];
    coreDataController.coreDataHelper = self.coreDataHelper;
    BSCoreDataFixturesManager *manager = [[BSCoreDataFixturesManager alloc] init];
    [manager applyMissingFixturesOnManagedObjectModel:self.coreDataHelper.managedObjectModel coreDataController:coreDataController];
    
    
    // Create sample entries the first time
    // TODO add categories
    if ([self isFirstTheAppEverRun])
    {
        BSCoreDataController *controller = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataHelper];
        [controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-300.0" category:nil];
        [controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/07/2012"] description:@"Pocket money" value:@"100.0" category:nil];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self.coreDataHelper saveContext];
}

- (BOOL)isFirstTheAppEverRun {
    
    BOOL isFirstTime = NO;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = nil;
    
    if ([paths count] > 0)
    {
        documentsDirectoryPath = paths[0];
        NSString* pathToFirstTimeFlag =  [documentsDirectoryPath stringByAppendingFormat:@"/%@", FIRSTTIME_FILE];
        isFirstTime = ![[NSFileManager defaultManager] fileExistsAtPath:pathToFirstTimeFlag];
        if (isFirstTime) {
            [NSKeyedArchiver archiveRootObject:@[@"firstTime"] toFile:pathToFirstTimeFlag];
        }
    }
    
    return isFirstTime;
}

@end