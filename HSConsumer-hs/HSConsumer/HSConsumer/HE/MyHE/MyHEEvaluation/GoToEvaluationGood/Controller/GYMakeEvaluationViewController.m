//
//  GYMakeEvaluationViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMakeEvaluationViewController.h"
#import "IQKeyboardManager.h"
#import "GYAlertView.h"
#import "GYGIFHUD.h"

@interface GYMakeEvaluationViewController () <GYNetRequestDelegate>

@property (nonatomic, assign) NSInteger serverScore;
@property (nonatomic, assign) NSInteger sepeedScroe;
@property (nonatomic, assign) NSInteger describeScroe;
@property (nonatomic, assign) NSInteger goodEvaluateScore;
@property (weak, nonatomic) IBOutlet UIButton* btnEvalutaionStar1; //评价商品的星星
@property (weak, nonatomic) IBOutlet UIButton* btnEvalutaionStar2;
@property (weak, nonatomic) IBOutlet UIButton* btnEvalutaionStar3;
@property (weak, nonatomic) IBOutlet UIButton* btnEvalutaionStar4;
@property (weak, nonatomic) IBOutlet UIButton* btnEvalutaionStar5;
@property (weak, nonatomic) IBOutlet UILabel* lbEvalutationGood; //评价商品LB
@property (weak, nonatomic) IBOutlet UITextView* tvInputText; //输入评价TV
@property (weak, nonatomic) IBOutlet UIScrollView* scrBackgroundView; //背景滚动试图
@property (weak, nonatomic) IBOutlet UIView* vEvalutationGoodBackground; //评价商品的背景view
@property (weak, nonatomic) IBOutlet UILabel* lbTextViewPlaceHolder;
@property (weak, nonatomic) IBOutlet UIView* vGoodInfo; //店铺的背景view
@property (weak, nonatomic) IBOutlet UILabel* lbMakeEvalutaionForShop; //给店铺评分LB
@property (weak, nonatomic) IBOutlet UILabel* lbServiceAttitude; //lb 服务态度
@property (weak, nonatomic) IBOutlet UILabel* lbSendSpeed; //LB 发货速度
@property (weak, nonatomic) IBOutlet UILabel* lbDescribeRightService; //lb 物流服务
@property (weak, nonatomic) IBOutlet UIButton* btnSpentTimeServiceStar1; //物流服务星星
@property (weak, nonatomic) IBOutlet UIButton* btnSpentTimeServiceStar2;
@property (weak, nonatomic) IBOutlet UIButton* btnSpentTimeServiceStar3;
@property (weak, nonatomic) IBOutlet UIButton* btnSpentTimeServiceStar4;
@property (weak, nonatomic) IBOutlet UIButton* btnSpentTimeServiceStar5;
@property (weak, nonatomic) IBOutlet UIButton* btnSendSpeedStar1; //发货速度星星
@property (weak, nonatomic) IBOutlet UIButton* btnSendSpeedStar2;
@property (weak, nonatomic) IBOutlet UIButton* btnSendSpeedStar3;
@property (weak, nonatomic) IBOutlet UIButton* btnSendSpeedStar4;
@property (weak, nonatomic) IBOutlet UIButton* btnSendSpeedStar5;
@property (weak, nonatomic) IBOutlet UIButton* btnServiceAttitudeStar1; //服务态度星星
@property (weak, nonatomic) IBOutlet UIButton* btnServiceAttitudeStar2;
@property (weak, nonatomic) IBOutlet UIButton* btnServiceAttitudeStar3;
@property (weak, nonatomic) IBOutlet UIButton* btnServiceAttitudeStar4;
@property (weak, nonatomic) IBOutlet UIButton* btnServiceAttitudeStar5;
@property (weak, nonatomic) IBOutlet UIView* vShopBackground; //给店铺评分背景view
@property (weak, nonatomic) IBOutlet UILabel* lbGoodName; //lb 商品名称
@property (weak, nonatomic) IBOutlet UILabel* lbSkuInfo; //lb 商品属性
@property (weak, nonatomic) IBOutlet UIImageView* imgvGoodPicture; //商品的图片
@property (weak, nonatomic) IBOutlet UIButton* btnSubmit; //btn 提交


