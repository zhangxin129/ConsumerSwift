//
//  CustomIOS7AlertView.h
//  CustomIOS7AlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

/*

   使用方法

   - (IBAction)launchDialog:(id)sender
   {
   // 创建控件
   CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];

   // 添加自定义控件到 alertView
   [alertView setContainerView:[self createUI]];

   // 添加按钮
   [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"GYHS_Base_confirm"),nil]];
   //设置代理
   [alertView setDelegate:self];

   // 通过Block设置按钮回调事件 可用代理或者block
   [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
   DDLogDebug(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
   [alertView close];
   }];

   [alertView setUseMotionEffects:true];

   // And launch the dialog
   [alertView show];

   }

   //按钮代理回调事件设置
   - (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
   {
   DDLogDebug(@"呵呵好: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
   [alertView close];
   }

   - (UIView *)createUI
   {
   UIView *vUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];

   return vUI;
   }

 */

#import <UIKit/UIKit.h>

@protocol CustomIOS7AlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomIOS7AlertView : UIView <CustomIOS7AlertViewDelegate>

@property (nonatomic, retain) UIView* parentView; // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView* dialogView; // Dialog's container view
@property (nonatomic, retain) UIView* containerView; // Container within the dialog (place your ui elements here)
//分隔线
@property (nonatomic, retain) UIImageView* lineView;
@property (nonatomic, retain) UIImageView* lineView1;

@property (nonatomic, strong) NSArray* arrBtnBackColor;
@property (nonatomic, strong) NSArray* arrBtnTextColor;
@property (nonatomic, strong) NSArray* arrIndesx;

@property (nonatomic, assign) id<CustomIOS7AlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray* buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;
//定义block
@property (copy) void (^onButtonTouchUpInside)(CustomIOS7AlertView* alertView, int buttonIndex);

- (id)init;

/*!
   DEPRECATED: Use the [CustomIOS7AlertView init] method without passing a parent view.
 */
- (id)initWithParentView:(UIView*)_parentView __attribute__((deprecated));

- (void)show;
- (void)close;

- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(CustomIOS7AlertView* alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)dealloc;

@end
