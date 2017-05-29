//
//  AnnouncementDetailViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/14/17.
//
//

#import "AnnouncementDetailViewController.h"

@interface AnnouncementDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;
@end

@implementation AnnouncementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [self.announcement getCategory];
    
    self.titleLabel.text = [self.announcement getTitle];
    self.dateLabel.text = [self.announcement getDateInString];
    self.contentLabel.text = [self.announcement getContent];
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel sizeToFit];
    [self.dateLabel sizeToFit];
    [self.contentLabel sizeToFit];
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
