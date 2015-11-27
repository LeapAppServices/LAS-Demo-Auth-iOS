//
//  WeiboSDKDelegate.m
//  Auth
//
//  Created by Sun Jin on 11/27/15.
//  Copyright © 2015 MaxLeap. All rights reserved.
//

#import "WeiboSDKDelegate.h"
#import <MLWeiboUtils/MLWeiboUtils.h>

@implementation WeiboSDKDelegate

+ (instancetype)sharedInstance {
    static WeiboSDKDelegate *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [WeiboSDKDelegate new];
    });
    return _sharedInstance;
}

#pragma mark -
#pragma mark WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    // 处理微博认证响应
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        [MLWeiboUtils handleAuthorizeResponse:(WBAuthorizeResponse *)response];
    }
}

@end
