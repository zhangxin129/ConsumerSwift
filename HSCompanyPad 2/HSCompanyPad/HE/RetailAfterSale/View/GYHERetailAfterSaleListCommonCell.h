//
//  GYHERetailAfterSaleListCommonCell.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHESaleAfterModel;

@protocol GYHETransDataDelegate <NSObject>

- (void)transReturnModel:(GYHESaleAfterModel *)model;

@end

@interface GYHERetailAfterSaleListCommonCell : UITableViewCell

@property (nonatomic, strong) GYHESaleAfterModel* model;
@property (nonatomic, weak) id<GYHETransDataDelegate> delegate;

//自定义创建需要的cell 含8个信息
-(instancetype)createEightInformationWithOrderNumber:(NSString*)orderNumber operatingAdress:(NSString*)operatingAdress serialNumber:(NSString*)serialNumber afterSaleServiceNumber:(NSString*)serviceNumber HSNumber:(NSString*)HSNum applicationType:(NSString*)applicationType applicationTime:(NSString*)applicationTime stateType:(NSString*)stateType;



//自定义线下退货 的cell 含6个必要信息
-(instancetype)createSixInformationWithserialNumber:(NSString*)serialNumber afterSaleServiceNumber:(NSString*)serviceNumber amountOfMoney:(NSString*)money accumulatedPoints:(NSString*)accumulatedPoints applicationTime:(NSString*)applicationTime stateType:(NSString*)stateType;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
