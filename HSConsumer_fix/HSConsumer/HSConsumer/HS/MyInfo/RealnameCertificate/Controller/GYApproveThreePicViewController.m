//
//  GYApproveThreePicViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  待审批

#import "GYApproveThreePicViewController.h"
#import "Animations.h"
#import "GYHSRealNameWithPassportAuthViewController.h"
#import "GYHSRealNameWithLicenceAuthViewController.h"
#import "GYPhotoGroupView.h"
#import "GYHSRealNameWithIdentifyAuthViewController.h"

@interface GYApproveThreePicViewController()

@property (nonatomic,strong) NSArray *picArray;

@end

@implementation GYApproveThreePicViewController {

    __weak IBOutlet UIView* vUpBackground;

    __weak IBOutlet UILabel* lbApplyStatus;

    __weak IBOutlet UILabel* lbApplyStatusDetail;

    __weak IBOutlet UIView* vDownBackground;

    __weak IBOutlet UIImageView* imgvPictureA;

    __weak IBOutlet UILabel* lbPictureA;

    __weak IBOutlet UIButton* btnSamplePictureA;

    __weak IBOutlet UIImageView* imgvPictureB;

    __weak IBOutlet UILabel* lbPictureB;

    __weak IBOutlet UIButton* btnSamplePictureB;

    __weak IBOutlet UIImageView* imgvPictureC;

    __weak IBOutlet UILabel* lbPictureC;

    __weak IBOutlet UIButton* btnPictureC;

    __weak IBOutlet UIView* reasonView; //驳回原因View
    __weak IBOutlet UILabel* lbReasonLeft;
    __weak IBOutlet UILabel* lbRefuseReason; //驳回具体原因

    __weak IBOutlet NSLayoutConstraint* viewPicHeight; //整个图片框的高度
    __weak IBOutlet UIView* view3; //第二行第一列的图片框
    __weak IBOutlet UIView* lbViewSeparate; //两行labelView的分割线
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");

    [self modifyName];
    [self approvalStatus];

    if ([self.status isEqualToString:kRealNameAuthStatusApproveRefuse] || [self.status isEqualToString:kRealNameAuthStatusApproveLastRefuse]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"GYHS_RealName_To_Apply_For") style:UIBarButtonItemStyleBordered target:self action:@selector(againApple)];
    }
}

- (void)againApple
{
    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        GYHSRealNameWithIdentifyAuthViewController* vc = [[GYHSRealNameWithIdentifyAuthViewController alloc] init];
        vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");

        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        GYHSRealNameWithPassportAuthViewController* vc = [[GYHSRealNameWithPassportAuthViewController alloc] init];
        vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");

        [self.navigationController pushViewController:vc animated:YES];
    }
    else {

        GYHSRealNameWithLicenceAuthViewController* vc = [[GYHSRealNameWithLicenceAuthViewController alloc] init];
        vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //设置边框
    [vUpBackground addAllBorder];
    [vDownBackground addAllBorder];
}

