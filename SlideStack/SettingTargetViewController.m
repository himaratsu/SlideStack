//
//  SettingTargetViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/28.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SettingTargetViewController.h"
#import "MySettingViewController.h"

@interface SettingTargetViewController ()

@end

@implementation SettingTargetViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"検索対象";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"タイトル+本文";
            break;
        case 1:
            cell.textLabel.text = @"タグ";
            break;
        default:
            break;
    }
    
    if ([cell.textLabel.text isEqualToString:[MySettingViewController sharedInstance].targetDisplay]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* targetStr;
    switch (indexPath.row) {
        case 0:
            targetStr = @"タイトル+本文";
            break;
        case 1:
            targetStr = @"タグ";
            break;
        default:
            break;
    }
    
    [MySettingViewController sharedInstance].targetDisplay = targetStr;
    [self.tableView reloadData];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
