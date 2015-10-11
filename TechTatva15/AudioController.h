//
//  AudioController.h
//  ATBasicSounds
//
//  Created by Audrey M Tam on 22/03/2014.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioController : NSObject

- (instancetype)init;
- (void)tryPlayMusic;

@property (assign) BOOL backgroundMusicPlaying;
@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (assign) BOOL backgroundMusicInterrupted;

@end
