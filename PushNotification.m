    //
//  PushNotification.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 4/5/17.
//
//

#import "PushNotification.h"
#import <AWSMobileHubHelper/AWSMobileHubHelper.h>
#import "AWSConfiguration.h"
#import "NotificationChannelHandler.h"
#import "NotificationChannels.h"

@interface PushNotification() <AWSPushManagerDelegate, AWSPushTopicDelegate>

@property (nonatomic, strong) AWSPushManager *pushManager;
@property (nonatomic, strong) NSArray *notificationChannels;

@end

@implementation PushNotification

- (PushNotification *)init {
    NSString *ServiceKey = @"Devo";
//    NSString *ServiceKey = @"Prod";
    
    if (self = [super init]) {
        self.pushManager = [AWSPushManager PushManagerForKey:ServiceKey];
        self.pushManager.delegate = self;
        [self.pushManager registerForPushNotifications];
        [self.pushManager registerTopicARNs:self.pushManager.topicARNs];
    }

    
    return self;
}

- (void)updateChannels:(NSArray *)channels completionHandler:(void (^)(NSError *error))completionHandler {
    NSArray *selectedTopics = [self getTopics:channels];
    
    // delete all
//    NotificationChannelHandler *notificationHandler = [[NotificationChannelHandler alloc] init];
//    [notificationHandler removeAllForDevice:@"" completionHandler:^(NSError *error) {
//        if (!error) {
//            
//             // add all
//            for (NSString *topic in selectedTopics) {
//                NotificationChannels *notificationChannel = [NotificationChannels new];
//                notificationChannel._channel = topic;
//                notificationChannel._deviceToken = @"";
//                
//                [notificationHandler save:notificationChannel completionHandler:^(NSError *error) {
//                    if (!error) {
//                        
//                    }
//                }];
//            }
//        }
//    }];
}

- (NSArray *)getTopics:(NSArray *)selectedChannels {
    NSMutableArray *topics = [[NSMutableArray alloc] initWithObjects:[self.pushManager.topics firstObject], nil];
    selectedChannels = [self convertToNotificationChannels:selectedChannels];
    
    for (NSString *topicName in selectedChannels) {
        for (AWSPushTopic *awsTopic in self.pushManager.topics) {
            NSRange range = [awsTopic.topicName rangeOfString:topicName options: NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [topics addObject:awsTopic];
            }
        }
    }
    
    return topics;
}

- (NSArray *)convertToNotificationChannels:(NSArray *)channels {
    NSMutableArray *notificationChannels = [[NSMutableArray alloc] init];
    
    for (NSString *channel in channels) {
        if ([channel isEqualToString:@"카리스마"]) {
            [notificationChannels addObject:@"Karisma"];
        } else if ([channel isEqualToString:@"카이로스"]) {
            [notificationChannels addObject:@"Kairos"];
        } else {
            [notificationChannels addObject:channel];
        }
    }
    
    return notificationChannels;
}

- (NSMutableDictionary *)getTopicsInDictionary {
    NSMutableDictionary *topicDict = [[NSMutableDictionary alloc] init];
    for (AWSPushTopic *topic in self.pushManager.topics) {
        [topicDict setObject:[NSNumber numberWithBool:false] forKey:topic];
    }
    return topicDict;
}

#pragma mark - AWSPushNotificationDelegate

- (void)pushManagerDidRegister:(AWSPushManager *)pushManager {
    AWSLogInfo(@"Successfully enabled Push Notification.");
    AWSPushTopic *topic = [pushManager topicForTopicARN:[pushManager.topicARNs firstObject]];
    [topic subscribe];
}

- (void)pushManager:(AWSPushManager *)pushManager
didFailToRegisterWithError:(NSError *)error {
    AWSLogError(@"Failed to enable Push Notifications: %@", error);
    

}

- (void)pushManager:(AWSPushManager *)pushManager
didReceivePushNotification:(NSDictionary *)userInfo {
    AWSLogInfo(@"Received a Push Notification: %@", userInfo);

}

- (void)pushManagerDidDisable:(AWSPushManager *)pushManager {
    AWSLogInfo(@"Successfully disabled Push Notifications.");
    
}

- (void)pushManager:(AWSPushManager *)pushManager
didFailToDisableWithError:(NSError *)error {
    AWSLogError(@"Failed to disable Push Notifications: %@", error);

}

#pragma mark - AWSPushNotificationTopicDelegate

- (void)topicDidSubscribe:(AWSPushTopic *)topic {
    AWSLogInfo(@"Successfully subscribed to a topic: %@", topic);
    
}

- (void)topic:(AWSPushTopic *)topic
didFailToSubscribeWithError:(NSError *)error {
    AWSLogError(@"Failed to subscribe to a topic: %@", error);
    
}

- (void)topicDidUnsubscribe:(AWSPushTopic *)topic {
    AWSLogInfo(@"Successfully unsubscribed to a topic: %@", topic);
    
}

- (void)topic:(AWSPushTopic *)topic
didFailToUnsubscribeWithError:(NSError *)error {
    AWSLogError(@"Failed to unsubscribe to a topic: %@", error);
    
}

@end
