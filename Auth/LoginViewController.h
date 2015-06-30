//
//  Copyright (c) 2015 LAS. All rights reserved.

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

- (IBAction)loginButtonTouchHandler:(id)sender;

@end
