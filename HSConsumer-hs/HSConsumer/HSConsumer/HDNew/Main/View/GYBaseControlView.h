//
//  GYBaseControlView.h
//  GYBaseController
//
//  Created by kuser on 16/9/8.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYBaseControlView : UIView

/*
    point  按钮点击位置
    titles 传入的数据源
    images 传入图片，没有设置为nil
    width  弹出视图的宽度
    name   选中label的文字
 */
-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images width:(CGFloat)width selectName:(NSString *)name;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@end
