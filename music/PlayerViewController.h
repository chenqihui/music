//
//  PlayerViewController.h
//  music
//
//  Created by chen on 14-2-13.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayMP3.h"

#import "ViewController.h"

@interface PlayerViewController : UIViewController<PlayMP3Delegate>
{
    PlayMP3 *playMP3;
    IBOutlet UISlider *playerProgress;
    id<ViewControllerData> delegate;
    IBOutlet UILabel *songNameLabel;
}

@property (retain, nonatomic) IBOutlet UIButton *playAndPauseBtn;
@property (retain, nonatomic) IBOutlet UIButton *lastSongBtn;
@property (retain, nonatomic) IBOutlet UIButton *nextSongBtn;

@property (nonatomic, assign) id<ViewControllerData> delegate;

- (void)prepareMusicOfIndex:(NSInteger)index;
- (void)prepareMusic:(NSString *)szFilename;

- (IBAction)playMusic:(id)sender;
- (IBAction)pauseMusic:(id)sender;
- (IBAction)stopMusic:(id)sender;

- (IBAction)playAndPauseMusic:(id)sender;
- (IBAction)playLastMusic:(id)sender;
- (IBAction)playNextMusic:(id)sender;

@end
