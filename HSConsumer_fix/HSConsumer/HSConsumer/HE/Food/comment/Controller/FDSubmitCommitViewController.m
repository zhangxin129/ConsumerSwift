//
//  FDSubmitCommitViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDSubmitCommitViewController.h"
#import "FDRecomFoodViewController.h"
#import "FDScoreBar.h"
#import "FDSelectFoodViewController.h"
#import "FDSubmitCommitOrderDetailFoodModel.h"
#import "GYGetPhotoView.h"
#import "GYOrderModel.h"
#import "GYUploadImage.h"

@interface FDSubmitCommitViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GYUploadPicDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, GYGetPhotoViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIView* tasteContainerView;
@property (weak, nonatomic) IBOutlet UIView* bottomView;

@property (weak, nonatomic) IBOutlet UIView* scoreBarView;
@property (weak, nonatomic) IBOutlet UIView* envScoreBarView;
@property (weak, nonatomic) IBOutlet UITextView* tfTasteEvaluate;
@property (weak, nonatomic) IBOutlet UITextView* tfRecommendFood;
@property (weak, nonatomic) IBOutlet UIButton* btnChooseFoodBtn;
@property (weak, nonatomic) IBOutlet UITextField* tfWaitTime;
@property (weak, nonatomic) IBOutlet UIButton* btnChooseEnvScore;
@property (weak, nonatomic) IBOutlet UIButton* btnChooseServiceScore;
@property (copy, nonatomic) NSMutableArray* picList;
@property (copy, nonatomic) NSString* comment;
@property (copy, nonatomic) NSString* tastePoint;
@property (copy, nonatomic) NSString* envPoint;
@property (copy, nonatomic) NSString* sevPoint;
@property (copy, nonatomic) NSNumber* serviceScore;
@property (copy, nonatomic) NSString* waitTime;
@property (copy, nonatomic) NSString* recommendFoodReason;
@property (copy, nonatomic) NSString* recommendFoodId;
@property (copy, nonatomic) NSString* recommendationItemName;
@property (strong, nonatomic) UIButton* currentUploadBtn;
@property (strong, nonatomic) UIImage* currentImage;
@property (assign, nonatomic) BOOL isUploading;
@property (strong, nonatomic) UITableView* foodListTableView;
@property (strong, nonatomic) UITableView* scoreListTableView;
@property (strong, nonatomic) NSMutableArray* foodListDataSource;
@property (strong, nonatomic) NSMutableArray* scoreListDataSource;
@property (weak, nonatomic) IBOutlet UIView* chooseFoodLineView;
@property (weak, nonatomic) IBOutlet UIView* chooseScoreLineView;
@property (strong, nonatomic) FDScoreBar* bar;
@property (strong, nonatomic) FDScoreBar* bar2;
@property (weak, nonatomic) IBOutlet UILabel* barScoreLabel;
@property (weak, nonatomic) IBOutlet UIView* serviceScoreBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* takeAwayScoreHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* recomFoodHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* recomAndEnvSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* envScoreHeight;
@property (weak, nonatomic) IBOutlet UIView* serviceScoreView;
@property (assign, nonatomic) NSInteger picID;
@property (weak, nonatomic) IBOutlet UIScrollView* uploadBtnScrollView;
@property (weak, nonatomic) IBOutlet UIView* separateLine1;
@property (weak, nonatomic) IBOutlet UIView* separateLine2;
@property (weak, nonatomic) IBOutlet UIView* separateLine3;
@property (weak, nonatomic) IBOutlet UIView* separateLine4;
@property (weak, nonatomic) IBOutlet UILabel* tfEvalutePlaceholderLabel;
@property (weak, nonatomic) IBOutlet UILabel* tfRecomPlaceholderLabel;

//2.5.0新添加评价 相关

@property (weak, nonatomic) IBOutlet UILabel* serviceScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel* recomFoodNameLabel;

