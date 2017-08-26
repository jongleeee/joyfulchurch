//
//  HomePageViewController.h
//  MySampleApp
//
//  Created by Dongeui  on 6/10/17.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TutorialPageViewController.h"

@interface HomePageViewController : UIViewController <UIPageViewControllerDataSource> {
    User *user;
}

@end
