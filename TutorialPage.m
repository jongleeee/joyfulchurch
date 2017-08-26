//
//  TutorialPage.m
//  MySampleApp
//
//  Created by Young Seok Lee on 8/19/17.
//
//

#import "TutorialPage.h"
#import "HomePageViewController.h"

@interface TutorialPage ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *startApp;
@property (nonatomic, strong) HomePageViewController *home;
@property (nonatomic, strong) UIPageViewController *tutorial;

@end

@implementation TutorialPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.startApp.hidden = YES;
    if ([self.imageFile isEqualToString:@"TutorialPage announcement"]){
        self.startApp.hidden = NO;
    }
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)endTutorial:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"start" object:nil];
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
