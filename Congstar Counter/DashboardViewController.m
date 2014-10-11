//
//  FirstViewController.m
//  Congstar Counter
//
//  Created by Josa Gesell on 09/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import "DashboardViewController.h"
#import "Data.h"
#import "DataFetcher.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [pieChartView setGradientFillStart:0.3 andEnd:1.0];

    [pieChartView setHidden:NO];
    [pieChartView setNeedsDisplay];

    [self update];
}


- (IBAction)reload:(id)sender {
    NSLog(@"Reload");
    [[DataFetcher instance] fetch];
    [self update];
}


- (void) update {

    Data *data = [Data findLast];

    if (!data) return;
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    ;
    
    float progress = progress = data.used / data.total;
    lastUpdateLabel.text = [NSString stringWithFormat:@"Last update: %@", data.time];
    statusLabel.text = [NSString stringWithFormat:@"%@ MB / %@ MB",
                        [formatter stringFromNumber:[NSNumber numberWithFloat:data.used]],
                        [formatter stringFromNumber:[NSNumber numberWithFloat:data.total]]];

    NSLog(@"progress: %f / %f = %f", (float)data.used, (float)data.total, (data.used / data.total));

    [pieChartView clearItems];

    [pieChartView addItemValue:1 - progress withColor:PieChartItemColorMake(1.0, 1.0, 1.0, 0.0)];
    [pieChartView addItemValue:progress withColor:PieChartItemColorMake(0.0, 0.0, 0.0, 0.6)];

    [pieChartView setHidden:NO];
    [pieChartView setNeedsDisplay];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
