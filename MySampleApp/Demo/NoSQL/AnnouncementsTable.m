//
//  AnnouncementsTable.m
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-objc v0.15
//


#import "AnnouncementsTable.h"
#import "Announcements.h"
#import "NoSQLSampleDataGenerator.h"
#import <AWSMobileHubHelper/AWSMobileHubHelper.h>
#import <sys/utsname.h>
@interface Table()

@property (nonatomic, strong) AWSDynamoDBObjectModel<AWSDynamoDBModeling> *model;
@property (nonatomic, strong) NSArray<Index *> *indexes;

@end


@implementation AnnouncementsTable

- (instancetype)init {
    if (self = [super init]) {

        self.model = [Announcements new];
        self.partitionKeyType = @"String";
        self.sortKeyType = @"Number";
        
        self.indexes = @[

                         [AnnouncementsPrimaryIndex new],

                         [AnnouncementsCategories new],
                         ];
    }

    return self;
}

- (NSString *)tableDisplayName {

    return @"Announcements";
}

/**
 * Converts attribute name from data object format to table format.
 * @param dataObjectAttributeName data object attribute name
 * @return table attribute name
 */
- (NSString*)tableAttributeName:(NSString*)dataObjectAttributeName {

    return [[Announcements JSONKeyPathsByPropertyKey] objectForKey:dataObjectAttributeName];
}


- (NSString *)getItemDescription {
    return [NSString stringWithFormat:@"Find Item with userId = %@ and creationDate = %@.", [AWSIdentityManager defaultIdentityManager].identityId, @(1111500000)];
}

- (void)getItemWithCompletionHandler:(void (^)(AWSDynamoDBObjectModel<AWSDynamoDBModeling> * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];


    [objectMapper load:[Announcements class]
               hashKey:[AWSIdentityManager defaultIdentityManager].identityId
              rangeKey:@(1111500000)
     completionHandler:^(AWSDynamoDBObjectModel<AWSDynamoDBModeling> * _Nullable response, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             completionHandler(response, error);
         });
     }];
}

- (NSString *)scanDescription {
    return @"Show all items in the table.";
}

- (void)scanWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    scanExpression.limit = @5;

    [objectMapper scan:[Announcements class]
            expression:scanExpression
     completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             completionHandler(response, error);
         });
     }];
}

- (NSString *)scanWithFilterDescription {
    return [NSString stringWithFormat:@"Find all items with announcementId < %@.", @"demo-announcementId-500000"];
}

- (void)scanWithFilterWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    scanExpression.filterExpression = @"#announcementId > :announcementId";
    scanExpression.expressionAttributeNames = @{
                                                @"#announcementId" : @"announcementId",
                                                };
    scanExpression.expressionAttributeValues = @{
                                                 @":announcementId" : @"demo-announcementId-500000",
                                                 };

    [objectMapper scan:[Announcements class]
            expression:scanExpression
     completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             completionHandler(response, error);
         });
     }];
}

- (void)insertSampleDataWithCompletionHandler:(void (^)(NSArray<NSError *> * _Nullable errors))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    NSMutableArray<NSError *> *errors = [NSMutableArray new];
    dispatch_group_t group = dispatch_group_create();
    int32_t numberOfSampleItems = 20;


    Announcements *itemForGet = [Announcements new];
    itemForGet._userId = [AWSIdentityManager defaultIdentityManager].identityId;
    itemForGet._creationDate = @(1111500000);
    itemForGet._announcementId = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"announcementId"];
    itemForGet._category = [NoSQLSampleDataGenerator randomPartitionSampleStringWithAttributeName:@"category"];
    itemForGet._content = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"content"];
    itemForGet._keywords = [NoSQLSampleDataGenerator randomSampleStringSet];
    itemForGet._title = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"title"];

    dispatch_group_enter(group);

    [objectMapper save:itemForGet
     completionHandler:^(NSError * _Nullable error) {
         if (error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [errors addObject:error];
             });
         }
         dispatch_group_leave(group);
     }];

    for (int32_t i = 0; i < numberOfSampleItems; i++) {

        Announcements *item = [Announcements new];
        item._userId = [AWSIdentityManager defaultIdentityManager].identityId;
        item._creationDate = [NoSQLSampleDataGenerator randomSampleNumber];
        item._announcementId = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"announcementId"];
        item._category = [NoSQLSampleDataGenerator randomPartitionSampleStringWithAttributeName:@"category"];
        item._content = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"content"];
        item._keywords = [NoSQLSampleDataGenerator randomSampleStringSet];
        item._title = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"title"];

        dispatch_group_enter(group);

        [objectMapper save:item
         completionHandler:^(NSError * _Nullable error) {
             if (error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [errors addObject:error];
                 });
             }
             dispatch_group_leave(group);
         }];
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([errors count] > 0) {
            completionHandler(errors);
        } else {
            completionHandler(nil);
        }
    });
}

