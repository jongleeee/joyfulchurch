//
//  Sermons.h
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-objc v0.16
//

@import UIKit;
@import AWSDynamoDB;

#import "NoSQLModelHelpers.h"

NS_ASSUME_NONNULL_BEGIN


@interface Sermons : AWSDynamoDBObjectModel <AWSDynamoDBModeling>

+ (NSDictionary *)JSONKeyPathsByPropertyKey;

@property (nonatomic, strong) NSString *_userId;
@property (nonatomic, strong) NSNumber *_creationDate;
@property (nonatomic, strong) NSSet<NSString *> *_keywords;
@property (nonatomic, strong) NSString *_series;
@property (nonatomic, strong) NSString *_sermon;
@property (nonatomic, strong) NSString *_sermonId;
@property (nonatomic, strong) NSString *_title;
@property (nonatomic, strong) NSString *_verse;

@end

NS_ASSUME_NONNULL_END
