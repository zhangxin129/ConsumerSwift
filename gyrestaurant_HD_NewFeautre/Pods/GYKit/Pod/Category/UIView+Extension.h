

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, UIViewCustomBorderType) {
    UIViewCustomBorderTypeNone = 0,
    UIViewCustomBorderTypeTop = 1 << 0,
    UIViewCustomBorderTypeRight = 1 << 1,
    UIViewCustomBorderTypeBottom = 1 << 2,
    UIViewCustomBorderTypeLeft = 1 << 3,
    UIViewCustomBorderTypeAll = UIViewCustomBorderTypeTop | UIViewCustomBorderTypeRight | UIViewCustomBorderTypeBottom | UIViewCustomBorderTypeLeft,
};
@interface UIView (Extension)
/**
 *  此类请在layoutSubviews 或者viewdidLayoutSubViews方法调用
 */
@property (nonatomic) UIViewCustomBorderType customBorderType UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *customBorderColor UI_APPEARANCE_SELECTOR;


/**
 *  自定义x
 */
@property (nonatomic, assign) CGFloat x;

/**
 *  自定义y
 */
@property (nonatomic, assign) CGFloat y;

/**
 *  自定义height
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  自定义width
 */
@property (nonatomic, assign) CGFloat width;

/**
 *  自定义size
 */
@property (nonatomic, assign) CGSize  size;

/**
 *  自定义origin
 */
@property (nonatomic, assign) CGPoint  origin;



/**
 *  自定义centerX
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 *  自定义centerY
 */
@property (nonatomic, assign) CGFloat centerY;

@end
