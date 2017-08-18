//
//  Sermon.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/16/17.
//
//

#import <Foundation/Foundation.h>
#import "Sermon.h"

@interface Sermon () {
    NSDateFormatter *formatter;
}

@property NSString *title;
@property NSString *verse;
@property NSString *sermon;
@property NSNumber *date;
@property NSString *series;

@end

@implementation Sermon

- (Sermon *)init {
    formatter = [[NSDateFormatter alloc] init];
    return self;
}

- (void)configureSermon:(NSDictionary *)sermon {
    self.title = [sermon objectForKey:@"_title"];
    self.verse = [sermon objectForKey:@"_verse"];
    self.sermon = [sermon objectForKey:@"_sermon"];
    self.date = [sermon objectForKey:@"_creationDate"];
    self.series = [sermon objectForKey:@"_series"];
}

- (NSString *)getTitle {
    return self.title;
}

- (NSString *)getVerse {
    return self.verse;
}

- (NSString *)getSermon {
    return self.sermon;
}

- (NSString *)getSeries {
    if ([self.series isKindOfClass:[NSNull class]]) {
        return @"";
    }

    return self.series;
}

- (NSDate *)getDate {
    return [NSDate dateWithTimeIntervalSince1970:[self.date doubleValue]];
}

- (NSString *)getMonth {
    [formatter setDateFormat:@"MMM"];
    NSString *uppercase = [formatter stringFromDate:[self getDate]];
    return [uppercase uppercaseString];
}

- (NSString *)getDay {
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:[self getDate]];
    return day;
}

- (NSString *)getYear {
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[self getDate]];
    return year;
}

@end
