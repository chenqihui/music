//
//  HttpWeb.h
//  music
//
//  Created by chen on 14-2-10.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpWebDelegate <NSObject>

- (void)httpWebOver:(NSMutableData *)resultData;

- (void)httpWebProgress:(float)n;

@end

@interface HttpWeb : NSObject//<NSURLConnectionDataDelegate>
{
    NSURLConnection *urlConnection;
}
@property (strong, nonatomic) NSMutableData *webData;
@property (assign, nonatomic) id<HttpWebDelegate> delegate;

- (void)download:(NSString *)urlStr;

- (void)download:(NSString *)urlStr downTag:(BOOL)bTag;

@end
