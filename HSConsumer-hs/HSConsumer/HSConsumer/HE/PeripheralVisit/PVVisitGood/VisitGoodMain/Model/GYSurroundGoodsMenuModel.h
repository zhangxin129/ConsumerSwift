//
//  GYSurroundGoodsMenuModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/11/13.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GYSurroundGoodsMenuModel : JSONModel

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, copy) NSString* id;

@end
