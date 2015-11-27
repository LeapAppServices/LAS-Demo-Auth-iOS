//
//  WeChatSDKDelegate.h
//  Auth
//
//  Created by Sun Jin on 11/27/15.
//  Copyright © 2015 MaxLeap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WeChatSDKDelegate : NSObject <WXApiDelegate>

+ (instancetype)sharedInstance;

@end
