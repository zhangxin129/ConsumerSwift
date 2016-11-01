//
//  GYAuthcodeView.h
//  Pods
//
//  Created by sqm on 16/7/6.
//
//

#import <UIKit/UIKit.h>

@interface GYAuthcodeView : UIView
@property (strong, nonatomic) NSArray* dataArray; //字符素材数组

@property (strong, nonatomic) NSMutableString* authCodeStr; //验证码字符串
/**
 *  刷新验证吗
 */
-(void)changeAuthcodeView;
@end
