//
//  User.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/25/17.
//
//

#import "User.h"
#import "PushNotification.h"

@implementation User {
    NSArray *subscribedChannels;
    NSMutableArray *permissions;
    PushNotification *pushNotification;
}

+ (id)sharedManager {
    static User *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (User *)init {
    if (self = [super init]) {
        [self initSubscribedChannels];
        [self initPermissions];
        [self initPushNotification];
    }
    return self;
}

- (void)initSubscribedChannels {
    NSDictionary *channelDictionary = [self getDataDictionaryAtPath:@"channels"];
    if (channelDictionary != NULL) {
        subscribedChannels = [[NSMutableArray alloc] initWithArray:[channelDictionary objectForKey:@"channels"]];
    } else {
        subscribedChannels = [[NSMutableArray alloc] init];
    }
}

- (void)initPermissions {
    NSDictionary *permissionDictionary = [self getDataDictionaryAtPath:@"permissions"];
    if (permissionDictionary != NULL) {
        permissions = [[NSMutableArray alloc] initWithArray:[permissionDictionary objectForKey:@"permissions"]];
    } else {
        permissions = [[NSMutableArray alloc] init];
    }
}

- (void)initPushNotification {
    pushNotification = [[PushNotification alloc] init];
}

- (BOOL)isAuthorizedFor:(NSString *)feature {
    return [permissions containsObject:feature];
}

- (void)updatePermission:(NSString *)feature {
    if (![permissions containsObject:feature]) {
        [permissions addObject:feature];
        [self savePermissionInDisk];
    }
}

- (NSString *)getDeviceToken {
    return @"DeviceToken";
}

- (NSArray *)getSubscribedChannels {
    if (subscribedChannels == NULL) {
        NSDictionary *channelDictionary = [self getDataDictionaryAtPath:@"channels"];
        return [channelDictionary objectForKey:@"channels"];
    }
    return subscribedChannels;
}

- (void)updateSubscribedChannels:(NSArray *)channels {
    subscribedChannels = channels;
    [self saveChannelInDisk];
}

- (void)saveChannelInDisk {
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setObject:subscribedChannels forKey:@"channels"];
    [self saveToDiskAtPath:@"channels" withData:dataDictionary];
}

- (void)savePermissionInDisk {
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setObject:permissions forKey:@"permissions"];
    [self saveToDiskAtPath:@"permissions" withData:dataDictionary];
}

- (void)saveToDiskAtPath:(NSString *)path withData:(NSDictionary *)dataDictionary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:path];
    
    [NSKeyedArchiver archiveRootObject:dataDictionary toFile:filePath];
}

- (NSDictionary *)getDataDictionaryAtPath:(NSString *)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:path];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return savedData;
    }
    
    return NULL;
}


@end
