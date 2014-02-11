//
//  ViewController.h
//  music
//
//  Created by chen on 14-2-7.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParserXML.h"
#import "HttpWeb.h"
#import "PlayMP3.h"

@interface ViewController : UIViewController<ParserXMLDelegate, HttpWebDelegate, PlayMP3Delegate>
{
    ParserXML *parserXML;
    HttpWeb *httpWeb;
    PlayMP3 *playMP3;
    IBOutlet UINavigationBar *navController;
    //UISegmentedControl的使用
    //http://www.cnblogs.com/aipingguodeli/archive/2012/04/12/2443687.html
    IBOutlet UISegmentedControl *musicSegment;
}
@property (retain, nonatomic) IBOutlet UIButton *playBtn;
@property (retain, nonatomic) IBOutlet UIButton *pauseBtn;
@property (retain, nonatomic) IBOutlet UIButton *stopBtn;
- (IBAction)playMusic:(id)sender;
- (IBAction)pauseMusic:(id)sender;
- (IBAction)stopMusic:(id)sender;

@end
