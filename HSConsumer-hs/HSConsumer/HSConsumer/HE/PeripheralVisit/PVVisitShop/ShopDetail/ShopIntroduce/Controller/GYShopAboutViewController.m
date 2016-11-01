//
//  GYShopAboutViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define hotGoodIdentifier @"hotGood"
#define locationCellIdentifier @"locationCell"
#define allshopCell @"allShopCell"
#define pageCount 6
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "GYShopAboutViewController.h"
#import "GYShopheaderView.h"
#import "YYWebImageManager.h"
#import "GYSocialDataService.h"
#import "GYShopInfoWithLocationCell.h"
//热卖商品的cell
#import "GYShopDetailHotGoodTableViewCell.h"
//星星的cell
#import "GYStarTableViewCell.h"
#import "GYCitySelectViewController.h"
#import "GYBMKViewController.h"
#import "GYShopItem.h"
#import "GYGoodDetailListTableViewCell.h"
#import "NSString+YYAdd.h"
#import "GYEasyBuyModel.h"
#import "GYAllShopTableViewCell.h"
#import "SearchGoodModel.h"
#import "GYGoodIntroductionCell.h"
#import "GYGoodIntroductionModel.h"
#import "GYGIFHUD.h"
#import "UIView+Extension.h"
#import "GYPhotoGroupView.h"
#import "GYMallBaseInfoModel.h"
#import "MJExtension.h"
#import "GYHSLoginViewController.h"
#import "GYHDChatViewController.h"
#import "GYHSLoginManager.h"
#import "GYAlertView.h"


@interface GYShopAboutViewController () {
    UIImageView* imgvArrow; //箭头
    UIImageView* imgvArrow2; //箭头
    CGAffineTransform rotationTransform;
    CGAffineTransform rotationTransform2;

    NSInteger totalPage;
    SearchGoodModel* GoodModel;
    NSInteger currentIndex;
    UITableView* diaosiTableview;
    GYShopInfoWithLocationCell* locationCell;
    GYStarTableViewCell* starCell;
    CLLocationCoordinate2D coordinate;
    UIButton* btnRight;
    NSMutableArray* marrDatasorce;
    ShopModel* shopInfo;
    GYShopheaderView* header;
    NSMutableArray* marrShopItem;
    BOOL isShow;
    BOOL isShowIntroduction;
    NSInteger rows; //控制查看店铺的行数
    NSInteger rowsIntroduction;
    NSMutableArray* marrHotGoods;
    BOOL isAttention;
    NSInteger currentPage; //当前页码

    NSString* shareContent; ///分享内容
    UIImageView* myImageview;
    NSString* strShopUrl; ////商铺Url
}
//**店铺详细*/
@property (nonatomic, strong) GYMallBaseInfoModel* mallDetailInfo;
/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView* loadingView;
/**
 *  面板
 */
@property (nonatomic, strong) UIView* panelView;
@property (nonatomic, assign) BOOL hadContact;

@end

@implementation GYShopAboutViewController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHE_SurroundVisit_ShopsIntroduction");
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.hadContact = NO;
}




