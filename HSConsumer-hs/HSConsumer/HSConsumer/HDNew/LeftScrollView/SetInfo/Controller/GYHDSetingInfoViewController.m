//
//  GYHDSetingInfoViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSetingInfoViewController.h"
#import "Masonry.h"
#import "GYHDSetingInfoCell.h"
#import "GYHDSetingInfoTextFiledCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDPopMessageTopView.h"
#import "GYHDAddressView.h"
#import "GYCityAddressModel.h"
#import "GYAddressData.h"
#import "GYHDSetingInfoPickerView.h"
#import "GYHDSetingInfoTextViiewCell.h"

#define kGYHDSetingInfoCell @"GYHDSetingInfoCell"
#define kGYHDSetingInfoTextFiledCell @"GYHDSetingInfoTextFiledCell"
#define kGYHDSetingInfoTextViiewCell @"GYHDSetingInfoTextViiewCell"
@interface GYHDSetingInfoViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, GYHDSetingInfoPickerViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) UIImageView* hearderImgV;
@property (nonatomic, strong) UIImageView* backImgView;
@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, strong) NSMutableArray* infoArr;
//背景
@property (nonatomic, strong) UIView* backView;
//下面弹出选择照片弹出框
@property (nonatomic, strong) GYHDPopMessageTopView* messageTopView;
//地址PickerView
@property (nonatomic, strong) GYHDSetingInfoPickerView* addressPickView;
//年龄PickerView
@property (nonatomic, strong) GYHDSetingInfoPickerView* agePickView;
//性别PickerView
@property (nonatomic, strong) GYHDSetingInfoPickerView* sexPickView;

//参数
@property (nonatomic, strong) NSData* imageData;
@property (nonatomic, strong) GYCityAddressModel* cityAddressModel;

//地址选择相关
@property (nonatomic, assign) NSInteger index; //省的选中行
@property (nonatomic, assign) NSInteger row; //市的选中行
@property (nonatomic, strong) NSArray* countryArray;
@property (nonatomic, strong) NSArray* provinceArray;
@property (nonatomic, strong) NSArray* cityArray;

@property (nonatomic, assign) NSInteger ageRow; //年龄的选中行
@property (nonatomic, assign) NSInteger sexRow; //性别的选中行

@property (nonatomic, strong) UITextView* textView; //
//backView
@end

@implementation GYHDSetingInfoViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    _row = 0;
    _index = 0;
    self.view.backgroundColor = [UIColor whiteColor];

    [self setUpUI];

    if (!self.model) {
        [self requestData];
    }
    else {
        [self initPickSelect];
        [self reloadData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate
- (void)textFiledEditChanged:(NSNotification*)obj
{
    UITextField* textField = (UITextField*)obj.object;
    NSString* toBeString = textField.text;
    NSString* lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange* selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition* position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 11) {
                textField.text = [toBeString substringToIndex:11];

                [GYUtils showToastOnKeyboard:kLocalized(@"昵称长度不超过11位")];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else {
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
            [GYUtils showToastOnKeyboard:kLocalized(@"昵称长度不超过11位")];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{

    //爱好
    if (textField.tag == 0) { //昵称
        self.model.nickName = textField.text;
    }
    [self changeInfoRequest];
    [self reloadData];
}

- (void)textViewDidEndEditing:(UITextView*)textView
{
    //爱好

    if (textView.text.length > 40) {
        textView.text = [textView.text substringToIndex:40];
        [GYUtils showMessage:kLocalized(@"爱好长度不超过40位")];
    }
    self.model.hobby = textView.text;

    [self changeInfoRequest];
    [self reloadData];
}

- (void)textViewDidChange:(UITextView*)textView
{

    if (textView.text.length > 40) {
        [textView endEditing:YES];
    }
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(kScreenWidth - 16 - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] } context:nil];
    textView.contentInset = UIEdgeInsetsMake((85 - rect.size.height) / 2.0, 0, 0, 0);
}

#pragma mark - GYHDSetingInfoPickerViewDelegate
- (NSArray<NSArray*>*)dataArrayForSetingInfoPickerView:(GYHDSetingInfoPickerView*)setingInfoPickerView
{

    if (setingInfoPickerView == _addressPickView) {
        NSMutableArray* provinceNameArray = [[NSMutableArray alloc] init];
        NSMutableArray* cityNameArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.provinceArray.count; i++) {
            GYProvinceModel* model = self.provinceArray[i];
            [provinceNameArray addObject:model.provinceName];

            if (i == _index) {
                self.cityArray = [[GYAddressData shareInstance] selectCitysByProvinceNo:model.provinceNo];
                for (int j = 0; j < self.cityArray.count; j++) {
                    GYCityAddressModel* mod = self.cityArray[j];

                    if ([mod.cityName hasSuffix:@"市"]) {
                        NSMutableString* cityName = [NSMutableString stringWithString:mod.cityName];

                        [cityNameArray addObject:[cityName substringToIndex:cityName.length - 1]];
                    }
                    else {
                        [cityNameArray addObject:mod.cityName];
                    }
                }
            }
        }
        return @[ self.countryArray, provinceNameArray, cityNameArray ];
    }
    else if (setingInfoPickerView == _agePickView) {

        NSMutableArray* arr = [[NSMutableArray alloc] init];
        for (int i = 1; i < 121; i++) {
            [arr addObject:[NSString stringWithFormat:@"%d岁", i]];
        }
        return @[ arr ];
    }
    else if (setingInfoPickerView == _sexPickView) {
        return @[ @[ kLocalized(@"男"), kLocalized(@"女") ] ];
    }
    return nil;
}

- (void)setingInfoPickerView:(GYHDSetingInfoPickerView*)setingInfoPickerView didSelectedForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (setingInfoPickerView == _addressPickView) {
        //切换省时，市随之刷新
        if (component == 1) {
            if (_index != row) {
                _index = row;
                [setingInfoPickerView reloadData];
            }
        }
        else if (component == 2) {
            _row = row;
        }
    }
    else if (setingInfoPickerView == _agePickView) {

        _ageRow = row;
    }
    else if (setingInfoPickerView == _sexPickView) {
        _sexRow = row;
    }
}

