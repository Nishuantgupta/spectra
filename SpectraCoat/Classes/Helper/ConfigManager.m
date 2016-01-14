//
//  ConfigManager.m
//  dictionaryiPhone4
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "ConfigManager.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "GlobalUtil.h"
#import "XMLReader.h"
#import "ResultManager.h"
#import "SBJSON.h"

@interface ConfigManager()
{
    ASIHTTPRequest * httpRequest;
    NSDictionary * settingDic;
}
- (BOOL)parseResponse :(NSData *)responseData;
- (void)loadFromLocal;
- (NSString *)getConfigURL;
- (void)hitIfConnected;
@end

@implementation ConfigManager
@synthesize settingDic, isLoadedFromNetwork;


typedef enum REQUEST_STATE
{
    REQUEST_STATE_NOTSTARTED = 5,
    REQUEST_STATE_COMPLETED,
    REQUEST_STATE_FAILED
} REQUEST_STATE;

static ConfigManager * mgr = nil;

+ (ConfigManager *)sharedInstance
{
    
    if( mgr == nil)           
    {
        mgr = [[ConfigManager alloc]init];
    }
    else
    {
        
    }
    return mgr;
}
- (id)init 
{
    self = [super init];
    if (self) 
    {
        isLoadedFromNetwork = NO;
    }
    return self;
}

- (void)hitIfConnected
{
    if(isLoadedFromNetwork == NO)
    {
    if(isConnectedToNetwork())
	{
        NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><PickColors xmlns=\"http://tempuri.org/\"></PickColors></s:Body></s:Envelope>"];
        
        NSURL *url = [NSURL URLWithString:@"http://www.spectracoat.mobi/Webservices.asmx"];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue:@"http://tempuri.org/PickColors" forHTTPHeaderField:@"SOAPAction"];
        [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        
        [theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
            if(error == nil)
            {
            NSDictionary *theXML = [XMLReader dictionaryForXMLData:data error:nil];
    
             NSString  * responseString  = [[[[theXML objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"]objectForKey:@"PickColorsResponse"] objectForKey:@"PickColorsResult" ];
       
            SBJSON * json =[SBJSON new];
            
            if(isLoadedFromNetwork == NO)
            {
            isLoadedFromNetwork = YES;
           // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
                NSArray * array = [json objectWithString:responseString error:NULL];
                NSLog(@"%d", [array count]);
                if([array count]>0)
                {
                    [[ResultManager sharedInstance] deleteAllTableData];
                }
                for (int i = 0 ; i < [ array count]; i++) {
                    [[ResultManager sharedInstance] saveColorWithData:[array objectAtIndex:i]];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kComplete" object:nil];
           // });
            
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kComplete" object:nil];
            }
            }
            else
            {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kComplete" object:nil];
            }

        }];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kComplete" object:nil];
    }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kComplete" object:nil];
    }
}

- (void)networkStatusChanged
{
    if(isLoadedFromNetwork == NO &&isConnectedToNetwork())
    {
        if( httpRequest == nil && [httpRequest complete] == NO)
            [self hitIfConnected];
    }
}
@end
