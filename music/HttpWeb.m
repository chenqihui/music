//
//  HttpWeb.m
//  music
//
//  Created by chen on 14-2-10.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "HttpWeb.h"

@implementation HttpWeb

@synthesize delegate, webData = _webData;

- (void)dealloc
{
    [_webData release];
    [super dealloc];
}

static bool finished = NO;

static bool bDownTag = NO;

- (void)download:(NSString *)urlStr
{
    [self download:urlStr downTag:NO];
}

- (void)download:(NSString *)urlStr downTag:(BOOL)bTag
{
    finished = NO;
    bDownTag = bTag;
    //    NSString *urlString = [NSString stringWithFormat:@"http://box.zhangmen.baidu.com/x?op=12&count=1&title=%@$$%@$$$$", @"夜夜夜夜", @"梁静茹"];
    //    urlString = @"http://box.zhangmen.baidu.com/x?op=12&count=1&title=怒放的生命$$汪峰$$$$";
    NSString *urlString = urlStr;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    //    [urlString release];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLConnection *aUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
//    [aUrlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    urlConnection = aUrlConnection;
    if (aUrlConnection)
    {
        if (self.webData)
        {
            //            [self.webData release];
            //            self.webData = nil;
        }
        self.webData = [NSMutableData data];
    }
    [urlConnection start];
    while(!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [aUrlConnection release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

static float size = 0;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    size = [response expectedContentLength];
//    NSLog(@"接收完响应:%lld", [response expectedContentLength]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
//    NSLog(@"接收完数据:");
    
    if (bDownTag)
    {
        float p = self.webData.length/size;
        [delegate httpWebProgress:p];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"数据接收错误:%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"连接完成");
    finished = YES;
    
//    NSString *result = [[NSString alloc] initWithData:self.webData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", result);
    // 使用NSXMLParser解析出我们想要的结果
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [delegate httpWebOver:_webData];
                   });
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
