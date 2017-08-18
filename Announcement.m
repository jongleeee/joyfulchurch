//
//  Announcement.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/16/17.
//
//

#import <Foundation/Foundation.h>
#import "Announcement.h"

@interface Announcement () {
    NSDateFormatter *formatter;
}

@property NSString *category;
@property NSString *title;
@property NSString *content;
@property NSArray *keywords;
@property NSNumber *date;

@end

@implementation Announcement

- (Announcement *)init {
    formatter = [[NSDateFormatter alloc] init];
    return self;
}

- (void)configureAnnouncement:(NSDictionary *)announcement {
    self.category = [announcement objectForKey:@"_category"];
    self.title = [announcement objectForKey:@"_title"];
    self.content = [announcement objectForKey:@"_content"];
    self.keywords = [announcement objectForKey:@"_keywords"];
    self.date = [announcement objectForKey:@"_creationDate"];
}

- (NSString *)getCategory {
    return self.category;
}

- (NSString *)getTitle {
    return self.title;
}

- (NSString *)getContent {
    return self.content;
}

- (NSArray *)getKeywords {
    return self.keywords;
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

- (NSString *)getDateInString {
    [formatter setDateFormat:@"MMM dd, YY"];
    return [formatter stringFromDate:[self getDate]];
}

- (NSString *)getNumberOfDaysInString {

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                                        fromDate:[self getDate]
                                                          toDate:[NSDate date]
                                                         options:0];
    
    NSString *connector;
    NSInteger time;
    
    if (components.day >=  1) {
        time = components.day;
        if (components.day == 1) {
            connector = @"day";
        } else {
            connector = @"days";
        }
    } else {
        time = components.hour;
        if (components.hour <= 1) {
            connector = @"hr";
        } else {
            connector = @"hrs";
        }
    }
    
    return [NSString stringWithFormat:@"%ld%@", (long)time, connector];
}

@end
