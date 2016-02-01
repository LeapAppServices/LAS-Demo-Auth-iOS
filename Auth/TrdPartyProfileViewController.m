//
//  Copyright (c) 2015 LAS. All rights reserved.

#import "TrdPartyProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MLFacebookUtilsV4/MLFacebookUtils.h>
#import <MLWeiboUtils/MLWeiboUtils.h>
#import <MLWeChatUtils/MLWeChatUtils.h>
#import "WBHttpRequest+WeiboUser.h"
#import "WeiboUser.h"
#import "WXApi.h"

@implementation TrdPartyProfileViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.platform;
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    // Load table header view from nib
    [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil];
    self.tableView.tableHeaderView = self.headerView;
    
    // Create array for table row titles
    self.rowTitleArray = @[@"Location", @"Gender"];
    
    // Set default values for the table row data
    self.rowDataArray = [@[@"N/A", @"N/A"] mutableCopy];
    
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([MLUser currentUser]) {
        [self updateProfile];
    }
    
    if ([self.platform isEqualToString:@"Facebook Profile"]) {
        [self refreshFacebookProfile];
    } else if ([self.platform isEqualToString:@"Weibo Profile"]) {
        [self refreshWeiboProfile];
    } else if ([self.platform isEqualToString:@"WeChat Profile"]) {
        [self refreshWechatProfile];
    }
}

#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    self.headerImageView.image = [UIImage imageWithData:self.imageData];
    
    // Add a nice corner radius to the image
    self.headerImageView.layer.cornerRadius = 8.0f;
    self.headerImageView.layer.masksToBounds = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.rowTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 120.0f, 44.0f)];
        titleLabel.tag = 1; // We use the tag to set it later
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake( 130.0f, 0.0f, 165.0f, 44.0f)];
        dataLabel.tag = 2; // We use the tag to set it later
        dataLabel.font = [UIFont systemFontOfSize:15.0f];
        dataLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:dataLabel];
    }
    
    // Cannot select these cells
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Access labels in the cell using the tag #
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *dataLabel = (UILabel *)[cell viewWithTag:2];
    
    // Display the data in the table
    titleLabel.text = [self.rowTitleArray objectAtIndex:indexPath.row];
    dataLabel.text = [self.rowDataArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - ()

// Set received values if they are not nil and reload the table
- (void)updateProfile {
    NSDictionary *profile = nil;
    if ([self.platform isEqualToString:@"Facebook Profile"]) {
        profile = [MLUser currentUser][@"facebookProfile"];
    } else if ([self.platform isEqualToString:@"Weibo Profile"]) {
        profile = [MLUser currentUser][@"weiboProfile"];
    } else if ([self.platform isEqualToString:@"WeChat Profile"]) {
        profile = [MLUser currentUser][@"wechatProfile"];
    }
    
    if (profile[@"location"]) {
        [self.rowDataArray replaceObjectAtIndex:0 withObject:profile[@"location"]];
    }
    
    if (profile[@"gender"]) {
        [self.rowDataArray replaceObjectAtIndex:1 withObject:profile[@"gender"]];
    }
    
    [self.tableView reloadData];
    
    // Set the name in the header view label
    if (profile[@"name"]) {
        self.headerNameLabel.text = profile[@"name"];
    }
    
    if (profile[@"pictureURL"]) {
        NSURL *pictureURL = [NSURL URLWithString:profile[@"pictureURL"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
        self.headerImageView.image = image;
    }
}

#pragma mark -
#pragma mark Facebook

- (void)refreshFacebookProfile {
    // Send request to Facebook
    NSDictionary *fileds = @{@"fileds":@"id, name, location.name, gender, birthday, relationship_status"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:fileds];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // LAS the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"userId"] = facebookID;
            }
            
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            
            if (userData[@"location"][@"name"]) {
                userProfile[@"location"] = userData[@"location"][@"name"];
            }
            
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            
            [[MLUser currentUser] setObject:userProfile forKey:@"facebookProfile"];
            [[MLUser currentUser] saveInBackgroundWithBlock:nil];
            
            [self updateProfile];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

#pragma mark -
#pragma mark Weibo

- (void)refreshWeiboProfile {
    MLWeiboAccessToken *token = [MLWeiboAccessToken currentAccessToken];
    if (!token) {
        return;
    }
    [WBHttpRequest requestForUserProfile:token.userID
                         withAccessToken:token.tokenString
                      andOtherProperties:nil
                                   queue:nil
                   withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error)
     {
         if ([result isKindOfClass:[WeiboUser class]]) {
             WeiboUser *user = (WeiboUser *)result;
             
             NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
             
             if (user.userID) {
                 userProfile[@"userId"] = user.userID;
             }
             
             if (user.name) {
                 userProfile[@"name"] = user.name;
             }
             
             if (user.location) {
                 userProfile[@"location"] = user.location;
             }
             
             if (user.gender) {
                 userProfile[@"gender"] = user.gender;
             }
             
             if (user.profileImageUrl) {
                 userProfile[@"pictureURL"] = user.profileImageUrl;
             }
             
             [[MLUser currentUser] setObject:userProfile forKey:@"weiboProfile"];
             [[MLUser currentUser] saveInBackgroundWithBlock:nil];
             
             [self updateProfile];
         } else {
             NSLog(@"failed to get user profile, error: %@,\nresult: %@", error, result);
         }
     }];
}

#pragma mark -
#pragma mark WeChat

- (void)refreshWechatProfile {
    MLWeChatAccessToken *token = [MLWeChatAccessToken currentAccessToken];
    if (!token) {
        return;
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token.tokenString, token.userID];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        id responseObject = nil;
        if (data) {
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (responseObject[@"errcode"] == nil) {;
                    
                    NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
                    
                    if (responseObject[@"openid"]) {
                        userProfile[@"userId"] = responseObject[@"openid"];
                    }
                    
                    if (responseObject[@"nickname"]) {
                        userProfile[@"name"] = responseObject[@"nickname"];
                    }
                    
                    if (responseObject[@"country"]) {
                        userProfile[@"location"] = responseObject[@"country"];
                    }
                    
                    if (responseObject[@"sex"]) {
                        userProfile[@"gender"] = [responseObject[@"sex"] stringValue];
                    }
                    
                    if (responseObject[@"headimgurl"]) {
                        userProfile[@"pictureURL"] = responseObject[@"headimgurl"];
                    }
                    
                    [[MLUser currentUser] setObject:userProfile forKey:@"wechatProfile"];
                    [[MLUser currentUser] saveInBackgroundWithBlock:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateProfile];
                    });
                    return ;
                } else {
                    error = [NSError errorWithDomain:@"GetWechatProfileError" code:[responseObject[@"errcode"] integerValue] userInfo:responseObject];
                }
            } else {
                
            }
        }
        NSLog(@"Something goes wrong, error: %@", error);
//    });
}

@end
