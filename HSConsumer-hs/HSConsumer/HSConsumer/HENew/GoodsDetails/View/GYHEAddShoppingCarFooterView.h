//
//  GYHEAddShoppingCarFooterView.h
//  HSConsumer
//
//  Created by lizp on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHEAddShoppingCarFooterViewIdentifier @"GYHEAddShoppingCarFooterView"

#import <UIKit/UIKit.h>

@interface GYHEAddShoppingCarFooterView : UICollectionReusableView

@property (nonatomic,strong) UIButton *addBtn;//加
@property (nonatomic,strong) UIButton *reduceBtn;//减
@property (nonatomic,strong) UITextField *numberextField;//数量

@end
