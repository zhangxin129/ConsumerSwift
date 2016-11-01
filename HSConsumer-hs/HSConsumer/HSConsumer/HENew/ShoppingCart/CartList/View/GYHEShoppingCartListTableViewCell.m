//
//  GYHEShoppingCartListTableViewCell.m
//  HSConsumer
//
//  Created by admin on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShoppingCartListTableViewCell.h"
#import "GYHESCCartAlertView.h"

@interface GYHEShoppingCartListTableViewCell () <GYHESCCartAlertViewDelegate>

@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) GYHESCCartAlertView* alertView;
@property (nonatomic, assign) NSInteger startEditNum;

@end

@implementation GYHEShoppingCartListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //添加手势
    UITapGestureRecognizer* imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapClick:)];
    [self.showImageView addGestureRecognizer:imageTap];
    UITapGestureRecognizer* labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapClick:)];
    [self.titleLabel addGestureRecognizer:labelTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(GYHECartItemModel *)itemModel {

    if (!itemModel) {
        return;
    }
    _itemModel = itemModel;
    _chooseButton.selected = itemModel.isSelect;
    [_showImageView setImageWithURL:[NSURL URLWithString:itemModel.pics[0][@"p200x200"]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
    _titleLabel.text = itemModel.name;
    _skuLabel.text = itemModel.skuContent;
    _moneyNumLabel.text = [GYUtils formatCurrencyStyle:[itemModel.skuPrice doubleValue]];
    _pvNumLabel.text = [GYUtils formatCurrencyStyle:[itemModel.skuPv doubleValue]];
    _numberLabel.text = itemModel.num;
    if (_itemModel.isAdd) {
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"gy_he_cart_add"] forState:UIControlStateNormal];
        self.addButton.enabled = YES;
    } else {
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"gy_he_cart_not_add"] forState:UIControlStateNormal];
        self.addButton.enabled = NO;
    }
    if (_itemModel.isSub) {
        [self.subtractButton setBackgroundImage:[UIImage imageNamed:@"gy_he_cart_subtract"] forState:UIControlStateNormal];
        self.subtractButton.enabled = YES;
    } else {
        [self.subtractButton setBackgroundImage:[UIImage imageNamed:@"gy_he_cart_not_subtract"] forState:UIControlStateNormal];
        self.subtractButton.enabled = NO;
    }
}

#pragma mark - custom methods
- (void)detailTapClick:(UITapGestureRecognizer*)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(pushToItemDetailWithIndexPath:)]) {
        [self.cellDelegate pushToItemDetailWithIndexPath:self.indexPath];
    }
}

#pragma mark - xib event response
//选中button
- (IBAction)chooseButtonClick:(UIButton *)sender {
    self.itemModel.isSelect = !self.itemModel.isSelect;
    sender.selected = self.itemModel.isSelect;
    if ([self.cellDelegate respondsToSelector:@selector(updateShowState:)]) {
        [self.cellDelegate updateShowState:self.indexPath];
    }
}

//加按钮
- (IBAction)addButtonClick:(UIButton *)sender {
    NSInteger count = kSaftToNSInteger(self.numberLabel.text);
    if (count < self.maxNumber) {
        count++;
        [self changeGoodsNumberNetWorkRequest:count withType:@"+1"];
    }
    else {
        [GYUtils showToast:[NSString stringWithFormat:kLocalized(@"HE_SC_CartMaxGoodsNumber"), self.maxNumber]];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"gy_he_cart_not_add"] forState:UIControlStateNormal];
        self.addButton.enabled = NO;
        self.itemModel.isAdd = NO;
    }
}

//减按钮
- (IBAction)subtractButtonClick:(UIButton *)sender {
    NSInteger count = kSaftToNSInteger(self.numberLabel.text);
    
    if (count > 1) {
        count--;
        [self changeGoodsNumberNetWorkRequest:count withType:@"-1"];
    }
    else {
        [GYUtils showToast:kLocalized(@"HE_SC_CartMinGoodsNumber")];
        [self.subtractButton setBackgroundImage:[UIImage imageNamed:@"gy_he_cart_not_subtract"] forState:UIControlStateNormal];
        self.subtractButton.enabled = NO;
        self.itemModel.isSub = NO;
    }
}

//编辑数量按钮
- (IBAction)editNumberButtonClick:(UIButton *)sender {
    self.startEditNum = [self.itemModel.num integerValue];
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    self.alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHESCCartAlertView class]) owner:self options:nil] firstObject];
    self.alertView.delegate = self;
    self.alertView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    self.alertView.maxNumber = self.maxNumber;
    self.alertView.numberTextField.text = self.numberLabel.text;
    [self.bgView addSubview:self.alertView];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.bgView];
    [self.alertView.numberTextField becomeFirstResponder]; //成为第一响应者
}

#pragma mark - GYHESCCartAlertViewDelegate
- (void)cancleButtonClicked
{
    [self.alertView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

- (void)confirmButtonClicked
{
    [self.alertView removeFromSuperview];
    [self.bgView removeFromSuperview];
    
    NSString *type = nil;
    NSInteger currentNum = kSaftToNSInteger(self.alertView.numberTextField.text);
    if (currentNum == self.startEditNum) {
        return;
    }
    if (currentNum < self.startEditNum) {
        type = @"-1";
    }
    if (currentNum > self.startEditNum) {
        type = @"+1";
    }
    [self changeGoodsNumberNetWorkRequest:currentNum withType:type];
}

#pragma mark - net request
- (void)changeGoodsNumberNetWorkRequest:(NSInteger)count withType:(NSString *)type
{
    NSMutableDictionary* parameterDic = [[NSMutableDictionary alloc] init];
    [parameterDic setValue:[NSString stringWithFormat:@"%d",count] forKey:@"num"];
    [parameterDic setValue:self.itemModel.itemId forKey:@"itemId"];
    [parameterDic setValue:self.itemModel.skuId forKey:@"itemSkuId"];
    [parameterDic setValue:type forKey:@"type"];
    //[parameterDic setValue:globalData.loginModel.token forKey:@"key"];
    
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kCartAddOrCutItemNumInCart parameters:parameterDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        DDLogDebug(@"--change goods number success");
        if (count + 1 == self.maxNumber) {
            [self.addButton setBackgroundImage:[UIImage imageNamed:@"gy_he_cart_add"] forState:UIControlStateNormal];//gy_he_cart_not_add
            self.addButton.enabled = YES;
            self.itemModel.isAdd = YES;
        }
        if (count - 1 == 1) {
            [self.subtractButton setBackgroundImage:[UIImage imageNamed:@"gy_he_cart_subtract"] forState:UIControlStateNormal];
            self.subtractButton.enabled = YES;
            self.itemModel.isSub = YES;
        }
        
        self.itemModel.num = [NSString stringWithFormat:@"%d", count];
        self.numberLabel.text = [NSString stringWithFormat:@"%d", count];
        if (self.itemModel.isSelect) {
            if ([self.cellDelegate respondsToSelector:@selector(updateShowState:)]) {
                [self.cellDelegate updateShowState:self.indexPath];
            }
        }
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}


@end