@property (weak, nonatomic) IBOutlet UILabel* evnScoreLabel;

@property (weak, nonatomic) IBOutlet UIPickerView* scorePickerView;

@property (nonatomic, strong) UIView* pickerBgView;

@property (nonatomic, strong) NSMutableArray* scoreDatas; //评分数组
@property (strong, nonatomic) IBOutlet UIView* myPickerView;

@property (nonatomic, assign) BOOL isSelected;

//餐厅增加服务评价

@property (weak, nonatomic) IBOutlet UILabel* sevLabel;
@property (nonatomic, assign) NSInteger tagIndex;

//国际化  add zhangx
@property (weak, nonatomic) IBOutlet UILabel* mustEnterLabel; //必填项
@property (weak, nonatomic) IBOutlet UILabel* tasteLabel; //口味评价
@property (weak, nonatomic) IBOutlet UILabel* serviceLabel; //服务评价
@property (weak, nonatomic) IBOutlet UILabel* pointsLabel; //分
@property (weak, nonatomic) IBOutlet UILabel* recomdDishesLabel; //推荐菜品
@property (weak, nonatomic) IBOutlet UILabel* waiteTimeLabel; //等待时间
@property (weak, nonatomic) IBOutlet UILabel* minutesLabel; //分钟
@property (weak, nonatomic) IBOutlet UILabel* seviceScoreLabel; //服务评价
@property (weak, nonatomic) IBOutlet UILabel* pointLabel; //分

@property (weak, nonatomic) IBOutlet UILabel* evnLabel; //环境评分
@property (weak, nonatomic) IBOutlet UILabel* poinLabel; //分
@property (weak, nonatomic) IBOutlet UILabel* uploadLabel; //上传图片

@property (weak, nonatomic) IBOutlet UILabel* uploadTipLabel; //单张图片不超过1M,支持JPG,PNG格式
@property (weak, nonatomic) IBOutlet UIButton* confirmEvaluateBtn; //提交评价
@property (weak, nonatomic) IBOutlet UIButton* pickerConfirmBtn;

@property (weak, nonatomic) IBOutlet UIButton* pickerCancelBtn;

@property (nonatomic, strong) GYGetPhotoView* getView;
@property (nonatomic, strong) UIView* bgView;

@end

@implementation FDSubmitCommitViewController
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _bottomView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

