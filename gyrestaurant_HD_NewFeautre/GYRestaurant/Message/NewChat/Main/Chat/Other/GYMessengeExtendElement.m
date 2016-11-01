//
//  GYExtendElement.m
//  HSConsumer
//
//  Created by shiang on 15/10/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYXMPP.h"
#import "GYMessengeExtendElement.h"

@implementation GYMessengeExtendElement


+(id)GYExtendElementWithID:(NSString *)id
{
    NSXMLElement *sub_node=[NSXMLElement elementWithName:@"id" stringValue:id];
    
    NSXMLElement *element=[NSXMLElement elementWithName:@"request"objectValue:nil];
    
    [element addAttributeWithName:@"xmlns" stringValue:@"gy:abnormal:offline"];
   
    
    [element addChild:sub_node];
    return element;
    
}


+(id)GYExtendElementWithElementId:(NSString *)elementID withSender:(NSString *)sender
{
    NSXMLElement *element=[NSXMLElement elementWithName:@"receipt"objectValue:nil];
    [element addAttributeWithName:@"xmlns" stringValue:@"gy:abnormal:offline"];
    
    NSXMLElement *sub_node_first=[NSXMLElement elementWithName:@"id" stringValue:elementID];
    NSXMLElement *sub_node_second=[NSXMLElement elementWithName:@"sender" stringValue:sender];
    
    [element addChild:sub_node_first];
    [element addChild:sub_node_second];
    
    return element;
    
}
@end
