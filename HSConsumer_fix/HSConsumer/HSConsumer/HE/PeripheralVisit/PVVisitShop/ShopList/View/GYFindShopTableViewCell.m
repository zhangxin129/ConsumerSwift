//
//  GYFindShopTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define KDetailFont [UIFont systemFontOfSize:13]
#define KTitleFont [UIFont systemFontOfSize:15]

#import "GYFindShopTableViewCell.h"

//#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h> //引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h> //引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h> //引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h> //引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h> //引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h> //只引入所需的单个头文件

@implementation GYFindShopTableViewCell {
    __weak IBOutlet UIImageView* imgvShopImage;

    __weak IBOutlet UILabel* lbShopTitle;
    __weak IBOutlet UILabel* lbShopAddress;

    __weak IBOutlet UILabel* lbDistance;
    __weak IBOutlet UIImageView* imgvLocation;

    __weak IBOutlet UILabel* lbComment;

    __weak IBOutlet UILabel* lbHsNumber;

    NSString* phoneNumber;
}
- (void)awakeFromNib
{
    // Initialization code
    lbShopTitle.textColor = kNavigationBarColor;
    lbShopAddress.textColor = kCellItemTextColor;
    //    lbShopTel.textColor = kCellItemTextColor;
    lbDistance.textColor = kCellItemTextColor;
    lbComment.textColor = kCellItemTextColor;
    lbHsNumber.textColor = kCellItemTextColor;
    imgvLocation.image = [UIImage imageNamed:@"gyhe_map_icon.png"];
    [self.btnShopTel setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    lbShopTitle.font = KTitleFont;
    lbShopAddress.font = KDetailFont;
    //    lbShopTel.font = [UIFont systemFontOfSize:11];
    lbDistance.font = KDetailFont;
    lbComment.font = KDetailFont;
    lbHsNumber.font = [UIFont systemFontOfSize:12];
    lbHsNumber.adjustsFontSizeToFitWidth = YES;
    self.btnShopTel.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUIWith:(ShopModel*)model
{

    self.model = model;
    [imgvShopImage setImageWithURL:[NSURL URLWithString:model.strShopPictureURL] placeholder:kLoadPng(@"gycommon_image_placeholder") options:kNilOptions completion:nil];

    //所有高度重新计算
    //    CGFloat  height = [GYUtils heightForString:model.strShopName fontSize:17.0 andWidth:190.0];
    //    CGRect frame = lbShopTitle.frame;
    //    frame.size.height=height;
    //    lbShopTitle.frame=frame;
    BOOL str = [GYUtils isBlankString:model.strCompanyName];
    lbShopTitle.text = [model.strCompanyName isEqualToString:@"<null>"] || str == YES ? [NSString stringWithFormat:@""] : model.strCompanyName;
    lbHsNumber.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_SurroundVisit_PointsCardNumber"), model.strResno];

    phoneNumber = model.strShopTel;
    [self.btnShopTel setTitle:[NSString stringWithFormat:@"%@", model.strShopTel] forState:UIControlStateNormal];

    lbDistance.text = [NSString stringWithFormat:@"%.1fkm", model.shopDistance.floatValue]; // modify by songjk
    if (!model.strRate.length > 0) {
        model.strRate = @"0.00";
    }
    // modify by songjk
    CGFloat fRate = [model.strRate floatValue];
    NSString* strRate = [NSString stringWithFormat:@"%.1f", fRate];
    lbComment.text = [NSString stringWithFormat:@"%@%@%%", kLocalized(@"GYHE_SurroundVisit_GoodComments"), strRate];

    lbShopAddress.text = [NSString stringWithFormat:@"%@", model.strShopAddress];

    CGFloat border = 10;
    CGSize distanceSize = [GYUtils sizeForString:lbDistance.text font:KDetailFont width:200];
    lbDistance.frame = CGRectMake(self.frame.size.width - distanceSize.width - border, lbDistance.frame.origin.y, distanceSize.width, lbDistance.frame.size.height);
    imgvLocation.frame = CGRectMake(lbDistance.frame.origin.x - imgvLocation.frame.size.width - 5, imgvLocation.frame.origin.y, imgvLocation.frame.size.width, imgvLocation.frame.size.height);
    lbShopTitle.frame = CGRectMake(CGRectGetMaxX(imgvShopImage.frame) + 10, lbShopTitle.frame.origin.y, imgvLocation.frame.origin.x - CGRectGetMaxX(imgvShopImage.frame) - 10 - 5, lbShopTitle.frame.size.height);

    [self setIconCout];
}

- (void)setIconCout
{
#if 0
    // add by songjk
    NSArray *arrData = [NSArray arrayWithObjects:
                        self.model.beReach,
                        self.model.beSell,
                        self.model.beCash,
                        self.model.beTake,
                        self.model.beTicket,
                        nil];


    NSMutableArray *marrUseData = [NSMutableArray array];
    for (int i = (arrData.count - 1); i > -1; i--) {
        NSString *str = arrData[i];
        if ([str isEqualToString:@"1"]) {
            NSNumber *num = [NSNumber numberWithInt:i+1];
            [marrUseData addObject:num];
        }
    }
    CGFloat iconWith = 15;
    // add bysongjk
    for (int i = 25; i < 30; i++) {
        UIView *view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < marrUseData.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 25+i;
        imageView.frame = CGRectMake(kScreenWidth-10-iconWith*(i+1), 30, iconWith, iconWith);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail%ld", (long)[marrUseData[i] integerValue]]];
        [self addSubview:imageView];

    }
#endif

    //add by zhnagqy  iOS消费者--轻松购--商品展示列表中特色服务排列建议与安卓（UI）一致
    NSArray* arrData = [NSArray arrayWithObjects:
                                    self.model.beTicket,
                                self.model.beReach,
                                self.model.beSell,
                                self.model.beCash,
                                self.model.beTake,
                                nil];
    NSArray* imageNames = @[ @"gyhe_good_detail5", @"gyhe_good_detail1", @"gyhe_good_detail2", @"gyhe_good_detail3", @"gyhe_good_detail4" ];
    CGFloat iconWith = 15;
    for (int i = 25; i < 30; i++) {
        UIView* view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
    NSInteger index = arrData.count - 1;
    for (NSInteger i = index, j = index; i >= 0; i--, j--) {
        UIImageView* imageView = [[UIImageView alloc] init];

        if ([arrData[i] isEqualToString:@"1"]) {
            imageView.tag = 25 + j;
            imageView.frame = CGRectMake(kScreenWidth - 10 - iconWith * (index - j + 1), 30, iconWith, iconWith);
            imageView.image = [UIImage imageNamed:imageNames[i]];
            [self addSubview:imageView];
        }
        else {
            j++;
        }
    }
}

//- (IBAction)btnPhoneCall:(id)sender {
//
//    JGActionSheetSection * ass0 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"呼叫号码"] buttonStyle:JGActionSheetButtonStyleRed];
//    JGActionSheetSection * ass1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[kLocalized(@"cancel_collection")] buttonStyle:JGActionSheetButtonStyleBlue];
//    NSArray *asss = @[ass0, ass1];
//    JGActionSheet *as = [[JGActionSheet alloc] initWithSections:asss];
//    as.delegate = self;
//
//    [as setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
//
//        switch (indexPath.section) {
//            case 0:
//            {
//                if (indexPath.row == 0)
//                {
//                    DDLogDebug(@"呼叫号码");
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
//                }else if (indexPath.row == 1)
//                {
//                    DDLogDebug(@"复制号码");
//                }
//            }
//                break;
//            case 1:
//            {
//                DDLogDebug(@"取消");
//            }
//                break;
//                break;
//
//            default:
//                break;
//        }
//
//        [sheet dismissAnimated:YES];
//    }];
//
//    [as setCenter:CGPointMake(100, 100)];
//
//    [as showInView:self animated:YES];
//}

@end
