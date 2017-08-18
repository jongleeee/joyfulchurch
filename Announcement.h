//
//  Announcement.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/16/17.
//
//

@interface Announcement : NSObject

- (void)configureAnnouncement:(NSDictionary *)announcement;

- (NSString *)getCategory;
- (NSString *)getTitle;
- (NSString *)getContent;
- (NSArray *)getKeywords;
- (NSDate *)getDate;
- (NSString *)getDateInString;
- (NSString *)getNumberOfDaysInString;
- (NSString *)getMonth;
- (NSString *)getDay;
- (NSString *)getYear;

@end
