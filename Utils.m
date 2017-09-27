//
//  Utils.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 4/8/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Sermon.h"
#import "Utils.h"

@implementation Utils {}

+ (NSArray *)orderByDate:(NSArray *)array {
    return [array sortedArrayUsingComparator:^NSComparisonResult(Sermon *obj1, Sermon *obj2) {
        return [[obj2 getDate] compare:[obj1 getDate]];
    }];
}

+ (NSArray *)getChannelLists {
    return @[@"죠이플 창", @"교회 소식 (전체 공지)", @"카리스마 대학부", @"카이로스 청년부", @"남성 기도회", @"월요 여성 중보기도 모임", @"여성 커피브레이크", @"교육부", @"찬양팀", @"여름 선교", @"겨울 선교", @"목자 모임", @"사역부장 모임"];
}

+ (NSString *)getTopicARNForChannel:(NSString *)channel {
    NSArray *channels = [self getChannelLists];
    int item = [channels indexOfObject:channel];
    
    switch (item) {
        case 0:
            return @"JoyfulBoard";
        case 1:
            return @"General";
        case 2:
            return @"Karisma";
        case 3:
            return @"Kairos";
        case 4:
            return @"prayerman";
        case 5:
            return @"prayerwoman";
        case 6:
            return @"coffeebreakwoman";
        case 7:
            return @"youtheducation";
        case 8:
            return @"praiseteam";
        case 9:
            return @"missionsummer";
        case 10:
            return @"missionwinter";
        case 11:
            return @"smallgroupleader";
        case 12:
            return @"departmentleader";
    }
    
    return channel;
}


+ (UIColor *)getColorForChannel:(NSString *)name {
    NSArray *channels = [self getChannelLists];
    int item = [channels indexOfObject:name];
    
    switch (item) {
        case 0:
            return [UIColor colorWithRed:255.0f/255.0f green:139.0f/255.0f blue:139.0f/255.0f alpha:1.0f];
        case 1:
            return [UIColor colorWithRed:33.0f/255.0f green:140.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        case 2:
            return [UIColor colorWithRed:174.0f/255.0f green:227.0f/255.0f blue:129.0f/255.0f alpha:1.0f];
        case 3:
            return [UIColor colorWithRed:255.0f/255.0f green:165.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
        case 4:
            return [UIColor colorWithRed:204.0f/255.0f green:110.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
        case 5:
            return [UIColor colorWithRed:207.0f/255.0f green:163.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
        case 6:
            return [UIColor colorWithRed:196.0f/255.0f green:79.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
        case 7:
            return [UIColor colorWithRed:255.0f/255.0f green:206.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
        case 8:
            return [UIColor colorWithRed:255.0f/255.0f green:152.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
        case 9:
            return [UIColor colorWithRed:255.0f/255.0f green:187.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
        case 10:
            return [UIColor colorWithRed:177.0/255.0f green:167.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
        case 11:
            return [UIColor colorWithRed:182.0f/255.0f green:204.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
        case 12:
            return [UIColor colorWithRed:179.0f/255.0f green:150.0f/255.0f blue:173.0f/255.0f alpha:1.0f];
    }
    
    return nil;
}

@end
