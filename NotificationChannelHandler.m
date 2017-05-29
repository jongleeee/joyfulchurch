//
//  NotificationChannelHandler.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 5/5/17.
//
//

#import <Foundation/Foundation.h>
#import "NotificationChannelHandler.h"
#import <AWSMobileHubHelper/AWSMobileHubHelper.h>


@implementation NotificationChannelHandler {}

- (void)save:(NotificationChannels *)channel completionHandler:(void (^)(NSError *error))completionHandler {
    
    [super save:channel completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(error);
        });
    }];
}

- (void)remove:(NotificationChannels *)channel completionHandler:(void (^)(NSError *error))completionHandler {
//    [super remove:(AWSDynamoDBObjectModel *) completionHandler:<#^(NSError *error)completionHandler#>]
}

- (void)removeForDevice:(NSString *)deviceToken andChannel:(NSString *)channel completionHandler:(void (^)(NSError *))completionHandler {
    NotificationChannels *notificationChannel = [NotificationChannels new];
    notificationChannel._deviceToken = deviceToken;
    notificationChannel._channel = channel;
    
    [super remove:notificationChannel completionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(error);
        });
    }];
}

@end
