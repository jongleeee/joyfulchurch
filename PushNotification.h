//
//  PushNotification.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 4/5/17.
//
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface PushNotification : NSObject {}
- (void)subscribeToTopics:(NSArray *)selectedChannels;
- (void)sendNotificationToChannel:(NSString *)channel withMessage:(NSDictionary *)message;
@end
