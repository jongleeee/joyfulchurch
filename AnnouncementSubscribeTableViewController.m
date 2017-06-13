//
//  AnnouncementSubscribeTableViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/25/17.
//
//

#import "AnnouncementSubscribeTableViewController.h"
#import "PushNotification.h"

@interface AnnouncementSubscribeTableViewController () {
    NSArray *categories;
    NSArray *channelsForPushNotification;
    NSMutableArray *selected;
    PushNotification *pushNotification;
}

@end

@implementation AnnouncementSubscribeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    user = [User sharedManager];
    
    self.navigationItem.title = @"Subscribe";
    categories = [[NSArray alloc] initWithObjects:@"General", @"Mission", @"카이로스", @"카리스마", @"설교", nil];
    
    selected = [[NSMutableArray alloc] initWithArray:[user getSubscribedChannels]];
    
    pushNotification =  [user getPushNotification];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(updateSubscribe:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateSubscribe:(id)sender {
    [user updateSubscribedChannels:selected];
    [self saveSubscribedChannels];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAnnouncements" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveSubscribedChannels {
    [pushNotification subscribeToTopics:selected];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"announcementSubscribeCell" forIndexPath:indexPath];
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    
    if ([selected containsObject:[categories objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if ([selected containsObject:[categories objectAtIndex:indexPath.row]]) {
        [selected removeObject:[categories objectAtIndex:indexPath.row]];
    } else {
        [selected addObject:[categories objectAtIndex:indexPath.row]];
    }
    [self.tableView reloadData];
}

- (void)displayAlertWithTitle:(NSString *)title andContext:(NSString *)context {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill all the informations" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
