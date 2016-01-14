//
//  GlobalUtil.m
//  dictionaryiPhone4
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "GlobalUtil.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@implementation GlobalUtil

#pragma mark Static Functions

+ (NSString *)queryDictionaryToString:(NSDictionary *)query
{
	NSMutableArray * queryArray = [[NSMutableArray alloc] init];
	for (id key in query)
    {
		[queryArray addObject:[NSString stringWithFormat:@"%@=%@", key, [query objectForKey:key]]];
	}
	
	NSString *queryString = [queryArray componentsJoinedByString:@"&"];	
	return queryString;
}

#pragma mark In Line Functions

BOOL isArrayWithItems(id object) 
{
	return ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) ? [object count] > 0 : FALSE;
}

BOOL isEmptyString(id object)
{
    if( object == nil)
        return YES;
    
    if( [object isEqual:[NSNull null]])
        return YES;
    
    if( [object isKindOfClass:[NSString class]] == NO)
        return YES;
    NSString * temp = (NSString *)object;
    NSCharacterSet * set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString * filteredString = [temp stringByTrimmingCharactersInSet:set];
    if( [filteredString length] < 1)
        return YES;
    
    return NO;
}

NSDate* getDateFor(NSString * sourceString, NSString * format)
{
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    NSLocale * usLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    [df setDateFormat:format];
    NSDate * date = [df dateFromString:sourceString];
    return date;
}
NSString* getStringFromDate(NSDate *sourceDate, NSString * format)
{
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    NSLocale * usLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    [df setDateFormat:format];
    NSString * dateString = [df stringFromDate:sourceDate];
    return dateString;
}

void setUserDefaultsForKey(NSString *key, id value){
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if([value isKindOfClass:[NSString class]])
    {
		[defaults setValue:value forKey:key];	
	}
    else
    {
		[defaults setObject:value forKey:key];	
	}
	[defaults synchronize];
}

id objectFromUserDefaultsForKey(NSString *key){
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:key];
}
void removeFromUserDefaultForKey(NSString * key)
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

BOOL isIndexWithinBounds(NSArray * items, int index)
{
	if(isArrayWithItems(items))
    {
		return ([items count]-1 >= index);
	}
	return NO;
}

NSString* resourcePath(NSString* resourceName) 
{
	return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:resourceName];
}

NSString* documentsDB(NSString* dbName)
{
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * documentsDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
	return documentsDBPath;	
}
NSString * cachePath(NSString *cacheFile)
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString * cachedDirectory = [paths objectAtIndex:0];
	NSString * cacheFileURL = [cachedDirectory stringByAppendingPathComponent:cacheFile];
    return cacheFileURL;
}
void showAlert(NSString * title, NSString * msg)
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}
NSString* filePath()
{
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	resourcePath = [[resourcePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"]
                    stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSString *_filePath = [NSString stringWithFormat:@"file:/%@//", resourcePath];
	return _filePath;	
}

BOOL isConnectedToNetwork()
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{   
		printf("Error. Could not recover network reachability flags\n");
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL isWWAN = flags & kSCNetworkReachabilityFlagsIsWWAN;
	return ((isReachable || isWWAN) && !needsConnection) ? YES : NO;
}

NSString * stringByStrippingHTML(NSString * baseString)
{
    NSRange r;
    NSString *s = baseString;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s; 
}
BOOL isIphone5()
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        if((screenBounds().size.height * [[UIScreen mainScreen]scale]) >= 1136)
        {
            return YES;
        }
        else
            return NO;
    }
    return NO;
}

CGRect screenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;
    return bounds;
}

NSString * encodeURL(NSURL * value)
{
	if (value == nil)
		return @"";
	
	NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value.absoluteString, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
	return result;
}
float getiOSVersion()
{
    return [[[UIDevice currentDevice]  systemVersion] floatValue];
}

BOOL isRetinaDevice()
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))?1:0;
}
BOOL isCameraAvailable()
{
    return [UIImagePickerController isSourceTypeAvailable:SOURCETYPE];
}
BOOL isTorchAvailable()
{
    return NO;
}
BOOL isVideoCamera()
{
    return NO;
}

UIColor* colorWithHexString(NSString* hex)
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