- (void)viewDidLoad
{
    //    [self loadFoods];

    self.mustEnterLabel.text = kLocalized(@"GYHE_Food_Required");
    self.tasteLabel.text = kLocalized(@"GYHE_Food_TasteEvaluation");
    self.tfEvalutePlaceholderLabel.text = kLocalized(@"GYHE_Food_EnterTasteEvaluationTenWords");
    self.serviceLabel.text = kLocalized(@"GYHE_Food_ServiceEvaluation");
    self.pointsLabel.text = kLocalized(@"GYHE_Food_Points");
    self.tfRecomPlaceholderLabel.text = kLocalized(@"GYHE_Food_EnterRecommendedReasonTenWords");
    self.recomdDishesLabel.text = kLocalized(@"GYHE_Food_RecommendedDishes");
    self.waiteTimeLabel.text = kLocalized(@"GYHE_Food_WaitingTime");
    self.seviceScoreLabel.text = kLocalized(@"GYHE_Food_ServiceEvaluation");
    self.minutesLabel.text = kLocalized(@"GYHE_Food_Minutes");
    self.pointLabel.text = kLocalized(@"GYHE_Food_Points");
    self.poinLabel.text = kLocalized(@"GYHE_Food_Points");
    self.evnLabel.text = kLocalized(@"GYHE_Food_EnvironmentalScore");
    self.uploadLabel.text = kLocalized(@"GYHE_Food_UploadPictures");
    self.uploadTipLabel.text = kLocalized(@"GYHE_Food_SingleImageSupportTip");
    [self.confirmEvaluateBtn setTitle:kLocalized(@"GYHE_Food_ConfirmEvaluation") forState:UIControlStateNormal];

    [self.pickerConfirmBtn setTitle:kLocalized(@"GYHE_Food_Confirm") forState:UIControlStateNormal];
    [self.pickerCancelBtn setTitle:kLocalized(@"GYHE_Food_Cancel") forState:UIControlStateNormal];

    [_separateLine1 addTopBorder];
    [_separateLine2 addTopBorder];
    [_separateLine3 addTopBorder];
    [_separateLine4 addTopBorder];
    [_tasteContainerView addTopBorder];
    [_tasteContainerView addBottomBorder];
    [_tasteContainerView setBottomBorderInset:YES];

    [_serviceScoreView addTopBorder];
    [_serviceScoreView addBottomBorder];
    [_serviceScoreView setBottomBorderInset:YES];

    [_chooseFoodLineView addTopBorder];
    [_chooseFoodLineView addBottomBorder];
    [_chooseFoodLineView setBottomBorderInset:YES];

    [_chooseScoreLineView addTopBorder];
    //  [_chooseScoreLineView addBottomBorder];
    [_chooseScoreLineView setBottomBorderInset:YES];

    [_uploadBtnScrollView addTopBorder];
    [_uploadBtnScrollView addBottomBorder];
    [_uploadBtnScrollView setBottomBorderInset:YES];
    _tfRecommendFood.delegate = self;
    _tfTasteEvaluate.delegate = self;

    if (self.isTakeaway) {
        _takeAwayScoreHeight.constant = 50;
        _recomFoodHeight.constant = 0;
        _recomAndEnvSpace.constant = 0;
        _envScoreHeight.constant = 0;
    } else {
        _takeAwayScoreHeight.constant = 0;
        _recomAndEnvSpace.constant = 100;
        _recomAndEnvSpace.constant = 18;
        _envScoreHeight.constant = 100;
    }
    [super viewDidLoad];
    _btnChooseFoodBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    _foodListDataSource = [[NSMutableArray alloc] init];
    _scoreListDataSource = [NSMutableArray arrayWithObjects:@"20", @"40", @"60", @"80", @"100", nil];
    self.title = kLocalized(@"GYHE_Food_AddEvaluation");
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    _bar = [[FDScoreBar alloc] initWithFrame:CGRectMake(0, 0, _scoreBarView.frame.size.width, _scoreBarView.frame.size.height) selectImage:image1 unSelectImage:image2];
    [_scoreBarView addSubview:_bar];
    _bar.clipsToBounds = YES;

    __weak typeof(self) weakSelf = self;
    _bar.block = ^{
        weakSelf.barScoreLabel.text = @(_bar.score * 20 + 40).stringValue;
    };
    _bar.score = 3;
    UIImage* image = [UIImage imageNamed:@"gyhe_food_env"];
    _bar2 = [[FDScoreBar alloc] initWithFrame:CGRectMake(0, 0, _envScoreBarView.frame.size.width, _envScoreBarView.frame.size.height) selectImage:image unSelectImage:nil];
    [_envScoreBarView addSubview:_bar2];
    _bar2.canTouch = NO;

    if (self.isTakeaway) {
        [_serviceScoreBarView addSubview:_bar2];
    }
    _bar2.score = 5;
    _btnChooseFoodBtn.layer.cornerRadius = 4;
    _btnChooseFoodBtn.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    _btnChooseFoodBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnChooseEnvScore.layer.cornerRadius = 4;
    _btnChooseEnvScore.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    _btnChooseEnvScore.layer.borderColor = [UIColor lightGrayColor].CGColor;

    _btnChooseServiceScore.layer.cornerRadius = 4;
    _btnChooseServiceScore.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    _btnChooseServiceScore.layer.borderColor = [UIColor lightGrayColor].CGColor;

    _picList = [[NSMutableArray alloc] init];

    _tfWaitTime.layer.cornerRadius = 4;
    _tfWaitTime.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    _tfWaitTime.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _picList = [[NSMutableArray alloc] init];
    _tfWaitTime.keyboardType = UIKeyboardTypeNumberPad;
    [_tfWaitTime addTarget:self action:@selector(tfWaitTimeChange:) forControlEvents:UIControlEventEditingChanged];

    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    [self setupTableView];

    [self setPicker];
}

