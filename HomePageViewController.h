//
//  HomePageViewController.h
//  MySampleApp
//
//  Created by Dongeui  on 6/10/17.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TutorialPage.h"

@interface HomePageViewController : UIViewController <UIPageViewControllerDataSource> {
    User *user;
}

- (void)endPageTutorial;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;



@end