#pragma mark selectcity 代理方法
- (void)getCity:(NSString*)CityTitle
{
    [btnRight setTitle:CityTitle forState:UIControlStateNormal];
}
#pragma mark UIScrollView 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (scrollView == header.srcView) {
        header.PageControl.currentPage = pageIndex;
        UIImageView* imageViewPic = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        [imageViewPic setBackgroundColor:[UIColor whiteColor]];
        [imageViewPic setContentMode:UIViewContentModeScaleAspectFit];
        [imageViewPic setImageWithURL:[NSURL URLWithString:shopInfo.marrShopImages[pageIndex][@"url"]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        imageViewPic.tag = 400 + pageIndex;
        [scrollView addSubview:imageViewPic];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    currentIndex = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
}

#pragma mark TableViewDataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
    case 0:
        return 1;
        break;
    case 1: {
        return rows;
    } break;
    case 2: {
        return rowsIntroduction;
    } break;
    case 3:
        return 1;
        break;
    case 4: {
        int hotRows;
        if (marrHotGoods.count % 2 == 0) {
            hotRows = marrHotGoods.count / 2.f;
        }
        else {
            hotRows = marrHotGoods.count / 2.f + 1;
        }

        return hotRows;
    } break;
    default:
        break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
   
    switch (indexPath.section) {
    case 0: {
        //店铺简介 修改
        CGFloat startHeight = 12;
         CGFloat heightStoreName = [GYUtils heightForString:[NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_SurroundVisit_PointsCardNumber"), shopInfo.strResourceNumber] fontSize:15.0 andWidth:kScreenWidth -109];
        CGFloat heightAddress = [GYUtils heightForString:shopInfo.strShopAddress fontSize:15.0 andWidth:kScreenWidth -109] ;        CGFloat totalHeight = startHeight + heightStoreName + heightAddress + 15 + 8 + 10;
        return totalHeight > 80 ? totalHeight : 80;
    } break;
    case 1: {
        if(marrShopItem.count > indexPath.row) {
            GYShopItem* shopItem = marrShopItem[indexPath.row];
            return [kSaftToNSString(shopItem.strAddr) heightForFont:[UIFont systemFontOfSize:14] width:210] + 35;

        }
        return 0;
    }

    break;
    case 2: {
        CGFloat height = 30;
        if ([shopInfo.strIntroduce isKindOfClass:[NSNull class]]) {
        }
        else {
            GYGoodIntroductionModel* model = [[GYGoodIntroductionModel alloc] init];
            model.strData = shopInfo.strIntroduce;
            height = model.fHight > height ? (model.fHight + 20) : (model.fHight + 30);
        }
        return height;
        break;
    } break;
    case 3:
        return 40.f;
        break;
    case 4:
        return 211.f;
        break;
    default:
        break;
    }
    return 0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
    case 0:
        return nil;
        break;
    case 1: {
        return [self checkAllShop];
    }
        break;
    case 2: {
        return [self seeShopIntroduction];
        
    }
        break;
    case 3: {
        return [self blankView];
    }
    break;
    case 4: {
        return [self hotGoodView];
    }
        return nil;
        break;
    default:
        break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
    case 0:
        return 0;
        break;
    case 1:
        return 44;
        break;
    case 2:
        return 44;
        break;
    case 3:
        return 0;
        break;
    case 4:
        return 30;
        break;
    default:
        break;
    }

    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = nil;
    GYAllShopTableViewCell* AllShopCell = [tableView dequeueReusableCellWithIdentifier:allshopCell];
    switch (indexPath.section) {
    case 0: {
        locationCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYShopInfoWithLocationCell class]) owner:self options:nil] lastObject];
        locationCell.lbHsNumber.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_SurroundVisit_PointsCardNumber"), shopInfo.strResourceNumber];
        locationCell.lbShopAddress.text =  shopInfo.strShopAddress;
        CGFloat heightStoreName = [GYUtils heightForString:locationCell.lbHsNumber.text fontSize:15.0 andWidth:kScreenWidth -109];
        CGFloat heightAddress = [GYUtils heightForString:shopInfo.strShopAddress fontSize:15.0 andWidth:kScreenWidth -109] ;
        CGRect frameShopName = locationCell.lbHsNumber.frame;
        frameShopName.size.height = heightStoreName > 27 ? heightStoreName : 27;
        locationCell.lbHsNumber.frame = frameShopName;


        CGRect frameShopAddress = locationCell.lbShopAddress.frame;
        frameShopAddress.size.height = heightAddress > 15 ? heightAddress : 15;
        frameShopAddress.origin.y = locationCell.lbHsNumber.frame.origin.y + locationCell.lbHsNumber.frame.size.height;
        locationCell.lbShopAddress.frame = frameShopAddress;

        CGRect frameTel = locationCell.btnPhoneCall.frame;
        frameTel.origin.y = locationCell.lbShopAddress.frame.origin.y + (heightAddress > 15 ? heightAddress : 15);
        locationCell.btnPhoneCall.frame = frameTel;

        [locationCell.btnPhoneCall setTitle:shopInfo.strShopTel forState:UIControlStateNormal];
        [locationCell.btnPhoneCall addTarget:self action:@selector(CallShop:) forControlEvents:UIControlEventTouchUpInside];
        locationCell.lbDistance.text = [NSString stringWithFormat:@"%.1fkm", self.strShopDistance.floatValue];

        [locationCell.btnCheckMap addTarget:self action:@selector(GoToBmkVc) forControlEvents:UIControlEventTouchUpInside];

        cell = locationCell;
    } break;
    case 1: {
        if (AllShopCell == nil) {
            AllShopCell = [[GYAllShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allshopCell];
        }
        if(marrShopItem.count > indexPath.row) {
            GYShopItem* shopItem = marrShopItem[indexPath.row];
            
            AllShopCell.lbAddr.text = [NSString stringWithFormat:@"%@", kSaftToNSString(shopItem.strAddr)];
            AllShopCell.lbAddr.height = [AllShopCell.lbAddr.text heightForFont:[UIFont systemFontOfSize:14] width:210];
            
            AllShopCell.backgroundColor = kDefaultVCBackgroundColor;
            [AllShopCell.btnShopTel setTitle:[NSString stringWithFormat:@"%@", kSaftToNSString(shopItem.strTel)] forState:UIControlStateNormal];
            AllShopCell.lbDistance.text = [NSString stringWithFormat:@"%.1fkm", [shopItem.strDistance doubleValue]];
            
            UIFont* font = [UIFont systemFontOfSize:13];
            AllShopCell.lbDistance.font = font;
            CGFloat boder = 10;
            CGSize distanctSize = [GYUtils sizeForString:AllShopCell.lbDistance.text font:font width:200];
            AllShopCell.lbDistance.frame = CGRectMake(kScreenWidth - distanctSize.width - boder, AllShopCell.height * 0.5 - distanctSize.height, distanctSize.width, AllShopCell.lbDistance.height);
            AllShopCell.imgDistance.frame = CGRectMake(AllShopCell.lbDistance.x - AllShopCell.imgDistance.width - 5, AllShopCell.height * 0.5 - AllShopCell.imgDistance.height, AllShopCell.imgDistance.width, AllShopCell.imgDistance.height);
            
            cell = AllShopCell;
            [AllShopCell.btnShopTel addTarget:self action:@selector(CallShop:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }

    break;
    case 2: {

        GYGoodIntroductionModel* model = [[GYGoodIntroductionModel alloc] init];
        model.strData = shopInfo.strIntroduce;
        GYGoodIntroductionCell* goodInfoCell = [GYGoodIntroductionCell cellWithTableView:tableView];
        goodInfoCell.model = model;
        cell = goodInfoCell;
    } break;
    case 3: {
        starCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYStarTableViewCell class]) owner:self options:nil] lastObject];
        starCell.lbPoint.text = shopInfo.strRate;
        switch ([shopInfo.strRate intValue]) {
        case 0: {
            starCell.btnStar1.selected = NO;
            starCell.btnStar2.selected = NO;
            starCell.btnStar3.selected = NO;
            starCell.btnStar4.selected = NO;
            starCell.btnStar5.selected = NO;
        } break;
        case 1: {
            starCell.btnStar1.selected = YES;
            starCell.btnStar2.selected = NO;
            starCell.btnStar3.selected = NO;
            starCell.btnStar4.selected = NO;
            starCell.btnStar5.selected = NO;
        } break;
        case 2: {
            starCell.btnStar1.selected = YES;
            starCell.btnStar2.selected = YES;
            starCell.btnStar3.selected = NO;
            starCell.btnStar4.selected = NO;
            starCell.btnStar5.selected = NO;
        } break;
        case 3: {
            starCell.btnStar1.selected = YES;
            starCell.btnStar2.selected = YES;
            starCell.btnStar3.selected = YES;
            starCell.btnStar4.selected = NO;
            starCell.btnStar5.selected = NO;
        } break;
        case 4: {
            starCell.btnStar1.selected = YES;
            starCell.btnStar2.selected = YES;
            starCell.btnStar3.selected = YES;
            starCell.btnStar4.selected = YES;
            starCell.btnStar5.selected = NO;
        } break;
        case 5: {
            starCell.btnStar1.selected = YES;
            starCell.btnStar2.selected = YES;
            starCell.btnStar3.selected = YES;
            starCell.btnStar4.selected = YES;
            starCell.btnStar5.selected = YES;
        } break;

        default:
            break;
        }
        starCell.lbEvaluatePerson.text = [NSString stringWithFormat:@"%@%@", shopInfo.strEvacount, kLocalized(@"GYHE_SurroundVisit_PeopleEvaluate")];

        [starCell.contentView addTopBorder];
        cell = starCell;

    } break;

    default:
        break;
    }

    return cell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
     DDLogInfo(@"%lu:section ",indexPath.section);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
    case 3: {
    } break;
    case 1: {
        if(marrShopItem.count > indexPath.row) {
            GYShopItem* shopItem = marrShopItem[indexPath.row];
            GYBMKViewController* vcBMK = [[GYBMKViewController alloc] initWithNibName:NSStringFromClass([GYBMKViewController class]) bundle:nil];
            vcBMK.strShopId = shopItem.strShopId;
            coordinate.latitude = [shopItem.strLat floatValue];
            coordinate.longitude = [shopItem.strLongitude floatValue];
            vcBMK.coordinateLocation = coordinate;
            [self.navigationController pushViewController:vcBMK animated:YES];
        }
        
    } break;
    default:
        break;
    }
}

