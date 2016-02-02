//
//  Copyright (c) 2015 LAS. All rights reserved.

#import "AppDelegate.h"
#import "WeiboSDKDelegate.h"
#import "WeChatSDKDelegate.h"

#import <MLFacebookUtilsV4/MLFacebookUtils.h>
#import <MLWeiboUtils/MLWeiboUtils.h>
#import <MLWeChatUtils/MLWeChatUtils.h>

// cn pro
#warning Please replace the folowing keys
#define MaxLeap_AppId @"your_maxleap_applicationId"
#define MaxLeap_ClientKey @"your_maxleap_clientkey"
#define MaxLeap_site MLSiteCN

#define Weibo_AppKey @"your_weibo_appkey"
#define Weibo_RedirectURI @"https://api.weibo.com/oauth2/default.html"

#define Weixin_AppId @"your_weixin_appId"
#define Weixin_AppSecret @"your_weixin_appSecret"

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // ****************************************************************************
    // Uncommit fill in with your MaxLeap credentials:
    // ****************************************************************************
#warning Please fill in with your MaxLeap credentials
     [MaxLeap setApplicationId:MaxLeap_AppId clientKey:MaxLeap_ClientKey site:MaxLeap_site];
    self.region = MaxLeap_site;
    
    if (self.region == MLSiteUS) {
        // ****************************************************************************
        // Make sure your Facebook application id is configured in Info.plist.
        // ****************************************************************************
        [MLFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    } else if (self.region == MLSiteCN) {
        [MLWeiboUtils initializeWeiboWithAppKey:Weibo_AppKey redirectURI:Weibo_RedirectURI];
        
        [MLWeChatUtils initializeWeChatWithAppId:Weixin_AppId appSecret:Weixin_AppSecret wxDelegate:[WeChatSDKDelegate sharedInstance]];
    }

    // Override point for customization after application launch.
    
    return YES;
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 90000
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (self.region == MLSiteUS) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    } else {
        BOOL weibo = [WeiboSDK handleOpenURL:url delegate:[WeiboSDKDelegate sharedInstance]];
        BOOL wechat = [WXApi handleOpenURL:url delegate:[WeChatSDKDelegate sharedInstance]];
        return weibo || wechat;
    }
}
#endif

// iOS 9
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (self.region == MLSiteUS) {
        NSString *sourceApplication = options[UIApplicationLaunchOptionsSourceApplicationKey];
        id annotation = options[UIApplicationLaunchOptionsAnnotationKey];
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    } else {
        BOOL weibo = [WeiboSDK handleOpenURL:url delegate:[WeiboSDKDelegate sharedInstance]];
        BOOL wechat = [WXApi handleOpenURL:url delegate:[WeChatSDKDelegate sharedInstance]];
        return weibo || wechat;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if (self.region == MLSiteUS) {
        [FBSDKAppEvents activateApp];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
