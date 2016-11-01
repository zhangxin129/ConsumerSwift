//
//  UIImage+GYExtension.h
//  Pods
//
//  Created by sqm on 16/6/15.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (GYExtension)
/**
 *  上传图片图片翻转问题
 */
- (UIImage*)fixOrientation;

#pragma mark - imageEffects
- (UIImage*)applySubtleEffect;
- (UIImage*)applyLightEffect;
- (UIImage*)applyExtraLightEffect;
- (UIImage*)applyDarkEffect;
- (UIImage*)applyTintEffectWithColor:(UIColor*)tintColor;
- (UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

#pragma mark - rotate
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

/**
 * 通过指定宽度裁剪图片
 * @param 要裁剪的图片
 * @param 定义的宽度
 *
 */
-(UIImage *) imageCompressTargetWidth:(CGFloat)defineWidth;
@end