#pragma mark 点击事件
//分享按钮
- (void)sharebtnrating:(UIButton*)sender
{
    
    GYSocialDataModel* model = [[GYSocialDataModel alloc] init];
    //创建分享参数
    NSInteger maxlength = 140;
    shareContent = [NSString stringWithFormat:@"%@   %@", strShopUrl, shopInfo.strShopName];
    if (shareContent.length > maxlength) {
        shareContent = [shareContent substringToIndex:maxlength];
    }
    model.content = shareContent;
    model.title = shopInfo.strShopName;
    model.toUrl = strShopUrl;
    YYWebImageManager* manager = [YYWebImageManager sharedManager];
    if (shopInfo.marrShopImages.count > 0) {
        NSDictionary* dic = shopInfo.marrShopImages[0];
        [manager requestImageWithURL:[NSURL URLWithString:dic[@"url"]] options:kNilOptions progress:nil transform:nil completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error) {
            if (!error) {
                model.image = image;
            }
            [GYSocialDataService postWithSocialDataModel:model  presentedController:self];
            
        }];
    }
    else {
        
        [GYSocialDataService postWithSocialDataModel:model presentedController:self];
    }
}


- (void)CallShop:(UIButton*)sender
{
    NSString* phoneNumber = sender.currentTitle;
    //传递号码，还有ActionSheet显示视图
    [GYUtils callPhoneWithPhoneNumber:phoneNumber showInView:self.view];
}
- (void)GoToBmkVc
{
    CLLocationCoordinate2D coordinateShop;
    coordinateShop.latitude = [shopInfo.strLat floatValue];
    coordinateShop.longitude = [shopInfo.strLongitude floatValue];
    GYBMKViewController* vcBMK = [[GYBMKViewController alloc] initWithNibName:NSStringFromClass([GYBMKViewController class]) bundle:nil];
    vcBMK.strShopId = shopInfo.strShopId;
    vcBMK.coordinateLocation = coordinateShop;
    [self.navigationController pushViewController:vcBMK animated:YES];
}

