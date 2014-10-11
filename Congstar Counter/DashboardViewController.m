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
#import "Formatter.h"

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


- (void)viewWillAppear:(BOOL)animated {
    [self update];
}


- (IBAction)reload:(id)sender {
    [[DataFetcher instance] fetchWithBlock: ^{
        [self update];
    }];
}


- (void) update {
    
    [pieChartView clearItems];

    Data *data = [Data findLast];


    if (!data) {
        lastUpdateLabel.text = @"";
        statusLabel.text = @"";
        return;
    }
    
    Formatter *formatter = [Formatter instance];
    
    float progress = progress = data.used / data.total;
    lastUpdateLabel.text = [NSString stringWithFormat:@"Last update: %@", [formatter date:data.time]];
    statusLabel.text = [NSString stringWithFormat:@"%@ MB / %@ MB",
                        [formatter megabytes:data.used],
                        [formatter megabytes:data.total]];


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
