//
//  dBase.m
//  iCheck
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import "dBase.h"


@implementation dBase
@synthesize selectStmt = selectStmt_,cmdString = cmdString_,command = command_,dbConnection_;


- (NSInteger)executeCommand
{
	switch (self.command )
	{
		case UPDATECMD:
		{

			if( sqlite3_open([dbFileName_ UTF8String], &dbConnection_) == SQLITE_OK)
				{
					if( sqlite3_exec(dbConnection_, [cmdString_ UTF8String],NULL,NULL,NULL) == SQLITE_OK )
					{
						///DLog(@"record updated successfully");
					}
					else
					{
						NSString * msg =[NSString stringWithUTF8String:(char*)sqlite3_errmsg(dbConnection_)];
						///DLog(@"error while updating record");
						///DLog(msg);
					}
					[self close];
					return 1;
				}
			break;
		}
		case SELECTCMD:
		{
			if( sqlite3_open([dbFileName_ UTF8String], &dbConnection_) == SQLITE_OK)
			{
				if (sqlite3_prepare_v2(dbConnection_, [cmdString_ cStringUsingEncoding:NSUTF8StringEncoding], -1, &selectStmt_, NULL) == SQLITE_OK)
				{
					return 1;
				}
				else
				{
					NSString * msg =[NSString stringWithUTF8String:(char*)sqlite3_errmsg(dbConnection_)];
					///DLog(@"error while selecting record");
					///DLog(@"%@ %@",msg,cmdString_);
					return 0;
				}	
			}
			break;
		}
		case INSERTCMD:
		{
			if( sqlite3_open([dbFileName_ UTF8String], &dbConnection_) == SQLITE_OK)
			{
				if( sqlite3_exec(dbConnection_, [cmdString_ UTF8String],NULL,NULL,NULL) == SQLITE_OK )
				{
					///DLog(@"record inserted successfully");
				}
				else
				{
					NSString * msg =[NSString stringWithUTF8String:(char*)sqlite3_errmsg(dbConnection_)];
					///DLog(@"error while inserting record");
					///DLog(msg);
				}
				[self close];
				return 1;
			}
			
			break;
		}
		case DELETECMD:
		{
			if( sqlite3_open([dbFileName_ UTF8String], &dbConnection_) == SQLITE_OK)
				{
					if( sqlite3_exec(dbConnection_, [cmdString_ UTF8String],NULL,NULL,NULL) == SQLITE_OK )
					{

					}
					else
					{

					}
					[self close];
					return 1;
			}
			break;
		}
	}
	return 0;
}
- (void)bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt*)pStmt
{
    if ((!obj) || ((NSNull *)obj == [NSNull null])) {
        sqlite3_bind_null(pStmt, idx);
    }
    
    // FIXME - someday check the return codes on these binds.
    else if ([obj isKindOfClass:[NSData class]]) {
        sqlite3_bind_blob(pStmt, idx, [obj bytes], [obj length], SQLITE_STATIC);
    }
    else if ([obj isKindOfClass:[NSDate class]]) {
        sqlite3_bind_double(pStmt, idx, [obj timeIntervalSince1970]);
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        
        if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            sqlite3_bind_int(pStmt, idx, ([obj boolValue] ? 1 : 0));
        }
        else if (strcmp([obj objCType], @encode(int)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longLongValue]);
        }
        else if (strcmp([obj objCType], @encode(float)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj floatValue]);
        }
        else if (strcmp([obj objCType], @encode(double)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj doubleValue]);
        }
        else {
            sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_TRANSIENT);
        }
    }
    else {
        sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_TRANSIENT);
    }
}

- (void)executeSelectCommand :(NSString *)sql :(NSArray *)arguments
{
    selectStmt_ = nil;
    
    BOOL retry = YES;
    int rc = sqlite3_open([dbFileName_ UTF8String], &dbConnection_);
    int retryCount = 0;
    while ( retry )
    {
       rc = sqlite3_prepare_v2(dbConnection_, [sql UTF8String], -1, &selectStmt_, 0);
        
        if( rc == SQLITE_BUSY )
        {
            continue;
        }
        else
        {
            retry = NO;
            const char * ch = sqlite3_errmsg(dbConnection_);
            if( ch != nil)
            {
                break;
            }
        }
        retryCount = 2;
    }
    int idx = 0;
    int bindCount = sqlite3_bind_parameter_count(selectStmt_);
    while( idx < bindCount )
    {
        id obj = [arguments objectAtIndex:idx];
        idx++;
        
        [self bindObject:obj toColumn:idx inStatement:selectStmt_];
    }
}
#pragma mark Table Commands

- (void)loadTable
{
	NSString * databasePath = documentsDB(@"Color.sqlite");
    dbFileName_ = [databasePath copy];
}
- (void)loadTable :(NSString *)dataBasePath
{
    dbFileName_ = [dataBasePath copy];    
}
- (void)setupDocumentsDB
{
	NSError *error = nil;	
	
	NSString *destPath = documentsDB(@"Color.sqlite");
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:destPath]){
		BOOL success = [[NSFileManager defaultManager] copyItemAtPath:resourcePath(@"Color.sqlite") 
                                                               toPath:destPath
                                                                error:&error];
		if (!success) {
//			DLog(@"error = %@", error);
		}
	}
}
- (int)open
{
    return sqlite3_open([dbFileName_ UTF8String], &dbConnection_);
}
- (void)close
{
	sqlite3_reset(self.selectStmt);
	sqlite3_reset(otherStmt_);
	sqlite3_finalize(self.selectStmt);
	sqlite3_finalize(otherStmt_);
	sqlite3_close(dbConnection_);
	self.selectStmt = nil;
	otherStmt_ = nil;
}
- (void)dealloc
{
	sqlite3_close(dbConnection_);
}

@end
