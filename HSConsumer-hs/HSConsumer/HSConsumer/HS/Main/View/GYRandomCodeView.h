//
//  GYRandomCodeView.h
//
//  Created by zxm on 16/1/4.

#import <UIKit/UIKit.h>
typedef void (^DidChangeCode)(NSString* code);

@interface GYRandomCodeView : UIView {
    DidChangeCode _didChangeCode;
}

- (void)didChangeCode:(DidChangeCode)didChangeCode;

// 背景颜色，父view需要设置为clear
@property (nonatomic, strong) UIColor* bgColor;

// 是否产生随机颜色，默认YES,否为黑色
@property (nonatomic, assign) BOOL randColor;

// 是否产生干扰线,默认YES
@property (nonatomic, assign) BOOL interferingLine;

// 是否产生干扰点,默认NO
@property (nonatomic, assign) BOOL interferingPoint;

// Y坐标的位置是否随机,默认YES
@property (nonatomic, assign) BOOL randomPointY;

//当前验证码
@property (nonatomic, copy) NSString* currentVerifyCode;

//更新验证码,返回当前验证码currentVerifyCode
- (NSString*)refreshVerifyCode;

@end
