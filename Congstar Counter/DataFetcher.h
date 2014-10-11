//
//  DataFetcher.h
//  Congstar Counter
//
//  Created by Josa Gesell on 09/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataFetcher : NSObject {
    sqlite3 *mySqliteDB;
}

+ (id)instance;
- (void) fetch;
- (void) fetchWithBlock:(void (^)(void))callback;
- (void) initDatabase;

@property (nonatomic, strong) NSString *databasePath;

@end
