//
//  NotificationChannel.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 5/5/17.
//
//

#import "DatabaseHandler.h"

@interface NotificationChannelHandler : DatabaseHandler

- (void)save:(NotificationChannels *)channel completionHandler:(void (^)(NSError *error))completionHandler;
- (void)remove:(AWSDynamoDBObjectModel *)channel completionHandler:(void (^)(NSError *error))completionHandler;
- (void)removeForDevice:(NSString *)deviceToken andChannel:(NSString *)channel completionHandler:(void (^)(NSError *))completionHandler;

@end
