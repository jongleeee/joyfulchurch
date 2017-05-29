//
//  AnnouncementHandler.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/15/17.
//
//

#import <Foundation/Foundation.h>
#import "AnnouncementHandler.h"
#import "Announcement.h"
#import <AWSMobileHubHelper/AWSMobileHubHelper.h>

@implementation AnnouncementHandler {}

- (void)save:(Announcements *)announcement completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler {
    
    announcement._userId = [AWSIdentityManager defaultIdentityManager].identityId;
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    announcement._creationDate = timeStampObj;

    [super save:announcement completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(error);
        });
    }];
}

- (void)query:(AWSDynamoDBQueryExpression *)queryExpression completionHandler:(void (^ _Nullable)(NSArray *items))completionHandler {

    Announcements *announcement = [Announcements new];
    [super query:announcement  queryExpression:queryExpression completionHandler:^(NSArray *items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *announcementList = [[NSMutableArray alloc] init];
            for (AWSDynamoDBObjectModel *item in items) {
                Announcement *announcement = [[Announcement alloc] init];
                [announcement configureAnnouncement:[item dictionaryValue]];
                [announcementList addObject:announcement];
            }
            completionHandler(announcementList);
        });
    }];
}

- (void)scan:(AWSDynamoDBScanExpression *)scanExpression completionHandler:(void (^ _Nullable)(NSArray *items))completionHandler {
    Announcements *announcement = [Announcements new];
    [super scan:announcement scanExpression:scanExpression completionHandler:^(NSArray *items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(items);
        });
    }];
}

- (void)getAnnouncements:(NSArray *)categories completionHandler:(void (^ _Nullable)(NSArray  *items))completionHandler {

    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];

    NSDictionary *categoryInformation = [self getInformationWithArray:categories];

    scanExpression.indexName = @"Categories";
    scanExpression.filterExpression = [categoryInformation objectForKey:@"filterExpression"];
    scanExpression.expressionAttributeNames = [categoryInformation objectForKey:@"expressionAttributeNames"];
    scanExpression.expressionAttributeValues = [categoryInformation objectForKey:@"expressionAttributeValues"];

    [self scan:scanExpression completionHandler:^(NSArray *items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *announcementList = [[NSMutableArray alloc] init];
            for (AWSDynamoDBObjectModel *item in items) {
                Announcement *announcement = [[Announcement alloc] init];
                [announcement configureAnnouncement:[item dictionaryValue]];
                [announcementList addObject:announcement];
            }
            completionHandler(announcementList);
        });
    }];
}

- (NSDictionary *)getInformationWithArray:(NSArray *)information {

    NSMutableDictionary *informationDictionary = [[NSMutableDictionary alloc] init];

    NSMutableArray *categoryParamNames = [[NSMutableArray alloc] init];
    for (int count = 1; count <= [information count]; count++) {
        [categoryParamNames addObject:[NSString stringWithFormat:@":category%d", count]];
    }

    NSString *conditionParams = [categoryParamNames componentsJoinedByString:@", "];

//    queryExpression.keyConditionExpression = @"#category in (:category1, :category2, :category3)";
    [informationDictionary setValue:[NSString stringWithFormat:@"#category in (%@)", conditionParams] forKey:@"filterExpression"];


//    queryExpression.expressionAttributeNames = @{
//                                                 @"#category" : @"category",
//                                                 };
    [informationDictionary setValue:@{@"#category" : @"category"} forKey:@"expressionAttributeNames"];

//    queryExpression.expressionAttributeValues = @{
//                                                  @":category" : @"카이로스",
//                                                  };
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [categoryParamNames count]; i++) {
        [paramDictionary setValue:[information objectAtIndex:i] forKey:[categoryParamNames objectAtIndex:i]];
    }
    [informationDictionary setValue:paramDictionary forKey:@"expressionAttributeValues"];

    return informationDictionary;
}

@end
