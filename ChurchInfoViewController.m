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


@end

@implementation ChurchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"ChurchInfo.jpg"] scaledToSize:self.view.frame.size]];

    /*
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 7;
    [self.infoImageView setUserInteractionEnabled:YES];
    [self.infoImageView addGestureRecognizer:singleTap];
     */
    
    
}


-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)navigate:(id)sender {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 37.695993;
    coordinate.longitude = -121.972684;
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:@"Joyful Church"];
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [mapItem openInMapsWithLaunchOptions:options];
    
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
