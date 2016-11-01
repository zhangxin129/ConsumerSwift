//
//  GYSocialDataService.m
//  UMSocial_Sdk_Demo
//
//  Created by sqm on 16/6/2.
//  Copyright © 2016年 yeahugo. All rights reserved.
//

#import "GYSocialDataService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "UIColor+YYAdd.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "WXApi.h"
#import "pop.h"
#import "GYUtils.h"

#define topSpace 10
#define subTitleColor [UIColor colorWithHexString:@"#646464"] //副标题

@interface GYSocialDataService () <UMSocialUIDelegate>
@property (nonatomic, strong) UIViewController* presentedController;
@property (nonatomic, strong) GYSocialDataModel* model;
@end
@implementation GYSocialDataService

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initObject];
    }

    return self;
}

- (void)initObject
{
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx2f3b74a5c55acc63" appSecret:@"04c5d9f41a529e33b51eb1664e07b93b" url:@"http://www.hsxt.com"];

    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialQQHandler setQQWithAppId:@"1101128973" appKey:@"0i9VDLlPAHaYh1Hv" url:@"http://www.hsxt.com"];

    //打开调试log的开关
    [UMSocialData openLog:YES];

    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];

    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1634067607"
                                              secret:@"4554d69fa1fbc4db121e671d8b118b5a"
                                         RedirectURL:@"http://www.hsxt.com"];

    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialConfig hiddenNotInstallPlatforms:@[ UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToWechatFavorite, UMShareToQzone ]];
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionCenter];
}

+ (void)postWithSocialDataModel:(GYSocialDataModel*)model presentedController:(UIViewController*)presentedController delegate:(id<UMSocialUIDelegate>)delegate
{

    [UMSocialSnsService presentSnsIconSheetView:presentedController
                                         appKey:@"574ec7ffe0f55ad9b7000e1e"
                                      shareText:model.content
                                     shareImage:model.image
                                shareToSnsNames:@[ UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToSina, UMShareToWechatFavorite, UMShareToQzone ]
                                       delegate:delegate];
}

+ (void)postWithSocialDataModel:(GYSocialDataModel*)model presentedController:(UIViewController*)presentedController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([GYUtils checkStringInvalid:model.title] || ([GYUtils checkStringInvalid:model.toUrl])) {
            [GYUtils showToast:kLocalized(@"GYHS_Base_Share_Data_Empty")];
            return;
        }
        
        GYSocialDataService *service = [[GYSocialDataService alloc]init];
        
        service.presentedController = presentedController;
        service.model = model;
        GYSocaialShareView *shareView = [[GYSocaialShareView alloc]init];
        shareView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        shareView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        [UMSocialData defaultData].extConfig.title = model.title;
        [UMSocialData defaultData].extConfig.qqData.title = model.title;
        [UMSocialData defaultData].extConfig.qqData.url = model.toUrl;
        [UMSocialData defaultData].extConfig.qzoneData.url = model.toUrl;
        [UMSocialData defaultData].extConfig.wechatFavoriteData.url = model.toUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = model.toUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = model.toUrl;
       
        
        shareView.block = ^(GYSocialSnsType type){
            
            switch (type) {
                case GYSocialSnsTypeWechatSession:
                {
                    
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:model.content image:model.image location:model.location urlResource:model.urlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                        
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            
                            
                        }
                        
                    }];
                }
                    break;
                    
                case GYSocialSnsTypeWechatTimeline:
                {
                    
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:model.content image:model.image location:model.location urlResource:model.urlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                        
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            
                            DDLogDebug(@"分享成功！");
                            
                        }
                        
                    }];
                    
                }
                    
                    break;
                    
                case GYSocialSnsTypeMobileQQ:
                    
                    
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:model.content   image:model.image location:model.location urlResource:model.urlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            DDLogDebug(@"分享成功！");
                        }
                    }];
                    
                    
                    break;
                    
                case GYSocialSnsTypeSina:{
                    
                    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToSina] content:model.content image:model.image location:model.location urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response) {
                        DDLogDebug(@"%@",response);
                        
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            DDLogDebug(@"分享成功！");
                        }
                    }];
                    
                
                    
                }
                    break;
                    
                case GYSocialSnsTypeWechatFavorite:{
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatFavorite] content:model.content image:model.image location:model.location urlResource:model.urlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            DDLogDebug(@"分享成功！");
                        }
                    }];
                    
                    
                    
                }
                    break;
                case GYSocialSnsTypeQzone:
                {
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:model.content image:model.image location:model.location urlResource:model.urlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            DDLogDebug(@"分享成功！");
                        }
                    }];
                    
                    
                    
                }
                    break;
                default:
                    break;
            }
        };

    });
}

