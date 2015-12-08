//
//  Copyright (c) 2015 MaxLeap. All rights reserved.

#import "LoginViewController.h"
#import <MaxLeap/MaxLeap.h>
#import <MLFacebookUtilsV4/MLFacebookUtils.h>
#import <MLWeiboUtils/MLWeiboUtils.h>
#import <MLWeChatUtils/MLWeChatUtils.h>
#import "AppDelegate.h"

@implementation LoginViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MLSite region = [(AppDelegate *)[UIApplication sharedApplication].delegate region];
    if (region == MLSiteUS) {
        self.weiboButton.hidden = YES;
        self.wechatButton.hidden = YES;
    } else if (region == MLSiteCN) {
        self.facebookPromtLabel.hidden = YES;
        self.facebookButton.hidden = YES;
    }
    
    
    // Check if user is cached and linked to Facebook, if so, bypass login
    MLUser *currentUser = [MLUser currentUser];
    BOOL linkedWithFacebook = [MLFacebookUtils isLinkedWithUser:currentUser];
    BOOL linkedWithWeibo = [MLWeiboUtils isLinkedWithUser:currentUser];
    BOOL linkedWithWeChat = [MLWeChatUtils isLinkedWithUser:currentUser];
    if (linkedWithFacebook || linkedWithWeibo || linkedWithWeChat) {
        [self showUserDetail];
    }
}

- (void)showUserDetail {
    [self performSegueWithIdentifier:@"showUserProfile" sender:nil];
}

#pragma mark - Login mehtods

- (MLUserResultBlock)loginCallbackForPlatform:(NSString *)platform {
    return ^(MLUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSString *message = [NSString stringWithFormat:@"Uh oh. The user cancelled the %@ login.", platform];
                NSLog(@"%@", message);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with %@ signed up and logged in!", platform);
            [self showUserDetail];
        } else {
            NSLog(@"User with %@ logged in!", platform);
            [self showUserDetail];
        }
    };
}

/* Login to facebook method */
- (IBAction)loginWithFacebook:(id)sender  {
    // fix the login error with code 304
    // http://stackoverflow.com/questions/29408299/ios-facebook-sdk-4-0-login-error-code-304
    FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc] init];
    [loginmanager logOut];
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login MLUser using facebook
    [MLFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:[self loginCallbackForPlatform:@"facebook"]];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (IBAction)loginWithWeibo:(id)sender {
    [MLWeiboUtils loginInBackgroundWithScope:@"all" block:[self loginCallbackForPlatform:@"weibo"]];
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (IBAction)loginWithWeChat:(id)sender {
    [MLWeChatUtils loginInBackgroundWithScope:@"snsapi_userinfo" block:[self loginCallbackForPlatform:@"wechat"]];
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

@end
