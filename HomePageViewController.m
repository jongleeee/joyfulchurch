//
//  HomePageViewController.m
//  MySampleApp
//
//  Created by Dongeui  on 6/10/17.
//
//

#import "HomePageViewController.h"
#import "ChurchInfoViewController.h"
#import "SermonTableViewController.h"
#import "AnnouncementTableViewController.h"
#import "LoginViewController.h"


@interface HomePageViewController ()

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *announcementView;
@property (weak, nonatomic) IBOutlet UIView *sermonView;
@property (weak, nonatomic) IBOutlet UIImageView *topView;

@property (weak, nonatomic) IBOutlet UILabel *sermonLabel;
@property (weak, nonatomic) IBOutlet UILabel *announcementLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *joyfulLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;


@end

@implementation HomePageViewController

//NSInteger toggleNumberForNavBar = 0;

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *topTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapDetected)];
    topTap.numberOfTapsRequired = 7;
    
    // In order to interact into UIImageView, this function should be called
    [self.topView setUserInteractionEnabled:YES];
    [self.topView addGestureRecognizer:topTap];
    
    self.sermonLabel.font = [UIFont fontWithName:@"System" size:20];
    [self.sermonLabel sizeToFit];
    self.infoLabel.font = [UIFont fontWithName:@"System" size:20];
    [self.infoLabel sizeToFit];
    self.announcementLabel.font = [UIFont fontWithName:@"System" size:20];
    [self.announcementLabel sizeToFit];
    
//    self.welcomeLabel.font = [UIFont fontWithName:@"System" size:20];
//    [self.welcomeLabel sizeToFit];
//    
//    self.joyfulLabel.font = [UIFont fontWithName:@"System" size:50];
//    [self.joyfulLabel sizeToFit];
    
    
    UITapGestureRecognizer *infoTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleInfoTap:)];
    [self.infoView addGestureRecognizer:infoTap];
    
    

    
    
    
    UITapGestureRecognizer *sermonTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSermonTap:)];
    [self.sermonView addGestureRecognizer:sermonTap];
    

    
    
    UITapGestureRecognizer *announcementTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleAnnouncementTap:)];
    [self.announcementView addGestureRecognizer:announcementTap];
}

-(void)tapDetected {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

-(void)handleInfoTap:(UITapGestureRecognizer*)recognizer {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChurchInfo" bundle:nil];
    ChurchInfoViewController *churchInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChurchInfoStoryboard"];
    [self.navigationController pushViewController:churchInfoViewController animated:YES];
}

-(void)handleSermonTap:(UITapGestureRecognizer*)recognizer {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sermon" bundle:nil];
    SermonTableViewController *sermonViewController = [storyboard instantiateViewControllerWithIdentifier:@"SermonTableStoryboard"];
    [self.navigationController pushViewController:sermonViewController animated:YES];
}

-(void)handleAnnouncementTap:(UITapGestureRecognizer*)recognizer {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    AnnouncementTableViewController *announcementViewController = [storyboard instantiateViewControllerWithIdentifier:@"AnnouncementStoryBoard"];
    [self.navigationController pushViewController:announcementViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if(!self.navigationController.navigationBar.isHidden) {
        self.navigationController.navigationBar.hidden = YES;
    } else {
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
