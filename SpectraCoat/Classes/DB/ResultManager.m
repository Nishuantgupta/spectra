//
//  ResultManager.m
//  Dictionary
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "ResultManager.h"
#import "dBase.h"

@implementation ResultManager

+ (ResultManager *)sharedInstance
{
    static ResultManager * mgr;
    if( mgr == nil)
    {
        mgr = [[ResultManager alloc]init];
    }
    return mgr;
}
- (id)init
{
    self = [super init];
    if (self) {
        databaseObject = [[dBase alloc]init];
        [databaseObject setupDocumentsDB];
        [databaseObject loadTable];
    }
    return self;
}

#pragma mark - Favourites Related method

- (NSMutableDictionary *)getSimilorColorforRed:(float)r Green:(float)g Blue:(float)b
{
    NSMutableDictionary * records = [[NSMutableDictionary alloc]init];
    NSString * searchQuery = [NSString stringWithFormat:@"select * from ColorTable c order by ((c.R - %f)*(c.R - %f) + (c.G - %f)*(c.G - %f) + (c.B - %f)*(c.B - %f)) Limit 1",r,r,g,g,b,b];
    [databaseObject executeSelectCommand:searchQuery :nil];
    
    int rc = sqlite3_step(databaseObject.selectStmt);
    while(rc == SQLITE_ROW)
    {
        [records setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 5)] forKey:@"Name"];
        [records setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 0)] forKey:@"RAL"];
        [records setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 4)] forKey:@"HEX"];
        [records setObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(databaseObject.selectStmt, 1)] forKey:@"R"];
        [records setObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(databaseObject.selectStmt, 2)] forKey:@"G"];
        [records setObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(databaseObject.selectStmt, 3)] forKey:@"B"];
        [records setObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(databaseObject.selectStmt, 6)] forKey:@"ID"];
        [records setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 7)] forKey:@"SKU"];
        [records setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 8)] forKey:@"URL"];
        
        rc = sqlite3_step(databaseObject.selectStmt);
    }
    [databaseObject close];
    NSLog(@"RGB = %@", records);
    return records;
}


- (NSArray *)getFavouriteColors
{
    NSMutableArray * records = [[NSMutableArray alloc]init];
    NSString * tableName = @"FavColorTable";
     NSString * searchQuery = [NSString stringWithFormat:@"SELECT * FROM %@ ",tableName];
    [databaseObject executeSelectCommand:searchQuery :nil];
    
    int rc = sqlite3_step(databaseObject.selectStmt);
    while(rc == SQLITE_ROW)
    {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        [dic setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 5)] forKey:@"Name"];
        [dic setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 0)] forKey:@"RAL"];
        [dic setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 4)] forKey:@"Name"];
        [dic setObject:[NSString stringWithFormat:@"%f", sqlite3_column_double(databaseObject.selectStmt, 1)] forKey:@"R"];
        [dic setObject:[NSString stringWithFormat:@"%f", sqlite3_column_double(databaseObject.selectStmt, 2)] forKey:@"G"];
        [dic setObject:[NSString stringWithFormat:@"%f", sqlite3_column_double(databaseObject.selectStmt, 3)] forKey:@"B"];
        
        [records addObject:dic];
        rc = sqlite3_step(databaseObject.selectStmt);
    }
    [databaseObject close];
    return records;
}

- (NSArray *)getAllColors
{
    NSMutableArray * records = [[NSMutableArray alloc]init];
    NSString * tableName = @"ColorTable";
    NSString * searchQuery = [NSString stringWithFormat:@"SELECT * FROM %@ ",tableName];
    [databaseObject executeSelectCommand:searchQuery :nil];
    
    int rc = sqlite3_step(databaseObject.selectStmt);
    while(rc == SQLITE_ROW)
    {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 5)] forKey:@"Name"];
        [dic setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 0)] forKey:@"RAL"];
        [dic setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 4)] forKey:@"HEX"];
        [dic setObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(databaseObject.selectStmt, 1)] forKey:@"R"];
        [dic setObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(databaseObject.selectStmt, 2)] forKey:@"G"];
        [dic setObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(databaseObject.selectStmt, 3)] forKey:@"B"];
        [dic setObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(databaseObject.selectStmt, 6)] forKey:@"ID"];
        [dic setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 7)] forKey:@"SKU"];
        [dic setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(databaseObject.selectStmt, 8)] forKey:@"URL"];
        
        [records addObject:dic];
        rc = sqlite3_step(databaseObject.selectStmt);
    }
    [databaseObject close];
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"ID" ascending:YES];
    [records sortUsingDescriptors:[NSArray arrayWithObject:sortName]];
    return records;
}


