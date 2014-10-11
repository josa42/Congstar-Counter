//
//  DataFetcher.m
//  Congstar Counter
//
//  Created by Josa Gesell on 09/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import "DataFetcher.h"
#import "Data.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <Regexer.h>
#import "GTMNSString+HTML.h"

@implementation DataFetcher
@synthesize databasePath;

#pragma mark Singleton Methods

+ (id)instance {
    static DataFetcher *sharedDataFetcher = nil;
    @synchronized(self) {
        if (sharedDataFetcher == nil)
            sharedDataFetcher = [[self alloc] init];
    }
    return sharedDataFetcher;
}

- (id)init {
    if (self = [super init]) {
        [self initDatabase];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (void) initDatabase {



    NSString *docsDir;
    NSArray *dirPaths;

    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];

    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"data.db"]];

    [Data initDatabaseTo:databasePath];
}

- (void) handleFailure {
    // Data
}


- (float) toMB: (float)number unit:(NSString *)unit {

    if ([unit isEqualToString:@"GB"]) {
        number *= 1000;
    } else if ([unit isEqualToString:@"MB"]) {
        // number *= (1000 * 1000);
    } else if ([unit isEqualToString:@"KB"]) {
        number /= 1000;
    }

    return number;
}

- (void) extract: (NSString *) rawResponse {
    


    NSString *stripped = [[[[[rawResponse gtm_stringByUnescapingFromHTML]
                            rx_stringByReplacingMatchesOfPattern:@"<[^>]+>" withTemplate:@""]
                            rx_stringByReplacingMatchesOfPattern:@"[^a-zA-Z,:ÄäÖöÜü\\d\\.,\\?!]" withTemplate:@" "]
                            rx_stringByReplacingMatchesOfPattern:@"[ ]+" withTemplate:@" "]
                           rx_stringByReplacingMatchesOfPattern:@"(\\d),(\\d)" withTemplate:@"$1.$2"];

    NSArray *matches = [stripped rx_matchesWithPattern:@"(\\d+(.\\d+)?) ([A-Z]{2}) von (\\d+(.\\d+)?) ([A-Z]{2}) verbraucht"];
    NSArray *matches2 = [stripped rx_matchesWithPattern:@"Verbleibende Zeit:[^\\d]*(\\d+) Tage (\\d+) Std"];
    
    
    // NSLog(@"%@", matches);
    // NSLog(@"%@", matches2);
    
    if (matches.count == 0  || matches2.count == 0) {
        NSLog(@"%@", stripped);
        NSLog(@"NOT FOUND");
        return;
    }
    
    Data *data = [[Data alloc] init];

    data.used = [self toMB:[[matches[0][1] text] floatValue] unit:[matches[0][3] text]];
    data.total = [self toMB:[[matches[0][4] text] floatValue] unit:[matches[0][6] text]];
    data.daysLeft = [[matches2[0][1] text] floatValue] +  ([[matches2[0][2] text] floatValue] / 24);
    data.time = [NSDate date];

    [data save];

//    NSLog(@"Used:  %f MB", data.used);
//    NSLog(@"Total: %f MB", data.total);
//    NSLog(@"time left: %d Days", data.daysLeft);
//
//    NSLog(@"all: %@", [Data findAll]);
}

- (void) fetch {
    [self fetchWithBlock: nil];
}

