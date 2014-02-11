//
//  DownLoadViewController.h
//  music
//
//  Created by chen on 14-2-11.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadViewController : UIViewController
{
    IBOutlet UITextField *nameText;
    IBOutlet UITextField *singerText;
    
    IBOutlet UIButton *checkBtn;
}
//@property (retain, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkInBaidu:(id)sender;

@end
