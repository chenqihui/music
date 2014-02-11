//
//  DownLoadViewController.m
//  music
//
//  Created by chen on 14-2-11.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "DownLoadViewController.h"

#import "LoadView.h"

@interface DownLoadViewController ()
{
    LoadView *loadView;
    UIProgressView *progressView;
    UILabel *progressLabel;
}

@end

@implementation DownLoadViewController

//@synthesize checkBtn;

- (void)dealloc
{
    [nameText release];
    [singerText release];
    [checkBtn release];
    [showResultMusic release];
    
    [parserXML release];
    [httpWeb release];
    [loadView release];
    [progressView release];
    [progressLabel release];
    [downloadBtn release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    SETBORDER(checkBtn);
    SETBORDER(downloadBtn);
    
    nameText.text = @"怒放的生命";;//@"希望";
    singerText.text = @"汪峰";//@"陈慧琳";
    
    httpWeb = [[HttpWeb alloc] init];
    httpWeb.delegate = self;
    loadView = [[LoadView alloc] initWithFrame:self.view.bounds];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.frame = CGRectMake(30, CGRectGetMaxY(showResultMusic.frame) + 10, 225, 30);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    progressView.transform = transform;
    [progressView setBackgroundColor:[UIColor blackColor]];
    //    progressView.progressTintColor = [UIColor whiteColor];
    [progressView setTrackTintColor:[UIColor blueColor]];
    progressView.progress = 0;
    [self.view addSubview:progressView];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progressView.frame)+10, CGRectGetMidY(progressView.frame), 60, 30)];
    [progressLabel setTextColor:[UIColor redColor]];
    [progressLabel setBackgroundColor:[UIColor clearColor]];
    [progressLabel setText:@"0%"];
    [self.view addSubview:progressLabel];
}

static bool bDownMP3 = NO;

- (IBAction)checkInBaidu:(id)sender
{
    [loadView appear:self.view];
    bDownMP3 = NO;
    NSString *urlString = [[[NSString stringWithFormat:@"http://box.zhangmen.baidu.com/x?op=12&count=1&title=%@$$%@$$$$", nameText.text, singerText.text] retain] autorelease];
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       [httpWeb download:urlString];
                   });
}

- (IBAction)downLoadMusic:(id)sender
{
    bDownMP3 = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       [httpWeb download:showResultMusic.text downTag:YES];
                   });
}

- (void)updateProgress:(NSNumber*)progress
{
    progressView.progress = [progress floatValue];
    [progressLabel setText:[NSString stringWithFormat:@"%.0f%%", [progress floatValue]*100]];
}

#pragma mark parserXMLDelegate

- (void)parserOver:(NSString *)result
{
    NSLog(@"%@", result);
    showResultMusic.text = result;
    [loadView disappear];
}

#pragma mark HttpWebDelegate

- (void)httpWebOver:(NSMutableData *)resultData
{
    // 使用NSXMLParser解析出我们想要的结果
    if (bDownMP3)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filename = [[NSString stringWithFormat:@"%@.mp3", nameText.text] lowercaseString];
        NSString* path=[documentsDirectory stringByAppendingPathComponent:filename];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        [resultData writeToFile:path atomically:NO];
        NSLog(@"下载mp3完成");
        bDownMP3 = NO;
    }else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       parserXML = [[ParserXML alloc] initParser:self];
                       [parserXML parser:resultData];
                   });
    }
}

- (void)httpWebProgress:(float)n
{
    if (bDownMP3)
    {
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:n] waitUntilDone:NO];
    }
}

@end
