//
//  dBase.h
//  iCheck
//
//  Created by Nishant Gupta on 7/10/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
enum
{
	SELECTCMD = 0,
	INSERTCMD,
	DELETECMD,
	UPDATECMD
};
typedef NSInteger COMMAND;

@interface dBase : NSObject {
	NSString * dbFileName_;
	sqlite3 * dbConnection_;
	NSMutableString * cmdString_;
	sqlite3_stmt * selectStmt_;
	sqlite3_stmt * otherStmt_;
	COMMAND  command_;
}
@property(nonatomic,strong)NSMutableString * cmdString;
@property(nonatomic)sqlite3_stmt * selectStmt;
@property(nonatomic)sqlite3* dbConnection_;
@property(nonatomic)COMMAND  command;

- (void)loadTable;
- (void)loadTable :(NSString *)dataBasePath;
- (void)close;
- (int)open;
- (NSInteger)executeCommand;
- (void)bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt*)pStmt;
- (void)executeSelectCommand :(NSString *)sql :(NSArray *)arguments;
- (void)setupDocumentsDB;
@end
