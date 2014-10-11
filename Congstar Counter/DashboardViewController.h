//
//  FirstViewController.h
//  Congstar Counter
//
//  Created by Josa Gesell on 09/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"

@interface DashboardViewController : UIViewController {
    
    IBOutlet PieChartView* pieChartView;
    IBOutlet UILabel *lastUpdateLabel;
    IBOutlet UILabel *statusLabel;
}



- (IBAction)reload:(id)sender;


@end

