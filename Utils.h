//
//  Utils.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 4/8/17.
//
//

@interface Utils : NSObject {}

+ (NSArray *)orderByDate:(NSArray *)array;
+ (NSArray *)getChannelLists;
+ (UIColor *)getColorForChannel:(NSString *)name;
+ (NSString *)getTopicARNForChannel:(NSString *)channel;

@end
