//
//  FBSharedObject.m
//  Burrp
//
//  Created by Nishant Gupta on 7/10/13.
//
//
//

#import "FBSharedObject.h"



static FBSharedObject *sharedObject = nil;

@implementation FBSharedObject
@synthesize fbSession;
@synthesize postDetails;
@synthesize delegate;
@synthesize userInfo;


+ (FBSharedObject *) getSingleton
{
    if (sharedObject == nil) {
        sharedObject = [[FBSharedObject alloc] init];
    }
    return sharedObject;
}



- (void) postOnFB:(NSDictionary *) post
{
    self.postDetails = post;  
        NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:1];
        
        NSString *message = [self.postDetails objectForKey:@"message"];
        if(message != nil)
            [variables setObject:message forKey:@"message"];
        
        NSString *link = [self.postDetails objectForKey:@"link"];
        if(link != nil)
            [variables setObject:link forKey:@"link"];
        
        NSString *title = [self.postDetails objectForKey:@"title"];
        if(title != nil)
            [variables setObject:title forKey:@"name"];
        
        NSString *description = [self.postDetails objectForKey:@"description"];
        if(description != nil)
            [variables setObject:description forKey:@"description"];
        
        NSString *image = [self.postDetails objectForKey:@"image"];
        if(image != nil)
            [variables setObject:image forKey:@"picture"];
        
    UIImage *picture = [self.postDetails objectForKey:@"picture"];
    if(picture != nil)
        [variables setObject:UIImagePNGRepresentation(picture) forKey:@"picture"];
//   BOOL appCall = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self.delegate initialText:title image:picture url:[NSURL URLWithString:link] handler:^(FBOSIntegratedShareDialogResult result, NSError *error)
//                {
//        if (error) {
//            if ([self.delegate respondsToSelector:@selector(facebookWallPostFailed)]) {
//                [self.delegate facebookWallPostFailed];
//            }
//        }
//        else
//        {
//            
//            if (result == FBOSIntegratedShareDialogResultSucceeded) {
//                if ([self.delegate respondsToSelector:@selector(facebookWallPostSuccess)]) {
//                    [self.delegate facebookWallPostSuccess];
//                
//                }
//                else
//                {
//                    if ([self.delegate respondsToSelector:@selector(facebookWallPostCancel)]) {
//                        [self.delegate facebookWallPostCancel];
//                    }
//                }
//                
//                
//                
//            }
//        }
//                    
//    }];
//
//        FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:[NSURL URLWithString:link]
//                                                              name:title
//                                                           caption:message
//                                                       description:description
//                                                           picture:nil
//                                                       clientState:nil
//                                                           handler:^(FBAppCall *call, NSDictionary *result, NSError *error) {
//                                                               if (error) {
//                                                                   if ([self.delegate respondsToSelector:@selector(facebookWallPostFailed)]) {
//                                                                       [self.delegate facebookWallPostFailed];
//                                                                   }
//                                                               }
//                                                               else
//                                                               {
//                                                                   
//                                                                   if ([[result objectForKey:@"completionGesture"] isEqualToString:@"post"] || [[result objectForKey:@"didComplete"] boolValue]) {
//                                                                       if ([self.delegate respondsToSelector:@selector(facebookWallPostSuccess)]) {
//                                                                           [self.delegate facebookWallPostSuccess];
//                                                                           
//                                                                       
//                                                                   }
//                                                                   else
//                                                                   {
//                                                                       if ([self.delegate respondsToSelector:@selector(facebookWallPostCancel)]) {
//                                                                           [self.delegate facebookWallPostCancel];
//                                                                       }
//                                                                   }
//                                                                  
//                                                                
//                                                                   
//                                                               }
//                                                                    }
//
//                                                           }];
//        if (!appCall) {
//            BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self.delegate
//                                                                                  initialText:description
//                                                                                        image:picture
//                                                                                          url:[NSURL URLWithString:link]
//                                                                                      handler:^(FBOSIntegratedShareDialogResult result, NSError *error)
//                                          {
//                                              if (!error) 
//                                              {
//                                                  if(result == FBOSIntegratedShareDialogResultCancelled)
//                                                  {
//                                                      
//                                                      if ([self.delegate respondsToSelector:@selector(facebookWallPostCancel)]) {
//                                                          [self.delegate facebookWallPostCancel];
//                                                      }
//                                                  }
//                                                  else if(result == FBOSIntegratedShareDialogResultSucceeded)
//                                                  {
//                                                  if ([self.delegate respondsToSelector:@selector(facebookWallPostSuccess)]) {
//                                                      [self.delegate facebookWallPostSuccess];
//                                                  }
//                                                  
//                                                  
//                                              }
//                                              }
//                                              
//                                          }];
    
    
 //           if (!appCall)
            {
                if( [FBSession activeSession].isOpen)
                {

                    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:variables HTTPMethod:@"POST"
                                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                    if (error) {
                                                        if ([self.delegate respondsToSelector:@selector(facebookWallPostFailed)]) {
                                                            [self.delegate facebookWallPostFailed];
                                                        }
                                                    }
                                                    else
                                                    {
                                                        if ([self.delegate respondsToSelector:@selector(facebookWallPostSuccess)]) {
                                                            [self.delegate facebookWallPostSuccess];
                                                        }
                                        
                                                    }
                                           
                                                }];
                }
                else
                {
//                    [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObjects:@"email", nil] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                        
//                    if (error) {
//                        if ([self.delegate respondsToSelector:@selector(facebookWallPostFailed)]) {
//                            [self.delegate facebookWallPostFailed];
//                        }
//                    }
//                    else
//                    {
                    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream", @"publish_actions", nil] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session,
                                                                                                                                                                                                         FBSessionState status,
                                                                                                                                                                                                         NSError *error) {
                        if (error) {
                            if ([self.delegate respondsToSelector:@selector(facebookWallPostFailed)]) {
                                [self.delegate facebookWallPostFailed];
                            }
                        }
                        else
                        {
                            [FBSession setActiveSession:session];
                            [FBRequestConnection startWithGraphPath:@"me/photos" parameters:variables HTTPMethod:@"POST"
                                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                      if (error) {
                                                          if ([self.delegate respondsToSelector:@selector(facebookWallPostFailed)]) {
                                                              [self.delegate facebookWallPostFailed];
                                                          }
                                                      }
                                                      else
                                                      {
                                                          if ([self.delegate respondsToSelector:@selector(facebookWallPostSuccess)]) {
                                                              [self.delegate facebookWallPostSuccess];
                                                          }
                                                          
                                                    
                                                          
                                                      }
                                                      
                                                  }];
//                        }
//
//                    }];
                    }}];
                }
            }
        }
 //   }



- (void) fbLogout
{
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"SessionID"];
    [userDefaults removeObjectForKey:@"Cookies"];
    [userDefaults removeObjectForKey:@"FBAccessToken"];
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"isFBLogin"];
    
    [userDefaults synchronize];
    
    self.userInfo = nil;
}

#pragma mark -
#pragma mark connecting FB Acount to Burrp Methods
- (BOOL)isSessionOpen
{
    return [FBSession activeSession].isOpen;
}

@end
