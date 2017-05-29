//
//  SermonsTable.m
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


#import "SermonsTable.h"
#import "Sermons.h"
#import "NoSQLSampleDataGenerator.h"
#import <AWSMobileHubHelper/AWSMobileHubHelper.h>
#import <sys/utsname.h>
@interface Table()

@property (nonatomic, strong) AWSDynamoDBObjectModel<AWSDynamoDBModeling> *model;
@property (nonatomic, strong) NSArray<Index *> *indexes;

@end


@implementation SermonsTable

- (instancetype)init {
    if (self = [super init]) {

        self.model = [Sermons new];
        self.partitionKeyType = @"String";
        self.sortKeyType = @"Number";
        
        self.indexes = @[

                         [SermonsPrimaryIndex new],
                         ];
    }

    return self;
}

- (NSString *)tableDisplayName {

    return @"Sermons";
}

/**
 * Converts attribute name from data object format to table format.
 * @param dataObjectAttributeName data object attribute name
 * @return table attribute name
 */
- (NSString*)tableAttributeName:(NSString*)dataObjectAttributeName {

    return [[Sermons JSONKeyPathsByPropertyKey] objectForKey:dataObjectAttributeName];
}


- (NSString *)getItemDescription {
    return [NSString stringWithFormat:@"Find Item with userId = %@ and creationDate = %@.", [AWSIdentityManager defaultIdentityManager].identityId, @(1111500000)];
}

- (void)getItemWithCompletionHandler:(void (^)(AWSDynamoDBObjectModel<AWSDynamoDBModeling> * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];


    [objectMapper load:[Sermons class]
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

    [objectMapper scan:[Sermons class]
            expression:scanExpression
     completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             completionHandler(response, error);
         });
     }];
}

- (NSString *)scanWithFilterDescription {
    return [NSString stringWithFormat:@"Find all items with sermon < %@.", @"demo-sermon-500000"];
}

- (void)scanWithFilterWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    scanExpression.filterExpression = @"#sermon > :sermon";
    scanExpression.expressionAttributeNames = @{
                                                @"#sermon" : @"sermon",
                                                };
    scanExpression.expressionAttributeValues = @{
                                                 @":sermon" : @"demo-sermon-500000",
                                                 };

    [objectMapper scan:[Sermons class]
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


    Sermons *itemForGet = [Sermons new];
    itemForGet._userId = [AWSIdentityManager defaultIdentityManager].identityId;
    itemForGet._creationDate = @(1111500000);
    itemForGet._keywords = [NoSQLSampleDataGenerator randomSampleStringSet];
    itemForGet._sermon = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"sermon"];
    itemForGet._sermonId = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"sermonId"];
    itemForGet._title = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"title"];
    itemForGet._verse = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"verse"];

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

        Sermons *item = [Sermons new];
        item._userId = [AWSIdentityManager defaultIdentityManager].identityId;
        item._creationDate = [NoSQLSampleDataGenerator randomSampleNumber];
        item._keywords = [NoSQLSampleDataGenerator randomSampleStringSet];
        item._sermon = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"sermon"];
        item._sermonId = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"sermonId"];
        item._title = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"title"];
        item._verse = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"verse"];

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


    [objectMapper query:[Sermons class]
             expression:queryExpression
     completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
         if (error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completionHandler(@[error]);
             });
         } else {
             NSMutableArray<NSError *> *errors = [NSMutableArray new];
             dispatch_group_t group = dispatch_group_create();

             for (Sermons *item in response.items) {
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


    Sermons *itemToUpdate = (Sermons *)item;
    itemToUpdate._keywords = [NoSQLSampleDataGenerator randomSampleStringSet];
    itemToUpdate._sermon = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"sermon"];
    itemToUpdate._sermonId = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"sermonId"];
    itemToUpdate._title = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"title"];
    itemToUpdate._verse = [NoSQLSampleDataGenerator randomSampleStringWithAttributeName:@"verse"];

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


@implementation SermonsPrimaryIndex

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

    [objectMapper query:[Sermons class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}

- (NSString *)queryWithPartitionKeyAndFilterDescription {
   return [NSString stringWithFormat:@"Find all items with %@ = %@ and %@ > %@.", @"userId", [AWSIdentityManager defaultIdentityManager].identityId, @"sermon", @"demo-sermon-500000"];
}

- (void)queryWithPartitionKeyAndFilterWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    queryExpression.keyConditionExpression = @"#userId = :userId";
    queryExpression.filterExpression = @"#sermon > :sermon";
    queryExpression.expressionAttributeNames = @{
                                                 @"#userId" : @"userId",
                                                 @"#sermon" : @"sermon",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":userId" : [AWSIdentityManager defaultIdentityManager].identityId,
                                                  @":sermon" : @"demo-sermon-500000",
                                                  };


    [objectMapper query:[Sermons class]
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


    [objectMapper query:[Sermons class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}

- (NSString *)queryWithPartitionKeyAndSortKeyAndFilterDescription {
return [NSString stringWithFormat:@"Find all items with %@ = %@, %@ < %@, and %@ > %@.", @"userId", [AWSIdentityManager defaultIdentityManager].identityId, @"creationDate", @(1111500000), @"sermon", @"demo-sermon-500000"];
}

- (void)queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler:(void (^)(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    queryExpression.keyConditionExpression = @"#userId = :userId AND #creationDate < :creationDate";
    queryExpression.filterExpression = @"#sermon > :sermon";
    queryExpression.expressionAttributeNames = @{
                                                 @"#userId" : @"userId",
                                                 @"#creationDate" : @"creationDate",
                                                 @"#sermon" : @"sermon",
                                                 };
    queryExpression.expressionAttributeValues = @{
                                                  @":userId" : [AWSIdentityManager defaultIdentityManager].identityId,
                                                  @":creationDate" : @(1111500000),
                                                  @":sermon" : @"demo-sermon-500000",
                                                  };


    [objectMapper query:[Sermons class]
             expression:queryExpression
      completionHandler:^(AWSDynamoDBPaginatedOutput * _Nullable response, NSError * _Nullable error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              completionHandler(response, error);
          });
      }];
}
@end
