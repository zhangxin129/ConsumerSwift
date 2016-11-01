//
//  GYEasyBuySecondeTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
//用于实现将 cell 中  titile 和button 的颜色 实现单选。（第二个section）
@protocol ThirdCellSendData <NSObject>

- (void)sendDataWithTitle:(UILabel*)title WithSelectedBtn:(UIButton*)sender;

@end
#import <UIKit/UIKit.h>

@interface GYEasyBuySecondeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UIButton* btnSelected;
@property (assign, nonatomic) id<ThirdCellSendData> delegate; //代理给tableview  cellforrow

- (void)refreshUIWith:(NSString *)title;
- (void)selectOneRow;
- (void)nonSelectOneRow;
@end
