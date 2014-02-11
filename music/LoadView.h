//
//  LoadView.h
//  music
//
//  Created by chen on 14-2-10.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadView : UIView
{
    UIView *load;
}

- (void)appear:(UIView *)view;

- (void)disappear;

@end