- (void)setupTableView
{
    CGRect rectFood = [_chooseFoodLineView convertRect:_btnChooseFoodBtn.frame toView:_scrollView];
    CGRect foodListTableFrame = CGRectMake(rectFood.origin.x, rectFood.origin.y + rectFood.size.height - 50, rectFood.size.width, 150);
    _foodListTableView = [[UITableView alloc] initWithFrame:foodListTableFrame];
    _foodListTableView.dataSource = self;
    _foodListTableView.delegate = self;
    [self setHeight:0 view:_foodListTableView];
    _foodListTableView.rowHeight = 30.f;
    _foodListTableView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    _foodListTableView.layer.borderColor = [UIColor grayColor].CGColor;
    [_scrollView addSubview:_foodListTableView];

    if (!self.isTakeaway) {
        CGRect rectScore = [_chooseScoreLineView convertRect:_btnChooseEnvScore.frame toView:_scrollView];
        CGRect scoreListTableFrame = CGRectMake(rectScore.origin.x, rectScore.origin.y + rectScore.size.height - 40, rectScore.size.width, 150);
        _scoreListTableView = [[UITableView alloc] initWithFrame:scoreListTableFrame];
        _scoreListTableView.dataSource = self;
        _scoreListTableView.delegate = self;
        [self setHeight:0 view:_scoreListTableView];
        _scoreListTableView.rowHeight = 30.f;
        _scoreListTableView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _scoreListTableView.layer.borderColor = [UIColor grayColor].CGColor;
        [_scrollView addSubview:_scoreListTableView];
    } else {
        CGRect rectScore = [_serviceScoreView convertRect:_btnChooseServiceScore.frame toView:_scrollView];
        CGRect scoreListTableFrame = CGRectMake(rectScore.origin.x, rectScore.origin.y + rectScore.size.height, rectScore.size.width, 150);
        _scoreListTableView = [[UITableView alloc] initWithFrame:scoreListTableFrame];
        _scoreListTableView.dataSource = self;
        _scoreListTableView.delegate = self;
        [self setHeight:0 view:_scoreListTableView];
        _scoreListTableView.rowHeight = 30.f;
        _scoreListTableView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _scoreListTableView.layer.borderColor = [UIColor grayColor].CGColor;
        [_scrollView addSubview:_scoreListTableView];
    }
}

- (void)setPicker
{

    _pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _pickerBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_pickerBgView];
    _pickerBgView.hidden = YES;

    _myPickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 258);

    [self.view addSubview:_myPickerView];

    _scorePickerView.delegate = self;
    _scorePickerView.dataSource = self;

    _scoreDatas = [NSMutableArray array];

    for (NSInteger i = 99; i >= 0; i--) {

        NSString* str = [NSString stringWithFormat:@"%ld%@", i + 1, kLocalized(@"GYHE_Food_Points")];

        [_scoreDatas addObject:str];
    }

    [_scorePickerView selectRow:0 inComponent:0 animated:YES];
}

- (void)setHeight:(NSInteger)height view:(UIView*)view
{
    CGRect rect = view.frame;
    rect.size.height = height;
    view.frame = rect;
}