- (void)modifyName
{

    lbReasonLeft.text = kLocalized(@"GYHS_RealName_Dismiss_Reason");
    lbApplyStatus.text = kLocalized(@"GYHS_RealName_State");
    lbRefuseReason.text = @"sgesdghdagsdgrseg";

    NSString* strA = @"";
    NSString* strB = @"";
    NSString* strH = @"";

    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {

        lbPictureA.text = kLocalized(@"GYHS_RealName_Front_Of_Papers");
        lbPictureB.text = kLocalized(@"GYHS_RealName_Back_Of_Papers");
        lbPictureC.text = kLocalized(@"GYHS_RealName_Holding_Papers_Photos");
        strA = globalData.personInfo.creFaceImg;
        strB = globalData.personInfo.creBackImg;
        strH = globalData.personInfo.creHoldImg;
        viewPicHeight.constant = 305;
        view3.hidden = NO;
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {

        lbPictureA.text = kLocalized(@"GYHS_RealName_Passport_Documents_As");
        lbPictureB.text = kLocalized(@"GYHS_RealName_Holding_Papers_Photos");
        strA = globalData.personInfo.creFaceImg;
        strB = globalData.personInfo.creHoldImg;
        viewPicHeight.constant = 158;
        view3.hidden = YES;
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {

        lbPictureA.text = kLocalized(@"GYHS_RealName_Business_License_Certificate");
        lbPictureB.text = kLocalized(@"GYHS_RealName_Holding_Papers_Photos");
        strA = globalData.personInfo.creFaceImg;
        strB = globalData.personInfo.creHoldImg;
        viewPicHeight.constant = 158;
        view3.hidden = YES;
    }

    lbApplyStatusDetail.textColor = kNavigationBarColor;
    lbApplyStatus.textColor = kCellItemTitleColor;
    lbReasonLeft.textColor = kCellItemTitleColor;
    lbRefuseReason.textColor = kNavigationBarColor;

    lbPictureA.textColor = kCellItemTitleColor;
    lbPictureB.textColor = kCellItemTitleColor;
    lbPictureC.textColor = kCellItemTitleColor;
    [btnSamplePictureA setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePictureB setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnPictureC setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePictureA setTitle:kLocalized(@"GYHS_RealName_Column_Picture") forState:UIControlStateNormal];
    [btnSamplePictureB setTitle:kLocalized(@"GYHS_RealName_Column_Picture") forState:UIControlStateNormal];
    [btnPictureC setTitle:kLocalized(@"GYHS_RealName_Column_Picture") forState:UIControlStateNormal];
    vUpBackground.backgroundColor = [UIColor whiteColor];
    vDownBackground.backgroundColor = [UIColor whiteColor];

    [self setBtn:btnPictureC WithColor:kNavigationBarColor WithWidth:1 WithIndex:3];
    [self setBtn:btnSamplePictureA WithColor:kNavigationBarColor WithWidth:1 WithIndex:3];
    [self setBtn:btnSamplePictureB WithColor:kNavigationBarColor WithWidth:1 WithIndex:3];

    [imgvPictureA setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, strA, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];

    [imgvPictureB setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, strB, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];

    [imgvPictureC setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, strH, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];
    
    self.picArray = @[
                      [NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, strA, globalData.loginModel.custId, globalData.loginModel.token],
                      [NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, strB, globalData.loginModel.custId, globalData.loginModel.token],
                      [NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, strH, globalData.loginModel.custId, globalData.loginModel.token],
                      imgvPictureA,
                      imgvPictureB,
                      imgvPictureC
                      ];

    [self imageAddTipInfo];
}

- (void)setBtn:(UIButton*)sender WithColor:(UIColor*)color WithWidth:(CGFloat)width WithIndex:(NSInteger)buttonTag
{
    sender.layer.cornerRadius = 2.0f;
    sender.layer.borderWidth = width;
    sender.tag = buttonTag;
    sender.layer.borderColor = color.CGColor;
    sender.layer.masksToBounds = YES;
}

- (IBAction)btnSamplePicA:(id)sender
{

    UIImageView* imgv;
    UIView* backgroundView;
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
    imgv.bounds = CGRectMake(0, 0, 140 + 140 * 0.9, 90 + 90 * 0.9);

    NSString* imageName = @"hs_auth_sample_picture_a.jpg";
    if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {

        imageName = @"hs_passport.jpg";
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {

        imageName = @"hs_business_license.jpg";
    }
    imgv.image = [UIImage imageNamed:imageName];

    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [backgroundView addSubview:imgv];
    [self.view addSubview:backgroundView];

    [UIView animateWithDuration:0.24 animations:^{
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

        [Animations zoomIn:imgv andAnimationDuration:0.24 andWait:NO];

    } completion:^(BOOL finished){

    }];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenView:)];
    [backgroundView addGestureRecognizer:tap];
}

- (IBAction)btnSamplePicB:(id)sender
{
    UIImageView* imgv;
    UIView* backgroundView;
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
    imgv.bounds = CGRectMake(0, 0, 140 + 140 * 0.9, 90 + 90 * 0.9);

    NSString* imageName = @"hs_auth_sample_picture_b.jpg";
    if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {

        imageName = @"hs_passport_hold.jpg";
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
        imageName = @"hs_orgnizationPaper_hold.jpg";
    }

    imgv.image = [UIImage imageNamed:imageName];

    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [backgroundView addSubview:imgv];
    [self.view addSubview:backgroundView];

    [UIView animateWithDuration:0.24 animations:^{
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

        [Animations zoomIn:imgv andAnimationDuration:0.24 andWait:NO];

    } completion:^(BOOL finished){

    }];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenView:)];
    [backgroundView addGestureRecognizer:tap];
}

