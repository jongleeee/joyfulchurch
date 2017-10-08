//
//  SermonDetailViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/13/17.
//
//

#import "SermonDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AudioPlayer.h"

@interface SermonDetailViewController () {
    double duration;
    NSString *currTime;
    NSString *timeRemain;
    double countup;
    double countdown;
    double sliderVal;
    AudioPlayer *audioPlayer;
    NSURL *sermonURL;
}
@property (weak, nonatomic) IBOutlet UILabel *sermonMonth;
@property (weak, nonatomic) IBOutlet UILabel *sermonDate;
@property (weak, nonatomic) IBOutlet UILabel *sermonYear;
@property (weak, nonatomic) IBOutlet UILabel *sermonSeries;
@property (weak, nonatomic) IBOutlet UIView *sermonInfo;
@property (weak, nonatomic) IBOutlet UILabel *sermonTitle;
@property (weak, nonatomic) IBOutlet UILabel *sermonVerse;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISlider *sliderAudio;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *timeRemaining;
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation SermonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    audioPlayer = [AudioPlayer sharedManager];
    
    self.sermonTitle.text = [self.sermon getTitle];
    self.sermonTitle.adjustsFontSizeToFitWidth = YES;
    self.sermonVerse.text = [self.sermon getVerse];
    [audioPlayer setSermonTitle:[self.sermon getTitle]];
    
    self.sermonTitle.adjustsFontSizeToFitWidth = YES;
    [self.sermonTitle sizeToFit];
    [self.sermonVerse sizeToFit];
    
    self.sermonSeries.text = [self.sermon getSeries];
    self.sermonSeries.adjustsFontSizeToFitWidth = YES;
    [self.sermonSeries sizeToFit];
    [audioPlayer setSermonSeries:[self.sermon getSeries]];
    
    self.sermonMonth.text = [self.sermon getMonth];
    self.sermonMonth.adjustsFontSizeToFitWidth = YES;
    [self.sermonMonth sizeToFit];
    
    self.sermonDate.text = [self.sermon getDay];
    self.sermonDate.adjustsFontSizeToFitWidth = YES;
    [self.sermonDate sizeToFit];
    
    self.sermonYear.text = [self.sermon getYear];
    self.sermonYear.adjustsFontSizeToFitWidth = YES;
    [self.sermonYear sizeToFit];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(becomeActive)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    [self initiatePlayer];
    if ([audioPlayer isPlaying]) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
    }

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self    selector:@selector(updateSlider) userInfo:nil repeats:YES];
    self.sliderAudio.maximumValue = duration;
    [self.sliderAudio addTarget:self action:@selector(sliderSlid:) forControlEvents:UIControlEventValueChanged];
    self.sliderAudio.minimumValue = 0.0;
    self.sliderAudio.continuous = YES;
    
    self.sermonInfo.layer.borderColor = [UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:47.0f/255.0f alpha:1.0f].CGColor;
    self.sermonInfo.layer.borderWidth = 1.0;
    self.sermonInfo.layer.shadowOpacity = 0.4;
    self.sermonInfo.layer.shadowRadius = 5.0f;
    self.sermonInfo.layer.shadowOffset = CGSizeMake(0.0f, 8.0f);
    self.activityIndicator.hidden = YES;
}

- (void)becomeActive
{
    if (![audioPlayer isPlaying]) {
        [self changeButtonImageToPlay];
    }
    else {
        [self changeButtonImageToPause];
    }

}

- (IBAction)sliderSlid:(id)sender {
    float inputSeconds = self.sliderAudio.value;
    self.currentTime.text = [self displayTime:inputSeconds];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.player removeObserver:self forKeyPath:@"status"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSermon:(id)sender {

    if ([audioPlayer isPlaying]) {
        [self pause];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
        
    } else {
        [self play];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUp) userInfo:nil repeats:YES];
    }
    
}

-(void)countUp {
    double inputSec = CMTimeGetSeconds(audioPlayer.getCurrentTime);
    self.sliderAudio.value = inputSec;
    self.currentTime.text = [self displayTime:inputSec];
}

- (void)playerItemDidReachEnd {
    [audioPlayer seekToTime:kCMTimeZero];
    [self changeButtonImageToPlay];
}

- (void)initiatePlayer {
    [audioPlayer setSermonString:[self.sermon getSermon]];
    NSString *urlString = [NSString stringWithFormat:@"https://bit.ly/%@", [self.sermon getSermon]];
    sermonURL = [NSURL URLWithString: urlString];

    if ([audioPlayer isPlaying] && ![audioPlayer compareURL:sermonURL]) {
        [self changeButtonImageToPause];
    }
    
    [audioPlayer prepareToPlayWithURL:sermonURL];
    duration = CMTimeGetSeconds([audioPlayer getTotalTime]);
    NSNumber *theDouble = [NSNumber numberWithDouble:duration];
    int inputSeconds = [theDouble intValue];
    self.timeRemaining.text = [self displayTime:inputSeconds];
    [self.timeRemaining sizeToFit];

    double curTime = CMTimeGetSeconds([audioPlayer getCurrentTime]);
    NSNumber *theDoubleCurr = [NSNumber numberWithDouble:curTime];
    int inputSecs = [theDoubleCurr intValue];
    self.currentTime.text = [self displayTime:inputSecs];
    [self.currentTime sizeToFit];
    sliderVal = curTime;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player];
}

- (NSString *)displayTime:(double)inputSeconds {
    int hours =  inputSeconds / 3600;
    int minutes = ( inputSeconds - hours * 3600 ) / 60;
    int seconds = inputSeconds - hours * 3600 - minutes * 60;
    
    NSString *time;
    if (hours != 0) {
        time = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];
    }
    
    else {
        time = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
    }
    return time;
}

- (IBAction)sliderDidFinishedMoving:(id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slider = sender;
        
        if (CMTIME_IS_INVALID([audioPlayer getTotalTime])) {
            return;
        }
        float minValue = [slider minimumValue];
        float maxValue = [slider maximumValue];
        float value = [slider value];
        double time = duration * (value - minValue) / (maxValue - minValue);
        [audioPlayer seekToTimeWithTolerance:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    }
}

- (void)updateSlider {
    self.sliderAudio.maximumValue = [self durationInSeconds];
    self.sliderAudio.value = [self currentTimeInSeconds];
}

- (Float64)durationInSeconds {
    Float64 dur = CMTimeGetSeconds([audioPlayer getTotalTime]);
    return dur;
}

- (Float64)currentTimeInSeconds {
    Float64 dur = CMTimeGetSeconds([audioPlayer getCurrentTime]);
    return dur;
}

- (void)play {
    [audioPlayer play];
    [self changeButtonImageToPause];
}

- (void)pause {
    [audioPlayer resume];
    [self changeButtonImageToPlay];
}

- (void)changeButtonImageToPlay {
    [self.playButton setImage:[UIImage imageNamed:@"PlayButton"] forState:UIControlStateNormal];
}

- (void)changeButtonImageToPause {
    [self.playButton setImage:[UIImage imageNamed:@"PauseButton"] forState:UIControlStateNormal];
}

- (void)displayAlertWithTitle:(NSString *)title andContext:(NSString *)context {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:context preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
