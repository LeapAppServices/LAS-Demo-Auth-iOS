//
//  MLWeChatUtils.h
//  MLWeChatUtils
//

#import <MaxLeap/MaxLeap.h>
#import <MLWeChatUtils/MLWeChatAccessToken.h>

@class SendAuthResp;
@protocol WXApiDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MLWeChatUtils : NSObject

///--------------------------------------
/// @name Interacting With WeChat
///--------------------------------------

/*!
 @abstract Initializes MaxLeap WeChat Utils.
 
 @warning You must invoke this in order to use the WeChat functionality in MaxLeap.
 @warning The apis below are only available when `+[WXApi regiterApp:]` successfully.
 
 @param appId       Your wechat app key.
 @param appSecrect  Your wechat app secrect.
 @param delegate    The WXApi delegate to handle wechat request and response.
 
 @return Return the value returned by `+[WXApi registerApp:]`
 */
+ (BOOL)initializeWeChatWithAppId:(NSString *)appId appSecret:(NSString *)appSecret wxDelegate:(id <WXApiDelegate>)delegate;

///--------------------------------------
/// @name Logging In
///--------------------------------------

/*!
 @abstract *Asynchronously* logs in a user using WeChat with scopes.
 
 @discussion This method delegates to the WeChat SDK to authenticate the user,
 and then automatically logs in (or creates, in the case where it is a new user) a <MLUser>.
 The `onResp:` method defined in `WXApiDelegate` protocol should be implemented and `[MLWeChatUtils handleAuthorizeResponse:]` should be called when the delegate recieve `SendAuthResp`.
 
 @param scope       The API scopes requested by the app in a list of space-delimited, case sensitive strings.
 @param block       The block to execute when the log in completes.
 It should have the following signature: `^(MLUser *user, NSError *error)`.
 */
+ (void)loginInBackgroundWithScope:(nullable NSString *)scope block:(nullable MLUserResultBlock)block;

/*!
 @abstract Handle the wechat authenticate response to complete the login process.
 
 @discussion This method result in a <MLUser> logging in or creating. And then the block in method `loginInBackgroundWithScope:block:` or `linkUserInBackground:withScope:block:` will be excuted on main thread.
 You should call this method when recieve the `SendAuthResp` response.
 
 @param authorizeResponse The `SendAuthResp` recieved in WXApiDelegate method 'onResp:'.
 */
+ (void)handleAuthorizeResponse:(SendAuthResp *)authorizeResponse;

/*!
 @abstract *Asynchronously* logs in a user using Facebook with read permissions.
 
 @discussion This method delegates to the Facebook SDK to authenticate the user,
 and then automatically logs in (or creates, in the case where it is a new user) a <MLUser>.
 
 @param token An instance of `MLWeChatAccessToken` to use.
 @param block The block to execute when the log in completes.
 It should have the following signature: `^(MLUser *user, NSError *error)`.
 */
+ (void)loginInBackgroundWithAccessToken:(MLWeChatAccessToken *)token block:(nullable MLUserResultBlock)block;

///--------------------------------------
/// @name Linking Users
///--------------------------------------

/*!
 @abstract *Asynchronously* links Facebook with read permissions to an existing <MLUser>.
 
 @discussion This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the <MLUser>.
 It will also save any unsaved changes that were made to the `user`.
 
 @param user  User to link to Wechat.
 @param scope The API scopes requested by the app in a list of space-delimited, case sensitive strings.
 @param block The block to execute when the linking completes.
 It should have the following signature: `^(BOOL succeeded, NSError *error)`.
 */
+ (void)linkUserInBackground:(MLUser *)user withScope:(nullable NSString *)scope block:(nullable MLBooleanResultBlock)block;

///--------------------------------------
/// @name Linking Users
///--------------------------------------

/*!
 @abstract *Asynchronously* links Facebook with read permissions to an existing <MLUser>.
 
 @discussion This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the <MLUser>.
 It will also save any unsaved changes that were made to the `user`.
 
 @param user  User to link to Wechat.
 @param token An instance of `MLWeChatAccessToken` to use.
 @param block The block to execute when the linking completes.
 It should have the following signature: `^(BOOL succeeded, NSError *error)`.
 */
+ (void)linkUserInBackground:(MLUser *)user withAccessToken:(MLWeChatAccessToken *)token block:(nullable MLBooleanResultBlock)block;

/*!
 @abstract Unlinks the <MLUser> from a Facebook account *asynchronously*.
 
 @param user  User to unlink from Wechat.
 @param block The block to execute.
 It should have the following argument signature: `^(BOOL succeeded, NSError *error)`.
 */
+ (void)unlinkUserInBackground:(MLUser *)user block:(nullable MLBooleanResultBlock)block;

///--------------------------------------
/// @name Getting Linked State
///--------------------------------------

/*!
 @abstract Whether the user has their account linked to wechat.
 
 @param user User to check for a wechat link. The user must be logged in on this device.
 
 @returns `YES` if the user has their account linked to wechat, otherwise `NO`.
 */
+ (BOOL)isLinkedWithUser:(nullable MLUser *)user;

@end

NS_ASSUME_NONNULL_END
