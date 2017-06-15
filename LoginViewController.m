//
//  LoginViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/25/17.
//
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController () {
    User *user;
}
@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user = [User sharedManager];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)passwordChanged:(id)sender {
    if ([self.password.text isEqualToString:@"joyfulAdmin"]) {
        [self addPermission:@"Announcement"];
        [self addPermission:@"Sermon"];
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.password.text isEqualToString:@"광고"]) {
        [self addPermission:@"Announcement"];
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.password.text isEqualToString:@"설교"]) {
        [self addPermission:@"Sermon"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
         
 - (void)addPermission:(NSString *)feature {
     [user updatePermission:feature];
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