@property (weak, nonatomic) IBOutlet UITextView *labelTextView;  //标签textView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;         //标签label
@property (weak, nonatomic) IBOutlet UIButton *realNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *falseNameComment; //匿名评价
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isAnonymous;  //是否匿名评价
@property (nonatomic,copy) NSString *strMessage;

@end

@implementation GYMakeEvaluationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScore];
    [self modifyName];
    [self textColor];
    [self addBackgroundImageForBtn];
    [self setBorderWithView:_tvInputText WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:_labelTextView WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [_vGoodInfo addAllBorder];
    [self setAllStars];
}

- (void)setScore
{
    self.title = kLocalized(@"GYHE_MyHE_MakeEvaluation");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    _serverScore = 5;
    _sepeedScroe = 5;
    _describeScroe = 5;
    _goodEvaluateScore = 5;
    
    _isSelected = NO;
    _isAnonymous = NO;
    _strMessage = @"false";
}

/**默认设置为五星*/
- (void)setAllStars
{
    [self btnEvaluationClicked:_btnEvalutaionStar5];
    [self btnEvaluationClicked:_btnServiceAttitudeStar5];
    [self btnEvaluationClicked:_btnSendSpeedStar5];
    [self btnEvaluationClicked:_btnSpentTimeServiceStar5];
}

- (void)loadDataFromNetwork
{
    if ([GYUtils isBlankString:_strComment]) {
        
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_PleaseInputCommentInformation")];
        return;
    }
    else if (_serverScore == 0) {
        
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_PleaseEnterServiceAttitude")];
    
        return;
    }
    else if (_sepeedScroe == 0) {
        
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_PleasePleaseEnterSpeedOfDelivery")];
        
        return;
    }
    else if (_describeScroe == 0) {
        
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_PleaseInputInformation")];
        
        return;
    }
    else if (_goodEvaluateScore == 0) {
        
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_PleaseInputPraise")];
        
        return;
    }
    NSMutableDictionary* GoodDict = [NSMutableDictionary dictionary];
    //[GoodDict setValue:globalData.loginModel.token forKey:@"key"];
    [GoodDict setValue:self.model.serviceResourceNo forKey:@"serviceResourceId"];
    [GoodDict setValue:self.model.orderDetailId forKey:@"orderDetailId"];
    [GoodDict setValue:self.model.vShopId forKey:@"virtualShopId"];
    [GoodDict setValue:self.model.categoryId forKey:@"categoryId"];
    [GoodDict setValue:self.model.id forKey:@"itemId"];
    [GoodDict setValue:self.model.title forKey:@"itemName"];
    [GoodDict setValue:self.model.sku forKey:@"sku"];
    [GoodDict setValue:self.model.price forKey:@"price"];
    [GoodDict setValue:_strComment forKey:@"content"];
    [GoodDict setValue:@(_goodEvaluateScore) forKey:@"score"];
    [GoodDict setValue:self.model.orderId forKey:@"orderId"];
    [GoodDict setValue:_tag forKey:@"tag"];
    NSString* strPicPath = self.model.url;
    strPicPath = [strPicPath lastPathComponent];
    [GoodDict setValue:strPicPath forKey:@"pic"];
    NSMutableDictionary* shopDict = [NSMutableDictionary dictionary];
    [shopDict setValue:self.model.orderId forKey:@"orderId"];
    [shopDict setValue:self.model.vShopId forKey:@"virtualShopId"];
    [shopDict setValue:self.model.shopId forKey:@"shopId"];
    [shopDict setValue:@(_serverScore) forKey:@"serverScore"];
    [shopDict setValue:@(_describeScroe) forKey:@"conformScore"];
    [shopDict setValue:@(_sepeedScroe) forKey:@"deliveryScore"];
    NSArray* arr = [NSArray arrayWithObject:GoodDict];
    NSData* cartListData = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:NULL];
    NSString* cartListString = [[NSString alloc] initWithData:cartListData encoding:NSUTF8StringEncoding];
    //cartListString = [self encodeToPercentEscapeString:cartListString];
    NSData* shopListData = [NSJSONSerialization dataWithJSONObject:shopDict options:kNilOptions error:NULL];
    NSString* shopListString = [[NSString alloc] initWithData:shopListData encoding:NSUTF8StringEncoding];
    NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:globalData.loginModel.token forKey:@"key"];
    [dic1 setValue:shopListString forKey:@"shopCommentJson"];
    [dic1 setValue:cartListString forKey:@"itemCommentJson"];
    [dic1 setValue:_strMessage forKey:@"isAnonymous"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetPublishEvaluationUrl parameters:dic1 requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request start];
}

- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil userInfo:nil];
    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_EvaluationSuccess")];
    self.refreshListBlock(self.model);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor*)color
{

    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
}

- (void)addBackgroundImageForBtn
{
    [self setButtonInfo:_btnEvalutaionStar1 buttonTag:100];
    [self setButtonInfo:_btnEvalutaionStar2 buttonTag:101];
    [self setButtonInfo:_btnEvalutaionStar3 buttonTag:102];
    [self setButtonInfo:_btnEvalutaionStar4 buttonTag:103];
    [self setButtonInfo:_btnEvalutaionStar5 buttonTag:104];
    [self setButtonInfo:_btnServiceAttitudeStar1 buttonTag:200];
    [self setButtonInfo:_btnServiceAttitudeStar2 buttonTag:201];
    [self setButtonInfo:_btnServiceAttitudeStar3 buttonTag:202];
    [self setButtonInfo:_btnServiceAttitudeStar4 buttonTag:203];
    [self setButtonInfo:_btnServiceAttitudeStar5 buttonTag:204];
    [self setButtonInfo:_btnSendSpeedStar1 buttonTag:300];
    [self setButtonInfo:_btnSendSpeedStar2 buttonTag:301];
    [self setButtonInfo:_btnSendSpeedStar3 buttonTag:302];
    [self setButtonInfo:_btnSendSpeedStar4 buttonTag:303];
    [self setButtonInfo:_btnSendSpeedStar5 buttonTag:304];
    [self setButtonInfo:_btnSpentTimeServiceStar1 buttonTag:400];
    [self setButtonInfo:_btnSpentTimeServiceStar2 buttonTag:401];
    [self setButtonInfo:_btnSpentTimeServiceStar3 buttonTag:402];
    [self setButtonInfo:_btnSpentTimeServiceStar4 buttonTag:403];
    [self setButtonInfo:_btnSpentTimeServiceStar5 buttonTag:404];
}

