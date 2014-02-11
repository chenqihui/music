//
//  ViewController.m
//  music
//
//  Created by chen on 14-2-7.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "ViewController.h"

#import "LoadView.h"
#import "DownLoadViewController.h"

@interface ViewController ()
{
    NSURLConnection *urlConnection;
    NSString *name;
    NSString *singer;
    
    LoadView *loadView;
    UIProgressView *progressView;
    UILabel *progressLabel;
    DownLoadViewController *downLoadViewController;
}
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSXMLParser *xmlParser;

@end

struct search {
    int a;
}s;
typedef struct search search;

@implementation ViewController

- (void)dealloc
{
    [parserXML release];
    [httpWeb release];
    [loadView release];
    [progressView release];
    [progressLabel release];
    [_playBtn release];
    [_pauseBtn release];
    [_stopBtn release];
    [playMP3 release];
    [navController release];
    [musicSegment release];
    [downLoadViewController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
// 
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
////        navController.translucent = NO;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//
//    }
    
    [musicSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(30, 104, 225, 30);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    progressView.transform = transform;
    [progressView setBackgroundColor:[UIColor whiteColor]];
//    progressView.progressTintColor = [UIColor whiteColor];
    [progressView setTrackTintColor:[UIColor whiteColor]];
    progressView.progress = 0;
    [self.view addSubview:progressView];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progressView.frame)+10, CGRectGetMidY(progressView.frame), 60, 30)];
    [progressLabel setTextColor:[UIColor redColor]];
    [progressLabel setBackgroundColor:[UIColor clearColor]];
    [progressLabel setText:@"0%"];
    [self.view addSubview:progressLabel];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
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
    view.layer.shadowRadius = 6;//阴影半径，默认3
    
    [self.view addSubview:view];
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, wd)];
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    //    view.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view0.layer.cornerRadius = wd / 2.0;
    view0.center = self.view.center;
    [view0 setBackgroundColor:[UIColor yellowColor]];
    view0.alpha = 0.4;
    
    [self.view addSubview:view0];
    
    int wd2 = 70;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd2, wd2)];
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    view2.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view2.layer.cornerRadius = wd2 / 2.0;
    view2.center = self.view.center;
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
    
    httpWeb = [[HttpWeb alloc] init];
    httpWeb.delegate = self;
    loadView = [[LoadView alloc] initWithFrame:self.view.bounds];
    
    playMP3 = [[PlayMP3 alloc] init];
    playMP3.delegate = self;
//    name = @"怒放的生命";
//    singer = @"汪峰";
    name = @"我";
    singer = @"张国荣";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [[NSString stringWithFormat:@"%@.mp3", name] lowercaseString];
    NSString* path=[documentsDirectory stringByAppendingPathComponent:filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [playMP3 setMusic:path];
    }
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

static bool bDownMP3 = NO;

- (void)downloadMusic:(id)sender
{
    [loadView appear:self.view];
    bDownMP3 = NO;
    NSString *urlString = [[[NSString stringWithFormat:@"http://box.zhangmen.baidu.com/x?op=12&count=1&title=%@$$%@$$$$", name, singer] retain] autorelease];
    [self download:urlString];
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
    [playMP3 stopMusic:sender];
}

- (void)download:(NSString *)urlStr
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^
    {
        [httpWeb download:urlStr];
    });
//    [httpWeb download:urlStr];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark parserXMLDelegate

- (void)parserOver:(NSString *)result
{
    NSLog(@"%@", result);
    bDownMP3 = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       [httpWeb download:result downTag:YES];
                   });
    [loadView disappear];
}

#pragma mark HttpWebDelegate

- (void)httpWebOver:(NSMutableData *)resultData
{
    // 使用NSXMLParser解析出我们想要的结果
    if (bDownMP3)
    {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^
//        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filename = [[NSString stringWithFormat:@"%@.mp3", name] lowercaseString];
            NSString* path=[documentsDirectory stringByAppendingPathComponent:filename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
            [resultData writeToFile:path atomically:NO];
            NSLog(@"下载mp3完成");
            bDownMP3 = NO;
//        });
        [playMP3 setMusic:path];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                        parserXML = [[ParserXML alloc] initParser:self];
                        [parserXML parser:resultData];
                   });
}

- (void)httpWebProgress:(float)n
{
    if (bDownMP3)
    {
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:n] waitUntilDone:NO];
    }
}

- (void)updateProgress:(NSNumber*)progress
{
    progressView.progress = [progress floatValue];
    [progressLabel setText:[NSString stringWithFormat:@"%.0f%%", [progress floatValue]*100]];
}

- (void)PlayMP3Progress:(float)n
{
    [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:n] waitUntilDone:NO];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li", Index);
    
    switch (Index)
    {
            
        case 0:
            if(downLoadViewController)
            {
                [downLoadViewController.view removeFromSuperview];
                [downLoadViewController release];
                downLoadViewController = nil;
            }
            break;
            
        case 1:
            if(!downLoadViewController)
            {
                downLoadViewController = [[DownLoadViewController alloc] init];
                [downLoadViewController.view setFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
                [self.view addSubview:downLoadViewController.view];
            }
            break;
        default:
            
            break;
    }
}

@end
