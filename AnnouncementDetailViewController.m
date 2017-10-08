//
//  AnnouncementDetailViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/14/17.
//
//

#import "AnnouncementDetailViewController.h"

@interface AnnouncementDetailViewController () 
@property (weak, nonatomic) IBOutlet UIView *announcementInfo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;
@end

@implementation AnnouncementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [self.announcement getCategory];
    
    self.titleLabel.text = [self.announcement getTitle];
    self.dateLabel.text = [self.announcement getDay];
    self.monthLabel.text = [self.announcement getMonth];
    self.yearLabel.text = [self.announcement getYear];
    self.categoryLabel.text = [self.announcement getCategory];
    self.contentLabel.text = [self.announcement getContent];
    
    UIColor *color = [self getColorForCategory:[self.announcement getCategory]];
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    self.monthLabel.adjustsFontSizeToFitWidth = YES;
    self.yearLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel sizeToFit];
    [self.dateLabel sizeToFit];
    [self.contentLabel sizeToFit];
    [self.monthLabel sizeToFit];
    [self.yearLabel sizeToFit];
    [self.categoryLabel sizeToFit];
    
    [self addBottomBorder];
    
    UIImage *img = [UIImage imageNamed:@"WhiteBanner"];
    self.categoryImage.image = img;
    self.categoryImage.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.categoryImage.tintColor = color;
}

- (void)viewDidLayoutSubviews {
    [self.contentLabel setContentOffset:CGPointZero animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBottomBorder {
    CALayer *upperBorder = [CALayer layer];
    UIColor *color = [UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:47.0f/255.0f alpha:1.0f];
    upperBorder.backgroundColor = [color CGColor];
    upperBorder.frame = CGRectMake(0, CGRectGetHeight(self.announcementInfo.frame) - 1.0f, CGRectGetWidth(self.announcementInfo.frame), 1.0f);
    [self.announcementInfo.layer addSublayer:upperBorder];

}

- (UIColor *)getColorForCategory:(NSString *) category {
    return [Utils getColorForChannel:category];
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
