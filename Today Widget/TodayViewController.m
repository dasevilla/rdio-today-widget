//
//  TodayViewController.m
//  Rdio
//
//  Created by Devin Sevilla on 1/22/15.
//  Copyright (c) 2015 Rdio Inc. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "RdioDesktop.h"

@interface TodayViewController () <NCWidgetProviding>

@property (weak) IBOutlet NSTextField *trackNameLabel;
@property (weak) IBOutlet NSTextField *artistNameLabel;
@property (weak) IBOutlet NSTextField *albumNameLabel;
@property (weak) IBOutlet NSImageView *albumArtworkImageView;
@property (weak) IBOutlet NSButton *playPauseBtn;

@end

@implementation TodayViewController

RdioDesktopApplication *rdioDesktop;

- (void)loadView
{
    [super loadView];

    rdioDesktop = [SBApplication applicationWithBundleIdentifier:@"com.rdio.desktop"];

    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(updateTrackInfo:) name:@"com.rdio.desktop.playStateChanged" object:nil];

    [self updateTrackDetails];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
}

- (void) updateTrackInfo:(NSNotification *)notification
{
    [self updateTrackDetails];
}

- (void) updateTrackDetails
{
    if ([rdioDesktop isRunning]) {
        if (rdioDesktop.playerState == RdioDesktopEPSSPlaying) {
            _playPauseBtn.image = [NSImage imageNamed:@"Player Pause"];
        } else if(rdioDesktop.playerState == RdioDesktopEPSSPaused) {
            _playPauseBtn.image = [NSImage imageNamed:@"Player Play"];
        } else if(rdioDesktop.playerState == RdioDesktopEPSSStopped) {
            _playPauseBtn.image = [NSImage imageNamed:@"Player Play"];
        }

        _trackNameLabel.stringValue = [rdioDesktop.currentTrack name];
        _artistNameLabel.stringValue = [rdioDesktop.currentTrack artist];
        _albumNameLabel.stringValue = [rdioDesktop.currentTrack album];

        NSImage *albumImage = (NSImage *)[rdioDesktop.currentTrack artwork];
        [_albumArtworkImageView setImage:albumImage];
    }
}

- (IBAction)playPauseBtn:(id)sender {
    if ([rdioDesktop isRunning]) {
        [rdioDesktop playpause];
    }
}

- (IBAction)previousBtn:(id)sender {
    if ([rdioDesktop isRunning]) {
        [rdioDesktop previousTrack];
    }
}

- (IBAction)nextBtn:(id)sender {
    if ([rdioDesktop isRunning]) {
        [rdioDesktop nextTrack];
    }
}

@end
