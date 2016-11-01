//
//  GYHDChatImageShowView.m
//  HSConsumer
//
//  Created by shiang on 16/3/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDChatImageShowView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GYHDChatImageShowView ()<UIActionSheetDelegate,UIScrollViewDelegate>{
    
    UIActionSheet *actionSheet;
}
/**展示图片*/
@property (nonatomic, weak) UIImageView *showImageView;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation GYHDChatImageShowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [ super initWithFrame:frame]) {
        
        [self setUI];
        
    }
    return self;
}

- (void)setUI {
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        
        [self removeConstraint:constraint];
    }
    
    self.backgroundColor = [UIColor blackColor];
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    scrollView.userInteractionEnabled=YES;
    
    //scrollView 增加缩放
    scrollView.maximumZoomScale=2.0;
    scrollView.minimumZoomScale=1;
    
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    //    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.bottom.right.mas_equalTo(0);
    //    }];
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.userInteractionEnabled = YES;
    showImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [showImageView setFrame:scrollView.bounds];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
    [showImageView addGestureRecognizer:longTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [showImageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [showImageView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self.scrollView addSubview:showImageView];
    _showImageView = showImageView;
    
    
    //    [showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.bottom.right.mas_equalTo(0);
    //    }];
}

- (void)setImageWithUrl:(NSURL *)url {
    if ([url.absoluteString hasPrefix:@"http"] ||
        [url.absoluteString hasPrefix:@"file"]) {
        [self.showImageView setImageWithURL:url placeholder:[UIImage imageNamed:@"ep_placeholder_image_type1"] options:kNilOptions completion:nil ];
    }else {
        @weakify(self);
        ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset* asset) {
            @strongify(self);
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            self.showImageView.image = image;
            
        } failureBlock:^(NSError* error){
            
        }];
    }

}
- (void)disMiss {
    
    
    [self removeFromSuperview];
}
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    
    if (![window isKeyWindow]) {
        [window becomeKeyWindow];
        [window makeKeyAndVisible];
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
}

-(void)showInView:(UIView*)superView{
    
    [superView addSubview:self];
    
    [self setFrame:superView.bounds];
    //    [self mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.bottom.right.mas_equalTo(0);
    //    }];
}

- (void)longTap:(UILongPressGestureRecognizer *)longTap {
    if (longTap.state == UIGestureRecognizerStateBegan) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kLocalized(@"GYHD_Cancel") destructiveButtonTitle:nil otherButtonTitles:kLocalized(@"GYHD_Save"),nil];
        [actionSheet showInView:self.scrollView];
        
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    
    [actionSheet resignFirstResponder];
    
    [self disMiss];
}

- (void)doubleTap:(UIGestureRecognizer*)gestureRecognizer {
    
    //    [self.showImageView mas_updateConstraints:^(MASConstraintMaker *make) {
    //
    //        make.center.mas_equalTo(self.scrollView.center);
    //    }];
    
    if (_scrollView.zoomScale==2.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    }
    else{
        
        [_scrollView setZoomScale:2.0 animated:YES];
    }
}

#pragma mark -UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _showImageView;
}

// 视图已经放大或缩小
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    DDLogInfo(@"scrollViewDidZoom");
    
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            //   UIImageWriteToSavedPhotosAlbum(self.showImageView.image, nil, nil, nil);
            //modify by jianglincen 修改图片保存方法,增加回调
            
            UIImageWriteToSavedPhotosAlbum(self.showImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
            [self disMiss];
        }
            break;
        default:
            break;
    }
}

#pragma mark -ImageSave Callback
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    
    if (error != NULL)
    {
        
//        DDLogInfo(@"保存失败");
    }
    else  // No errors
    {
        // Show message image successfully saved
        [GYUtils showToast:kLocalized(@"GYHD_Save_Success")];
//        DDLogInfo(@"保存成功");
        
    }
}

@end