- (BOOL)isFavouriteColor:(NSString *)ID
{
    NSString * tableName = @"FavColorTable";
    NSString * searchQuery = [NSString stringWithFormat:@"SELECT * FROM %@ where RAL = '%@'",tableName, ID];
    [databaseObject executeSelectCommand:searchQuery :nil];
    int rc = sqlite3_step(databaseObject.selectStmt);
    BOOL isFav = NO;
    while(rc == SQLITE_ROW)
    {
        isFav = YES;
        rc = sqlite3_step(databaseObject.selectStmt);
    }
    [databaseObject close];
    return isFav;
}


- (BOOL)isExistColorName:(NSString *)ID
{
    NSString * tableName = @"FavColorTable";
    NSString * searchQuery = [NSString stringWithFormat:@"SELECT * FROM %@ where Name = '%@'",tableName, ID];
    [databaseObject executeSelectCommand:searchQuery :nil];
    int rc = sqlite3_step(databaseObject.selectStmt);
    BOOL isFav = NO;
    while(rc == SQLITE_ROW)
    {
        isFav = YES;
        rc = sqlite3_step(databaseObject.selectStmt);
    }
    [databaseObject close];
    return isFav;
}

- (void)saveFavouritesColorWithData:(NSDictionary *)Record
{
    if(![self isFavouriteColor:[Record objectForKey:@"RAL"]])
    {
    @synchronized( databaseObject )
    {
        [databaseObject executeSelectCommand:@"INSERT INTO FavColorTable(RAL, R, G, B, Name) VALUES(?,?,?,?, ?)" :[NSArray arrayWithObjects:[Record objectForKey:@"RAL"], [Record objectForKey:@"R"], [Record objectForKey:@"G"], [Record objectForKey:@"B"], [Record objectForKey:@"Name"], nil]];
       
        int ch = sqlite3_step(databaseObject.selectStmt);
        if (ch == SQLITE_DONE) 
        {
           // NSLog(@"Saved SuccessFully");
        }
        else 
        {
            const char *ch = sqlite3_errmsg(databaseObject.dbConnection_);
            NSString *errMsg = [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
            NSLog(@"Inserting Error : %@",errMsg);
        }
        [databaseObject close];
    }
    }
}

- (void)deleteFavouritesColorForID:(NSString *)ID
{
    @synchronized( databaseObject )
    {
        [databaseObject executeSelectCommand:@"DELETE FROM FavColorTable WHERE RAL = ?" :[NSArray arrayWithObject:ID]];
        int ch = sqlite3_step(databaseObject.selectStmt);
        if (ch == SQLITE_DONE)
        {
            NSLog(@"Deleted SuccessFully");
        }
        [databaseObject close];
    }
}

- (void)deleteAllTableData
{
    @synchronized(databaseObject)
    {
        [databaseObject executeSelectCommand:@"DELETE FROM ColorTable" :[NSArray arrayWithObjects:nil]];
        int rc = sqlite3_step(databaseObject.selectStmt);
        if (rc == SQLITE_DONE) {
            ///DLog(@"Deleted SucessFull");
        }
        [databaseObject close];
    }
}

- (void)saveColorWithData:(NSDictionary *)Record
{
        @synchronized( databaseObject )
        {
            [databaseObject executeSelectCommand:@"INSERT INTO ColorTable(RAL, R, G, B, SKU, NAME, ID, OpenURL) VALUES(?,?,?,?, ?,?,?,?)" :[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@-%@-%@", [Record objectForKey:@"R"], [Record objectForKey:@"G"], [Record objectForKey:@"B"]] , [Record objectForKey:@"R"], [Record objectForKey:@"G"], [Record objectForKey:@"B"], [Record objectForKey:@"SKU"], [Record objectForKey:@"Name"], [Record objectForKey:@"Sequence"], [Record objectForKey:@"ProductUrl"],  nil]];
            
            int ch = sqlite3_step(databaseObject.selectStmt);
            if (ch == SQLITE_DONE)
            {
               // NSLog(@"Saved SuccessFully");
            }
            else
            {
                const char *ch = sqlite3_errmsg(databaseObject.dbConnection_);
                NSString *errMsg = [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
                NSLog(@"Inserting Error : %@",errMsg);
            }
            [databaseObject close];
        }
}

#pragma mark -

@end
