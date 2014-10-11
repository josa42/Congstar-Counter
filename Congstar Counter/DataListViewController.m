//
//  SecondViewController.m
//  Congstar Counter
//
//  Created by Josa Gesell on 09/10/14.
//  Copyright (c) 2014 Josa Gesell. All rights reserved.
//

#import "DataListViewController.h"
#import "Data.h"
#import "DataFetcher.h"
#import "Formatter.h"


@interface DataListViewController ()

@end

@implementation DataListViewController
{
    NSArray *dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataList = [Data findAll];
}


- (void)viewDidAppear:(BOOL)animated
{
    dataList = [Data findAll];
    [tableView reloadData];
}

- (IBAction)reload:(id)sender {
    [[DataFetcher instance] fetchWithBlock: ^{
        [[DataFetcher instance] fetch];
        dataList = [Data findAll];
        [tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Formatter *formatter = [Formatter instance];
    
    static NSString *simpleTableIdentifier = @"DataTableCell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    Data *data = ((Data *)[dataList objectAtIndex:indexPath.row]);
    cell.textLabel.text = [NSString stringWithFormat:@"%@ MB / %@ MB",
                           [formatter megabytes:data.used],
                           [formatter megabytes:data.total]];
    cell.detailTextLabel.text = [formatter  date:data.time];
    return cell;
}


- (BOOL)tableView:(UITableView *)_tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Data *data = (Data*)[dataList objectAtIndex:indexPath.row];
        [data remove];
        dataList = [Data findAll];
        [tableView reloadData];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
