//
//  AnnouncementHandler.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/15/17.
//
//

#import "DatabaseHandler.h"
@import AWSDynamoDB;

@interface AnnouncementHandler : DatabaseHandler

- (void)save:(Announcements *)announcement completionHandler:(void (^)(NSError *error))completionHandler;
- (void)query:(AWSDynamoDBQueryExpression *)queryExpression completionHandler:(void (^)(NSArray *items))completionHandler;
- (void)getAnnouncements:(NSArray *)categories completionHandler:(void (^)(NSArray  *items))completionHandler;

@end