- (void)removeSampleDataWithCompletionHandler:(void (^)(NSArray<NSError *> * _Nullable errors))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    queryExpression.keyConditionExpression = @"#userId = :userId";
    queryExpression.expressionAttributeNames = @{@"#userId": @"userId"};
    queryExpression.expressionAttributeValues = @{
                                                 @":userId" : [AWSIdentityManager defaultIdentityManager].identityId,
                                                 };


    [objectMapper query:[Announcements class]
             expression:queryExpression
     completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
         if (error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completionHandler(@[error]);
             });
         } else {
             NSMutableArray<NSError *> *errors = [NSMutableArray new];
             dispatch_group_t group = dispatch_group_create();

             for (Announcements *item in response.items) {
                 dispatch_group_enter(group);
                 [objectMapper remove:item
                    completionHandler:^(NSError * _Nullable error) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [errors addObject:error];
                            });
                        }
                        dispatch_group_leave(group);
                    }];
             }

             dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                 if ([errors count] > 0) {
                     completionHandler(errors);
                 } else {
                     completionHandler(nil);
                 }
             });
         }
     }];
}



- (void)updateItem:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)item
 completionHandler:(void (^)(NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];


    Announcements *itemToUpdate = (Announcements *)item;
    itemToUpdate._announcementId = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"announcementId"];
    itemToUpdate._category = [NoSQLSampleDataGenerator randomPartitionSampleStringWithAttributeName:@"category"];
    itemToUpdate._content = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"content"];
    itemToUpdate._keywords = [NoSQLSampleDataGenerator randomSampleStringSet];
    itemToUpdate._title = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"title"];

    [objectMapper save:itemToUpdate
     completionHandler:^(NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             completionHandler(error);
         });
     }];
}

- (void)removeItem:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)item
 completionHandler:(void (^)(NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    [objectMapper remove:item
       completionHandler:^(NSError * _Nullable error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               completionHandler(error);
           });
       }];
}

@end


@implementation AnnouncementsPrimaryIndex

- (NSString *)indexName {
   return nil;
}

- (NSArray<NSString *> *)supportedOperations {
    return @[
             QueryWithPartitionKey,
             QueryWithPartitionKeyAndFilter,
             QueryWithPartitionKeyAndSortKey,
             QueryWithPartitionKeyAndSortKeyAndFilter,
             ];
}

- (NSString *)queryWithPartitionKeyDescription {
    return [NSString stringWithFormat:@"Find all items with %@ = %@.", @"userId", [AWSIdentityManager defaultIdentityManager].identityId];
}

