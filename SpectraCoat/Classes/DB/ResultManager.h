//
//  ResultManager.h
//  Dictionary
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <Foundation/Foundation.h>
@class dBase;
@interface ResultManager : NSObject
{
    dBase * databaseObject;
}
+ (ResultManager *)sharedInstance;

//  Favourite
- (NSMutableDictionary *)getSimilorColorforRed:(float)r Green:(float)g Blue:(float)b;
- (NSArray *)getFavouriteColors;
- (NSArray *)getAllColors;
- (BOOL)isFavouriteColor:(NSString *)ID;
- (void)saveFavouritesColorWithData:(NSDictionary *)Record;
- (void)deleteFavouritesColorForID:(NSString *)ID;
- (void)deleteAllFavouritesData;
- (void)saveColorWithData:(NSDictionary *)Record;
- (void)deleteAllTableData;
- (BOOL)isExistColorName:(NSString *)ID;

@end