- (void)btnClicked:(UIButton*)sender
{
    sender.selected = YES;
}

- (void)btnCheck
{
    isShow = !isShow;
    [UIView animateWithDuration:0.3 animations:^{
        rotationTransform = CGAffineTransformRotate(self.imgvArrow.transform, DEGREES_TO_RADIANS(180));
        self.imgvArrow.transform = rotationTransform;
    } completion:^(BOOL finished) {
        if (isShow) {
            rows = marrShopItem.count;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [diaosiTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            rows = 0;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [diaosiTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)concernShopRequest
{
    kCheckLogined
    header.btnAttention.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        header.btnAttention.enabled = YES;
        
    });
    //已经关注  就取消关注
    if (isAttention) {
        [GYGIFHUD show];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%@", shopInfo.strVshopId] forKey:@"vShopId"];
        [dict setValue:shopInfo.strShopId forKey:@"shopId"];
        [dict setValue:globalData.loginModel.token forKey:@"key"];
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:CancelConcernShopUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if (!error) {
                NSDictionary *ResponseDic = responseObject;
                if (!error) {
                    NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"]) {
                        isAttention = !isAttention;
                        header.btnAttention.selected = NO;
                        [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_CancelShopFocusSuccess")];
                    } else {
                        [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_CancelShopFail")];
                    }
                }
            }else {
                [GYUtils parseNetWork:error resultBlock:nil];
            }
        }];
        [request start];
    }
    else {
        
        [GYGIFHUD show];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        
        if(![GYUtils checkStringInvalid:shopInfo.strVshopId]) {
            [dict setValue:[NSString stringWithFormat:@"%@", shopInfo.strVshopId] forKey:@"vShopId"];
            [dict setValue:globalData.loginModel.token forKey:@"key"];
            [dict setValue:shopInfo.strShopId forKey:@"shopId"];
            [dict setValue:shopInfo.strVshopId forKey:@"vShopId"];
            //add by zhangqy 店名最长显示30字
            [dict setValue:shopInfo.strShopName forKey:@"shopName"];
        }
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:ConcernShopUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if (!error) {
                NSDictionary *ResponseDic = responseObject;
                if (!error) {
                    NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"]) {
                        isAttention = !isAttention;
                        header.btnAttention.selected = YES;
                        [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_FocusShopSuccess")];
                    } else if ([retCode isEqualToString:@"855"]) {
                        
                        [GYAlertView showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater") confirmBlock:^{
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }];
                        
                    } else {
                        [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_FocusFail")];
                        
                    }
                }
            }else {
                [GYUtils parseNetWork:error resultBlock:nil];
            }
        }];
        [request start];
    }
}

