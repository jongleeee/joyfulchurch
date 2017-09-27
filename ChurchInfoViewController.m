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


@end

@implementation ChurchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self addNavigateToMapImage];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)addNavigateToMapImage {
    UITapGestureRecognizer *mapNavigationImageTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(navigate:)];
    [self.mapNavigationImage setUserInteractionEnabled:YES];
    [self.mapNavigationImage addGestureRecognizer:mapNavigationImageTap];
}

- (IBAction)navigate:(id)sender {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 37.695993;
    coordinate.longitude = -121.972684;
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:@"comgooglemaps://?q=JoyfulChurch&center=37.695993,-121.9726845"]];
    } else {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Joyful Church"];
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