- (void)loadFoods
{

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:kSaftToNSString(_userKey) forKey:@"userKey"];
    [params setObject:kSaftToNSString(_orderId) forKey:@"orderId"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:GetFoodOrderDetailUrl
                                                     parameters:params
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (responseObject) {

                                                           NSDictionary* dic = responseObject;
                                                           if ([dic[@"retCode"] integerValue] == 200 && dic[@"data"]) {
                                                               NSDictionary* data = dic[@"data"];
                                                               NSArray* array = data[@"foodList"];
                                                               for (int i = 0; i < array.count; i++) {
                                                                   NSDictionary* item = array[i];
                                                                   FDSubmitCommitOrderDetailFoodModel* model = [[FDSubmitCommitOrderDetailFoodModel alloc] initWithDictionary:item error:nil];
                                                                   [_foodListDataSource addObject:model];
                                                               }
                                                               [_foodListTableView reloadData];
                                                           }
                                                       }

                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == _foodListTableView) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
        }
        if (_foodListDataSource.count > indexPath.row) {

            FDSubmitCommitOrderDetailFoodModel* model = _foodListDataSource[indexPath.row];
            cell.textLabel.text = model.foodName;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor grayColor];
            return cell;
        }
    } else if (tableView == _scoreListTableView) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
        }
        if (_scoreListDataSource.count > indexPath.row) {
            cell.textLabel.text = _scoreListDataSource[indexPath.row];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _foodListTableView) {
        NSInteger count = _foodListDataSource.count;
        return count;
    }
    return 5;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _foodListTableView) {
        FDSubmitCommitOrderDetailFoodModel* model = nil;
        if (_foodListDataSource.count > indexPath.row) {
            model = _foodListDataSource[indexPath.row];
        }
        [_btnChooseFoodBtn setTitle:model.foodName forState:UIControlStateNormal];
        _recommendationItemName = model.foodName;
        _recommendFoodId = model.foodId;
        //        [self btnChooseFoodClicked:nil];
    } else if (tableView == _scoreListTableView) {
        if (_scoreListDataSource.count > indexPath.row) {
            [_btnChooseEnvScore setTitle:_scoreListDataSource[indexPath.row] forState:UIControlStateNormal];
            [_btnChooseServiceScore setTitle:_scoreListDataSource[indexPath.row] forState:UIControlStateNormal];
        }
        //        [self btnChooseScoreClicked:nil];
        _bar2.score = indexPath.row + 1;
        _envPoint = @(indexPath.row + 1).stringValue;
    }
}

#pragma mark - 新ui变动 取消以下方法
//- (IBAction)btnChooseFoodClicked:(id)sender {
//    NSInteger count = _foodListDataSource.count;
//    NSInteger height = 0;
//    if (count<5) {
//        height = 30 *count;
//    }
//    else{
//        height = 30 * 5;
//    }
//    [UIView animateWithDuration:0.25 animations:^{
//        [self setHeight:(_foodListTableView.frame.size.height==0?height:0) view:_foodListTableView];
//    }];
//}
//- (IBAction)btnChooseScoreClicked:(id)sender {
//    [UIView animateWithDuration:0.25 animations:^{
//        [self setHeight:(_scoreListTableView.frame.size.height==0?150:0) view:_scoreListTableView];
//    }];
//}
//- (IBAction)btnChooseServiceScoreClicked:(id)sender {
//    [UIView animateWithDuration:0.25 animations:^{
//        [self setHeight:(_scoreListTableView.frame.size.height==0?150:0) view:_scoreListTableView];
//    }];
//}

- (IBAction)btnUploadClicked:(UIButton*)sender
{
    _currentUploadBtn = sender;
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];

    self.getView = [[[NSBundle mainBundle] loadNibNamed:@"GYGetPhotoView" owner:self options:nil] firstObject];
    self.getView.frame = CGRectMake(15, kScreenHeight - 155, kScreenWidth - 30, 155);
    self.getView.delegate = self;
    [self.bgView addSubview:self.getView];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.bgView];
}

#pragma mark -GYGetPhotoViewDelegate
- (void)takePhotoBtnClickDelegate
{
    [self.getView removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self photocamera];
}

