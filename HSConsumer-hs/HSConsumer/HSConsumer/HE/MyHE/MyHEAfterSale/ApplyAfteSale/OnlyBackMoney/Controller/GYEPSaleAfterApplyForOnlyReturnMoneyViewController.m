//
//  GYEPSaleAfterApplyForOnlyReturnMoneyViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.

#import "GYEPSaleAfterApplyForOnlyReturnMoneyViewController.h"
#import "YYKit.h"
#import "UIActionSheet+Blocks.h"
#import "UIButton+GYExtension.h"
#import "EasyPurchaseData.h"
#import "GYGIFHUD.h"
#import "GYEPMyHEViewController.h"
#import "GYUploadImgCell.h"
#import "CellForReturnGoodsCell.h"
#import "GYGetPhotoView.h"

@interface GYEPSaleAfterApplyForOnlyReturnMoneyViewController () <UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, CellForReturnGoodsCellDelegate, GYNetRequestDelegate,GYGetPhotoViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView* scvContainer;
@property (strong, nonatomic) NSMutableArray* arrDataSource;
@property (strong, nonatomic) UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIImageView* ivUploadPicture;
@property (weak, nonatomic) IBOutlet UIButton* btnUploadPicture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* distanceTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* diatanceTop;
@property (weak, nonatomic) IBOutlet UIView* onlyBackView;
@property (weak, nonatomic) IBOutlet YYLabel* lbLabelMoney;
@property (weak, nonatomic) IBOutlet YYLabel* lbMoneyAmount;
@property (nonatomic, assign) double total; //提交的总金额
@property (weak, nonatomic) IBOutlet UILabel* lbLabelInputTip;
@property (weak, nonatomic) IBOutlet UIView* onlyBackMoneyInfoView;
@property (weak, nonatomic) IBOutlet UILabel* returnMoneyInfoLab;
@property (weak, nonatomic) IBOutlet UILabel* plorLabel;
@property (weak, nonatomic) IBOutlet UITextView* tvInputContent;
@property (strong, nonatomic) UICollectionView* collectionView;
@property (assign, nonatomic) CGFloat itemWH; //cell宽高
@property (assign, nonatomic) CGFloat margin; //cell间距
@property (strong, nonatomic) NSMutableArray* selectedPhotos; //选择的图片
@property (strong, nonatomic) NSIndexPath* deletePhoto; //要删除的照片
@property (weak, nonatomic) IBOutlet UILabel* uploadTipLabel; //上传图片提示
@property (weak, nonatomic) IBOutlet UIView* bottomView;
@property (weak, nonatomic) IBOutlet UIButton* commitBtn;
@property (assign, nonatomic) BOOL uploadedImgFlag;
@property (nonatomic, copy) NSString* urlString;
@property (nonatomic, copy) NSString* orderDetailsIDs;
@property (nonatomic, copy) NSString* strReturnAmount;
@property (nonatomic, copy) NSString* strReturnPvAmount;
@property (nonatomic, strong)GYGetPhotoView *getView;
@property (nonatomic, strong)UIView *bgView;

@end

@implementation GYEPSaleAfterApplyForOnlyReturnMoneyViewController

