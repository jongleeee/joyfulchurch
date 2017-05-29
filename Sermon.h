//
//  Sermon.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/16/17.
//
//

@interface Sermon : NSObject

- (void)configureSermon:(NSDictionary *)sermon;

- (NSString *)getTitle;
- (NSString *)getVerse;
- (NSString *)getSermon;
- (NSDate *)getDate;
- (NSString *)getDateInString;

@end
