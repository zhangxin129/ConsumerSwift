//
//  GYPurchaseToolsCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSToolPurchaseModel.h"

@class GYHSToolPurchaseModel;


@interface GYPurchaseToolsCell : UICollectionViewCell

@property (nonatomic, strong) GYHSToolPurchaseModel *model;

@property (nonatomic, assign) BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UITextField *toolNumTF;


@end
