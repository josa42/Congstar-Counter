//
//  Formatter.m
//  Congstar Counter
//
//  Created by Josa Gesell on 11/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import "Formatter.h"

@implementation Formatter
#pragma mark Singleton Methods

+ (Formatter *)instance {
    static Formatter *sharedFormatter = nil;
    @synchronized(self) {
        if (sharedFormatter == nil)
            sharedFormatter = [[self alloc] init];
    }
    return sharedFormatter;
}

- (id)init {
    if (self = [super init]) {
        
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        
        megabytesFormatter = [[NSNumberFormatter alloc] init];
        [megabytesFormatter setMaximumFractionDigits:1];
        [megabytesFormatter setRoundingMode: NSNumberFormatterRoundDown];
    
    }
    return self;
}

- (NSString *)date: (NSDate *) date {
    return [dateFormatter stringFromDate:date];
}

- (NSString *)megabytes: (double)megabytes {
    return [megabytesFormatter stringFromNumber:[NSNumber numberWithFloat:megabytes]];
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
