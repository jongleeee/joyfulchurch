//
//  AudioPlayer.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 7/19/17.
//
//

#import "AudioPlayer.h"

@implementation AudioPlayer {
    NSURL *url;
    AVPlayerItem *playerItem;
    AVPlayer *audioPlayer;
}

+ (id)sharedManager {
    static AudioPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (AudioPlayer *)init {
    return [super init];
}

- (BOOL)prepareToPlayWithURL:(NSURL *)audioUrl {

    @try {
        playerItem = [[AVPlayerItem alloc] initWithURL:audioUrl];
        audioPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [self updatePlayingInfoCenter];
    } @catch (NSException *exception) {
        return NO;
    }

    return YES;
}

- (void)play {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [audioPlayer play];
    
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionaryWithDictionary:center.nowPlayingInfo];
    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(CMTimeGetSeconds(audioPlayer.currentTime));
    center.nowPlayingInfo = playingInfo;
}

- (void)resume {
    [audioPlayer pause];
}

- (BOOL)isPlaying {
    return audioPlayer.rate != 0 && audioPlayer.error == nil;
}

- (double)getTotalTime {
    return CMTimeGetSeconds(playerItem.asset.duration);
}
- (double)getCurrentTime {
    return CMTimeGetSeconds(audioPlayer.currentTime);
}

- (void)updatePlayingInfoCenter {
    NSMutableDictionary *playingInfo = [[NSMutableDictionary alloc] init];
    playingInfo[MPMediaItemPropertyAlbumTitle] = @"Series 1";
    playingInfo[MPMediaItemPropertyArtist] = @"Joyful Church";
    playingInfo[MPMediaItemPropertyTitle] = @"Sermon - 1";
    playingInfo[MPMediaItemPropertyPlaybackDuration] = @(CMTimeGetSeconds(playerItem.asset.duration));
    playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = @(1);
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = playingInfo;
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    commandCenter.playCommand.enabled = true;
    [commandCenter.playCommand addTarget:self action:@selector(play)];
    
    commandCenter.pauseCommand.enabled = true;
    [commandCenter.pauseCommand addTarget:self action:@selector(resume)];
}

@end
