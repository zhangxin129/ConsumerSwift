//
//  FDShopCommentModel.h
//  HSConsumer
//
//  Created by apple on 16/1/15.
//  Copyright (c) 2016年 guiyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FDShopCommentModel : JSONModel
@property (nonatomic, assign) float score;
@property (nonatomic, assign) float serviceScore;
@property (nonatomic, assign) float surroundingsScore;
@property (nonatomic, assign) float totalScore;
@end