//联系商家请求
- (void)contactShopRequest
{
    if (!shopInfo.strResourceNumber || [shopInfo.strResourceNumber isKindOfClass:[NSNull class]]) { //空
        [self alertContact];
        return;
    }
    
    if (!globalData.loginModel.token || [globalData.loginModel.token isKindOfClass:[NSNull class]]) { //空
        [self alertContact];
        return;
    }
    
    if (!self.hadContact) {
        self.hadContact = YES;
        
        kCheckLogined
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopShortlyInfoUrl parameters:@{ @"key" : kSaftToNSString(globalData.loginModel.token),@"resourceNo" : kSaftToNSString(shopInfo.strResourceNumber) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
              if (!error) {
                  NSDictionary *ResponseDic = responseObject;
                  if (!error) {
                      NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                      if ([retCode isEqualToString:@"200"] && [ResponseDic isKindOfClass:[NSDictionary class]]) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              GYHDChatViewController *chatViewController = [[GYHDChatViewController alloc] init];
                              chatViewController.companyInformationDict = responseObject;
                              [self.navigationController pushViewController:chatViewController animated:YES];
                              
                          });
                      }
                  }
              }else {
                  [GYUtils parseNetWork:error resultBlock:nil];
              }
          }];
        [request start];
    }
}


#pragma mark 自定义方法
//加载店铺信息
- (void)httpRequestForShopInfo
{
    
    NSString* str;
    if (globalData.selectedCityCoordinate) {
        str = globalData.selectedCityCoordinate;
    }
    else {
        str = [NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude];
    }
    
    [GYMallBaseInfoModel loadBigShopDataWithVshopid:self.strVshopId landMark:str result:^(NSDictionary* dictData, NSError* error, NSString* retCode) {
        if (error.code == 855) {
            [GYAlertView showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater")
                        confirmBlock:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
            return;
        }
        if (!dictData) {
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_RequestError")];
            shopInfo.strVshopId = nil;
            
        }  else {
            // modify by songjk 防止空数据 加上 kSaftToNSString
            NSDictionary *ResponseDic = dictData;
            shopInfo.strShopName = ResponseDic[@"vShopName"];
            strShopUrl = ResponseDic[@"vShopUrl"];
            if (kSaftToNSString(ResponseDic[@"rate"]).length > 0) {
                shopInfo.strRate = [NSString stringWithFormat:@"%.01f", [ResponseDic[@"rate"] floatValue]];
            } else {
                shopInfo.strRate = @"0.0";
            }
            
            if ([ResponseDic[@"introduce"] isKindOfClass:[NSNull class]]) {
                shopInfo.strIntroduce = @" ";
            } else {
                shopInfo.strIntroduce = ResponseDic[@"introduce"];
                
            }
            shopInfo.marrShopImages = ResponseDic[@"picList"];
            shopInfo.marrAllShop = ResponseDic[@"shops"];
            shopInfo.strVshopId = self.strVshopId;
            shopInfo.strResourceNumber = kSaftToNSString(ResponseDic[@"companyResourceNo"]);
            
            shopInfo.strStoreName = kSaftToNSString(ResponseDic[@"vShopName"]);// add by songjk;
            shopInfo.befocus = [ResponseDic[@"beFocus"] boolValue];
            
            if (shopInfo.befocus) {
                header.btnAttention.selected = YES;
                isAttention = YES;//已关注
            } else {
                header.btnAttention.selected = NO;
                isAttention = NO;//没有关注
            }
            
            NSArray *arrShops = ResponseDic[@"shops"];
            for (int i = 0; i < arrShops.count; i++) {
                NSDictionary *temDict = arrShops[i];
                GYShopItem *shopItem = [[GYShopItem alloc] init];
                shopItem.strShopId = kSaftToNSString(temDict[@"id"]);
                shopItem.strLat = kSaftToNSString(temDict[@"lat"]);
                shopItem.strLongitude = kSaftToNSString(temDict[@"longitude"]);
                shopItem.strTel = kSaftToNSString(temDict[@"tel"]);
                shopItem.strAddr = kSaftToNSString(temDict[@"addr"]);
                if ([[temDict allKeys] containsObject:@"dist"]) {
                    shopItem.strDistance = kSaftToNSString(temDict[@"dist"]);
                } else {
                    CLLocationCoordinate2D shopCoordinate;
                    shopCoordinate.latitude = [kSaftToNSString(temDict[@"lat"]) floatValue];
                    shopCoordinate.longitude = [kSaftToNSString(temDict[@"longitude"]) floatValue];
                    BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
                    mp1 = BMKMapPointForCoordinate(globalData.locationCoordinate);
                    CLLocationDistance dis = BMKMetersBetweenMapPoints(mp1, mp2);
                    shopItem.strDistance = [NSString stringWithFormat:@"%.1f", dis/1000];
                }
                [marrShopItem addObject:shopItem];
                if (i == 0) {
                    NSString *strTel = shopItem.strTel;
                    if (strTel || strTel.length > 0) {
                        shopInfo.strShopTel = strTel;
                    } else {
                        shopInfo.strShopTel = @" ";
                    }
                    shopInfo.strLongitude = shopItem.strLongitude;
                    shopInfo.strLat = shopItem.strLat;
                    shopInfo.strShopAddress = shopItem.strAddr;
                    shopInfo.strShopId = shopItem.strShopId;
                    shopInfo.strShopDistance = shopItem.strDistance;
                }
            }
            self.strShopDistance = [NSString stringWithFormat:@"%@", shopInfo.strShopDistance];
            [header setShopInfo:shopInfo];
            diaosiTableview.tableHeaderView = header;
            [diaosiTableview reloadData];
        }
    }];
}

//添加headerview
- (void)addHeadview
{
    header = [[GYShopheaderView alloc] initWithShopModel:CGRectMake(0, 0, kScreenWidth, 360) WithOwer:self];
    [header.btnAttention addTarget:self action:@selector(concernShopRequest) forControlEvents:UIControlEventTouchUpInside];
    [header.btnCollect addTarget:self action:@selector(contactShopRequest) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic)];
    [header.srcView addGestureRecognizer:tap];
    diaosiTableview.tableHeaderView = header;
}

