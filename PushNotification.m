    //
//  PushNotification.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 4/5/17.
//
//

#import "PushNotification.h"
#import <AWSMobileHubHelper/AWSMobileHubHelper.h>
#import <AWSSNS/AWSSNS.h>
#import "CloudLogicAPIInvokeViewController.h"
#import "CloudLogicAPI.h"
#import "AWSAPIGateway/AWSAPIGateway.h"
#import <AWSLambda/AWSLambda.h>
#import "AWSAPI_N11KQZNXH0_SendNotificationClient.h"
#import "AWSConfiguration.h"
#import "NotificationChannelHandler.h"
#import "NotificationChannels.h"

@interface PushNotification() <AWSPushManagerDelegate, AWSPushTopicDelegate>

@property (nonatomic, strong) AWSPushManager *pushManager;
@property (nonatomic, strong) NSArray *notificationChannels;
@property (nonatomic, strong) CloudLogicAPI *cloudLogicAPI;

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
        [self setUpCloudLogicAPI];
    }

    return self;
}

- (void)setUpCloudLogicAPI {
    self.cloudLogicAPI = [[CloudLogicAPI alloc] initWithName:@"sendNotification"
                                                       paths:@[
                                                               @"/sendnotification",                                                   ]
                                                    endPoint:@"https://n11kqznxh0.execute-api.us-west-1.amazonaws.com/beta"
                                                   apiClient: [AWSAPI_N11KQZNXH0_SendNotificationClient clientForKey:AWSCloudLogicDefaultConfigurationKey]
                                              apiDescription:@"Sends notification to topic"
                          ];
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

- (void)sendNotificationToChannel:(NSString *)channel withMessage:(NSDictionary *)message{
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       };

    NSMutableDictionary<NSString *, NSString *> *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary<NSString *, NSString *> *queryParameters = [[NSMutableDictionary alloc] init];

    NSString *topicARN;
    if ([channel isEqualToString:@"카이로스"]) {
        topicARN = @"Kairos";
    } else if ([channel isEqualToString:@"카리스마"]) {
        topicARN = @"Karisma";
    } else if ([channel isEqualToString:@"설교"]) {
        topicARN = @"Sermon";
    } else {
        topicARN = @"General";
    }

    [parameters setValue:topicARN forKey:@"channel"];
    [parameters setValue:[message objectForKey:@"title"] forKey:@"messageTitle"];
    [parameters setValue:[message objectForKey:@"content"] forKey:@"messageContext"];

    AWSAPIGatewayRequest *apiRequest = [[AWSAPIGatewayRequest alloc] initWithHTTPMethod:@"POST"
                                                                              URLString:@"/"
                                                                        queryParameters:queryParameters
                                                                       headerParameters:headerParameters
                                                                               HTTPBody:parameters];

    [[self.cloudLogicAPI.apiClient invoke:apiRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error occurred: %@", task.error);
            return task.error;
        }

        AWSAPIGatewayResponse *response = (AWSAPIGatewayResponse *)task.result;
        NSString *responseString = [[NSString alloc] initWithData:response.responseData encoding:NSUTF8StringEncoding];
        NSString *statusCode = [NSString stringWithFormat: @"%ld", (long)response.statusCode];
        NSLog(@"Response: %@", responseString);
        NSLog(@"Status Code: %@", statusCode);

        return nil;
    }];
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
