//
//  LoadView.m
//  music
//
//  Created by chen on 14-2-10.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView

- (void)dealloc
{
    [load release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor whiteColor]];
//        [self setAlpha:0.5];
        // Initialization code
        load = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        load.center = self.center;
        load.layer.cornerRadius = 6;//30 / 2.0;
        [load setBackgroundColor:[UIColor whiteColor]];
        UIActivityIndicatorView *a = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(25, 25, 50, 50)] autorelease];
        [a setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [a startAnimating];
        [load addSubview:a];
        [self addSubview:load];
    }
    return self;
}

- (void)appear:(UIView *)view
{
    [view addSubview:self];
}

- (void)disappear
{
    [self removeFromSuperview];
}

@end
