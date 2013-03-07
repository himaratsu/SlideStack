//
//  SettingDefaultSortViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/05.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SettingDefaultSortViewController.h"
#import "MySettingViewController.h"

@interface SettingDefaultSortViewController ()

@end

@implementation SettingDefaultSortViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    GA_TRACK_CLASS
    
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Sorting", nil);
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
    return 3;
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
            cell.textLabel.text = NSLocalizedString(@"Latest", nil);
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"MostView", nil);
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"MostDownLoad", nil);
            break;
        default:
            break;
    }
    
    if ([cell.textLabel.text isEqualToString:[MySettingViewController sharedInstance].defaultSortDisplay]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* defaultSortDisplay;
    switch (indexPath.row) {
        case 0:
            defaultSortDisplay = NSLocalizedString(@"Latest", nil);
            break;
        case 1:
            defaultSortDisplay = NSLocalizedString(@"MostView", nil);
            break;
        case 2:
            defaultSortDisplay = NSLocalizedString(@"MostDownLoad", nil);
            break;
        default:
            break;
    }
    
    [MySettingViewController sharedInstance].defaultSortDisplay = defaultSortDisplay;
    [self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