- (void)showBigPic
{
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0, max = shopInfo.marrShopImages.count; i < max; i++) {
        GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
        item.largeImageURL = [NSURL URLWithString:kSaftToNSString(shopInfo.marrShopImages[i][@"url"])];
        item.thumbView = [header.srcView viewWithTag:400 + i];
        [items addObject:item];
    }
    
    GYPhotoGroupView* v = [[GYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:[header.srcView viewWithTag:header.PageControl.currentPage+400] toContainer:self.navigationController.view animated:YES completion:nil];
}

- (UIView*)seeShopIntroduction
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    v.backgroundColor = [UIColor whiteColor];
    UIButton* btnChechShop = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChechShop.frame = CGRectMake(kDefaultMarginToBounds, 0, kScreenWidth, 43);
    btnChechShop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnChechShop.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btnChechShop setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChechShop setTitle:kLocalized(@"GYHE_SurroundVisit_ShopsIntroduce") forState:UIControlStateNormal];
    [btnChechShop addTarget:self action:@selector(seeIntroduction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - kDefaultMarginToBounds - 20, 15, 18, 10)];
    imageViewArrow.image = [UIImage imageNamed:@"gyhe_down_arrow"];
    if (isShowIntroduction) {
        imageViewArrow.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        imageViewArrow.transform = CGAffineTransformMakeRotation(0);
    }
    [v addSubview:btnChechShop];
    [v addAllBorder];
    [v addSubview:imageViewArrow];
    return v;
}

