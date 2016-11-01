//
//  FDShopCommitCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDShopCommitCell.h"
#import "FDPhotoViewController.h"
#import "FDScoreBar.h"

@interface FDShopCommitCell ()

@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView0;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView1;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView2;
@property (weak, nonatomic) IBOutlet UILabel* nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel* recomFoodLabel;
@property (weak, nonatomic) IBOutlet UILabel* recomReason;
@property (weak, nonatomic) IBOutlet UILabel* commentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView* picScrollView;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@property (strong, nonatomic) NSMutableArray* photos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton* verygoodBtn;
@property (weak, nonatomic) IBOutlet UILabel* verygoodNum;
@property (weak, nonatomic) IBOutlet UIView* separateBar;
@property (weak, nonatomic) IBOutlet UIView* barScoreView;
@property (strong, nonatomic) FDScoreBar* bar;
@property (weak, nonatomic) IBOutlet UIImageView* HSlogoImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* commentDistanceTop;
@end

@implementation FDShopCommitCell

- (void)awakeFromNib
{
    // Initialization code
    [_separateBar addAllBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setModel:(FDShopCommitModel*)model
{
    if (model) {
        _model = model;
        _nicknameLabel.text = model.nickname;

        if (model.recomReason.length > 0) {
            _recomFoodLabel.text = [NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_Food_RecommendedDishes"), model.recomFood];

            self.commentDistanceTop.constant = 12;
        }
        //        else {
        //            _recomFoodLabel.text = @"";
        //            self.commentDistanceTop.constant = -20;
        //        }
        if (model.recomReason.length > 0) {
            _recomReason.text = [NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_Food_RecommendedReason"), model.recomReason];
        }
        else {

            _recomReason.text = @"";
        }

        if (model.hasCard == YES) {

            _HSlogoImgView.hidden = NO;
        }
        else {
            _HSlogoImgView.hidden = YES;
        }

        if (_isSeviceTableView == YES) {

            _recomFoodLabel.text = @"";
            self.commentDistanceTop.constant = -20;
        }
        _commentLabel.text = model.comment;
        _dateLabel.text = model.commentDate;
        _photos = [[NSMutableArray alloc] init];
        [_photos addObjectsFromArray:_model.picList];
        _verygoodNum.text = [NSString stringWithFormat:@"(%@)", model.goodNum];

        NSInteger score = 0;
        if (model.tastePoint.integerValue == 0) {
            score = 0;
        }
        else if (model.tastePoint.integerValue > 0 && model.tastePoint.integerValue <= 60) {
            score = 1;
        }
        else if (model.tastePoint.integerValue > 60 && model.tastePoint.integerValue <= 70) {
            score = 2;
        }
        else if (model.tastePoint.integerValue > 70 && model.tastePoint.integerValue <= 80) {
            score = 3;
        }
        else if (model.tastePoint.integerValue > 80 && model.tastePoint.integerValue <= 90) {
            score = 4;
        }
        else if (model.tastePoint.integerValue > 90 && model.tastePoint.integerValue <= 100) {
            score = 5;
        }
        [self setTagScoreViewWithScore:score];

        for (UIView* view in _picScrollView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        if (!_photos || _photos.count == 0) {
            _scrollViewHeightConstraint.constant = 0;
        }
        else {
            _scrollViewHeightConstraint.constant = 80;
            for (int i = 0; i < _photos.count; i++) {
                UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(90 * i, 10, 80, 80)];

                //                [imageView sd_setImageWithURL:[NSURL URLWithString:_photos[i]]];

                [imageView setImageWithURL:[NSURL URLWithString:_photos[i]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];

                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellImageTapped:)];
                imageView.tag = i + 7000;
                [imageView addGestureRecognizer:tap];
                [_picScrollView addSubview:imageView];
            }
            _picScrollView.contentSize = CGSizeMake(90 * _photos.count, 80);
        }
        _verygoodBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (model.isGood) {
            [_verygoodBtn setImage:[UIImage imageNamed:@"gyhe_food_good"] forState:UIControlStateNormal];
        }
        else {
            [_verygoodBtn setImage:[UIImage imageNamed:@"gyhe_food_good2"] forState:UIControlStateNormal];
        }
    }
}

- (void)cellImageTapped:(UITapGestureRecognizer*)tap
{
    FDSelectFoodViewController* vc = (FDSelectFoodViewController*)_dele;
    FDPhotoViewController* photoVC = [[FDPhotoViewController alloc] init];
    UIView* tapView = tap.view;
    NSInteger index = tapView.tag - 7000;
    photoVC.images = _photos;

    photoVC.currentSelected = index;
    [vc.navigationController pushViewController:photoVC animated:YES];
}

- (void)setTagScoreViewWithScore:(NSInteger)score
{

    UIImage* image0 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower2"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    switch (score) {
    case 5:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image0;
        break;
    case 4:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image1;
        break;
    case 3:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image2;
        break;
    case 2:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image1;
        _scoreImageView2.image = image2;
        break;
    case 1:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image2;
        _scoreImageView2.image = image2;
        break;

    default:
        _scoreImageView0.image = image2;
        _scoreImageView1.image = image2;
        _scoreImageView2.image = image2;
        break;
    }
}

- (IBAction)verygoodBtnClicked:(UIButton*)sender
{
    kCheckLogined

        if (!_model.isGood)
    {

        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        NSString* userKey = globalData.loginModel.token;
        NSString* userId = globalData.loginModel.custId;
        [params setObject:_model.commentId forKey:@"commentId"];
        // [params setObject:_model.vShopId forKey:@"vShopId"];
        [params setObject:userKey forKey:@"userKey"];
        [params setObject:userId forKey:@"userId"];
        [params setObject:_model.shopId forKey:@"shopId"];
        [Network Post:commentGoodUrl parameters:params completion:^(id responseObject, NSError* error) {

            if (responseObject) {
                NSDictionary *rootDic = responseObject;
                if ([rootDic[@"retCode"] integerValue] == 200) {
                    [_verygoodBtn setImage:[UIImage imageNamed:@"gyhe_food_good"] forState:UIControlStateNormal];
                    NSString *verygoodNum = @([_model.goodNum integerValue]+1).stringValue;
                    _verygoodNum.text = [NSString stringWithFormat:@"(%@)", verygoodNum];
                    _model.goodNum = verygoodNum;
                    _model.isGood = YES;
                    [self makeToast:kLocalized(@"GYHE_Food_ClickPraiseSuccess") duration:1 position:CSToastPositionCenter];

                }else {
                    [self makeToast:kLocalized(@"GYHE_Food_ClickPraiseFailed") duration:1 position:CSToastPositionCenter];
                }
            }
        }];
    }
}

@end