- (IBAction)btnSamplePicC:(id)sender
{
    UIImageView* imgv;
    UIView* backgroundView;
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
    imgv.bounds = CGRectMake(0, 0, 140 + 140 * 0.9, 90 + 90 * 0.9);
    imgv.image = [UIImage imageNamed:@"hs_auth_sample_picture_h.jpg"];

    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [backgroundView addSubview:imgv];
    [self.view addSubview:backgroundView];

    [UIView animateWithDuration:0.24 animations:^{
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

        [Animations zoomIn:imgv andAnimationDuration:0.24 andWait:NO];

    } completion:^(BOOL finished){

    }];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenView:)];
    [backgroundView addGestureRecognizer:tap];
}

- (void)hidenView:(UITapGestureRecognizer*)tap
{

    [UIView animateWithDuration:0.24 animations:^{
        tap.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}

- (void)approvalStatus
{

    if ([GYUtils isBlankString:self.refuseReason]) {

        lbRefuseReason.text = @"";
    }
    else {

        lbRefuseReason.text = self.refuseReason;
    }
    //驳回原因高度自适应
    lbRefuseReason.numberOfLines = 0;

    lbRefuseReason.lineBreakMode = NSLineBreakByWordWrapping;

    CGSize size = [lbRefuseReason sizeThatFits:CGSizeMake(lbRefuseReason.frame.size.width, MAXFLOAT)];

    lbRefuseReason.frame = CGRectMake(120, 0, 180, size.height);

    lbRefuseReason.font = [UIFont systemFontOfSize:14];

    [reasonView addSubview:lbRefuseReason];

    if ([self.status isEqualToString:kRealNameAuthStatusApproveRefuse] || [self.status isEqualToString:kRealNameAuthStatusApproveLastRefuse]) {

        lbApplyStatusDetail.text = kLocalized(@"GYHS_RealName_Approval_To_Dismiss");
        reasonView.hidden = NO;
        lbViewSeparate.hidden = NO;
    }else {

        lbApplyStatusDetail.text = kLocalized(@"GYHS_RealName_Pending");
        reasonView.hidden = YES;
        lbViewSeparate.hidden = YES;
    }
}

- (void)imageAddTipInfo
{
    UITapGestureRecognizer* imageATap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showApproveInfo:)];
    imageATap.cancelsTouchesInView = NO;
    imgvPictureA.userInteractionEnabled = YES;
    [imgvPictureA addGestureRecognizer:imageATap];

    UITapGestureRecognizer* imageBTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showApproveInfo:)];
    imageBTap.cancelsTouchesInView = NO;
    imgvPictureB.userInteractionEnabled = YES;
    [imgvPictureB addGestureRecognizer:imageBTap];
    
    UITapGestureRecognizer* imageCTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showApproveInfo:)];
    imageCTap.cancelsTouchesInView = NO;
    imgvPictureC.userInteractionEnabled = YES;
    [imgvPictureC addGestureRecognizer:imageCTap];
}

- (void)showApproveInfo:(UITapGestureRecognizer *)tap
{
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
    if(tap.view == imgvPictureA) {
        item.largeImageURL = [NSURL URLWithString:kSaftToNSString(self.picArray[0])];
        item.thumbView = self.picArray[3];
    }else if(tap.view == imgvPictureB) {
        item.largeImageURL = [NSURL URLWithString:kSaftToNSString(self.picArray[1])];
        item.thumbView = self.picArray[4];
    }else if(tap.view == imgvPictureC){
        item.largeImageURL = [NSURL URLWithString:kSaftToNSString(self.picArray[2])];
        item.thumbView = self.picArray[5];
    }
    if(item == nil) {
        return;
    }
    [items addObject:item];
    GYPhotoGroupView* v = [[GYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:tap.view toContainer:self.navigationController.view animated:YES completion:nil];
}
@end
