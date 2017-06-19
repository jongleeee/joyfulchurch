//
//  AnnouncementAddViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/17/17.
//
//

#import "AnnouncementAddViewController.h"
#import <AWSLambda/AWSLambda.h>
#import "AWSConfiguration.h"
#import "PushNotification.h"

@interface AnnouncementAddViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *announcementTitle;
@property (weak, nonatomic) IBOutlet UITextView *announcementContent;
@property (weak, nonatomic) IBOutlet UIPickerView *announcementCategoryPicker;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSString *selectedCategory;
@property (strong, nonatomic) PushNotification *notificationHandler;
@end

@implementation AnnouncementAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    user = [User sharedManager];
    self.notificationHandler = [user getPushNotification];
    
    [self resizePickerView];
    
    self.announcementContent.text = @"Context";
    self.announcementContent.textColor = [UIColor lightGrayColor];
    self.announcementContent.delegate = self;
    
    self.announcementCategoryPicker.dataSource = self;
    self.announcementCategoryPicker.delegate = self;
    
    self.categories = [[NSArray alloc] initWithObjects:@"General", @"Mission", @"카리스마", @"카이로스", nil];
    self.selectedCategory = [self.categories objectAtIndex:0];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)sendNotification:(NSString *)channel {
    NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
    [message setObject:self.announcementTitle.text forKey:@"title"];
    [message setObject:self.announcementContent.text forKey:@"context"];
    
    [self.notificationHandler sendNotificationToChannel:channel withMessage:message];
}

-(void)dismissKeyboard {
    [self.announcementTitle resignFirstResponder];
    [self.announcementContent resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)resizePickerView {
    CGAffineTransform t0 = CGAffineTransformMakeTranslation( 0,
                                                            self.announcementCategoryPicker.bounds.size.height/2 );
    CGAffineTransform s0 = CGAffineTransformMakeScale(0.8, 0.8);
    CGAffineTransform t1 = CGAffineTransformMakeTranslation( 0,
                                                            self.announcementCategoryPicker.bounds.size.height/-2 );
    self.announcementCategoryPicker.transform = CGAffineTransformConcat( t0,
                                                   CGAffineTransformConcat(s0, t1) );
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.announcementContent.text isEqualToString:@"Context"]) {
        self.announcementContent.text = @"";
        self.announcementContent.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.announcementContent.text.length == 0){
        self.announcementContent.textColor = [UIColor lightGrayColor];
        self.announcementContent.text = @"Context";
        [self.announcementContent resignFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![self.announcementContent hasText]) {
        self.announcementContent.text = @"Context";
        self.announcementContent.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)saveAnnouncement:(id)sender {
    if (self.announcementTitle.text.length == 0 || self.announcementContent.text.length == 0 || [self.announcementContent.text isEqualToString:@"Context"]) {
        [self displayAlertWithTitle:@"Error" andContext:@"Please fill all the information"];
    } else {
        Announcements *announcement = [Announcements new];
        announcement._title = self.announcementTitle.text;
        announcement._content = self.announcementContent.text;
        announcement._category = self.selectedCategory;
        
        AnnouncementHandler *announcementHandler = [[AnnouncementHandler alloc] init];
        [announcementHandler save:announcement completionHandler:^(NSError *error) {
            if (error) {
                [self displayAlertWithTitle:@"Error" andContext:@"Could not save at this time. Please try again later"];
            } else {
                [self sendNotification:self.selectedCategory];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAnnouncements" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }
}

- (void)displayAlertWithTitle:(NSString *)title andContext:(NSString *)context {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill all the informations" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}
// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.categories count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.categories[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedCategory = self.categories[row];
}

@end
