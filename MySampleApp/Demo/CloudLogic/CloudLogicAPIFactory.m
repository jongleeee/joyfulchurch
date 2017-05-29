//
//  CloudLogicAPIFactory.m
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

#import "CloudLogicAPIFactory.h"
#import "CloudLogicAPI.h"
#import "AWSAPI_AD8JYGQVC1_CreateAnnouncementMobileHubClient.h"
#import "AWSAPI_LOGQZC12CB_CreateSermonMobileHubClient.h"
#import <AWSCore/AWSCore.h>
#import "AWSConfiguration.h"

@implementation CloudLogicAPIFactory

+ (NSArray<CloudLogicAPI *> *)supportedCloudLogicAPIs {
    
    return @[
             [[CloudLogicAPI alloc] initWithName:@"createAnnouncement"
                                           paths:@[
                                                    @"/announcements", @"/announcements/123",                                                   ]
                                        endPoint:@"https://ad8jygqvc1.execute-api.us-west-1.amazonaws.com/Development"
                                       apiClient: [AWSAPI_AD8JYGQVC1_CreateAnnouncementMobileHubClient clientForKey:AWSCloudLogicDefaultConfigurationKey]
                                  apiDescription:@"Creates announcement"
              ],
             [[CloudLogicAPI alloc] initWithName:@"createSermon"
                                           paths:@[
                                                    @"/items", @"/items/123",                                                   ]
                                        endPoint:@"https://logqzc12cb.execute-api.us-west-1.amazonaws.com/Development"
                                       apiClient: [AWSAPI_LOGQZC12CB_CreateSermonMobileHubClient clientForKey:AWSCloudLogicDefaultConfigurationKey]
                                  apiDescription:@"creates sermon"
              ],
             ];
}

@end
