//
//  NoSQLTableFactory.h
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
#import <Foundation/Foundation.h>

@class Table;

@interface NoSQLTableFactory : NSObject

+ (NSArray<Table *> *)supportedTables;

@end
