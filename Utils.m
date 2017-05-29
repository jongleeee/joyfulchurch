//
//  Utils.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 4/8/17.
//
//

#import <Foundation/Foundation.h>
#import "Sermon.h"
#import "Utils.h"

@implementation Utils {}

+ (NSArray *)orderByDate:(NSArray *)array {
    return [array sortedArrayUsingComparator:^NSComparisonResult(Sermon *obj1, Sermon *obj2) {
        return [[obj2 getDate] compare:[obj1 getDate]];
    }];
}

@end
