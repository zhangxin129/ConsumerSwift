//
//  GYHResSegmentModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYProductModel : NSObject
@property (nonatomic, copy) NSString *optName;
@property (nonatomic, copy) NSString *lastStatusTime;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *lastApplyId;
@property (nonatomic, copy) NSString *optId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *categoryCode;
@property (nonatomic, copy) NSString *microPic;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *warningValue;
@property (nonatomic, copy) NSString *enableStatus;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *buySegmentNumber;//本地赋值购买数量 段的数量
@property (nonatomic, copy) NSString *buyCardNumber;//卡的数量
@end

@interface GYSegmentModel : NSObject

@property (nonatomic, copy) NSString *cardCount;
@property (nonatomic, copy) NSString *segmentPrice;
@property (nonatomic, copy) NSString *buyStatus;
@property (nonatomic, copy) NSString *segmentDesc;
@property (nonatomic, copy) NSString *segmentCount;

@property (nonatomic, assign, getter=isSelected) BOOL selected;//本地标示是否被选择
@end



@interface  GYHSResSegmentModel: NSObject
@property (nonatomic, strong) NSArray<GYSegmentModel *> *segment;
@property (nonatomic, strong) GYProductModel *product;
@property (nonatomic, copy) NSString *startBuyRes;
@end

