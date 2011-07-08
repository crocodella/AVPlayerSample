//
//  AVPlayerSampleViewController.h
//  AVPlayerSample
//
//  Created by Fabio Rodella on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AVPlayerSampleViewController : UIViewController {
	AVPlayer *avPlayer;
	MPMediaItem *currentItem;
	
	NSTimer *audioUpdateTimer;
	
	BOOL wasPlaying;
	
	id timeObserver;
	
	UIBackgroundTaskIdentifier bgTaskId;
	
	IBOutlet UILabel *artistLabel;
	IBOutlet UILabel *albumLabel;
	IBOutlet UILabel *titleLabel;
	
	IBOutlet UIImageView *albumArtView;
	
	IBOutlet UILabel *currentTimeLabel;
	IBOutlet UILabel *durationLabel;
	IBOutlet UIProgressView *timeProgressView;
	
	IBOutlet UIButton *playButton;
}

- (void)updateAudioTime;

- (void)loadRandomSong;

- (IBAction)playButtonTapped:(id)sender;

- (IBAction)nextButtonTapped:(id)sender;

@end

