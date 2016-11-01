//
//  GYDBManager.h
//  HSCompanyPad
//
//  Created by User on 16/8/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GYMainHistoryModel.h"

@interface GYDBManager : NSObject

+ (instancetype)sharedInstance;

-(void)createHistoryTable;

-(BOOL)saveHistoryModel:(GYMainHistoryModel*)model;

-(NSMutableArray*)selectHistoryModels;

@end
