//
//  FirstViewController.m
//  Congstar Counter
//
//  Created by Josa Gesell on 09/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import "DashboardViewController.h"
#import "Data.h"

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


- (void) update {

    Data *data = [Data findLast];
    float progress = 0;

    if (data) {
        progress = data.used / data.total;
    }

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
