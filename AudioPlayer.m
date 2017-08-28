//
//  AudioPlayer.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 7/19/17.
//
//

#import "AudioPlayer.h"

@implementation AudioPlayer {
    NSURL *sermonurl;
    AVPlayerItem *playerItem;
    AVPlayer *audioPlayer;
    NSString *title;
    NSString *series;
    NSString *sermon;
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
        if ([self compareURL:audioUrl]) {
            playerItem = [[AVPlayerItem alloc] initWithURL:audioUrl];
            audioPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            sermonurl = audioUrl;
            [self updatePlayingInfoCenter];
        }
    } @catch (NSException *exception) {
        return NO;
    }
    return YES;
}

- (void)play {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [audioPlayer play];
    [self updatePlayTimeInPlayingInfoCenter:audioPlayer.currentTime];
}

- (void)resume {
    [audioPlayer pause];
}

- (BOOL)isPlaying {
    return audioPlayer.rate != 0 && audioPlayer.error == nil;
}

- (CMTime)getTotalTime {
    return playerItem.asset.duration;
}
- (CMTime)getCurrentTime {
    return audioPlayer.currentTime;
}

- (double) getCurrTimeInSec {
    return CMTimeGetSeconds(audioPlayer.currentTime);
}

- (NSString *) getSermon {
    return sermon;
}

- (void)seekToTime:(CMTime)time {
    [audioPlayer seekToTime:time];
    [self updatePlayTimeInPlayingInfoCenter:time];
}

- (void)seekToTimeWithTolerance:(CMTime)time {
    [audioPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self updatePlayTimeInPlayingInfoCenter:time];
}

- (void)setSermonString:(NSString *) sermonInString {
    sermon = sermonInString;
}

- (BOOL)compareURL:(NSURL *)url {
    if (![url isEqual:sermonurl] || [sermonurl isEqual:NULL]) {
        return YES;
    }
    return NO;
}

- (void)setSermonTitle:(NSString*)sermonTitle {
    title = sermonTitle;
}

- (void)setSermonSeries:(NSString*)sermonSeries {
    series = sermonSeries;
}

- (void)updatePlayingInfoCenter {
    NSMutableDictionary *playingInfo = [[NSMutableDictionary alloc] init];
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"Launch"]];
    playingInfo[MPMediaItemPropertyArtwork] = albumArt;
    playingInfo[MPMediaItemPropertyAlbumTitle] = series;
    playingInfo[MPMediaItemPropertyArtist] = @"이상준 목사";
    playingInfo[MPMediaItemPropertyTitle] = title;
    playingInfo[MPMediaItemPropertyPlaybackDuration] = @(CMTimeGetSeconds(playerItem.asset.duration));
    playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = @(1);
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = playingInfo;
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    commandCenter.playCommand.enabled = true;
    [commandCenter.playCommand addTarget:self action:@selector(play)];
    
    commandCenter.pauseCommand.enabled = true;
    [commandCenter.pauseCommand addTarget:self action:@selector(resume)];
}

- (void)updatePlayTimeInPlayingInfoCenter:(CMTime)time {
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionaryWithDictionary:center.nowPlayingInfo];
    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(CMTimeGetSeconds(time));
    center.nowPlayingInfo = playingInfo;
}

@end