- (UITableView*)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(_onlyBackView.frame.origin.x, 10, kScreenWidth - 30, [CellForReturnGoodsCell getHeight] * self.arrDataSource.count - 1) style:UITableViewStylePlain];
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 6, 0, 6)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setScrollEnabled:NO];
    }
    return _tableView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_bottomView addAllBorder];
    [self.tableView addAllBorder];
    [self.tableView setBottomBorderInset:YES];
    [self.tableView setRightBorderInset:YES];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellForReturnGoodsCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:kCellForReturnGoodsCellIdentifier];
    [_scvContainer addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _uploadedImgFlag = NO;
    [_scvContainer setBackgroundColor:kClearColor];
    _ivUploadPicture.userInteractionEnabled = YES;
    [_btnUploadPicture setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [_btnUploadPicture setTitle:kLocalized(@"GYHE_MyHE_PleaseUpdatePhoto") forState:UIControlStateNormal];
    [self setPropertyWord];
    [self reduceHaveRequestedGoods];
    [self setLabelAndButton];
    [self setHideKeyBoardAndScrollViewFrame];
    [self configCollectionView];
}

- (void)setLabelAndButton
{
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    _urlString = @"";
    _plorLabel.text = kLocalized(@"GYHE_MyHE_RefundEnter200Characters");
    _plorLabel.textColor = [UIColor lightGrayColor];
    self.uploadTipLabel.text = kLocalized(@"GYHE_MyHE_UploadDocumentsTips");
    _returnMoneyInfoLab.text = kLocalized(@"GYHE_MyHE_RefundInstruction");
    _returnMoneyInfoLab.font = [UIFont systemFontOfSize:13];
    _returnMoneyInfoLab.textColor = kCorlorFromHexcode(0x8C8C8C);
    _lbLabelInputTip.text = nil;
    [_commitBtn setBackgroundColor:kClearColor];
    [_commitBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [_commitBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kNavigationBarColor];
    [_commitBtn setTitle:kLocalized(@"GYHE_MyHE_CommitApply") forState:UIControlStateNormal];
}

- (void)setPropertyWord
{
    //属性字符串  *退款金额
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@", kLocalized(@"GYHE_MyHE_RefundMoney")]];
    text.font = [UIFont boldSystemFontOfSize:13.0f];
    text.color = kCorlorFromHexcode(0x8C8C8C);
    [text setColor:kNavigationBarColor range:NSMakeRange(0, 1)];
    _lbLabelMoney.attributedText = text;
    //属性字符串 0.00价格
    NSMutableAttributedString* textMoney = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [GYUtils formatCurrencyStyle:kSaftToDouble(self.dicDataSource[@"total"])]]];
    textMoney.font = [UIFont boldSystemFontOfSize:13.0f];
    textMoney.color = kNavigationBarColor;
    _lbMoneyAmount.attributedText = textMoney;
    _total = kSaftToDouble(self.dicDataSource[@"total"]) //总额-运费
        - kSaftToDouble(self.dicDataSource[@"postAge"]);
    NSMutableAttributedString* textMoney1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [GYUtils formatCurrencyStyle:0]]];
    textMoney1.font = [UIFont boldSystemFontOfSize:13.0f];
    textMoney1.color = kNavigationBarColor;
    _lbMoneyAmount.attributedText = textMoney1;
}

- (void)setHideKeyBoardAndScrollViewFrame
{
    //添加点击隐藏键盘
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [_scvContainer addGestureRecognizer:tapGesture];
    _selectedPhotos = [NSMutableArray array];
    //滚动容器的滚动范围
    [_scvContainer setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_btnUploadPicture.frame) + 50)];
    _tvInputContent.delegate = self;
}

- (void)reduceHaveRequestedGoods
{
    self.arrDataSource = [NSMutableArray array];
    NSArray* arrItems = self.dicDataSource[@"items"];
    for (NSDictionary* dic in arrItems) {
        if (kSaftToNSInteger(dic[@"refundStatus"]) == -1 || kSaftToNSInteger(dic[@"refundStatus"]) == -2 || kSaftToNSInteger(dic[@"refundStatus"]) == 6) {
            [self.arrDataSource addObject:dic];
        }
    }
}

- (void)configCollectionView
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 14;
    _itemWH = (kScreenWidth - 2 * _margin - 4) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 280 + [CellForReturnGoodsCell getHeight] * self.arrDataSource.count, kScreenWidth - 28, _itemWH * 2 + 12) collectionViewLayout:layout];
    _collectionView.backgroundColor = kClearColor;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    [_scvContainer addSubview:_collectionView];
    [_collectionView registerClass:[GYUploadImgCell class] forCellWithReuseIdentifier:@"GYUploadImgCell"];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_selectedPhotos.count >= 5) { //图片不少5张时候，隐藏添加按钮
        return _selectedPhotos.count;
    }
    else {
        return _selectedPhotos.count + 1;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYUploadImgCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GYUploadImgCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imgView.image = [UIImage imageNamed:@"gyhe_upload_img"];
        if (indexPath.row == 5) {
            cell.imgView.image = [UIImage imageNamed:@""];
            cell.contentView.backgroundColor = kClearColor;
            cell.backgroundColor = kClearColor;
        }
    }
    else {
        if (_selectedPhotos.count > indexPath.row) {
            cell.imgView.image = _selectedPhotos[indexPath.row];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == _selectedPhotos.count) {
        if (indexPath.row < 3) {
            self.diatanceTop.constant = -15;
        }
        else {
            self.diatanceTop.constant = _itemWH;
        }
        if (indexPath.row >= 5) {
            return;
        }
        [self pickPhotoButtonClick];
    }
    else {
        self.deletePhoto = indexPath;
        
        [GYUtils showMessge:kLocalized(@"GYHE_MyHE_UpDeletePhoto") confirm:^{
            
            [_selectedPhotos removeObject:_selectedPhotos[self.deletePhoto.row]];
            [self.collectionView reloadData];
            if (_selectedPhotos.count < 4) {
                self.diatanceTop.constant = -15;
            }
            else {
                self.diatanceTop.constant = _itemWH;
            }
            
        } cancleBlock:^{
            
        }];
    }
}

