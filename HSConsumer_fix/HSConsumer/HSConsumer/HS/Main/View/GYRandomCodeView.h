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

//当前验证码
@property (nonatomic, copy) NSString* currentVerifyCode;

//更新验证码,返回当前验证码currentVerifyCode
- (NSString*)refreshVerifyCode;

@end