- (void)seeIntroduction
{
    DDLogDebug(@"查看简介");
    //一个section刷新
    isShowIntroduction = !isShowIntroduction;
    [UIView animateWithDuration:0.3 animations:^{
        rotationTransform2 = CGAffineTransformRotate(self.imgvArrow2.transform, DEGREES_TO_RADIANS(180));
        self.imgvArrow2.transform = rotationTransform2;
    } completion:^(BOOL finished) {
        if (isShowIntroduction) {
            rowsIntroduction = 1;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
            [diaosiTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            rowsIntroduction = 0;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
            [diaosiTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)alertContact
{
    [GYAlertView showMessage:kLocalized(@"GYHE_SurroundVisit_ServerNotRespond_PleaseTry_AgainLater") confirmBlock:nil];
    
}
- (void)initView
{
    myImageview = [[UIImageView alloc] init];
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
    
    diaosiTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    diaosiTableview.dataSource = self;
    diaosiTableview.delegate = self;
    marrDatasorce = [NSMutableArray array];
    marrShopItem = [NSMutableArray array];
    marrHotGoods = [NSMutableArray array];
    CGRect rect = diaosiTableview.frame;
    shopInfo = [[ShopModel alloc] init];
    
    currentPage = 1;
    UIView* backgroundView = [[UIView alloc] initWithFrame:rect];
    backgroundView.backgroundColor = kDefaultVCBackgroundColor;
    diaosiTableview.backgroundView = backgroundView;
    diaosiTableview.delegate = self;
    diaosiTableview.dataSource = self;
    diaosiTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:[UIImage imageNamed:@"gyhe_share_shop.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(sharebtnrating:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rig = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rig; //////分享
    
    rotationTransform = CGAffineTransformRotate(imgvArrow.transform, DEGREES_TO_RADIANS(360));
    rotationTransform2 = CGAffineTransformRotate(imgvArrow.transform, DEGREES_TO_RADIANS(360));
    
    [diaosiTableview registerNib:[UINib nibWithNibName:NSStringFromClass([GYShopInfoWithLocationCell class]) bundle:nil] forCellReuseIdentifier:locationCellIdentifier];
    [diaosiTableview registerNib:[UINib nibWithNibName:NSStringFromClass([GYShopDetailHotGoodTableViewCell class]) bundle:nil] forCellReuseIdentifier:hotGoodIdentifier];
    [diaosiTableview registerNib:[UINib nibWithNibName:NSStringFromClass([GYAllShopTableViewCell class]) bundle:nil] forCellReuseIdentifier:allshopCell];
    [self.view addSubview:diaosiTableview];
    [self addHeadview];
    [self getCurrentLocation];
}
/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag) {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else {
        [self.panelView removeFromSuperview];
    }
}

- (UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)getCurrentLocation
{
    [self httpRequestForShopInfo];
}

- (void)setBorderWithView:(UIButton*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor*)color
{
    [view setTitleColor:color forState:UIControlStateNormal];
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
}

#pragma mark 懒加载
- (UIView*)hotGoodView
{
    UIView* vHotGood = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    vHotGood.backgroundColor = kDefaultVCBackgroundColor;
    UILabel* lbHotGood = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultMarginToBounds, 0, 100, 25)];
    lbHotGood.text = kLocalized(@"GYHE_SurroundVisit_HotGood");
    lbHotGood.backgroundColor = [UIColor clearColor];
    lbHotGood.font = [UIFont systemFontOfSize:15.0f];
    lbHotGood.textColor = kCellItemTitleColor;
    [vHotGood addSubview:lbHotGood];
    [vHotGood addTopBorder];
    
    return vHotGood;
}

- (UIView*)blankView
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    v.backgroundColor = kDefaultVCBackgroundColor;
    [v addTopBorder];
    return v;
}

- (UIImageView*)imgvArrow
{
    if (imgvArrow == nil) {
        imgvArrow = [[UIImageView alloc] init];
        imgvArrow.frame = CGRectMake(kScreenWidth - kDefaultMarginToBounds - 20, 15, 18, 10);
        imgvArrow.userInteractionEnabled = NO;
        imgvArrow.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        imgvArrow.contentMode = UIViewContentModeScaleAspectFit;
        imgvArrow.image = [UIImage imageNamed:@"gyhe_down_arrow"];
    }
    return imgvArrow;
}

- (UIImageView*)imgvArrow2
{
    if (imgvArrow2 == nil) {
        imgvArrow2 = [[UIImageView alloc] init];
        imgvArrow2.frame = CGRectMake(kScreenWidth - kDefaultMarginToBounds - 20, 15, 18, 10);
        imgvArrow2.userInteractionEnabled = NO;
        imgvArrow2.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        imgvArrow2.contentMode = UIViewContentModeScaleAspectFit;
        imgvArrow2.image = [UIImage imageNamed:@"gyhe_down_arrow"];
    }
    return imgvArrow2;
}

- (UIView*)checkAllShop
{
    UIView* backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    UIButton* btnChechShop = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChechShop.frame = CGRectMake(kDefaultMarginToBounds, 0, kScreenWidth, 43);
    btnChechShop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    btnChechShop.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btnChechShop setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChechShop setTitle:kLocalized(@"GYHE_SurroundVisit_CheckAllShop") forState:UIControlStateNormal];
    [btnChechShop addTarget:self action:@selector(btnCheck) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:btnChechShop];
    [backGroundView addBottomBorder];
    UIImageView* imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - kDefaultMarginToBounds - 20, 15, 18, 10)];
    imageViewArrow.image = [UIImage imageNamed:@"gyhe_down_arrow"];
    if (isShow) {
        imageViewArrow.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        imageViewArrow.transform = CGAffineTransformMakeRotation(0);
    }
    CALayer* topBorder = [CALayer layer];
    
    topBorder.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"gyhe_line_confirm_dialog_yellow"]] CGColor];
    topBorder.frame = CGRectMake(backGroundView.frame.origin.x + 16, 0, CGRectGetWidth(backGroundView.frame) - 32, 1.0f);
    [backGroundView.layer addSublayer:topBorder];
    [backGroundView addSubview:imageViewArrow];
    
    return backGroundView;
}

@end
