//
//  parserXML.m
//  music
//
//  Created by chen on 14-2-10.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "ParserXML.h"

@implementation ParserXML

@synthesize delegate;

- (void)dealloc
{
    [_xmlParser release];
    [elementToParse release];
    [currentElementValue release];
    [super dealloc];
}

//单例
- (id)initParser:(id)mdelegate
{
    if (self)
    {
        self = [super init];
        delegate = mdelegate;
        elementToParse = [[NSArray arrayWithObjects:@"url", nil] retain];
    }
    
    return self;
}

- (void)parser:(NSData *)data
{
    if (_xmlParser)
    {
        [_xmlParser release];
        _xmlParser = nil;
    }
    if (currentElementValue)
    {
        [currentElementValue release];
    }
    currentElementValue = nil;
    
    _xmlParser = [[NSXMLParser alloc] initWithData:data];
    [_xmlParser setDelegate: self];
    [_xmlParser setShouldResolveExternalEntities: YES];
    
    BOOL flag = [self.xmlParser parse]; //开始解析
    if(flag) {
        NSLog(@"解析指定路径的xml文件成功");
    }
    else {
        NSLog(@"解析指定路径的xml文件失败");
    }
}

#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}
//step 2：准备解析节点
static BOOL bF = NO;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //    storingFlag = [elementToParse containsObject:elementName];
    if([elementName isEqualToString:@"url"])
    {
        bF = YES;
    }else if([elementName isEqualToString:@"encode"])
    {
        if (bF)
            storingFlag = YES;
        else
            storingFlag = NO;
    }else if([elementName isEqualToString:@"decode"])
    {
        if (bF)
            storingFlag = YES;
        else
            storingFlag = NO;
    }else
    {
        bF = NO;
        storingFlag = NO;
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@", string);
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

//step 5：解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//    bDownMP3 = YES;
    //下载
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [delegate parserOver:currentElementValue];
                   });
}
//step 6：获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    if (storingFlag)
    {
        NSString *result = [[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding] autorelease];
        if (!currentElementValue)
        {
            result = [result stringByDeletingLastPathComponent];
            currentElementValue = [[NSString alloc] initWithFormat:@"%@", result];
        }
        else {
            currentElementValue = [[currentElementValue stringByAppendingPathComponent:result] retain];
        }
//        NSLog(@"%@", currentElementValue);
    }
}

@end
