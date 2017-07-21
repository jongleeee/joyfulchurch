//
//  AudioPlayer.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 7/19/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import AVFoundation;
@import MediaPlayer;
@import AudioToolbox;


@interface AudioPlayer : NSObject<AVAudioPlayerDelegate>

+ (id)sharedManager;

- (BOOL)prepareToPlayWithURL:(NSURL *)url;
- (void)play;
- (void)resume;
- (BOOL)isPlaying;
- (double)getTotalTime;
- (double)getCurrentTime;

@end
