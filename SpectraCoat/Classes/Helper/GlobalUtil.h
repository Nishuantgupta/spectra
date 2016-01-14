//
//  GlobalUtil.h
//  dictionaryiPhone4
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <Foundation/Foundation.h>

@interface GlobalUtil : NSObject
+ (NSString *)queryDictionaryToString:(NSDictionary *)query;

BOOL isArrayWithItems(id object);
BOOL isEmptyString(id object);
NSDate* getDateFor(NSString * sourceString, NSString * format);
NSString* getStringFromDate(NSDate *sourceDate, NSString * format);
void setUserDefaultsForKey(NSString *key, id value);
id objectFromUserDefaultsForKey(NSString *key);
void removeFromUserDefaultForKey(NSString * key);
BOOL isIndexWithinBounds(NSArray * items, int index);
NSString* filePath();
NSString * cachePath(NSString *cacheFile);
NSString* resourcePath(NSString* resourceName);
NSString* documentsDB(NSString* dbName);
void showAlert(NSString * title, NSString * msg);
BOOL isConnectedToNetwork();
NSString * stringByStrippingHTML(NSString * baseString);
BOOL isIphone5();
CGRect screenBounds();
NSString * encodeURL(NSURL * value);
float getiOSVersion();
BOOL isHomeTakeoverTracked();
BOOL isRetinaDevice();
BOOL isCameraAvailable();
BOOL isTorchAvailable();
BOOL isVideoCamera();
UIColor* colorWithHexString(NSString* hex);
@end
