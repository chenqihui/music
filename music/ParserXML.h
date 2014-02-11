//
//  parserXML.h
//  music
//
//  Created by chen on 14-2-10.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserXMLDelegate <NSObject>

- (void)parserOver:(NSString *)result;

@end

@interface ParserXML : NSObject<NSXMLParserDelegate>
{
    BOOL storingFlag; //查询标签所对应的元素是否存在
    NSArray *elementToParse;  //要存储的元素
    //    NSMutableString *currentElementValue;  //用于存储元素标签的值
    NSString *currentElementValue;
    id<ParserXMLDelegate> delegate;
}

@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (assign, nonatomic) id<ParserXMLDelegate> delegate;

- (id)initParser:(id)mdelegate;

- (void)parser:(NSData *)data;

@end
