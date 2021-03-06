//
//  PlayMP3.m
//  music
//
//  Created by chen on 14-2-10.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "PlayMP3.h"

//iPhone 播放音频声音文件
//http://blog.csdn.net/xys289187120/article/details/6595919

@implementation PlayMP3

@synthesize delegate;

- (void)dealloc
{
    [player release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setMusic:(NSString *)szURL
{
    
    if (player)
    {
        [player release];
        player = nil;
    }
    NSURL *url = [[[NSURL alloc] initFileURLWithPath:szURL] autorelease];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    //初始化播放器
    [player prepareToPlay];
    
    //设置播放循环次数，如果numberOfLoops为负数 音频文件就会一直循环播放下去
    player.numberOfLoops = -1;
    
    //设置音频音量 volume的取值范围在 0.0为最小 0.1为最大 可以根据自己的情况而设置
    player.volume = 0.5f;
}

- (void)initPlayer
{
    if(!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(change:) userInfo:nil repeats:YES];
    }
    if (bPause)
    {
        [timer setFireDate:[NSDate distantPast]];
        bPause = NO;
    }
}

static bool bPause = NO;

//IOS中定时器NSTimer的开启与关闭
//http://blog.csdn.net/enuola/article/details/8099461

- (BOOL)playMusic:(id)sender
{
    [self initPlayer];
    bPause = NO;
    return [player play];
}

- (void)pauseMusic:(id)sender
{
    [timer setFireDate:[NSDate distantFuture]];
    bPause = YES;
    [player pause];
}

- (void)stopMusic:(id)sender
{
    player.currentTime = 0;
    [timer setFireDate:[NSDate distantFuture]];
    bPause = YES;
    [player stop];
}

- (void)change:(NSTimer *)aTimer
{
    float n = player.currentTime/player.duration;
    if([delegate respondsToSelector:@selector(PlayMP3Progress:)])
        [delegate PlayMP3Progress:n];
}

- (void)playAtTime:(float)n
{
    NSTimeInterval t = (double)(n * player.duration);
    player.currentTime = t;
    if(!bPause)
        [self playMusic:nil];
}

- (BOOL)playing
{
    return player.playing;
}

@end
