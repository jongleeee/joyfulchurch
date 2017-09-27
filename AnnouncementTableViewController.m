//
//  AnnouncementTableViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/13/17.
//
//

#import "AnnouncementTableViewController.h"
#import "User.h"
#import "Utils.h"


@interface AnnouncementTableViewController () {
    NSMutableArray *announcements;
    User *user;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addAnnouncementButton;

@end

@implementation AnnouncementTableViewController

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
                            action:@selector(getLatestAnnouncements)
                  forControlEvents:UIControlEventValueChanged];
    [self getLatestAnnouncements];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:47.0f/255.0f alpha:1.0f]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAnnouncements:) name:@"updateAnnouncements" object:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    
    if (![user isAuthorizedFor:@"Announcement"]) {
        self.addAnnouncementButton.enabled = false;
    } else {
        self.addAnnouncementButton.enabled = true;
    }
}

- (void)getLatestAnnouncements {
    AnnouncementHandler *announcementHandler = [[AnnouncementHandler alloc] init];
    [announcementHandler getAnnouncements:[user getSubscribedChannels] completionHandler:^(NSArray<Announcement *> *items) {
        announcements = [Utils orderByDate:items];
        [self reloadAnnouncements];
    }];
}

- (void)reloadAnnouncements {
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
    if (announcements) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
        return 1;
        
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No announcement is currently available. \n Please pull down to refresh.";
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
    return [announcements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnnouncementTableViewCell *cell = (AnnouncementTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AnnouncementTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnnouncementTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Announcement *announcement = [announcements objectAtIndex:indexPath.row];
    
    cell.title.text = [announcement getTitle];
    [cell.title sizeToFit];
    cell.title.adjustsFontSizeToFitWidth = YES;

    cell.date.text = [announcement getDay];
    [cell.date sizeToFit];
    
    cell.month.text = [announcement getMonth];
    [cell.date sizeToFit];
    
    cell.year.text = [announcement getYear];
    [cell.date sizeToFit];
    
    UIImage *img = [UIImage imageNamed:@"WhiteBanner"];
    cell.categoryImage.image = img;
    cell.categoryImage.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.categoryImage.tintColor = [self getColorForCategory:[announcement getCategory]];

    [cell.categoryImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    cell.categoryImage.autoresizingMask = UIViewAutoresizingNone;
    cell.categoryImage.clipsToBounds = YES;

    cell.categoryLabel.text = [NSString stringWithFormat:@"%@", [announcement getCategory]];
    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AnnouncementDetailStoryboard" bundle:nil];
    AnnouncementDetailViewController *announcementDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"AnnouncementDetailStoryboard"];
    announcementDetailViewController.announcement = [announcements objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:announcementDetailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)addAnnouncementPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AnnouncementAddStoryboard" bundle:nil];
    AnnouncementAddViewController *announcementAddViewController = [storyboard instantiateViewControllerWithIdentifier:@"AnnouncementAddStoryboard"];
    [self.navigationController pushViewController:announcementAddViewController animated:YES];
}

- (IBAction)chooseAnnouncements:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AnnouncementSubscribeStoryboard" bundle:nil];
    AnnouncementSubscribeTableViewController *announcementSubscribeTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"AnnouncementSubscribeStoryboard"];
    [self.navigationController pushViewController:announcementSubscribeTableViewController animated:YES];
}


- (UIColor *)getColorForCategory:(NSString *) category {
    return [Utils getColorForChannel:category];
}

- (void)updateAnnouncements:(NSNotification *)notification {
    [self getLatestAnnouncements];
}
@end
