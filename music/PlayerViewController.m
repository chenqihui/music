//
//  PlayerViewController.m
//  music
//
//  Created by chen on 14-2-13.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()
{
    UIProgressView *progressView;
    UILabel *progressLabel;
}

@end

@implementation PlayerViewController

@synthesize delegate;

- (void)dealloc
{
    [progressView release];
    [progressLabel release];
    [playMP3 release];
    [playerProgress release];
    [_playAndPauseBtn release];
    [_lastSongBtn release];
    [_nextSongBtn release];
    [songNameLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    playMP3 = [[PlayMP3 alloc] init];
    playMP3.delegate = self;
    
    SETCYCLEBORDER(_lastSongBtn);
    SETCYCLEBORDER(_nextSongBtn);
    SETCYCLEBORDER(_playAndPauseBtn);
    [_playAndPauseBtn setTitle:@"play" forState:UIControlStateNormal];
    [_playAndPauseBtn setTitle:@"pause" forState:UIControlStateSelected];
    
    playerProgress.maximumValue = 1;
    playerProgress.minimumValue = 0;
    [playerProgress addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    
    [songNameLabel setTextColor:[UIColor whiteColor]];
    
//    [self controlMusicView];
    
}

static int nCurrentIndex = 0;

- (void)prepareMusicOfIndex:(NSInteger)index
{
    nCurrentIndex = (int)index;
    NSString *name = [[delegate musicList] objectAtIndex:nCurrentIndex];
    [self prepareMusic:name];
    songNameLabel.text = name;
}

- (void)prepareMusic:(NSString *)szFilename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path=[documentsDirectory stringByAppendingPathComponent:szFilename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [playMP3 setMusic:path];
    }
}

- (void)controlMusicView
{
    int wd = 80;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, wd)];
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    //    view.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view.layer.cornerRadius = wd / 2.0;
    view.center = self.view.center;
    [view setBackgroundColor:[UIColor yellowColor]];
    //    view.alpha = 0;
    [view.layer setShadowColor:[UIColor yellowColor].CGColor];
    view.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 2;//阴影透明度，默认0
    view.layer.shadowRadius = 10;//阴影半径，默认3
    
    [self.view addSubview:view];
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - wd)/2, view.frame.origin.y, wd, wd)];
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    //    view.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view0.layer.cornerRadius = wd / 2.0;
    //    view0.center = self.view.center;
    [view0 setBackgroundColor:[UIColor yellowColor]];
    view0.alpha = 0.4;
    
    [self.view addSubview:view0];
    
    int wd2 = 70;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - wd2)/2, view.frame.origin.y + (wd - wd2)/2, wd2, wd2)];
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    view2.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view2.layer.cornerRadius = wd2 / 2.0;
    //    view2.center = self.view.center;
    [view2 setBackgroundColor:[UIColor blackColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:view2.bounds];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitle:@"play" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [view2 addSubview:btn];
    [btn addTarget:self action:@selector(downloadMusic:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:view2];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(change:) userInfo:view repeats:YES];
    
    //    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - wd/2, view.frame.origin.y + wd + 20, wd, wd)];
    //    [view3 setBackgroundColor:[UIColor blueColor]];
    //    [self.view addSubview:view3];
    //    [view3.layer setShadowColor:[UIColor redColor].CGColor];
    //    view3.layer.shadowOffset = CGSizeMake(5,-5);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    //    view3.layer.shadowOpacity = 1;//阴影透明度，默认0
    //    view3.layer.shadowRadius = 3;//阴影半径，默认3
}

- (void)change:(NSTimer *)aTimer
{
    UIView *view = aTimer.userInfo;
    static int alphaTag = 1;
    alphaTag = (alphaTag == 1 ? 0 : 1);
    [UIView animateWithDuration:1.9 animations:^
     {
         view.alpha = alphaTag;
     }                completion:^(BOOL finished)
     {
         self.view.userInteractionEnabled = YES;
     }];
}

- (void)downloadMusic:(id)sender
{
}

- (IBAction)playMusic:(id)sender
{
    [playMP3 playMusic:sender];
}

- (IBAction)pauseMusic:(id)sender
{
    [playMP3 pauseMusic:sender];
}

- (IBAction)stopMusic:(id)sender
{
    [_playAndPauseBtn setSelected:NO];
    [playMP3 stopMusic:sender];
    [playerProgress setValue:0];
}

- (IBAction)playAndPauseMusic:(id)sender
{
    if (!_playAndPauseBtn.selected)
    {
        BOOL bFlag = [playMP3 playMusic:nil];
        if (!bFlag)
        {
            if ([[delegate musicList] count] > 0)
            {
                nCurrentIndex = 0;
                [self prepareMusicOfIndex:nCurrentIndex];
                [playMP3 playMusic:nil];
            }else
            {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的音乐列表没有音乐" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
    }else
    {
        [playMP3 pauseMusic:nil];
    }
    [_playAndPauseBtn setSelected:!_playAndPauseBtn.selected];
}

- (IBAction)playLastMusic:(id)sender
{
    if ([[delegate musicList] count] > 0)
    {
        if (nCurrentIndex == 0)
        {
            [self prepareMusicOfIndex:[[delegate musicList] count] - 1];
        }else
        {
            [self prepareMusicOfIndex:nCurrentIndex - 1];
        }
    }
    [self stopMusic:nil];
    [self playAndPauseMusic:nil];
}

- (IBAction)playNextMusic:(id)sender
{
    [self stopMusic:nil];
    if ([[delegate musicList] count] > 0)
    {
        if (nCurrentIndex == [[delegate musicList] count] - 1)
        {
            [self prepareMusicOfIndex:0];
        }else
        {
            [self prepareMusicOfIndex:nCurrentIndex + 1];
        }
    }
    [self stopMusic:nil];
    [self playAndPauseMusic:nil];
}

- (void)updateValue:(id)sender
{
    //添加响应事件
    float f = playerProgress.value; //读取滑块的值
    [playMP3 playAtTime:f];
}

- (void)updateProgress:(NSNumber*)progress
{
//    progressView.progress = [progress floatValue];
//    [progressLabel setText:[NSString stringWithFormat:@"%.0f%%", [progress floatValue]*100]];
    [playerProgress setValue:[progress floatValue] animated:YES];
}

#pragma mark

- (void)PlayMP3Progress:(float)n
{
    [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:n] waitUntilDone:NO];
}

@end
