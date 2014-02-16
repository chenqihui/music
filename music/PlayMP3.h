//
//  PlayMP3.h
//  music
//
//  Created by chen on 14-2-10.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@protocol PlayMP3Delegate <NSObject>

@optional

- (void)PlayMP3Progress:(float)n;

@end

@interface PlayMP3 : NSObject
{
    AVAudioPlayer *player;
    id<PlayMP3Delegate> delegate;
    NSTimer *timer;
}
@property (assign, nonatomic) id<PlayMP3Delegate> delegate;

- (BOOL)playMusic:(id)sender;

- (void)pauseMusic:(id)sender;

- (void)stopMusic:(id)sender;

- (void)setMusic:(NSString *)szURL;

- (void)playAtTime:(float)n;

- (BOOL)playing;

@end
