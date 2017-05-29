//
//  DatabaseHandler.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/15/17.
//
//
#import "Announcements.h"
#import "Sermons.h"
#import "NotificationChannels.h"

@import AWSDynamoDB;

@interface DatabaseHandler : NSObject {}

- (void)save:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)model completionHandler:(void (^)(NSError * error))completionHandler;
- (void)query:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)item queryExpression:(AWSDynamoDBQueryExpression *)queryExpression completionHandler:(void (^)(NSArray *items))completionHandler;
- (void)scan:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)item scanExpression:(AWSDynamoDBScanExpression *)scanExpression completionHandler:(void (^)(NSArray *items))completionHandler;
- (void)remove:(AWSDynamoDBObjectModel *)item completionHandler:(void (^)(NSError *error))completionHandler;

@end
