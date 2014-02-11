//
//  DownLoadViewController.m
//  music
//
//  Created by chen on 14-2-11.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "DownLoadViewController.h"

#define SETBORDER(view) view.layer.borderWidth = 1;view.layer.masksToBounds = YES;view.layer.cornerRadius = 8;

@interface DownLoadViewController ()

@end

@implementation DownLoadViewController

//@synthesize checkBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    SETBORDER(checkBtn);
}

- (void)dealloc {
    [nameText release];
    [singerText release];
    [checkBtn release];
    [super dealloc];
}
- (IBAction)checkInBaidu:(id)sender {
}
@end