- (void)finishBtnDidSelect:(GYHDSetingInfoPickerView*)setingInfoPickerView
{

    if (setingInfoPickerView == _addressPickView) {
        //记录选中的模型
        NSInteger selectCity = [self.addressPickView.pickView selectedRowInComponent:2];
        if (self.cityArray.count > selectCity) {
            self.cityAddressModel = self.cityArray[selectCity];
        }

        [self dismissBackView];
        self.model.area = self.cityAddressModel.cityFullName;
        [self reloadData];
        [self changeInfoRequest];
    }
    else if (setingInfoPickerView == _agePickView) {

        NSInteger age = [self.agePickView.pickView selectedRowInComponent:0] + 1;
        [self dismissBackView];
        self.model.age = [NSString stringWithFormat:@"%ld", age];
        [self reloadData];
        [self changeInfoRequest];
    }
    else if (setingInfoPickerView == _sexPickView) {

        NSInteger sexIndex = [self.sexPickView.pickView selectedRowInComponent:0];
        NSString* sex = sexIndex == 1 ? @"0" : @"1";
        [self dismissBackView];
        self.model.sex = sex;
        [self reloadData];
        [self changeInfoRequest];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [self dismissBackView];
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData* imageData = UIImagePNGRepresentation(image);
        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"useriCon%d.png",arc4random()]];
        [imageData writeToFile:fullPath atomically:NO];
        
        weakSelf.imageData = imageData;
        _hearderImgV.image = image;
        [self changeInfoRequest];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.row == 0 || indexPath.row == 4) {
        if (indexPath.row == 0) {
            GYHDSetingInfoTextFiledCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHDSetingInfoTextFiledCell forIndexPath:indexPath];
            if (self.titleArr.count > indexPath.row)
                cell.titleLab.text = self.titleArr[indexPath.row];
            if (self.infoArr.count > indexPath.row)
                cell.textField.text = self.infoArr[indexPath.row];
            cell.textField.tag = indexPath.row;
            cell.textField.delegate = self;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
                                                         name:@"UITextFieldTextDidChangeNotification"
                                                       object:cell.textField];
            return cell;
        }
        else {
            GYHDSetingInfoTextViiewCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHDSetingInfoTextViiewCell forIndexPath:indexPath];
            if (self.titleArr.count > indexPath.row)
                cell.hobitLabel.text = self.titleArr[indexPath.row];
            if (self.infoArr.count > indexPath.row)
                cell.descriptionHobitTextView.text = self.infoArr[indexPath.row];
            cell.descriptionHobitTextView.tag = indexPath.row;
            self.textView = cell.descriptionHobitTextView;
            self.textView.delegate = self;

            CGRect rect = [_textView.text boundingRectWithSize:CGSizeMake(kScreenWidth - 16 - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] } context:nil];
            _textView.contentInset = UIEdgeInsetsMake((85 - rect.size.height) / 2.0 - 10, 0, 0, 0);
            return cell;
        }
    }
    else {
        GYHDSetingInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHDSetingInfoCell forIndexPath:indexPath];
        if (self.titleArr.count > indexPath.row)
            cell.titleLab.text = self.titleArr[indexPath.row];
        if (self.infoArr.count > indexPath.row)
            cell.textLab.text = self.infoArr[indexPath.row];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 4) {
        return 85;
    }
    else {
        return 57;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 1) {
        self.agePickView.delegate = self;
        [self.agePickView.pickView selectRow:_ageRow inComponent:0 animated:YES];
    }
    else if (indexPath.row == 2) {
        self.sexPickView.delegate = self;
        [self.sexPickView.pickView selectRow:_sexRow inComponent:0 animated:YES];
    }
    else if (indexPath.row == 3) {

        self.addressPickView.delegate = self;
        [self.addressPickView.pickView selectRow:_row inComponent:2 animated:YES];
        [self.addressPickView.pickView selectRow:_index inComponent:1 animated:YES];
    }
}