- (void)getBlumBtnClickDelegate
{
    [self.getView removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self photoalbumr];
}
- (void)cancelBtnClickDelegate
{
    [self.getView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

//进入相册
- (void)photoalbumr
{

    if ([UIImagePickerController isSourceTypeAvailable:

                                     UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* picker =
            [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    } else {

        [GYUtils showMessage:kLocalized(@"GYHE_Food_AccessAlbumFailed")];
    }
}

//进入拍照
- (void)photocamera
{

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];

        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagepicker.allowsEditing = NO;
        [self presentViewController:imagepicker animated:YES completion:nil];
    } else {

        [GYUtils showMessage:kLocalized(@"GYHE_Food_DeviceNoSupportCamera")];
    }
}

//此方法用于模态 消除actionsheet
- (void)actionSheetCancel:(UIActionSheet*)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

//Pickerviewcontroller的代理方法。
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{

    static NSInteger picId = 7000;
    picId++;
    _picID = picId;
    [picker dismissViewControllerAnimated:YES
                               completion:^{

                               }];
    _currentImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    GYUploadImage* uploadPic = [[GYUploadImage alloc] init];
    uploadPic.urlType = 3;
    uploadPic.index = (int)_picID;
    _currentUploadBtn.tag = _picID;
    [uploadPic uploadImg:_currentImage WithParam:nil];
    uploadPic.delegate = self;
    _isUploading = YES;
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.tag = _picID * 2;
    aiv.frame = _currentUploadBtn.bounds;
    aiv.backgroundColor = [UIColor lightGrayColor];
    [_currentUploadBtn addSubview:aiv];
    [aiv startAnimating];
    aiv.hidden = NO;
}

#pragma mark 上传图片代理方法。
- (void)didFinishUploadImg:(NSURL*)url withTag:(int)index
{

    NSString* urlString = url.absoluteString;

    UIButton* btn = [self.uploadBtnScrollView viewWithTag:index];
    UIActivityIndicatorView* aiv = [btn viewWithTag:index * 2];

    [btn setImage:_currentImage forState:UIControlStateNormal];
    [aiv stopAnimating];
    [aiv removeFromSuperview];

    NSDictionary* picDic = @{ @(index) : urlString.lastPathComponent };
    [_picList addObject:picDic];
    // _currentUploadBtn.enabled = NO;
    _isUploading = NO;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 15, 15)];
    iv.image = [UIImage imageNamed:@"gyhe_food_cancel"];
    iv.backgroundColor = [UIColor darkGrayColor];
    [view addSubview:iv];
    view.tag = index;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePicTapped:)];
    [view addGestureRecognizer:tap];
    [btn addSubview:view];
}

- (void)removePicTapped:(UITapGestureRecognizer*)tap
{
    UIView* view = tap.view;
    NSInteger tag = view.tag;
    for (int i = 0; i < _picList.count; i++) {
        NSDictionary* dic = _picList[i];
        if ([dic.allKeys.firstObject integerValue] == tag) {
            [_picList removeObject:dic];
            UIButton* btn = (UIButton*)[view superview];
            btn.enabled = YES;
            [btn setImage:[UIImage imageNamed:@"gyhe_food_upload"] forState:UIControlStateNormal];
            [tap.view.subviews[0] removeFromSuperview];
            [tap.view removeFromSuperview];
        }
    }
}

#pragma mark 上传图片失败
- (void)didFailUploadImg:(NSError*)error withTag:(int)index
{
    [self.view makeToast:kLocalized(@"GYHE_Food_UploadPicturesFaild")];

    _isUploading = NO;
    UIButton* btn = [self.uploadBtnScrollView viewWithTag:index];
    UIActivityIndicatorView* aiv = [btn viewWithTag:index * 2];
    aiv.hidden = YES;
    [aiv removeFromSuperview];
}

