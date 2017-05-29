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

@end

@implementation Sermon

- (void)configureSermon:(NSDictionary *)sermon {
    self.title = [sermon objectForKey:@"_title"];
    self.verse = [sermon objectForKey:@"_verse"];
    self.sermon = [sermon objectForKey:@"_sermon"];
    self.date = [sermon objectForKey:@"_creationDate"];
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

- (NSDate *)getDate {
    return [NSDate dateWithTimeIntervalSince1970:[self.date doubleValue]];
}

- (NSString *)getDateInString {
    NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc] init];
    [dateFormatterr setDateFormat:@" MMM dd "];
    return [dateFormatterr stringFromDate:[self getDate]];
}

@end