#pragma mark - 点击事件
- (void)pushBack
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//拍照，相册
- (void)showPhoto:(UIButton*)btn
{

    WS(weakSelf)
    self.messageTopView.block = ^(NSString* messageString) {
        if ([messageString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_take_photos"]]) {
            [weakSelf photocamera];
        } else if ([messageString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_my_ablum"]]) {
            [weakSelf photoalbumr];
        }
        [weakSelf dismissBackView];
    };
}

- (void)dismissBackView
{

    [_backView removeFromSuperview];
    _backView = nil;
    [_messageTopView removeFromSuperview];
    _messageTopView = nil;
    [_addressPickView removeFromSuperview];
    _addressPickView = nil;
    [_agePickView removeFromSuperview];
    _agePickView = nil;
    [_sexPickView removeFromSuperview];
    _sexPickView = nil;
}

- (void)finishAction
{
}

#pragma mark - 自定义方法
//网络请求
- (void)requestData
{
    //d6aa97dbc1804f194386ef98e444fab6af825bfe43d76c31f3190197a17d3085
    [[GYHDMessageCenter sharedInstance] searchFriendWithCustId:globalData.loginModel.custId RequetResult:^(NSDictionary* resultDict) {
        
        NSMutableDictionary *friendDetailDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:resultDict[GYHDDataBaseCenterFriendDetailed]]];
        self.model = [[GYHDUserSetingHeaderModel alloc] initWithDictionary:friendDetailDict error:nil];
        [self initPickSelect];
        [self reloadData];

    }];
}

- (void)changeInfoRequest
{
    NSMutableDictionary* dict = @{
        @"nickname" : kSaftToNSString(self.model.nickName),
        @"headShot" : @"",
        @"age" : kSaftToNSString(self.model.age),
        @"sex" : kSaftToNSString(self.model.sex),
        @"countryNo" : kSaftToNSString(self.cityAddressModel.countryNo),
        @"provinceNo" : kSaftToNSString(self.cityAddressModel.provinceNo),
        @"cityNo" : kSaftToNSString(self.cityAddressModel.cityNo),
        @"area" : kSaftToNSString(self.model.area),
        @"hobby" : kSaftToNSString(self.model.hobby),
        @"individualSign" : kSaftToNSString(self.model.sign),
    }.mutableCopy;
    if (_imageData) {
        [dict setObject:_imageData forKey:@"imageData"];
    }
    WS(weakSelf);
    [[GYHDMessageCenter sharedInstance] updateSelfInfoWith:dict RequetResult:^(NSDictionary* resultDict) {
        
        
        if (resultDict) {
            if ([resultDict[@"retCode"] integerValue] == 200) {
                if (_imageData) {
                    [ weakSelf requestData];
                }
                
            }else {
                [GYUtils showToast:resultDict[@"message"] duration:2.5f position:CSToastPositionBottom];
            }
        }else {
            [GYUtils showMessage:@"保存资料失败！"];
        }
    }];
}