- (void)textViewDidChange:(UITextView*)textView
{
    NSString* text = textView.text;

    if (textView == _tfTasteEvaluate) {
        if (text.length == 0 && textView.isFirstResponder) {
            _tfEvalutePlaceholderLabel.text = kLocalized(@"GYHE_Food_EnterTasteEvaluationTenWords");
        } else {
            _tfEvalutePlaceholderLabel.text = @"";
        }
    } else if (textView == _tfRecommendFood && textView.isFirstResponder) {
        if (text.length == 0) {
            _tfRecomPlaceholderLabel.text = kLocalized(@"GYHE_Food_EnterRecommendedReasonTenWords");
        } else {
            _tfRecomPlaceholderLabel.text = @"";
        }
    }
}

#pragma mark -pikerview代理方法
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return _scoreDatas.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{

    return 1;
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return [_scoreDatas objectAtIndex:row];
}

// 返回选中的行
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* sore = [_scoreDatas objectAtIndex:row];
    NSString* str;
    if (sore.length > 0)
        str = [sore substringToIndex:sore.length - 1];
    _serviceScoreLabel.text = str;
    if (_tagIndex == 555 || _tagIndex == 444) {

        _evnScoreLabel.text = str;
    } else {
        _sevLabel.text = str;
    }
}

///宽度
- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth;
}

