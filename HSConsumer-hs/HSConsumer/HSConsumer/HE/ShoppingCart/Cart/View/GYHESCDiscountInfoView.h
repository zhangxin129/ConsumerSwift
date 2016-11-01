//
//  GYHESCDiscountInfoView.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCCartListModel.h"

@protocol GYHESCDiscountInfoViewDelegate <NSObject>

@optional

- (void)resetDiscountInfoView:(NSIndexPath*)indexPath;

//- (void)downArrowClicked;

@end

@interface GYHESCDiscountInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* numberLabel;
@property (weak, nonatomic) IBOutlet UILabel* detailLabel;
@property (weak, nonatomic) IBOutlet UIView* detailView;
@property (weak, nonatomic) IBOutlet UIImageView* showImageView;

@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, strong) GYHESCCartListModel* listModel;
@property (nonatomic, assign) BOOL isShowMore; //是否展开

@property (nonatomic, weak) id<GYHESCDiscountInfoViewDelegate> delegate;
@end