#pragma mark clickEvent
- (void)pickPhotoButtonClick
{
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    self.getView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYGetPhotoView class]) owner:self options:nil] firstObject];
    self.getView.frame = CGRectMake(15, kScreenHeight - 155, kScreenWidth-30, 155);
    self.getView.delegate = self;
    [self.bgView addSubview:self.getView];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.bgView];
}

#pragma mark-GYGetPhotoViewDelegate
-(void)takePhotoBtnClickDelegate
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
- (void)cancelBtnClickDelegate{
    if (_selectedPhotos.count < 4) {
        self.diatanceTop.constant = -15;
    }
    else {
        self.diatanceTop.constant = _itemWH;
    }
    [self.getView removeFromSuperview];
    [self.bgView removeFromSuperview];
}


#pragma mark - CellForReturnGoodsCellDelegate
- (void)selectChange:(id)sender
{
    [self updateAmountAndItemIdsBySelect];
}

- (void)updateAmountAndItemIdsBySelect
{
    CGFloat totalAmount = 0;
    CGFloat totalAmountPv = 0;
    NSMutableArray* arrIDs = [NSMutableArray array];
    CellForReturnGoodsCell* cell = nil;
    for (int i = 0; i < self.arrDataSource.count; i++) {
        cell = (CellForReturnGoodsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.selected) {
            totalAmount += kSaftToDouble(self.arrDataSource[i][@"subTotal"]);
            totalAmountPv += kSaftToDouble(self.arrDataSource[i][@"subPoints"]);
            [arrIDs addObject:kSaftToNSString(self.arrDataSource[i][@"orderDetailId"])];
        }
    }
    totalAmount = totalAmount //总额-抵扣券
        - kSaftToDouble(self.dicDataSource[@"activityAmount"]);
    totalAmount = totalAmount >= 0 ? totalAmount : 0;
    if (arrIDs.count > 0) {
        _orderDetailsIDs = [arrIDs componentsJoinedByString:@","];
    }
    else {
        _orderDetailsIDs = @"";
    }
    _strReturnPvAmount = [@(totalAmountPv) stringValue];
    _strReturnAmount = [@(totalAmount) stringValue];
    [self setReturnAmount:[GYUtils formatCurrencyStyle:totalAmount]];
}

- (void)setReturnAmount:(NSString*)amount
{
    //属性字符串 0.00价格
    NSMutableAttributedString* textMoney = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", amount]];
    textMoney.font = [UIFont boldSystemFontOfSize:13.0f];
    textMoney.color = kNavigationBarColor;
    _lbMoneyAmount.attributedText = textMoney;
}

- (void)loadDataFromNetwork
{
    GlobalData* data = globalData;
    if (_tvInputContent.text.length > 200) {
        _tvInputContent.text = [_tvInputContent.text substringToIndex:200];
    };
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : kSaftToNSString(self.dicDataSource[@"id"]),
        @"orderDetailIds" : _orderDetailsIDs,
        @"reasonDesc" : _tvInputContent.text,
        @"refundType" : @"2", //1 退货，2 仅退款， 3换货
        @"price" : _strReturnAmount,
        @"points" : _strReturnPvAmount,
        @"picUrls" : _urlString };
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyRefundOrSwapItemUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    NSDictionary* dic = responseObject;
    if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) { //返回成功数据
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_CommitSuccess") confirm:^{
            
            NSInteger count = self.navigationController.viewControllers.count;
            for (NSInteger i = count-1; i >= 0; i--) {
                UIViewController *vc = self.navigationController.viewControllers[i];
                if ([vc isKindOfClass:[GYEPMyHEViewController class]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAfterSaleListNotification" object:nil];
                [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count -3] animated:YES];
                    break;
                }
            }
        }];
    }
    else {
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_CommitFail")];
    }
}