///高度
- (CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (IBAction)btnSubmitClicked:(UIButton*)sender
{

    if (_tfTasteEvaluate.text.length > 200 || _tfTasteEvaluate.text.length < 10) {
        [GYUtils showToast:kLocalized(@"GYHE_Food_EnterTasteEvaluationTenWords")];
        return;
    }
    if (_tfRecommendFood.text.length != 0 && (_tfRecommendFood.text.length > 200 || _tfRecommendFood.text.length < 10)) {
        [GYUtils showToast:kLocalized(@"GYHE_Food_EnterTasteEvaluationTenWords")];
        return;
    }

    _recommendFoodReason = [_tfRecommendFood.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _comment = [_tfTasteEvaluate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    ;
    _waitTime = [_tfWaitTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    ;

    _envPoint = _evnScoreLabel.text;

    _sevPoint = _sevLabel.text;

    _tastePoint = @(_bar.score * 20 + 40).stringValue;

    if (_bar.score == 0) {
        [self.view makeToast:kLocalized(@"GYHE_Food_SelectTasteScore")];
        return;
    }

    if (!_comment || _comment.length == 0) {
        [self.view makeToast:kLocalized(@"GYHE_Food_EnterTasteEvaluationTenWords")];
        return;
    }
    if (_comment.length < 10) {
        [self.view makeToast:kLocalized(@"GYHE_Food_TasteEvaluationTenWordsLess")];
        return;
    }
    if ([_serviceScoreLabel.text integerValue] == 0 && self.isTakeaway) {
        [self.view makeToast:kLocalized(@"GYHE_Food_SelectServiceScore")];
        return;
    }
    if (!self.isTakeaway && _waitTime.length <= 0) {

        [self.view makeToast:kLocalized(@"GYHE_Food_EnterMealWaitingTime")];
        return;
    }

    sender.enabled = false;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:kSaftToNSString(_userKey) forKey:@"userKey"];

    [params setObject:kSaftToNSString(_recommendationItemName) forKey:@"recommendationItemName"];

    [params setObject:kSaftToNSString(_recommendFoodId) forKey:@"recommendFoodId"];

    [params setObject:kSaftToNSString(_recommendFoodReason) forKey:@"recommendFoodReason"];

    [params setObject:kSaftToNSString(_waitTime) forKey:@"waitTime"];
    if (_envPoint != 0) {
        if (self.isTakeaway) {

            [params setObject:kSaftToNSString(_envPoint) forKey:@"serviceScore"];
        } else {

            [params setObject:kSaftToNSString(_envPoint) forKey:@"evnPoint"];
            [params setObject:kSaftToNSString(_sevPoint) forKey:@"serviceScore"];
        }
    }

    [params setObject:kSaftToNSString(_tastePoint) forKey:@"tastePoint"];

    [params setObject:kSaftToNSString(_comment) forKey:@"comment"];
    [params setObject:kSaftToNSString(_vShopId) forKey:@"vShopId"];
    [params setObject:kSaftToNSString(_shopId) forKey:@"shopId"];
    [params setObject:kSaftToNSString(_orderId) forKey:@"orderId"];
    [params setObject:kSaftToNSString(_userId) forKey:@"userId"];
    //    NSNumber* type = self.isTakeaway ? @(1) : @(2);
    NSString* type = self.foodOrderType;
    [params setObject:kSaftToNSString(type) forKey:@"type"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (int i = 0; i < _picList.count; i++) {
        NSDictionary* dic = _picList[i];
        [list addObject:dic.allValues.firstObject];
    }

    [params setObject:list forKey:@"picList"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:FoodCommentShopUrl
                                                     parameters:params
                                                  requestMethod:GYNetRequestMethodPOST
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           [GYUtils showToast:kLocalized(@"GYHE_Food_EvaluationFaild")];
                                                           return;
                                                       }
                                                       [GYUtils showToast:kLocalized(@"GYHE_Food_EvaluationSuccess")];

                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                                                           BOOL flag = NO;
                                                           for (UIViewController* vc in self.navigationController.viewControllers) {
                                                               if ([vc isMemberOfClass:[FDSelectFoodViewController class]]) {
                                                                   [self.navigationController popToViewController:vc animated:YES];
                                                                   flag = YES;
                                                                   break;
                                                               }
                                                           }
                                                           if (!flag) {
                                                               [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
                                                           }
                                                       });

                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - 点击平分

- (IBAction)scoreClickAction:(UIButton*)sender
{

    _tagIndex = sender.tag;

    [UIView animateWithDuration:0.25
                     animations:^{
                         _myPickerView.frame = CGRectMake(0, kScreenHeight - 258 - 64, kScreenWidth, 258);
                     }];
    _pickerBgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _pickerBgView.hidden = NO;
}

#pragma mark - 推荐菜
- (IBAction)recomClick:(UIButton*)sender
{

    DDLogDebug(@"进入推荐菜");

    FDRecomFoodViewController* vc = [[FDRecomFoodViewController alloc] init];

    vc.myBlock = ^(FDSubmitCommitOrderDetailFoodModel* model) {

        _recommendationItemName = model.foodName;

        _recommendFoodId = model.foodId;

        _recomFoodNameLabel.text = model.foodName;

    };

    vc.userKey = _userKey;
    vc.orderId = _orderId;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 取消平分
- (IBAction)cancelScoreAction:(UIButton*)sender
{

    [_scorePickerView selectRow:0 inComponent:0 animated:YES];

    [UIView animateWithDuration:0.25
                     animations:^{

                         _myPickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 258);

                     }];
    _pickerBgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    _pickerBgView.hidden = YES;
}

#pragma mark - 确定评分
- (IBAction)confirmScoreAction:(UIButton*)sender
{

    //    [_scorePickerView reloadAllComponents];
    [UIView animateWithDuration:0.25
                     animations:^{
                         _myPickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 258);
                     }];
    _pickerBgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    _pickerBgView.hidden = YES;
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{

    if (textView == _tfRecommendFood) {

        if (_recommendationItemName == nil) {

            [GYUtils showMessage:kLocalized(@"GYHE_Food_SelectRecommendDishes")
                         confirm:^{
                         }];
            [textView endEditing:YES];
        }
    }
}

- (void)tfWaitTimeChange:(UITextField *)textField  {

    if ([textField.text doubleValue] > 999) {
        if (textField.text.length > 3) {
            [_tfWaitTime endEditing:NO];
            _tfWaitTime.text = [textField.text substringToIndex:3];
            [GYUtils showMessage:kLocalized(@"GYHE_Food_TheLongWaitingTime")];
            return;
        }
    }
}

@end
