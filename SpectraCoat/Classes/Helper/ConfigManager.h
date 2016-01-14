//
//  ConfigManager.h
//  dictionaryiPhone4
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;
@interface ConfigManager : NSObject <UIAlertViewDelegate>
{
    BOOL isLoadedFromNetwork;
}

@property (nonatomic, assign) BOOL isLoadedFromNetwork;
@property (nonatomic, readonly) NSDictionary * settingDic;
+ (ConfigManager *)sharedInstance;
- (NSString *)getURL :(NSString *)name;
- (NSString *)getContent :(NSString *)contentType;
- (void)hitIfConnected;
@end
