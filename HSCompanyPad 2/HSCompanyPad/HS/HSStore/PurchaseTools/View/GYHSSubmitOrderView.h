//
//  GYHSSubmitOrderView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSAddressListModel;
@class GYHSCardTypeModel;
@class GYHSPurchaseAddressCell;

typedef NS_ENUM(NSUInteger, GYHSSubmitType)
{
    GYHSSubmitTypeToolPurchase ,//添加
    GYHSSubmitTypeResourceSegment //修改
    
};

@protocol GYHSSubmitViewDelegate <NSObject>

- (void)deleteAddress:(GYHSAddressListModel *)model;
- (void)changeAddress:(GYHSAddressListModel *)model;
- (void)addAddress;
- (void)transSelectedMode:(GYHSAddressListModel *)model;
-(void)transPriceStr:(NSString *)priceStr;

@end

@interface GYHSSubmitOrderView : UIView

@property (nonatomic, weak) id<GYHSSubmitViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *addrDataArray;
@property (nonatomic, strong) GYHSCardTypeModel *typeModel;
@property (nonatomic, assign) GYHSSubmitType type;
@property (nonatomic, strong) NSMutableArray *resSegArray;
@property (nonatomic, strong) NSMutableArray *toolPurArray;

@end
