//
//  User.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/25/17.
//
//

#import "User.h"

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeredPushNotification:) name:@"registeredPushNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultChannels) name:@"subscribeDefaultChannels" object:nil];
    }
    return self;
}

- (void)initSubscribedChannels {
    NSDictionary *channelDictionary = [self getDataDictionaryAtPath:@"channels"];
    if (channelDictionary != NULL) {
        subscribedChannels = [[NSMutableArray alloc] initWithArray:[channelDictionary objectForKey:@"channels"]];
    } else {
        [self setDefaultChannels];
    }
}

- (void)setDefaultChannels {
    NSArray *defaultChannels = [[NSArray alloc] initWithObjects:@"죠이플 창", @"교회 소식 (전체 공지)", nil];
    [self updateSubscribedChannels:defaultChannels];
    [pushNotification subscribeToTopics:defaultChannels];
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

- (PushNotification *)getPushNotification {
    return pushNotification;
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

- (void)registeredPushNotification:(NSNotification *)notification {
    [pushNotification subscribeToTopics:[self getSubscribedChannels]];
}

@end
