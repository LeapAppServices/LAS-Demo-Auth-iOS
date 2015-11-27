//
//  MLWeiboUtils.h
//  MLWeiboUtils
//

#import <MaxLeap/MaxLeap.h>
#import <MLWeiboUtils/MLWeiboAccessToken.h>

@class WBAuthorizeResponse;

@interface MLWeiboUtils : NSObject

///--------------------------------------
/// @name Interacting With Weibo
///--------------------------------------

/*!
 @abstract Initializes MaxLeap Weibo Utils.
 
 @warning You must invoke this in order to use the Weibo functionality in MaxLeap.
 @warning The apis below are only available when `+[WeiboSDK regiterAppKey:]` successfully.
 
 @param appKey      Your weibo app key.
 @param redirectURI @see WBAuthorizeRequest.redirectURI in WeiboSDK.h
 
 @return Return the value returned by +[WeiboSDK regiterAppKey:]
 */
+ (BOOL)initializeWeiboWithAppKey:(NSString *)appKey redirectURI:(NSString *)redirectURI;

///--------------------------------------
/// @name Logging In
///--------------------------------------

/*!
 @abstract *Asynchronously* logs in a user using Weibo with scopes.
 
 @discussion This method delegates to the Weibo SDK to authenticate the user,
 and then automatically logs in (or creates, in the case where it is a new user) a <MLUser>.
 The `didReceiveWeiboResponse:` method defined in `WeiboSDKDelegate` should be implemented and call `[MLWeiboUtils handleAuthorizeResponse:]` when the delegate recieve `WBAuthorizeResponse`.
 
 @param scope       Array of read permissions to use.
 @param block       The block to execute when the log in completes.
 It should have the following signature: `^(MLUser *user, NSError *error)`.
 */
+ (void)loginInBackgroundWithScope:(NSString *)scope block:(MLUserResultBlock)block;

/*!
 @abstract Handle the weibo authenticate response to complete the login process.
 
 @discussion This method result in a <MLUser> logging in or creating. And then the block in methocd `loginInBackgroundWithScope:block:` will be excuted on main thread.
 
 @param scope       Array of read permissions to use.
 @param block       The block to execute when the log in completes.
 It should have the following signature: `^(MLUser *user, NSError *error)`.
 */
+ (void)handleAuthorizeResponse:(WBAuthorizeResponse *)authorizeResponse;

/*!
 @abstract *Asynchronously* logs in a user using Facebook with read permissions.
 
 @discussion This method delegates to the Facebook SDK to authenticate the user,
 and then automatically logs in (or creates, in the case where it is a new user) a <MLUser>.
 
 @param scope       Array of read permissions to use.
 @param block       The block to execute when the log in completes.
 It should have the following signature: `^(MLUser *user, NSError *error)`.
 */
+ (void)loginInBackgroundWithAccessToken:(MLWeiboAccessToken *)token block:(MLUserResultBlock)block;

///--------------------------------------
/// @name Linking Users
///--------------------------------------

/*!
 @abstract *Asynchronously* links Facebook with read permissions to an existing <MLUser>.
 
 @discussion This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the <MLUser>.
 It will also save any unsaved changes that were made to the `user`.
 
 @param user        User to link to Facebook.
 @param permissions Array of read permissions to use.
 @param block       The block to execute when the linking completes.
 It should have the following signature: `^(BOOL succeeded, NSError *error)`.
 */
+ (void)linkUserInBackground:(MLUser *)user withScope:(NSString *)scope block:(MLBooleanResultBlock)block;

///--------------------------------------
/// @name Linking Users
///--------------------------------------

/*!
 @abstract *Asynchronously* links Facebook with read permissions to an existing <MLUser>.
 
 @discussion This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the <MLUser>.
 It will also save any unsaved changes that were made to the `user`.
 
 @param user        User to link to Facebook.
 @param permissions Array of read permissions to use.
 @param block       The block to execute when the linking completes.
 It should have the following signature: `^(BOOL succeeded, NSError *error)`.
 */
+ (void)linkUserInBackground:(MLUser *)user withAccessToken:(MLWeiboAccessToken *)token block:(MLBooleanResultBlock)block;

/*!
 @abstract Unlinks the <MLUser> from a Facebook account *asynchronously*.
 
 @param user User to unlink from Facebook.
 @param block The block to execute.
 It should have the following argument signature: `^(BOOL succeeded, NSError *error)`.
 */
+ (void)unlinkUserInBackground:(MLUser *)user block:(MLBooleanResultBlock)block;

///--------------------------------------
/// @name Getting Linked State
///--------------------------------------

/*!
 @abstract Whether the user has their account linked to weibo.
 
 @param user User to check for a weibo link. The user must be logged in on this device.
 
 @returns `YES` if the user has their account linked to weibo, otherwise `NO`.
 */
+ (BOOL)isLinkedWithUser:(MLUser *)user;

@end