- (void)setButtonInfo:(UIButton*)sender buttonTag:(int)tag
{
    [sender setBackgroundImage:[UIImage imageNamed:@"gyhe_collocate_star_gray"] forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"gyhe_collocate_star_yellow"] forState:UIControlStateSelected];
    sender.tag = tag;
    [sender addTarget:self action:@selector(btnEvaluationClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnEvaluationClicked:(UIButton*)sender
{
    int tag = (int)sender.tag;
    if (100 <= tag && tag < 200) {
        _goodEvaluateScore = sender.tag - 100 + 1;
        for (UIButton* v in _vEvalutationGoodBackground.subviews) {

            if ([v isKindOfClass:[UIButton class]]) {
                if (100 <= v.tag && v.tag <= sender.tag) {
                    v.selected = YES;
                }
                else {
                    v.selected = NO;
                }
            }
        }
    }
    else if (tag >= 300 && tag < 400) {
        _sepeedScroe = sender.tag - 100 + 1;
        for (UIButton* v in _vShopBackground.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                if (300 <= v.tag && v.tag <= sender.tag) {
                    v.selected = YES;
                }
                else {
                    if (v.tag >= sender.tag && v.tag < 400) {
                        v.selected = NO;
                    }
                }
            }
        }
    }
    else if (tag >= 200 && tag < 300) {
        _serverScore = sender.tag - 100 + 1;
        for (UIButton* v in _vShopBackground.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                if (200 <= v.tag && v.tag <= sender.tag) {
                    v.selected = YES;
                }
                else {
                    if (v.tag >= sender.tag && v.tag < 300) {
                        v.selected = NO;
                    }
                }
            }
        }
    }
    else if (tag >= 400 && tag < 500) {
        _describeScroe = sender.tag - 100 + 1;
        for (UIButton* v in _vShopBackground.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                if (400 <= v.tag && v.tag <= sender.tag) {
                    v.selected = YES;
                }
                else {
                    if (v.tag >= sender.tag && v.tag < 500) {
                        v.selected = NO;
                    }
                }
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scrBackgroundView.contentSize = CGSizeMake(kScreenWidth, 600);
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)modifyName
{
    _lbTextViewPlaceHolder.text = kLocalized(@"GYHE_MyHE_LeaveWordForOthers");
    _lbMakeEvalutaionForShop.text = kLocalized(@"GYHE_MyHE_EvalutationForShop");
    _lbGoodName.text = self.model.title;
    _lbSkuInfo.text = self.model.sku;
    [_imgvGoodPicture setImageWithURL:[NSURL URLWithString:self.model.url] placeholder:kLoadPng(@"gycommon_image_placeholder") options:kNilOptions completion:nil];
    _lbSendSpeed.text = kLocalized(@"GYHE_MyHE_SendShopSpeed");
    _lbEvalutationGood.text = kLocalized(@"GYHE_MyHE_EvalutationGood");
    _lbDescribeRightService.text = kLocalized(@"GYHE_MyHE_DescribeService");
    _lbServiceAttitude.text = kLocalized(@"GYHE_MyHE_ServiceAttitude");
    [_btnSubmit setTitle:kLocalized(@"GYHE_MyHE_Submit") forState:UIControlStateNormal];
    [self btnEvaluationClicked:_btnEvalutaionStar5];
    [self btnEvaluationClicked:_btnSendSpeedStar5];
    [self btnEvaluationClicked:_btnServiceAttitudeStar5];
    [self btnEvaluationClicked:_btnSpentTimeServiceStar5];
}

- (void)textColor
{
    _tipLabel.textColor = kCellItemTextColor;
    _tipLabel.font = [UIFont systemFontOfSize:15];
    _falseNameComment.textColor = kCellItemTitleColor;
    _lbTextViewPlaceHolder.textColor = kCellItemTextColor;
    _lbSkuInfo.textColor = kCellItemTextColor;
    _lbGoodName.textColor = kCellItemTitleColor;
    _lbEvalutationGood.textColor = kCellItemTitleColor;
    _lbMakeEvalutaionForShop.textColor = kCellItemTitleColor;
    _lbServiceAttitude.textColor = kCellItemTitleColor;
    _lbDescribeRightService.textColor = kCellItemTitleColor;
    _lbSendSpeed.textColor = kCellItemTitleColor;
    _vShopBackground.backgroundColor = [UIColor whiteColor];
    _vEvalutationGoodBackground.backgroundColor = [UIColor whiteColor];
    [GYUtils setBorderWithView:_vShopBackground WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [GYUtils setBorderWithView:_vEvalutationGoodBackground WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [_btnSubmit setBackgroundImage:[UIImage imageNamed:@"gyhe_alert_btn_confirm_bg"] forState:UIControlStateNormal];
    
    UIImage* image = kLoadPng(@"gyhe_btn_tick_no");
    [_realNameBtn setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView*)textView
{
    if (textView.tag == 656) {
        if (textView.text.length == 0) {
            _lbTextViewPlaceHolder.hidden = NO;
        } else {
            _lbTextViewPlaceHolder.hidden = YES;
        }
        
        if (textView.text.length > 200) {
            [GYAlertView showMessage:kLocalized(@"GYHE_MyHE_Evaluate200Characters")];
            textView.text = [textView.text substringToIndex:200];
        }
        _strComment = textView.text;
    }
    
    if (textView.tag == 655) {
        
        if (textView.text.length == 0) {
            
            _tipLabel.hidden = NO;
        } else {
            _tipLabel.hidden = YES;
            
        }
        _tag = textView.text;
    }
  
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (textView.tag == 656) {
        NSString* beStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (beStr.length > 200) {
            return NO;
        }
        _strComment = beStr;
    }
    if (textView.tag == 655) {
        NSString* beStr1 = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (beStr1.length > 200) {
            return NO;
        }
        _tag = beStr1;
    }
   
    return YES;
}

- (IBAction)btnSubmit:(id)sender {
    [self loadDataFromNetwork];
}

- (IBAction)realNameIsClickBtn:(id)sender {
    
    _isSelected = !_isSelected;
    if (_isSelected) {
        [sender setImage:kLoadPng(@"gyhe_btn_tick_yes") forState:UIControlStateNormal];
        _isAnonymous = YES;
        _strMessage = @"true";
    }
    else {
        [sender setImage:kLoadPng(@"gyhe_btn_tick_no") forState:UIControlStateNormal];
        _isAnonymous = NO;
        _strMessage = @"false";
    }
}

@end
