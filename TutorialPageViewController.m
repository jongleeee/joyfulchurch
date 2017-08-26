//
//  TutorialPageViewController.m
//  MySampleApp
//
//  Created by Young Seok Lee on 8/19/17.
//
//

#import "TutorialPageViewController.h"

@interface TutorialPageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation TutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.closeButton.hidden = YES;
    
    if ([self.imageFile isEqualToString:@"AnnouncementTutorial"]){
        self.closeButton.hidden = NO;
    }

    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
}


- (IBAction)endTutorial:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endTutorial" object:nil];
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