//加载数据源
- (void)reloadData
{
    NSString* imgUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, self.model.headImage];
    if ([self.model.headImage hasPrefix:@"http"]) {
        imgUrl = self.model.headImage;
    }
    
    [self.hearderImgV setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    [self.backImgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:[UIImage imageNamed:@"msg_imgph"]];

    NSString* sex = [self.model.sex isEqualToString:@"0"] ? kLocalized(@"女") : ([self.model.sex isEqualToString:@"1"] ? kLocalized(@"男") : @"");

    self.infoArr = @[ kSaftToNSString(self.model.nickName),
        kSaftToNSString(self.model.age),
        kSaftToNSString(sex),
        kSaftToNSString(self.model.area),
        kSaftToNSString(self.model.hobby) ].mutableCopy;

    [self.tabView reloadData];
}

- (void)initPickSelect
{
    //初始化pickView默认选中行

    _sexRow = [self.model.sex isEqualToString:@"0"] ? 1 : 0;
    _ageRow = [self.model.age intValue] == 0 ? 0 : [self.model.age intValue] - 1;
    
    for (int i = 0; i < self.provinceArray.count; i++) {
        GYProvinceModel* model = self.provinceArray[i];
        if (model.provinceNo == self.model.province) {
            _index = i;
            self.cityArray = [[GYAddressData shareInstance] selectCitysByProvinceNo:model.provinceNo];
            for (int j = 0; j < self.cityArray.count; j++) {
                GYCityAddressModel* mod = self.cityArray[j];
                if (mod.cityNo == self.model.city) {
                    _row = j;
                }
            }
        }
    }
}

//UI设置
- (void)setNav
{

    self.navigationController.navigationBarHidden = YES;
    UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBut setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBut];
    [self.view bringSubviewToFront:backBut];
    [backBut mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(50);
    }];

    UILabel* lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:17];
    lab.textColor = [UIColor whiteColor];
    lab.text = @"网络信息设置";
    [self.view addSubview:lab];
    [self.view bringSubviewToFront:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(backBut.mas_centerY);
    }];
}

- (void)setUpUI
{

    UIImageView* backImgView = [[UIImageView alloc] init];
    backImgView.image = [UIImage imageNamed:@"gycommon_image_placeholder"];
    backImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backImgView];
    _backImgView = backImgView;
    [backImgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.mas_equalTo(-20);
        make.right.mas_equalTo(20);
        make.height.equalTo(backImgView.mas_width);
    }];

    UIView* fontView = [[UIView alloc] init];
    fontView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [backImgView addSubview:fontView];
    [fontView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];

    self.tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tabView.rowHeight = 57;
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tabView];

    [self.tabView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.right.bottom.mas_equalTo(0);

    }];
    self.tabView.contentInset = UIEdgeInsetsMake(kScreenWidth / 720.0 * 274.0, 0, 0, 0);
    self.tabView.backgroundColor = [UIColor clearColor];
    self.tabView.separatorColor = UIColorFromRGB(0xebebeb);
    self.tabView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);

    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDSetingInfoCell class]) bundle:nil] forCellReuseIdentifier:kGYHDSetingInfoCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDSetingInfoTextFiledCell class]) bundle:nil] forCellReuseIdentifier:kGYHDSetingInfoTextFiledCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDSetingInfoTextViiewCell class]) bundle:nil] forCellReuseIdentifier:kGYHDSetingInfoTextViiewCell];

    [self setNav];
    [self setHeader];
}

- (void)setHeader
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 118)];
    view.backgroundColor = [UIColor clearColor];
    UIView* sub = [[UIView alloc] init];
    sub.backgroundColor = [UIColor whiteColor];
    [view addSubview:sub];
    [sub mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(68);
    }];
    UIImageView* imgView = [[UIImageView alloc] init];
    imgView.layer.cornerRadius = 50;
    imgView.clipsToBounds = YES;
    imgView.image = [UIImage imageNamed:@"gyhd_defaultheadimg"];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(view);
        make.width.height.mas_equalTo(100);
        make.top.mas_equalTo(0);
    }];

    UIButton* cameraBtn = [[UIButton alloc] init];
    [cameraBtn setImage:[UIImage imageNamed:@"gyhd_leftScrollView_camera"] forState:UIControlStateNormal];
    cameraBtn.imageEdgeInsets = UIEdgeInsetsMake(60, 0, 0, 0);
    [view addSubview:cameraBtn];
    [cameraBtn addTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.centerY.equalTo(imgView);
        make.width.height.mas_equalTo(100);
    }];
    _hearderImgV = imgView;

    self.tabView.tableHeaderView = view;
}

