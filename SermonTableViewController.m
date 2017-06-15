//
//  SermonTableViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/13/17.
//
//
#import <MediaPlayer/MediaPlayer.h>
#import "SermonTableViewController.h"
#import "User.h"
#import "Utils.h"

@interface SermonTableViewController () {
    NSMutableArray *sermons;
    User *user;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addSermonButton;

@end

@implementation SermonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [User sharedManager];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestSermons)
                  forControlEvents:UIControlEventValueChanged];
    [self getLatestSermons];
}


- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
    
    if (![user isAuthorizedFor:@"Sermon"]) {
        self.addSermonButton.enabled = false;
    } else {
        self.addSermonButton.enabled = true;
    }
}

- (void)getLatestSermons {
    SermonHandler *sermonHandler = [[SermonHandler alloc] init];
    [sermonHandler getAllSermons:^(NSArray<Sermon *> *items) {
        sermons = [Utils orderByDate:items];
        [self reloadSermons];
    }];
}

- (void)reloadSermons {
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor lightGrayColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (sermons) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
        return 1;
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No sermon is currently available. \n Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"System" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sermons count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SermonTableViewCell *cell = (SermonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SermonTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SermonTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Sermon *sermon = [sermons objectAtIndex:indexPath.row];
    
    cell.title.text = [sermon getTitle];
    cell.title.adjustsFontSizeToFitWidth = YES;
    [cell.title sizeToFit];
    
    cell.subtitle.text = [sermon getVerse];
    [cell.subtitle sizeToFit];
    
    cell.date.text = [sermon getDateInString];
    [cell.date sizeToFit];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.date.layer.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(6.0, 6.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cell.date.layer.bounds;
    maskLayer.path  = maskPath.CGPath;
    cell.date.layer.masksToBounds = YES;
    cell.date.layer.mask = maskLayer;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Sermon *sermon = [sermons objectAtIndex:indexPath.row];
    NSString *url = [sermon getSermon];
    
    if ([url isEqualToString:@" "]) {
        url = @"2mD7KMJ";
    }
    
    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc]initWithContentURL: [NSURL URLWithString: [NSString stringWithFormat:@"https://bit.ly/%@", url]]];
    [controller.moviePlayer prepareToPlay];
    [controller.moviePlayer play];
    
    [self.navigationController presentMoviePlayerViewControllerAnimated:controller];
    
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SermonDetailStoryboard" bundle:nil];
    SermonDetailViewController *sermonDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"SermonDetailStoryboard"];
    sermonDetailViewController.sermon = [sermons objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:sermonDetailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (IBAction)addSermonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SermonAddStoryboard" bundle:nil];
    SermonAddViewController *sermonAddViewController = [storyboard instantiateViewControllerWithIdentifier:@"SermonAddStoryboard"];
    [self.navigationController pushViewController:sermonAddViewController animated:YES];
}

@end
