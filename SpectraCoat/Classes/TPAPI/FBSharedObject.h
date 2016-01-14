//
//  FBSharedObject.h
//  Burrp
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define  kUserInfoReceivedNotificationKey @"kUserInfoReceivedNotificationKey"

@protocol FBShareObjectDelegate  <NSObject>

@optional
- (void)accessTokenFound:(NSString *)accessToken;
- (void)facebookWallPostSuccess;
-(void)facebookWallPostCancel;
- (void)facebookWallPostFailed;
@end


@interface FBSharedObject : NSObject
{
    FBSession *fbSession;
    NSDictionary *postDetails;
    
    __unsafe_unretained  id<FBShareObjectDelegate> delegate;
    FBRequestConnection *fbConnection;
    
    
    NSDictionary *userInfo;
    BOOL isUserInfoCall;
}

@property (nonatomic, readonly) FBSession *fbSession;
@property (nonatomic, retain) NSDictionary *postDetails;
@property (nonatomic, assign) id<FBShareObjectDelegate> delegate;
@property (nonatomic, retain) NSDictionary *userInfo;

+ (FBSharedObject *) getSingleton;
- (BOOL)isSessionOpen;
- (void) fbLogin;
- (void) fbLogout;
- (void) postOnFB:(NSDictionary *) post;
- (void) loginSuccess;

@end
