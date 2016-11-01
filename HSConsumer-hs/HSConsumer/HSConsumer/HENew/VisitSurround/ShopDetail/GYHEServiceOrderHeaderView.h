//
//  GYHEServiceOrderHeaderView.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

/**
 *  上面的头视图
 */
#import <UIKit/UIKit.h>

@class GYHEServiceOrderHeaderView;
//代理方法
@protocol GYHEServiceOrderHeaderViewDelegate <NSObject>
//刷新表
- (void)reloadData:(GYHEServiceOrderHeaderView*)headView;


@end








@interface GYHEServiceOrderHeaderView : UIView
@property (nonatomic, weak) id<GYHEServiceOrderHeaderViewDelegate> delegate;
//默认地址 应该是联系人对象? 需要从前面传递过来
@property (nonatomic, assign) BOOL hasValidAddress;  //前面传过来的 存在有效地址


//开关控件的值
@property(nonatomic,assign) BOOL isSwitchOn;
@property(nonatomic , assign) NSInteger tableViewCount;

@property (nonatomic, assign) BOOL hasAbilityTakeHSCard; //判断赠卡的条件
-(void)initView;
@end
