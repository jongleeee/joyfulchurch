//
//  DatabaseHandler.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/10/17.
//
//

#import <Foundation/Foundation.h>
#import "DatabaseHandler.h"

@implementation DatabaseHandler {}

- (void)save:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)item completionHandler:(void (^)(NSError *error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    
    [objectMapper save:item
     completionHandler:^(NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             completionHandler(error);
         });
     }];
}

- (void)query:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)item queryExpression:(AWSDynamoDBQueryExpression *)queryExpression completionHandler:(void (^)(NSArray *items))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    
    [objectMapper query:[item class] expression:queryExpression completionHandler:^(AWSDynamoDBPaginatedOutput *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completionHandler(@[]);
            } else {
                completionHandler(response.items);
            }
        });
    }];
}

- (void)scan:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)item scanExpression:(AWSDynamoDBScanExpression *)scanExpression completionHandler:(void (^)(NSArray *items))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    
    [objectMapper scan:[item class] expression:scanExpression completionHandler:^(AWSDynamoDBPaginatedOutput *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completionHandler(@[]);
            } else {
                completionHandler(response.items);
            }
        });
    }];
}

- (void)remove:(AWSDynamoDBObjectModel<AWSDynamoDBModeling> *)item completionHandler:(void (^)(NSError *error))completionHandler {
    AWSDynamoDBObjectMapper *objectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    
    [objectMapper remove:item completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(error);
        });
    }];
    
}

@end
