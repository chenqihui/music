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

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSURLConnection *urlConnection;
    NSString *name;
    NSString *singer;
    
    UIProgressView *progressView;
    UILabel *progressLabel;
    DownLoadViewController *downLoadViewController;
    
    NSMutableArray *m_arMusicList;
}
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSXMLParser *xmlParser;

@end

struct search {
    int a;
}s;
typedef struct search search;

@implementation ViewController

@synthesize m_tableView = _m_tableView;

- (void)dealloc
{
    [progressView release];
    [progressLabel release];
    [_playBtn release];
    [_pauseBtn release];
    [_stopBtn release];
    [playMP3 release];
    [navController release];
    [musicSegment release];
    [downLoadViewController release];
    [_m_tableView release];
    
    [m_arMusicList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_arMusicList = [[NSMutableArray alloc] init];
    [self getMusicList];
    
    SETBORDER(_playBtn);
    SETBORDER(_pauseBtn);
    SETBORDER(_stopBtn);
    
    [musicSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
//    [self.view setBackgroundColor:[UIColor blackColor]];
    
    playMP3 = [[PlayMP3 alloc] init];
    playMP3.delegate = self;
    name = @"怒放的生命";
    singer = @"汪峰";
    
    _m_tableView.dataSource = self;
    _m_tableView.delegate = self;
    
    [self controlMusicView];
}

- (void)controlMusicView
{
    
    int wd = 80;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - wd)/2, CGRectGetMaxY(_m_tableView.frame) + 30, wd, wd)];
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    //    view.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view.layer.cornerRadius = wd / 2.0;
//    view.center = self.view.center;
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
    [view2 setBackgroundColor:[UIColor whiteColor]];
    
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
    [playMP3 stopMusic:sender];
}

- (void)updateProgress:(NSNumber*)progress
{
    progressView.progress = [progress floatValue];
    [progressLabel setText:[NSString stringWithFormat:@"%.0f%%", [progress floatValue]*100]];
}

#pragma mark

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
                [self getMusicList];
                [_m_tableView reloadData];
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

#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arMusicList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LomemoBasicCell";
    UITableViewCell* cell=nil;
//    UILabel* text = nil;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
//        text=[[[UILabel alloc]initWithFrame:CGRectMake(50,2,260,26)] autorelease];
//        text.font=[UIFont systemFontOfSize:15];
//        text.textColor=[UIColor blackColor];
//        text.backgroundColor=[UIColor clearColor];
//        [cell.contentView addSubview:text];
    }
//    text.text = [m_arDs objectAtIndex:[indexPath row]];
//    text.text = name;
    cell.textLabel.text = [m_arMusicList objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [m_arMusicList objectAtIndex:[indexPath row]];
    NSString* path=[documentsDirectory stringByAppendingPathComponent:filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [playMP3 setMusic:path];
    }
}

- (void)getMusicList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager * fm = [NSFileManager defaultManager];
    
    NSArray  *arr = [fm directoryContentsAtPath:documentsDirectory];
    [m_arMusicList removeAllObjects];
    [m_arMusicList addObjectsFromArray:arr];
//    if ([m_arMusicList count] != 0)
//    {
//        [m_arMusicList removeObjectAtIndex:0];
//    }
    NSLog(@"%@", m_arMusicList);
}

@end
