//
//  GYGIFHUD.m
//  GiFHUD
//
//  Created by apple on 15/10/15.
//  Copyright (c) 2015年 Cem Olcay. All rights reserved.
//

#import "GYGIFHUD.h"
#import "AppDelegate.h"
#import <ImageIO/ImageIO.h>
#import "GYBaseNavController.h"

#define Size 80
#define FadeDuration 0.3
#define GifSpeed 0.3

#define APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

#pragma mark - UIImage Animated GIF

@implementation UIImage (animatedGIF)

static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i)
{
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber* number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0) {
                number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0) {
            
                delayCentiseconds = (int)lrint([number doubleValue] * 100);
            }
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count])
{
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const* const values)
{
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b)
{
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const* const values)
{
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
    
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray* frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds)
{
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage* frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage* const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count])
{
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage* animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source)
{
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray* const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage* const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage* animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef CF_RELEASES_ARGUMENT source)
{
    if (source) {
        UIImage* const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    }
    else {
        return nil;
    }
}

+ (UIImage*)animatedImageWithAnimatedGIFData:(NSData*)data
{
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(toCF data, NULL));
}

+ (UIImage*)animatedImageWithAnimatedGIFURL:(NSURL*)url
{
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(toCF url, NULL));
}

@end

#pragma mark - GYGIFHUD Private

@interface GYGIFHUD ()

+ (instancetype)sharedInstance;

@property (nonatomic, strong) UIView* overlayView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, assign) BOOL shown;

@end

#pragma mark - GYGIFHUD Implementation

@implementation GYGIFHUD

#pragma mark Lifecycle

static id instance;

+ (id)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        
    });
    return instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)copyWithZone:(NSZone*)zone
{
    return instance;
}

- (instancetype)init
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, Size, Size)])) {
    
        [self setAlpha:0];
        [self setCenter:CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5)];
        [self setClipsToBounds:NO];
        
        [self.layer setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0] CGColor]];
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 20, 20)];
        [self addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark HUD

+ (void)show
{
    //    [GYGIFHUD setGifWithImageName:@"adtivity.gif"];
    
    [GYGIFHUD setAnima];
    if (![[self sharedInstance] shown]) {
        [APPDELEGATE.window addSubview:[[self sharedInstance] getoverlayView]];
        
        [APPDELEGATE.window addSubview:instance];
        [APPDELEGATE.window bringSubviewToFront:[self sharedInstance]];
        [[self sharedInstance] setShown:YES];
        [[self sharedInstance] fadeIn];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
            [self dismiss];
            
        });
    }
}

+ (void)dismiss
{

    [[self sharedInstance] fadeOut];
    
}

+ (void)dismiss:(void (^)(void))complated
{
    if (![[self sharedInstance] shown])
        return complated();
        
    [[self sharedInstance] fadeOutComplate:^{
        [[[self sharedInstance] getoverlayView] removeFromSuperview];
        complated();
    }];
}

#pragma mark Effects

- (void)fadeIn
{
    [self.imageView startAnimating];
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:1];
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        [self.imageView stopAnimating];
        [[instance getoverlayView] removeFromSuperview];
        [instance removeFromSuperview];
        [self.imageView setAnimationImages:nil];// bill
    }];
}

- (void)fadeOutComplate:(void (^)(void))complated
{
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        [self.imageView stopAnimating];
        [self.imageView setAnimationImages:nil];// bill
        complated();
    }];
}

- (UIView*)getoverlayView
{

    if (!self.overlayView) {
        self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                             kScreenWidth,
                                                             kScreenHeight )];
        [self.overlayView setBackgroundColor:[UIColor grayColor]];
        [self.overlayView setAlpha:0];
        [UIView animateWithDuration:FadeDuration animations:^{
            [self.overlayView setAlpha:0.3];
        }];
        
        // 添加蒙版，阻止点击事件
        UIView* tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                            kScreenWidth,
                                                            kScreenHeight)];
        tmpView.backgroundColor = [UIColor clearColor];
        tmpView.userInteractionEnabled = NO;
        [self.overlayView addSubview:tmpView];
    }
    return self.overlayView;
}

#pragma mark Gif

+ (void)setGifWithImages:(NSArray*)images
{
    [[[self sharedInstance] imageView] setAnimationImages:images];
    [[[self sharedInstance] imageView] setAnimationDuration:GifSpeed];
}

+ (void)setGifWithImageName:(NSString*)imageName
{
    [[[self sharedInstance] imageView] stopAnimating];
    [[[self sharedInstance] imageView] setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:imageName withExtension:nil]]];
}

+ (void)setGifWithURL:(NSURL*)gifUrl
{
    [[[self sharedInstance] imageView] stopAnimating];
    [[[self sharedInstance] imageView] setImage:[UIImage animatedImageWithAnimatedGIFURL:gifUrl]];
}

#pragma mark 用序列帧播放 yejg

+ (void)setAnima
{
    if ([[self sharedInstance] imageView].isAnimating)
        return;
        
    // 1.加载所有的动画图片
    NSMutableArray* images = [NSMutableArray array];
    
    for (int i = 0; i < 20; i++) {
        // 计算文件名
        NSString* filename = [NSString stringWithFormat:@"hub%03d.png", i + 1];
        // 加载图片
        
       
        UIImage *image = [UIImage imageNamed:filename];
      
        
        // 添加图片到数组中
        [images addObject:image];
    }
    [[self sharedInstance] imageView].animationImages = images;
    
    // 2.设置播放次数(无限次)
    [[self sharedInstance] imageView].animationRepeatCount = 0;
    
    // 3.设置播放时间
    [[self sharedInstance] imageView].animationDuration = images.count * 0.05;
    
    [[[self sharedInstance] imageView] startAnimating];
}


@end
