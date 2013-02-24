//
//  SelectTagViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SelectTagViewController.h"
#import "SlideListTableViewController.h"
#import "IIViewDeckController.h"
#import "TagManageTableViewController.h"
#import "TagManager.h"
#import "TagWithCheckMarkObject.h"

@interface SelectTagViewController ()

@end

@implementation SelectTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(150, 0, 270, 568)
                                                          style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload {
    self.dataArray = [[TagManager sharedInstance] checkedTagArray];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_dataArray count];
    }
    else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"タグを選ぶ";
        case 1:
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        TagWithCheckMarkObject *tag = [_dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = tag.tagName;
    }
    else {
        cell.textLabel.text = @"＜タグの追加＞";
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *centerNav = ((UINavigationController*)self.viewDeckController.centerController);
    if ([centerNav isKindOfClass:[SlideListTableViewController class]] == NO) {
        [centerNav popToRootViewControllerAnimated:NO];
    }
    SlideListTableViewController *slideListTableVC = ((SlideListTableViewController*)centerNav.topViewController);
    
    if (indexPath.section == 0) {
        TagWithCheckMarkObject *tag = [_dataArray objectAtIndex:indexPath.row];
        slideListTableVC.searchWord = tag.tagName;
        
        [self.viewDeckController closeOpenView];
    }
    else {
        TagManageTableViewController *tagManageTableVC = [[TagManageTableViewController alloc] initWithNibName:@"TagManageTableViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tagManageTableVC];
        [self presentViewController:navController animated:YES completion:nil];
    }
    
}


@end
