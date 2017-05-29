//
//  SermonDetailViewController.m
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/13/17.
//
//

#import "SermonDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SermonDetailViewController () {
    BOOL playerStarted;
    BOOL playing;
}

@property (weak, nonatomic) IBOutlet UILabel *sermonTitle;
@property (weak, nonatomic) IBOutlet UILabel *sermonVerse;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation SermonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sermonTitle.text = [self.sermon getTitle];
    self.sermonTitle.adjustsFontSizeToFitWidth = YES;
    self.sermonVerse.text = [self.sermon getVerse];
    
    self.sermonTitle.adjustsFontSizeToFitWidth = YES;
    [self.sermonTitle sizeToFit];
    [self.sermonVerse sizeToFit];
    
    self.activityIndicator.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (playerStarted) {
        [self.player removeObserver:self forKeyPath:@"status"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSermon:(id)sender {

    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc]initWithContentURL: [NSURL URLWithString: @"https://bit.ly/2mD7KMJ"]];
    [controller.moviePlayer prepareToPlay];
    [controller.moviePlayer play];
    
    [self.navigationController presentMoviePlayerViewControllerAnimated:controller];
    
    /*
    if (playerStarted) {

        if (playing) {
            
            [self pause];
            
        } else {
            
            [self play];
            
        }
    } else {
        
        [self showLoading];
        [self.playButton setHidden:YES];
        [self initiatePlayer];
        
    }
     */
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        
        if (self.player.status == AVPlayerStatusFailed || self.player.status == AVPlayerItemStatusUnknown){
            
            [self displayAlertWithTitle:@"Error" andContext:@"Could not play sermon at this time. Please try again"];
            
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self stopLoading];
            [self play];
            [self.playButton setHidden:NO];
            
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self resetPlayer];
}

- (void)initiatePlayer {
    NSURL *sermonURL = [NSURL URLWithString: @"https://bit.ly/2mD7KMJ"];
    self.player = [[AVPlayer alloc]initWithURL:sermonURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)play {
    [self.player play];
    playing = true;
    playerStarted = true;
    [self changePlayerButtonName:@"Pause"];
}

- (void)pause {
    [self.player pause];
    playing = false;
    [self changePlayerButtonName:@"Play"];
}

- (void)resetPlayer {
    playerStarted = false;
    playing = false;
    [self changePlayerButtonName:@"Play"];
    [self.player removeObserver:self forKeyPath:@"status"];
}

- (void)changePlayerButtonName:(NSString *)name {
    [self.playButton setTitle:name forState:UIControlStateNormal];
    [self.playButton sizeToFit];
}

- (void)displayAlertWithTitle:(NSString *)title andContext:(NSString *)context {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:context preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showLoading {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)stopLoading {
    [self.activityIndicator stopAnimating];
}


@end
