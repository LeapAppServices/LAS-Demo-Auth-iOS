//
//  Copyright (c) 2015 LAS. All rights reserved.

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *facebookPromtLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;


@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
