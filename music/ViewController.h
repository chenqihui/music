//
//  ViewController.h
//  music
//
//  Created by chen on 14-2-7.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayMP3.h"

@protocol ViewControllerData <NSObject>

- (NSArray *)musicList;

@end

@interface ViewController : UIViewController<ViewControllerData>
{
    //UISegmentedControl的使用
    //http://www.cnblogs.com/aipingguodeli/archive/2012/04/12/2443687.html
    IBOutlet UISegmentedControl *musicSegment;
}
@property (retain, nonatomic) IBOutlet UITableView *m_tableView;

@end
