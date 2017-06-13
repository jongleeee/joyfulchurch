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

    for (AWSPushTopic *topic in self.pushManager.topics) {
        NSLog(@"topic : %@", topic.topicName);
    }
    
    return self;
}


- (void)subscribeToTopics:(NSArray *)selectedChannels {
    selectedChannels = [self convertToNotificationChannels:selectedChannels];
    
    for (AWSPushTopic *topic in self.pushManager.topics) {
        [topic unsubscribe];
    }
    
    for (AWSPushTopic *awsTopic in self.pushManager.topics) {
        for (NSString *topicName in selectedChannels) {
            NSRange range = [awsTopic.topicName rangeOfString:topicName options: NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [awsTopic subscribe];
            }
        }
    }
}

- (NSArray *)convertToNotificationChannels:(NSArray *)channels {
    NSMutableArray *notificationChannels = [[NSMutableArray alloc] init];
    
    for (NSString *channel in channels) {
        if ([channel isEqualToString:@"카리스마"]) {
            [notificationChannels addObject:@"Karisma"];
        } else if ([channel isEqualToString:@"카이로스"]) {
            [notificationChannels addObject:@"Kairos"];
        } else if ([channel isEqualToString:@"설교"]){
            [notificationChannels addObject:@"Sermon"];
        } else {
            [notificationChannels addObject:channel];
        }
    }
    
    return notificationChannels;
}

#pragma mark - AWSPushNotificationDelegate

- (void)pushManagerDidRegister:(AWSPushManager *)pushManager {
    AWSLogInfo(@"Successfully enabled Push Notification.");
    AWSPushTopic *topic = [pushManager topicForTopicARN:[pushManager.topicARNs firstObject]];
    [topic subscribe];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registeredPushNotification" object:nil];
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
