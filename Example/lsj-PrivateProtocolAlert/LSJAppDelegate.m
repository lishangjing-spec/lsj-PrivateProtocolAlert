//
//  LSJAppDelegate.m
//  lsj-PrivateProtocolAlert
//
//  Created by lsj on 10/15/2021.
//  Copyright (c) 2021 lsj. All rights reserved.
//

#import "LSJAppDelegate.h"
#import "LSJPrivateProtocolAlert.h"
#import "LSJViewController.h"

#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


@implementation LSJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // 用户点击过同意，会直接执行 completionBlock
    LSJPrivateProtocolAlert *alert = [LSJPrivateProtocolAlert new];
    alert.appName = @"测试项目";
    alert.userAgreementURL = [NSURL URLWithString:@"https://www.jianshu.com"];
    alert.privacyPolicyURL = [NSURL URLWithString:@"https://www.juejin.com"];
    kWeakSelf(self);
    alert.completionBlock = ^{
        kStrongSelf(self);
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window makeKeyAndVisible];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = [LSJViewController new];
    };
    [alert show];
    
    return YES;
}

-(void)startApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
