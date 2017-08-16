//
//  Sermon.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/16/17.
//
//

#import <Foundation/Foundation.h>
#import "Sermon.h"

@interface Sermon ()

@property NSString *title;
@property NSString *verse;
@property NSString *sermon;
@property NSNumber *date;
@property NSString *series;

@end

@implementation Sermon

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
    NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc] init];
    [dateFormatterr setDateFormat:@"MMM"];
    NSString *uppercase = [dateFormatterr stringFromDate:[self getDate]];
    return [uppercase uppercaseString];
}

- (NSString *)getDay {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:[self getDate]];
    return day;
}

- (NSString *)getYear {
    NSDateFormatter *formatterr = [[NSDateFormatter alloc] init];
    [formatterr setDateFormat:@"yyyy"];
    NSString *year = [formatterr stringFromDate:[self getDate]];
    return year;
}


- (NSString *)getDateInString {
    NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc] init];
    [dateFormatterr setDateFormat:@" MMM dd "];
    return [dateFormatterr stringFromDate:[self getDate]];
}

@end
