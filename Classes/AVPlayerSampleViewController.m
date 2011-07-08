//
//  AVPlayerSampleViewController.m
//  AVPlayerSample
//
//  Created by Fabio Rodella on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AVPlayerSampleViewController.h"

@implementation AVPlayerSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	audioUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
														target:self
													  selector:@selector(updateAudioTime)
													  userInfo:nil
													   repeats:YES];
	
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
	
	[self loadRandomSong];
	
	wasPlaying = NO;
}

- (void)dealloc {
	[currentItem release];
	[avPlayer release];
    [super dealloc];
}

- (void)updateAudioTime {
	
	if (currentItem) {
		
		CMTime cTime = avPlayer.currentTime;
		float currentTimeSec = cTime.value / cTime.timescale;
		
		NSNumber *duration = [currentItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
		
		int minutes = floor(currentTimeSec / 60);
		int seconds = trunc(currentTimeSec - minutes * 60);
		float progress = currentTimeSec / [duration floatValue];
		
		currentTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
		timeProgressView.progress = progress;
	}
}

- (void)loadRandomSong {
	
	MPMediaQuery *query = [MPMediaQuery albumsQuery];
	NSArray *songs = query.items;
	
	if (songs != nil && [songs count] > 0) {
		[currentItem release];
		currentItem = [[songs objectAtIndex:arc4random() % [songs count]] retain];
		
		titleLabel.text = [currentItem valueForProperty:MPMediaItemPropertyTitle];
		artistLabel.text = [currentItem valueForProperty:MPMediaItemPropertyArtist];
		albumLabel.text = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
		
		NSNumber *time = [currentItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
		
		int minutes = floor([time floatValue] / 60);
		int seconds = trunc([time floatValue] - minutes * 60);
		
		durationLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
		
		CGSize artworkImageViewSize = albumArtView.bounds.size;
		MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
		if (artwork != nil) {
			albumArtView.image = [artwork imageWithSize:artworkImageViewSize];
		} else {
			albumArtView.image = nil;
		}
		
		NSURL *itemURL = [currentItem valueForProperty:MPMediaItemPropertyAssetURL];
		
		if (!avPlayer) {
			avPlayer = [[AVPlayer alloc] initWithURL:itemURL];
		} else {
			[avPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:itemURL]];
			avPlayer.rate = 0.0f;
		}
		
		CMTime endTime = CMTimeMakeWithSeconds([time floatValue], 1);
		timeObserver = [avPlayer addBoundaryTimeObserverForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:endTime]] queue:NULL usingBlock:^(void) {
			[avPlayer removeTimeObserver:timeObserver];
			timeObserver = nil;
			[self nextButtonTapped:nil];
		}];
	}
}

- (IBAction)playButtonTapped:(id)sender {
	if (avPlayer.rate == 0.0f) {
		
		UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
		
		[avPlayer play];
		newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
		
		if (newTaskId != UIBackgroundTaskInvalid && bgTaskId != UIBackgroundTaskInvalid)
			[[UIApplication sharedApplication] endBackgroundTask: bgTaskId];
		
		bgTaskId = newTaskId;
		
		[playButton setTitle:@"Pause" forState:UIControlStateNormal];
		wasPlaying = YES;
	} else {
		[avPlayer pause];
		[playButton setTitle:@"Play" forState:UIControlStateNormal];
		wasPlaying = NO;
	}
}

- (IBAction)nextButtonTapped:(id)sender {
	[self loadRandomSong];
	if (wasPlaying) {
		[self playButtonTapped:nil];
	}
}

@end
