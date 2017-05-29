//
//  SermonHandler.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/15/17.
//
//

#import <Foundation/Foundation.h>
#import "SermonHandler.h"
#import "Sermon.h"
#import <AWSMobileHubHelper/AWSMobileHubHelper.h>


@implementation SermonHandler {}

- (void)save:(Sermons *)sermon completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler {
    sermon._userId = [AWSIdentityManager defaultIdentityManager].identityId;;
    
    [super save:sermon completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(error);
        });
    }];
}

- (void)query:(AWSDynamoDBQueryExpression *)queryExpression completionHandler:(void (^ _Nullable)(NSArray *items))completionHandler {

    Sermons *sermon = [Sermons new];
    [super query:sermon  queryExpression:queryExpression completionHandler:^(NSArray *items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(items);
        });
    }];
}

- (void)scan:(AWSDynamoDBScanExpression *)scanExpression completionHandler:(void (^ _Nullable)(NSArray *items))completionHandler {

    Sermons *sermon = [Sermons new];
    [super scan:sermon scanExpression:scanExpression completionHandler:^(NSArray *items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(items);
        });
    }];
}

- (void)getAllSermons:(void (^ _Nullable)(NSArray *items))completionHandler {

    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    [self scan:scanExpression completionHandler:^(NSArray *items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *sermonList = [[NSMutableArray alloc] init];
            for (AWSDynamoDBObjectModel *item in items) {
                Sermon *sermon = [[Sermon alloc] init];
                [sermon configureSermon:[item dictionaryValue]];
                [sermonList addObject:sermon];
            }
            completionHandler(sermonList);
        });
    }];
}

@end
