//
//  Copyright (c) 2015 LAS. All rights reserved.

#import "AppDelegate.h"

#import <MaxLeap/MaxLeap.h>
#import <MLFacebookUtilsV4/MLFacebookUtils.h>

#import "LoginViewController.h"

@implementation AppDelegate


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // ****************************************************************************
    // Uncommit fill in with your MaxLeap credentials:
    // ****************************************************************************
#warning Please fill in with your MaxLeap credentials
    // [MaxLeap setApplicationId:@"APPLICATION_ID_HERE" clientKey:@"CLIENT_KEY_HERE"];
    
    // ****************************************************************************
    // Make sure your Facebook application id is configured in Info.plist.
    // ****************************************************************************
    [MLFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

    // Override point for customization after application launch.
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