//进入相册
- (void)photoalbumr
{
    if ([UIImagePickerController isSourceTypeAvailable:
                                     UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* picker =
            [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (appName == nil) {
            appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        };
        [[[UIAlertView alloc] initWithTitle:nil message:[GYUtils localizedStringWithKey:@"GYHD_setPrivacyCamera"] delegate:nil cancelButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_confirm"] otherButtonTitles:nil] show];
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

        imagepicker.allowsEditing = YES;

        [self presentViewController:imagepicker animated:YES completion:nil];
    }
    else {
        NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (appName == nil) {
            appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        };
        [[[UIAlertView alloc] initWithTitle:nil message:[GYUtils localizedStringWithKey:@"GYHD_setPrivacyCamera"] delegate:nil cancelButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_confirm"] otherButtonTitles:nil] show];
    }
}

#pragma mark - 懒加载
- (NSArray*)titleArr
{
    if (!_titleArr) {
        _titleArr = @[ kLocalized(@"昵称"), kLocalized(@"年龄"), kLocalized(@"性别"), kLocalized(@"地区"), kLocalized(@"爱好") ];
    }
    return _titleArr;
}

- (NSMutableArray*)infoArr
{
    if (!_infoArr) {
        _infoArr = @[ @"", @"", @"", @"", @"" ].mutableCopy;
    }
    return _infoArr;
}

- (UIView*)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.7;

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackView)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

- (GYHDPopMessageTopView*)messageTopView
{
    if (!_messageTopView) {

        [self.view addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.left.right.top.mas_equalTo(0);
        }];

        NSArray* messageArray = @[ [GYUtils localizedStringWithKey:@"GYHD_choose_Image"], [GYUtils localizedStringWithKey:@"GYHD_take_photos"], [GYUtils localizedStringWithKey:@"GYHD_my_ablum"] ];
        _messageTopView = [[GYHDPopMessageTopView alloc] initWithMessageArray:messageArray];
        UIWindow* wind = [UIApplication sharedApplication].keyWindow;
        [wind addSubview:_messageTopView];
        [_messageTopView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(140);
        }];
    }
    return _messageTopView;
}

- (GYHDSetingInfoPickerView*)addressPickView
{
    if (!_addressPickView) {
        //        [self.view addSubview:self.backView];
        //        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.bottom.left.right.top.mas_equalTo(0);
        //        }];
        //
        _addressPickView = [[GYHDSetingInfoPickerView alloc] init];
        _addressPickView.backgroundColor = [UIColor whiteColor];
        UIWindow* wind = [UIApplication sharedApplication].keyWindow;
        [wind addSubview:_addressPickView];

        [_addressPickView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(180);
        }];
    }
    return _addressPickView;
}

- (GYHDSetingInfoPickerView*)agePickView
{
    if (!_agePickView) {
        //        [self.view addSubview:self.backView];
        //        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.bottom.left.right.top.mas_equalTo(0);
        //        }];

        _agePickView = [[GYHDSetingInfoPickerView alloc] init];
        _agePickView.backgroundColor = [UIColor whiteColor];
        UIWindow* wind = [UIApplication sharedApplication].keyWindow;
        [wind addSubview:_agePickView];
        [_agePickView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(180);
        }];
    }
    return _agePickView;
}

- (GYHDSetingInfoPickerView*)sexPickView
{
    if (!_sexPickView) {
        //        [self.view addSubview:self.backView];
        //        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.bottom.left.right.top.mas_equalTo(0);
        //        }];

        _sexPickView = [[GYHDSetingInfoPickerView alloc] init];
        _sexPickView.backgroundColor = [UIColor whiteColor];
        UIWindow* wind = [UIApplication sharedApplication].keyWindow;
        [wind addSubview:_sexPickView];
        [_sexPickView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(180);
        }];
    }
    return _sexPickView;
}

- (NSArray *)countryArray {
    if(!_countryArray) {
        NSArray* countryArray = @[ [GYUtils localizedStringWithKey:@"GYHD_china"] ];
        _countryArray = countryArray;
    }
    return _countryArray;
}

- (NSArray *)provinceArray {
    if(!_provinceArray) {
        NSArray* provinceArray = [[GYAddressData shareInstance] selectAllProvinces];
        _provinceArray = provinceArray;
    }
    return _provinceArray;
}

- (NSArray *)cityArray {
    if(!_cityArray) {
        _cityArray = [[NSArray alloc] init];
    }
    return _cityArray;
}

@end
