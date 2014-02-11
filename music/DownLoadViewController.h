//
//  DownLoadViewController.h
//  music
//
//  Created by chen on 14-2-11.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParserXML.h"
#import "HttpWeb.h"

@interface DownLoadViewController : UIViewController<ParserXMLDelegate, HttpWebDelegate>
{
    IBOutlet UITextField *nameText;
    IBOutlet UITextField *singerText;
    
    IBOutlet UIButton *checkBtn;
    IBOutlet UITextField *showResultMusic;
    IBOutlet UIButton *downloadBtn;
    
    ParserXML *parserXML;
    HttpWeb *httpWeb;
}
//@property (retain, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkInBaidu:(id)sender;
- (IBAction)downLoadMusic:(id)sender;

@end
