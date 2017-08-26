//
//  TutorialPage.h
//  MySampleApp
//
//  Created by Young Seok Lee on 8/19/17.
//
//

#import <UIKit/UIKit.h>

@interface TutorialPage : UIViewController

- (IBAction)endTutorial:(id)sender;

@property NSUInteger pageIndex;
@property NSString *imageFile;

@end
