//
//  SermonDetailViewController.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/13/17.
//
//

#import <UIKit/UIKit.h>
#import "Sermon.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>


@interface SermonDetailViewController : UIViewController
@property (nonatomic, strong) Sermon *sermon;
@end