- (void)queryWithPartitionKeyWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    queryExpression.keyConditionExpression = @"#userId = :userId";
    queryExpression.expressionAttributeNames = @{
                                                 @"#userId" : @"userId",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":userId" : [AWSIdentityManager defaultIdentityManager].identityId,
                                                  };

    [objectMapper query:[Announcements class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}

- (NSString *)queryWithPartitionKeyAndFilterDescription {
   return [NSString stringWithFormat:@"Find all items with %@ = %@ and %@ > %@.", @"userId", [AWSIdentityManager defaultIdentityManager].identityId, @"announcementId", @"demo-announcementId-500000"];
}

- (void)queryWithPartitionKeyAndFilterWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    queryExpression.keyConditionExpression = @"#userId = :userId";
    queryExpression.filterExpression = @"#announcementId > :announcementId";
    queryExpression.expressionAttributeNames = @{
                                                 @"#userId" : @"userId",
                                                 @"#announcementId" : @"announcementId",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":userId" : [AWSIdentityManager defaultIdentityManager].identityId,
                                                  @":announcementId" : @"demo-announcementId-500000",
                                                  };


    [objectMapper query:[Announcements class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}

- (NSString *)queryWithPartitionKeyAndSortKeyDescription {
   return [NSString stringWithFormat:@"Find all items with %@ = %@ and %@ < %@.", @"userId", [AWSIdentityManager defaultIdentityManager].identityId ,@"creationDate", @(1111500000)];
}

- (void)queryWithPartitionKeyAndSortKeyWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    queryExpression.keyConditionExpression = @"#userId = :userId AND #creationDate < :creationDate";
    queryExpression.expressionAttributeNames = @{
                                                 @"#userId" : @"userId",
                                                 @"#creationDate" : @"creationDate",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":userId" : [AWSIdentityManager defaultIdentityManager].identityId,
                                                  @":creationDate" : @(1111500000),
                                                  };


    [objectMapper query:[Announcements class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}

- (NSString *)queryWithPartitionKeyAndSortKeyAndFilterDescription {
return [NSString stringWithFormat:@"Find all items with %@ = %@, %@ < %@, and %@ > %@.", @"userId", [AWSIdentityManager defaultIdentityManager].identityId, @"creationDate", @(1111500000), @"announcementId", @"demo-announcementId-500000"];
}

- (void)queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    queryExpression.keyConditionExpression = @"#userId = :userId AND #creationDate < :creationDate";
    queryExpression.filterExpression = @"#announcementId > :announcementId";
    queryExpression.expressionAttributeNames = @{
                                                 @"#userId" : @"userId",
                                                 @"#creationDate" : @"creationDate",
                                                 @"#announcementId" : @"announcementId",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":userId" : [AWSIdentityManager defaultIdentityManager].identityId,
                                                  @":creationDate" : @(1111500000),
                                                  @":announcementId" : @"demo-announcementId-500000",
                                                  };


    [objectMapper query:[Announcements class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}
@end

@implementation AnnouncementsCategories

- (NSString *)indexName {

    return @"Categories";
}

- (NSArray<NSString *> *)supportedOperations {
    return @[
             QueryWithPartitionKey,
             QueryWithPartitionKeyAndFilter,
             QueryWithPartitionKeyAndSortKey,
             QueryWithPartitionKeyAndSortKeyAndFilter,
             ];
}

- (NSString *)queryWithPartitionKeyDescription {
    return [NSString stringWithFormat:@"Find all items with %@ = %@.", @"category", @"demo-category-3"];
}

- (void)queryWithPartitionKeyWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];

    queryExpression.indexName = @"Categories";
    queryExpression.keyConditionExpression = @"#category = :category";
    queryExpression.expressionAttributeNames = @{
                                                 @"#category" : @"category",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":category" : @"demo-category-3",
                                                  };

    [objectMapper query:[Announcements class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}

- (NSString *)queryWithPartitionKeyAndFilterDescription {
   return [NSString stringWithFormat:@"Find all items with %@ = %@ and %@ > %@.", @"category", @"demo-category-3", @"announcementId", @"demo-announcementId-500000"];
}

- (void)queryWithPartitionKeyAndFilterWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];

    queryExpression.indexName = @"Categories";
    queryExpression.keyConditionExpression = @"#category = :category";
    queryExpression.filterExpression = @"#announcementId > :announcementId";
    queryExpression.expressionAttributeNames = @{
                                                 @"#category" : @"category",
                                                 @"#announcementId" : @"announcementId",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":category" : @"demo-category-3",
                                                  @":announcementId" : @"demo-announcementId-500000",
                                                  };


    [objectMapper query:[Announcements class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}

- (NSString *)queryWithPartitionKeyAndSortKeyDescription {
   return [NSString stringWithFormat:@"Find all items with %@ = %@ and %@ < %@.", @"category", @"demo-category-3" ,@"creationDate", @(1111500000)];
}

- (void)queryWithPartitionKeyAndSortKeyWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];

    queryExpression.indexName = @"Categories";
    queryExpression.keyConditionExpression = @"#category = :category AND #creationDate < :creationDate";
    queryExpression.expressionAttributeNames = @{
                                                 @"#category" : @"category",
                                                 @"#creationDate" : @"creationDate",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":category" : @"demo-category-3",
                                                  @":creationDate" : @(1111500000),
                                                  };


    [objectMapper query:[Announcements class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}

- (NSString *)queryWithPartitionKeyAndSortKeyAndFilterDescription {
return [NSString stringWithFormat:@"Find all items with %@ = %@, %@ < %@, and %@ > %@.", @"category", @"demo-category-3", @"creationDate", @(1111500000), @"announcementId", @"demo-announcementId-500000"];
}

- (void)queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];

    queryExpression.indexName = @"Categories";
    queryExpression.keyConditionExpression = @"#category = :category AND #creationDate < :creationDate";
    queryExpression.filterExpression = @"#announcementId > :announcementId";
    queryExpression.expressionAttributeNames = @{
                                                 @"#category" : @"category",
                                                 @"#creationDate" : @"creationDate",
                                                 @"#announcementId" : @"announcementId",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":category" : @"demo-category-3",
                                                  @":creationDate" : @(1111500000),
                                                  @":announcementId" : @"demo-announcementId-500000",
                                                  };


    [objectMapper query:[Announcements class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}
@end
