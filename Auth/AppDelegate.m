//
//  Copyright (c) 2015 LAS. All rights reserved.

#import "AppDelegate.h"
#import "WeiboSDKDelegate.h"
#import "WeChatSDKDelegate.h"

#import <MLFacebookUtilsV4/MLFacebookUtils.h>
#import <MLWeiboUtils/MLWeiboUtils.h>
#import <MLWeChatUtils/MLWeChatUtils.h>

// cn pro
#define MaxLeap_AppId @"56567d14a5ff7f00019ee642"
#define MaxLeap_ClientKey @"OVNLNU90SEk5aWhnZlNvYmVoa28zUQ"
#define MaxLeap_site MLSiteCN

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // ****************************************************************************
    // Uncommit fill in with your MaxLeap credentials:
    // ****************************************************************************
#warning Please fill in with your MaxLeap credentials
    // [MaxLeap setApplicationId:@"APPLICATION_ID_HERE" clientKey:@"CLIENT_KEY_HERE" site:SITE];
    [MaxLeap setApplicationId:MaxLeap_AppId clientKey:MaxLeap_ClientKey site:MaxLeap_site];
    self.region = MaxLeap_site;
    
    // ****************************************************************************
    // Make sure your Facebook application id is configured in Info.plist.
    // ****************************************************************************
    [MLFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    [MLWeiboUtils initializeWeiboWithAppKey:@"2328234403" redirectURI:@"https://api.weibo.com/oauth2/default.html"];
    
    [MLWeChatUtils initializeWeChatWithAppId:@"wx41b6f4bde79513c8" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" wxDelegate:[WeChatSDKDelegate sharedInstance]];
    
    // Override point for customization after application launch.
    
    return YES;
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL facebook = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    BOOL weibo = [WeiboSDK handleOpenURL:url delegate:[WeiboSDKDelegate sharedInstance]];
    BOOL wechat = [WXApi handleOpenURL:url delegate:[WeChatSDKDelegate sharedInstance]];
    return facebook || weibo || wechat;
}

// iOS 9
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    NSString *sourceApplication = options[UIApplicationLaunchOptionsSourceApplicationKey];
    id annotation = options[UIApplicationLaunchOptionsAnnotationKey];
    BOOL facebook = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    BOOL weibo = [WeiboSDK handleOpenURL:url delegate:[WeiboSDKDelegate sharedInstance]];
    BOOL wechat = [WXApi handleOpenURL:url delegate:[WeChatSDKDelegate sharedInstance]];
    return facebook || weibo || wechat;
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
