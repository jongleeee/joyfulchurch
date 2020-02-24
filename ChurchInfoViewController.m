//
//  ChurchInfoViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/25/17.
//
//

#import "ChurchInfoViewController.h"
#import <MapKit/MapKit.h>

@interface ChurchInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mapNavigationImage;
@property (weak, nonatomic) IBOutlet UITextView *churchInformation;


@end

@implementation ChurchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self addNavigateToMapImage];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLayoutSubviews {
    [self.churchInformation setContentOffset:CGPointZero animated:NO];
}

//- (void)addNavigateToMapImage {
//    UITapGestureRecognizer *mapNavigationImageTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(navigate:)];
//    [self.mapNavigationImage setUserInteractionEnabled:YES];
//    [self.mapNavigationImage addGestureRecognizer:mapNavigationImageTap];
//}

- (IBAction)navigateToWeekendService:(id)sender {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 37.768545;
    coordinate.longitude = -121.909712;
    NSString *url = @"comgooglemapsurl://maps.google.com/maps?f=d&daddr=Joyful+Church+Weekend+Service&sll=37.768545,-121.909712&sspn=0.2,0.1&nav=1";
    [self openMapWithName:@"Joyful Church Weekend Service" andUrl:url OrCoordinate:coordinate];
}
- (IBAction)navigateToWeekdayService:(id)sender {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 37.7759229;
    coordinate.longitude = -121.9693361;
    NSString *url = @"comgooglemapsurl://maps.google.com/maps?f=d&daddr=Joyful+Church+Weekday+Service&sll=37.7759229,-121.9693361&sspn=0.2,0.1&nav=1";
    [self openMapWithName:@"Joyful Church Weekday Service" andUrl:url OrCoordinate:coordinate];
}

- (void)openMapWithName:(NSString *)name andUrl:(NSString *)url OrCoordinate:(CLLocationCoordinate2D)coordinate {
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:url]];
    } else {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:name];
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        [mapItem openInMapsWithLaunchOptions:options];
    }
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
