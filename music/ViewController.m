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
#import "PlayerViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *name;
    NSString *singer;
    
    DownLoadViewController *downLoadViewController;
    PlayerViewController *playerViewController;
    
    NSMutableArray *m_arMusicList;
}

@end

@implementation ViewController

@synthesize m_tableView = _m_tableView;

- (void)dealloc
{
    [musicSegment release];
    [downLoadViewController release];
    [playerViewController release];
    [_m_tableView release];
    
    [m_arMusicList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getMusicList];
    
    [musicSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    name = @"怒放的生命";
    singer = @"汪峰";
    
    _m_tableView.dataSource = self;
    _m_tableView.delegate = self;
//    _m_tableView.editing = YES;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    playerViewController = [[PlayerViewController alloc] init];
    [playerViewController.view setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    [self.view addSubview:playerViewController.view];
    playerViewController.delegate = self;
}

static bool bPlayView = NO;

-(void)leftAction:(id)sender
{
    int y = 64;
    if (bPlayView)
    {
        y = CGRectGetHeight(self.view.frame);
    }
    [UIView animateWithDuration:0.6 animations:^
     {
         [playerViewController.view setFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
     }                completion:^(BOOL finished)
     {
         bPlayView = !bPlayView;
     }];
}

-(void)rightAction:(id)sender
{
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了导航栏右按钮" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alter show];
    
    [self getMusicList];
    [_m_tableView reloadData];
    if (bPlayView)
    {
        [self leftAction:nil];
    }
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
#ifdef DEBUG
    NSLog(@"Index %li", Index);
#endif
    
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
    cell.textLabel.text = [[m_arMusicList objectAtIndex:[indexPath row]] stringByDeletingPathExtension];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSString *filename = [m_arMusicList objectAtIndex:[indexPath row]];
//    [playerViewController prepareMusic:filename];
    [playerViewController prepareMusicOfIndex:[indexPath row]];
    
    [self performSelectorOnMainThread:@selector(leftAction:) withObject:nil waitUntilDone:NO];
//    [playerViewController playMusic:nil];
    [playerViewController stopMusic:nil];
    [playerViewController playAndPauseMusic:nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
	//不能是UITableViewCellEditingStyleNone
}


//点击删除按钮后, 会触发如下事件. 在该事件中做响应动作就可以了
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *szSongName = [m_arMusicList objectAtIndex:[indexPath row]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [[NSString stringWithFormat:@"%@", szSongName] lowercaseString];
    NSString* path=[documentsDirectory stringByAppendingPathComponent:filename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [m_arMusicList removeObjectAtIndex:[indexPath row]];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)getMusicList
{
    m_arMusicList = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager * fm = [NSFileManager defaultManager];
    
    NSArray  *arr = [fm directoryContentsAtPath:documentsDirectory];
    [m_arMusicList removeAllObjects];
    for (NSString *path in arr)
    {
        if ([[path pathExtension] isEqualToString:@"mp3"])
        {
            [m_arMusicList addObject:path];
        }
    }
}

#pragma mark

- (NSArray *)musicList
{
    return m_arMusicList;
}

@end
