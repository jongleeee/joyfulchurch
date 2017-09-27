//
//  SermonAddViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/17/17.
//
//

#import "SermonAddViewController.h"
#import "PushNotification.h"

@interface SermonAddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sermonTitle;
@property (weak, nonatomic) IBOutlet UITextField *sermonVerse;
@property (weak, nonatomic) IBOutlet UITextField *sermonURL;
@property (weak, nonatomic) IBOutlet UIDatePicker *sermonDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *sermonSeries;
@property (nonatomic, strong) NSDate *sermonDate;
@property (nonatomic, strong) PushNotification *notificationHandler;
@end

@implementation SermonAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    user = [User sharedManager];
    self.notificationHandler = [user getPushNotification];
    self.sermonDate = [NSDate date];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.sermonTitle resignFirstResponder];
    [self.sermonVerse resignFirstResponder];
    [self.sermonURL resignFirstResponder];
    [self.sermonSeries resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)selectSermonDate:(id)sender {
    NSDate *pickerDate = [self.sermonDatePicker date];
    self.sermonDate = pickerDate;
}

- (IBAction)save:(id)sender {
    if (self.sermonTitle.text.length == 0 || self.sermonVerse.text.length == 0 || self.sermonURL.text.length == 0 || self.sermonSeries.text.length == 0) {
        [self displayAlertWithTitle:@"Error" andContext:@"Please fill all the information"];
    } else {
        Sermons *sermon = [Sermons new];
        sermon._title = self.sermonTitle.text;
        sermon._verse = self.sermonVerse.text;
        sermon._sermon = self.sermonURL.text;
        sermon._series = self.sermonSeries.text;
        
        NSTimeInterval timeStamp = [self.sermonDate timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        
        sermon._creationDate = timeStampObj;
        
        SermonHandler *sermonHandler = [[SermonHandler alloc] init];
        [sermonHandler save:sermon completionHandler:^(NSError *error) {
            if (error) {
                [self displayAlertWithTitle:@"Error" andContext:@"Could not save at this time. Please try again later"];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSermons" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }}];
    }
}

- (void)displayAlertWithTitle:(NSString *)title andContext:(NSString *)context {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:context preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
