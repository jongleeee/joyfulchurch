//
//  SermonHandler.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/15/17.
//
//

#import "DatabaseHandler.h"

@interface SermonHandler : DatabaseHandler

- (void)save:(Sermons *)sermon completionHandler:(void (^)(NSError *error))completionHandler;
- (void)query:(AWSDynamoDBQueryExpression *)queryExpression completionHandler:(void (^)(NSArray *items))completionHandler;
- (void)scan:(AWSDynamoDBScanExpression *)scanExpression completionHandler:(void (^)(NSArray *items))completionHandler;
- (void)getAllSermons:(void (^)(NSArray *items))completionHandler;

@end
