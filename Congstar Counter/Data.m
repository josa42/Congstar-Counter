//
//  Data.m
//  Congstar Counter
//
//  Created by Josa Gesell on 10/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import "Data.h"
#import <FMDatabase.h>

static NSString *databasePath = nil;

@implementation Data
@synthesize ID, used, total, daysLeft, time;

+ (BOOL) initDatabaseTo: (NSString*)_databasePath {

    databasePath = _databasePath;

    NSLog(@"databasePath: %@", databasePath);

    FMDatabase *db = [Data database];
    if (!db) return NO;

    if (![db executeUpdate:@"CREATE TABLE IF NOT EXISTS data (ID INTEGER PRIMARY KEY AUTOINCREMENT, used REAL, total REAL, days_left INTEGER, timestamp INTEGER)"]) {
        NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
        return NO;
    }

    [db close];

    return YES;
}

+ (NSArray *) findAll {
    FMDatabase *db = [Data database];
    if (!db) return nil;

    NSMutableArray *all = [NSMutableArray array];

    FMResultSet *result = [db executeQuery:@"SELECT * FROM data"];
    while ([result next]) {
        Data *data = [[Data alloc] init];
        data.ID = [result doubleForColumn:@"ID"];
        data.used = [result doubleForColumn:@"used"];
        data.total = [result doubleForColumn:@"total"];
        data.daysLeft = [result intForColumn:@"days_left"];
        data.time = [NSDate dateWithTimeIntervalSince1970:[result doubleForColumn:@"timestamp"]];

        [all addObject:data];
    }
    return all;
}

+ (Data *) findLast {
    FMDatabase *db = [Data database];
    if (!db) return nil;

    FMResultSet *result = [db executeQuery:@"SELECT * FROM data ORDER BY ID DESC LIMIT 1"];
    while ([result next]) {
        Data *data = [[Data alloc] init];
        data.ID = [result doubleForColumn:@"ID"];
        data.used = [result doubleForColumn:@"used"];
        data.total = [result doubleForColumn:@"total"];
        data.daysLeft = [result intForColumn:@"days_left"];
        data.time = [NSDate dateWithTimeIntervalSince1970:[result doubleForColumn:@"timestamp"]];

        return data;
    }
    return nil;
}

+ (FMDatabase *) database {
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];

    if ([db open]) {
        return db;
    }

    return nil;
}

- (BOOL) save
{
    BOOL success = false;
    FMDatabase *db = [Data database];

    if (!db) return NO;

    if (!ID) {
        success = [db executeUpdate:@"INSERT INTO data (used, total, days_left, timestamp) VALUES(?, ?, ?, ?)",
                   [NSNumber numberWithDouble:used],
                   [NSNumber numberWithDouble:total],
                   [NSNumber numberWithInt:total],
                   [NSNumber numberWithInt:daysLeft],
                   [NSNumber numberWithDouble:[time timeIntervalSince1970]]];
    } else {
        success = [db executeUpdate:@"UPDATE data SET used = ?, total = ?, days_left = ?, timestamp = ? WHERE id = ?",
                    [NSNumber numberWithDouble:used],
                    [NSNumber numberWithDouble:total],
                    [NSNumber numberWithInt:total],
                    [NSNumber numberWithInt:daysLeft],
                    [NSNumber numberWithDouble:[time timeIntervalSince1970]],
                    [NSNumber numberWithInt:ID]];
    }

    if (!success) {
        NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }

    [db close];

    return success;
}

@end
