//
//  Formatter.h
//  Congstar Counter
//
//  Created by Josa Gesell on 11/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Formatter : NSObject {
    NSDateFormatter *dateFormatter;
    NSNumberFormatter *megabytesFormatter;
}

+ (Formatter *)instance;

- (NSString *)date: (NSDate *) date;
- (NSString *)megabytes: (double)megabytes;

@end
