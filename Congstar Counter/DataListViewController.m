//
//  SecondViewController.m
//  Congstar Counter
//
//  Created by Josa Gesell on 09/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import "DataListViewController.h"
#import "Data.h"

@interface DataListViewController ()

@end

@implementation DataListViewController
{
    NSArray *recipes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    recipes = [Data findAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%f / %f",
        ((Data *)[recipes objectAtIndex:indexPath.row]).used,
        ((Data *)[recipes objectAtIndex:indexPath.row]).total
    ];
    return cell;
}

@end