- (void)didFinishShareInShakeView:(UMSocialResponseEntity*)response
{
    DDLogDebug(@"finish share with response is %@", response);
}

@end
@interface GYSocaialShareView ()
@property (nonatomic, strong) UIView* shareView;
@end

@implementation GYSocaialShareView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self) {
        self = [super initWithFrame:frame];
        [self customShareView];

        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:recognizer];
    }

    return self;
}

- (void)tap
{
    [self removeFromSuperview];
}

- (UIButton*)createButtonWithFrame:(CGRect)frame title:(NSString*)title image:(UIImage*)image
{

    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    if (image) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - image.size.width) / 2, (frame.size.height - image.size.height) / 2, image.size.width, image.size.height)];
        imageView.image = image;
        [button addSubview:imageView];

        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + topSpace / 2, frame.size.width, 16)];
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = subTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];

        button.frame = CGRectMake(frame.origin.x, frame.origin.y, image.size.width, image.size.height + topSpace + 16);
    }
    return button;
}

#pragma mark自定义分享页面
- (void)customShareView
{

    NSMutableArray* textArr = @[ @"微博" ].mutableCopy;
    NSMutableArray* imageArr = @[ @"gyhe_ums_sina_icon" ].mutableCopy;
    NSMutableArray<NSNumber*>* tagArr = @[ @(GYSocialSnsTypeSina) ].mutableCopy;

    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [textArr addObjectsFromArray:@[ @"微信", @"朋友圈", @"微信收藏" ]];
        [imageArr addObjectsFromArray:@[ @"gyhe_ums_wechat_icon", @"gyhe_ums_wechat_timeline_icon", @"gyhe_ums_wechat_favorite_icon" ]];
        [tagArr addObjectsFromArray:@[ @(GYSocialSnsTypeWechatSession), @(GYSocialSnsTypeWechatTimeline), @(GYSocialSnsTypeWechatFavorite) ]];
    }

    // 检测是否安装了QQ
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {

        [textArr addObjectsFromArray:@[ @"QQ", @"QQ空间" ]];
        [imageArr addObjectsFromArray:@[ @"gyhe_ums_qq_icon", @"gyhe_ums_qzone_icon" ]];
        [tagArr addObjectsFromArray:@[ @(GYSocialSnsTypeMobileQQ), @(GYSocialSnsTypeQzone) ]];
    }

    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - (textArr.count > 3 ? 240 : 140), kScreenWidth, textArr.count > 3 ? 220 : 120)];
    self.shareView.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.shareView];
    NSMutableArray* buttonArr = [NSMutableArray array];

    for (int i = 0; i < textArr.count; i++) {

        UIButton* button = [self createButtonWithFrame:CGRectMake((i % 3 + 1) * (kScreenWidth - 240) / 4 + (i % 3) * 80, 100 * (i / 3), 80, 80) title:textArr[i] image:[UIImage imageNamed:imageArr[i]]];
        [self.shareView addSubview:button];
        button.tag = tagArr[i].integerValue;
        [button addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArr addObject:button];

        // 计算X\Y
        CGFloat buttonX = (i % 3 + 1) * (kScreenWidth - 240) / 4 + (i % 3) * 80;
        CGFloat buttonEndY = 100 * (i / 3);
        CGFloat buttonW = 80;
        CGFloat buttonH = buttonW;
        CGFloat buttonBeginY = buttonEndY - kScreenHeight;

        // 按钮动画
        POPSpringAnimation* anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = 10;
        anim.springSpeed = 10;
        anim.beginTime = CACurrentMediaTime() + 0.1 * i;
        //            [button pop_addAnimation:anim forKey:nil];
    }

    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            self.shareView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 20));

    } completion:^(BOOL finished){

    }];
}

#pragma mark分享按钮点击
- (void)shareBtnClicked:(UIButton*)btn
{
    if (self.block) {
        self.block((int)btn.tag);
    }
    [self removeFromSuperview];
   
}





@end


@implementation GYSocialDataModel

@end
