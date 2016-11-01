//
//  MenuTabView.h
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kMenuBtnStartTag 100 //菜单按钮tag起始值

#import <UIKit/UIKit.h>

//菜单的协议
@protocol MenuTabViewDelegate <NSObject>

@optional

/**
 *  委托方法，选中菜单，更新对应视图
 *
 *	@param  index   更新对应视图索引
 */
- (void)changeViewController:(NSInteger)index;

// add by  songjk 不管改不改变都传粗去index
@optional
- (void)menuTabViewDidSelectIndex:(NSInteger)index;
@end
@interface MenuTabView : UIView

@property (assign, nonatomic) NSInteger selectedIndex; //当前选中的菜单索引
@property (weak, nonatomic) id<MenuTabViewDelegate> delegate; //菜单的协议

/**
 *	初始化创建菜单  默认高为34 不显示分隔条
 *
 *	@param  titles  菜单标题数组
 *
 *	@return	含标题的菜单视图
 */
- (id)initMenuWithTitles:(NSArray*)titles;

/**
 *	初始化创建菜单
 *
 *	@param  titles  菜单标题数组
 *	@param  frame   菜单frame
 *	@param  item    初始默认显示的item
 *	@param  showSeparator   是否显示分隔条
 *
 *	@return	含标题的菜单视图
 */
- (id)initMenuWithTitles:(NSArray*)titles withFrame:(CGRect)frame isShowSeparator:(BOOL)showSeparator;

/**
 *	同步示图，更新菜单状态
 *
 *	@param  index   按键的位置
 */
- (void)updateMenu:(NSInteger)index;

/**
 *	初始默认显示的item *必须要在set deletage后使用
 *
 *	@param  index   item 的索引
 */
- (void)setDefaultItem:(NSUInteger)index;

/**
 *	修改title , 前提已经初始化。
 *
 *	@param  title   要设置显示的title
 *	@param  index   item 的索引
 */
- (void)setNewTitle:(NSString *)title withIndex:(NSUInteger)index;

/**
 *	取得对应item的button
 *
 *	@param  index   要取的索引
 *
 *	@return	button
 */
- (UIButton *)getItemButton:(NSUInteger)index;

@end
