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
#import "SelectTagViewCell.h"

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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(RIGHT_SIDE_BAR_WIDTH, 0, 270, 548)
                                                          style:UITableViewStylePlain];
    self.view.backgroundColor = DEFAULT_TAG_LIST_BGCOLOR;
    self.tableView.backgroundColor = DEFAULT_TAG_LIST_BGCOLOR;
    
    self.tableView.separatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.tableView.scrollsToTop = NO;
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
    self.dataArray = [NSMutableArray arrayWithArray:[[TagManager sharedInstance] checkedTagArray]];
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
            return @"タグを管理";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor = DEFAULT_TAG_LIST_TITLE_BGCOLOR;
    
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 260, 20)];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = DEFAULT_TAG_LIST_TITLE_FONTCOLOR;
    
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SelectTagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SelectTagViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        TagWithCheckMarkObject *tag = [_dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = tag.tagName;
        cell.imageView.image = [UIImage imageNamed:@"tag.png"];
    }
    else {
        cell.textLabel.text = @"＜タグの追加＞";
    }
    cell.textLabel.textColor = DEFAULT_TAG_LIST_FONTCOLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    } else {
        return NO;
    }
}



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        TagWithCheckMarkObject *deleteTag = [_dataArray objectAtIndex:indexPath.row];
        [[TagManager sharedInstance] updateCheckMarkState:deleteTag.tagName isCheck:NO];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


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
    
    if (indexPath.section == 0) {
        UINavigationController *centerNav = ((UINavigationController*)self.viewDeckController.centerController);
        if ([centerNav isKindOfClass:[SlideListTableViewController class]] == NO) {
            [centerNav popToRootViewControllerAnimated:NO];
        }
        SlideListTableViewController *slideListTableVC = ((SlideListTableViewController*)centerNav.topViewController);
        
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
