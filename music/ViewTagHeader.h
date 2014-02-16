//
//  ViewTagHeader.h
//  music
//
//  Created by chen on 14-2-11.
//  Copyright (c) 2014年 User. All rights reserved.
//

#ifndef music_ViewTagHeader_h
#define music_ViewTagHeader_h

#define SETBORDER(view) view.layer.borderWidth = 1;view.layer.masksToBounds = YES;view.layer.cornerRadius = 8;

#define SETCYCLEBORDER(view) view.layer.borderWidth = 1;view.layer.masksToBounds = YES;view.layer.cornerRadius = view.frame.size.height/2.0;[view setBackgroundColor:[UIColor whiteColor]];

#endif
