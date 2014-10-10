//
//  Data.h
//  Congstar Counter
//
//  Created by Josa Gesell on 10/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class FMDatabase;

@interface Data : NSObject {
    // sqlite3 *mySqliteDB;
}

@property (nonatomic) NSInteger ID;
@property (nonatomic) double used;
@property (nonatomic) double total;
@property (nonatomic) NSInteger daysLeft;
@property (nonatomic, strong) NSDate *time;

+ (BOOL) initDatabaseTo: (NSString*)databasePath;
+ (FMDatabase *) database;
+ (NSArray *) findAll;
+ (Data *) findLast;
- (BOOL) save;

@end