- (void) fetchWithBlock:(void (^)(void))callback {
    
    
    /*
    NSString * resp = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\
    <html><head><meta name=\"viewport\" content=\"initial-scale = 1.0\" /><meta name=\"apollo-target-device\" content=\"iPhone\" /><meta name=\"apollo-page-id\" content=\"home\" /><meta name=\"language\" content=\"de\" /><title>Datennutzung - Datennutzung innerhalb Deutschlands</title><link rel=\"stylesheet\" type=\"text/css\" href=\"/styles/phone$4$CONG.css\" /><script type=\"text/javascript\" src=\"/scripts/phone.js\"></script></head><body class=\"speed\" onload=\"init();\"><div id=\"screenHeaderBar\"> </div><div id=\"page_home\" class=\"container\"><a id=\"lnkHome\" name=\"lnkHome\" href=\"/home;jsessionid=15C62501053D26F1C84C88C8503F5A31\" class=\"logoLink\"><div id=\"logoBar\"><div id=\"logoLeft\"> </div><div id=\"logoRight\">Datennutzung</div></div></a><div id=\"titleBar\"><h2 id=\"pageTitle\" class=\"title\">Datennutzung innerhalb Deutschlands</h2><div class=\"hr\"><hr /></div></div><div id=\"content\" class=\"pageContent\"><div class=\"passStatus\"><div class=\"progress emphasized\"><div class=\"barTextAbove color_default\"></div><div class=\"progressBar\"><div class=\"indicator color_default\" style=\"width:16%\"> </div></div><div class=\"barTextBelow color_default\"><span class=\"colored\">490,93 MB</span> von 3 GB verbraucht</div></div><table class=\"frame\"><tr class=\"infoLine\"><td><table><tr><td class=\"infoLabel billingPeriod\">Abrechnungsmonat:</td><td class=\"infoValue billingPeriod\">Oktober 2014</td></tr></table></td></tr><tr class=\"infoLine\"><td><table><tr><td class=\"infoLabel remainingTime\">Verbleibende Zeit:</td><td class=\"infoValue remainingTime\"><span class=\"value\">22</span> Tage <span class=\"value\">0</span> Std.</td></tr></table></td></tr><tr class=\"infoLine\"><td><table><tr><td class=\"infoLabel totalVolume\">Datennutzung:</td><td class=\"infoValue totalVolume\">Unbegrenzt</td></tr></table></td></tr><tr class=\"infoLine\"><td><table><tr><td class=\"infoLabel maxBandwidth\">Download-Geschwindigkeit:</td><td class=\"infoValue maxBandwidth\">max. 7,2 Mbit/s</td></tr></table></td></tr></table></div><div class=\"infoBox exhaustionInfo\">Wenn Sie 3 GB im laufenden Monat verbraucht haben, reduziert sich Ihre Surf-Geschwindigkeit.</div><p>Die angezeigten Informationen sind zeitverzögert und können vom tatsächlichen Verbrauch abweichen.<br/>Letzte Aktualisierung: 10.10.2014 um 00:01 Uhr (MEZ/MESZ)</p><p></p><div><p class=\"bookmark\">Tipp: Richten Sie sich ein Lesezeichen für diese Seite ein!</p></div></div><div id=\"footer\"><p id=\"customerCare\" class=\"customerCare\">Bei Rückfragen wenden Sie sich bitte an Ihren Kundenservice:<br/>01806&#160;324&#160;444&#160; (20 Cent pro Verbindung aus dem Festnetz; aus dem Mobilfunknetz 60 Cent pro Verbindung)</p><p id=\"costInfo\" class=\"costInfo\">Diese Seite ist für Sie kostenfrei.</p><div id=\"links\"><p><a href=\"/history/domestic;jsessionid=15C62501053D26F1C84C88C8503F5A31\">Buchungen</a> | <a href=\"/imprint;jsessionid=15C62501053D26F1C84C88C8503F5A31\">Impressum</a></p></div></div></div><div id=\"overlay\" class=\"hidden\"> </div><div id=\"popup\" class=\"hidden\"><div class=\"loading\"> </div></div></body></html>";

    // 490,93 MB von 3 GB
    [self extract:resp];

    if (callback != nil) {
        callback();
     }
     */


    

    NSString *userAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) CriOS/38.0.2125.59 Mobile/12A365 ";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];


    [manager GET:@"http://pass.telekom.de"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self extract:[operation responseString]];
             if (callback != nil) callback();
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             if (callback != nil) callback();
         }];
}

/*
 http://stackoverflow.com/questions/7946699/iphone-data-usage-tracking-monitoring
- (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived], nil];
}
*/

@end
