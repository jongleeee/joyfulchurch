//
//  AnnouncementSubscribeTableViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/25/17.
//
//

#import "AnnouncementSubscribeTableViewController.h"
#import "NotificationChannelHandler.h"
#import "NotificationChannels.h"

@interface AnnouncementSubscribeTableViewController () {
    NSArray *categories;
    NSArray *channelsForPushNotification;
    NSMutableArray *selected;
}

@end

@implementation AnnouncementSubscribeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    user = [User sharedManager];
    
    self.navigationItem.title = @"Subscribe";
    categories = [[NSArray alloc] initWithObjects:@"General", @"Mission", @"카이로스", @"카리스마", nil];
    
    selected = [[NSMutableArray alloc] initWithArray:[user getSubscribedChannels]];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarStyleDefault target:self action:@selector(updateSubscribe:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateSubscribe:(id)sender {
    [user updateSubscribedChannels:selected];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAnnouncements" object:nil];
    [self saveSubscribedChannels];
    
}

- (NSString *)getChannelName:(NSString *)channel {
    
    if ([channel isEqualToString:@"카리스마"]) {
        return @"Karisma";
    }
    
    if ([channel isEqualToString:@"카이로스"]) {
        return @"Kairos";
    }
    
    return channel;
}

- (void)saveSubscribedChannels {
    
    dispatch_group_t group = dispatch_group_create();
    
    NotificationChannelHandler *notificationHandler = [[NotificationChannelHandler alloc] init];
    
        NSString *deviceToken = @"aa";
    
    
    
    for (NSString *category in categories) {
    
        dispatch_group_enter(group);
        
        [notificationHandler removeForDevice:deviceToken andChannel:[self getChannelName:category] completionHandler:^(NSError *error) {
            if (!error) {
                if ([selected containsObject:category]) {
                    
                    NotificationChannels *notificationChannel = [NotificationChannels new];
                    notificationChannel._channel = [self getChannelName:category];
                    notificationChannel._deviceToken = deviceToken;
                    
                    [notificationHandler save:notificationChannel completionHandler:^(NSError *error) {
                        
                        dispatch_group_leave(group);
                        
                        if (error) {
                            [self displayAlertWithTitle:@"Oops" andContext:@"Server Error. Please contact administrators"];
                        } else {
                            NSLog(@"Succesful for : %@", notificationChannel._channel);
                        }
                        
                    }];
   
                } else {
                
                    dispatch_group_leave(group);
                    
                }
            
            } else {
                dispatch_group_leave(group);
                [self displayAlertWithTitle:@"Oops" andContext:@"Server Error. Please contact administrators"];
            }
        }];
    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });

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
