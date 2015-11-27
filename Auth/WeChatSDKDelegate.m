//
//  WeChatSDKDelegate.m
//  Auth
//
//  Created by Sun Jin on 11/27/15.
//  Copyright © 2015 MaxLeap. All rights reserved.
//

#import "WeChatSDKDelegate.h"
#import <MLWeChatUtils/MLWeChatUtils.h>

@implementation WeChatSDKDelegate

+ (instancetype)sharedInstance {
    static WeChatSDKDelegate *_shatedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shatedInstance = [WeChatSDKDelegate new];
    });
    return _shatedInstance;
}

#pragma mark -
#pragma mark WXApiDelegate

- (void)onReq:(BaseReq*)req {
    
}

- (void)onResp:(BaseResp*)resp {
    // 处理微信认证响应
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        [MLWeChatUtils handleAuthorizeResponse:(SendAuthResp *)resp];
    }
}

@end