#pragma mark - failDelegate
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)hideKeyboard:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (IBAction)btnSubmitApply:(id)sender
{
    
    if(!_orderDetailsIDs || [_orderDetailsIDs isEqualToString:@""]) {
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_PleaseSelectOneGoods")];
        return;
        
    }else if (_tvInputContent.text.length < 1) {
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_PleaseWriteReturnMoneyInstruction")];
        return;
        
    }else if ([GYUtils checkStringInvalid:_urlString]){
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_UploadDocumentsTips")];
        return;
    }
    
    [self loadDataFromNetwork];
}

- (void)photoalbumr
{
    if ([UIImagePickerController isSourceTypeAvailable:

                                     UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* picker =
            [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //  picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_AccessAlbumFailed")];
    }
}

- (void)photocamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagepicker.allowsEditing = NO;
        [self presentViewController:imagepicker animated:YES completion:nil];
    }
    else {
        if (_selectedPhotos.count < 4) {
            self.diatanceTop.constant = -15;
        }
        else {
            self.diatanceTop.constant = _itemWH;
        }
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_DeviceNoSupportCamera")];
    }
}
//此方法用于模态 消除actionsheet
- (void)actionSheetCancel:(UIActionSheet*)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

#pragma mark - PickerviewcontrollerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:@"imgRefundReturnMoney.png"];
    //上传图片获取URL
    GYUploadImage* uploadPic = [[GYUploadImage alloc] init];
    uploadPic.urlType = 3;
    [uploadPic uploadImg:image WithParam:nil];
    uploadPic.delegate = self;
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"imgRefundReturnMoney.png"];
    UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    if (_selectedPhotos.count >= 5) {
        return;
    }
    [_selectedPhotos addObject:savedImage];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3) * (_margin + _itemWH));
    [GYGIFHUD show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    if (_selectedPhotos.count < 4) {
        self.diatanceTop.constant = -15;
    }
    else {
        self.diatanceTop.constant = _itemWH;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SaveImage
- (void)saveImage:(UIImage*)currentImage withName:(NSString*)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    _uploadedImgFlag = YES;
}

#pragma mark 上传图片Delegate
- (void)didFinishUploadImg:(NSURL*)url withTag:(int)index
{
    _urlString = [NSString stringWithFormat:@"%@,%@", [url absoluteString], _urlString != nil ? _urlString : @""]; ////上传多张图片地址
    DDLogInfo(@"上传的图片url:%@", _urlString);
    [GYGIFHUD dismiss];
}
- (void)didFailUploadImg:(NSError*)error withTag:(int)index
{
    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_UploadPicturesFaild") confirm:^{
        
    }];
    _uploadedImgFlag = NO;
    _urlString = @"";
    [GYGIFHUD dismiss];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    unsigned long len = textView.text.length + text.length;
    if (len > 200) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView*)textView
{
    if (textView.text.length == 0) {
        _plorLabel.hidden = NO;
    }
    else {
        _plorLabel.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView*)textView
{
    _commentSting = textView.text;
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    self.distanceTopConstraint.constant = self.arrDataSource.count * 80 + 30;
    return [self.arrDataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellid = kCellForReturnGoodsCellIdentifier;
    CellForReturnGoodsCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[CellForReturnGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSInteger row = indexPath.row;
    NSString* imgUrl = self.arrDataSource[row][@"url"];
    [cell.ivGoodsPicture setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kLoadPng(@"gycommon_image_placeholder") options:kNilOptions completion:nil];
    cell.lbGoodsName.text = self.arrDataSource[row][@"title"];
    cell.lbGoodsPrice.text = [GYUtils formatCurrencyStyle:[self.arrDataSource[row][@"subTotal"] doubleValue]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [CellForReturnGoodsCell getHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellForReturnGoodsCell *cell = (CellForReturnGoodsCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.btnSelect sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
