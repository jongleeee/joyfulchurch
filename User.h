//
//  User.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/25/17.
//
//
#import <Foundation/Foundation.h>
#import "PushNotification.h"
#import <UIKit/UIKit.h>

@interface User : NSObject {}

+ (id)sharedManager;

- (BOOL)isAuthorizedFor:(NSString *)feature;
- (NSString *)getDeviceToken;
- (NSArray *)getSubscribedChannels;
- (void)updatePermission:(NSString *)feature;

- (void)updateSubscribedChannels:(NSArray *)channels;

- (PushNotification *)getPushNotification;
@end
