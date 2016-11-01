//
//  GYSurroundGoodsListModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/11/13.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GYSurroundGoodsListModel : JSONModel

@property (nonatomic, copy) NSString* picAddr;
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, copy) NSString* id;

@end