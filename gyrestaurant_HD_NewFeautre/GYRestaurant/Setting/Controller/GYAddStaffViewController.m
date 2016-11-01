//
//  GYAddStaffViewController.m
//  GYRestaurant
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddStaffViewController.h"
#import "GYSelectedButton.h"
#import "GYSystemSettingViewModel.h"
#import "GYSystemSettingModel.h"
#import "GYDeliverModel.h"
#import "UIView+Toast.h"
#import "GYNetRequest.h"

@interface GYAddStaffViewController ()<UITextFieldDelegate,GYSelectedButtonDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,GYNetRequestDelegate>

@property(nonatomic, strong) GYSelectedButton *selectCompanyUserBtn;
@property(nonatomic, strong) GYSelectedButton *selectSexBtn;
@property(nonatomic, strong) GYSelectedButton *selectStateBtn;
//@property(nonatomic, strong) GYSelectedButton *selectShopBtn;
@property(nonatomic, strong) UIScrollView *svBackView;
@property(nonatomic, strong) UITextField *staffNameTF;
@property(nonatomic, strong) UITextField *numTF;
@property(nonatomic, strong) UITextField *remarkTF;
@property(nonatomic, strong) NSMutableArray *shopArr;
@property(nonatomic, strong) UIButton *selectPhotoBtn;
@property (nonatomic, assign) int index;
@property(nonatomic, strong) GYDeliverModel *deliverModel;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, copy) NSString *sexStr;
@property(nonatomic, copy) NSString *statusStr;
@property(nonatomic, copy) NSString *shopNameStr;
@property(nonatomic, strong) NSMutableArray *resDataArr;
@property(nonatomic, copy) NSString *userStr;
@property(nonatomic, copy) NSString *picUrlStr;
@property(nonatomic, strong) GYSystemSettingModel *settingModel;
@property(nonatomic, copy) NSString *shopID;
@property(nonatomic, copy) NSString *employeeID;
@property (nonatomic, strong) UITextField *shopNameTextField;
@end

@implementation GYAddStaffViewController
#pragma mark - 继承系统
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self httpRequestRoleIdIsNull];
   // [self httpGetShopList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    
}
#pragma mark - 创建视图
-(void)createView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"IncreaseDeliveryStaff") withTarget:self withAction:@selector(popBack)];
    
    _svBackView = [[UIScrollView alloc ] initWithFrame:self.view.bounds];
    _svBackView.showsVerticalScrollIndicator = NO;
    _svBackView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight);
    _svBackView.userInteractionEnabled = YES;
    [self.view addSubview:_svBackView];
    
    
    UIImageView *imgViewLine = [[UIImageView alloc]init];
    imgViewLine.image = [UIImage imageNamed:@"redline.png"];
    [_svBackView addSubview:imgViewLine];
    [imgViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(2));
        
    }];
    
    UIView *v1 = [self createdViewWithX:0 y:0 width:kScreenWidth height:kScreenHeight - 66];
    UILabel *nameLable = [self createdLableWithText:kLocalized(@"DeliveryNamesOfTheMembers") textColor:[UIColor darkGrayColor]];
    nameLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(20);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    
    _staffNameTF = [[UITextField alloc]init];
    _staffNameTF.background = [UIImage imageNamed:@"blueBox.png"];
    _staffNameTF.keyboardType =  UIKeyboardTypeDefault;
    
    _staffNameTF.delegate = self;
    if (!_staffNameTF.text) {
        [self notifyWithText:kLocalized(@"DeliveryStaffNameCanNotBeEmpty")];
    }
    
    [v1 addSubview:_staffNameTF];
    
    [_staffNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(20);
        make.left.equalTo(nameLable.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    _selectCompanyUserBtn = [[GYSelectedButton alloc]init];
    _selectCompanyUserBtn.delegate = self;
    _selectCompanyUserBtn.tag = 100;
    [_selectCompanyUserBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:_selectCompanyUserBtn];
    [_selectCompanyUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(20);
        make.left.equalTo(_staffNameTF.mas_right).offset(30);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    NSString *companyUserName = kLocalized(@"SelectBusinessUsers");
    if (companyUserName.length > 0) {
        [_selectCompanyUserBtn setTitle:kLocalized(@"SelectBusinessUsers") forState:UIControlStateNormal];
    }
    UILabel *sexLable = [self createdLableWithText:kLocalizedAddParams(kLocalized(@"Person_sec"), @":") textColor:[UIColor darkGrayColor]];
    sexLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:sexLable];
    [sexLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(80);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    
    
    _selectSexBtn = [[GYSelectedButton alloc]init];
    [_selectSexBtn dataSourceArr:[NSMutableArray arrayWithObjects:kLocalized(@"Male"),kLocalized(@"Female"), nil]];
    
    _selectSexBtn.delegate = self;
    // _selectSexBtn.tag = 101;
    
    [v1 addSubview:_selectSexBtn];
    [_selectSexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(80);
        make.left.equalTo(sexLable.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
  //  NSString *sexStr = @"请选择";
    if (_sexStr.length > 0) {
        [_selectSexBtn setTitle:_sexStr forState:UIControlStateNormal];
    }else{
    [_selectSexBtn setTitle:kLocalized(@"PleaseSelect") forState:UIControlStateNormal];
    
    }
    
    UILabel *numLable = [self createdLableWithText:kLocalizedAddParams(kLocalized(@"contactNumber"), @":") textColor:[UIColor darkGrayColor]];
    numLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:numLable];
    [numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(140);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    _numTF = [[UITextField alloc]init];
    _numTF.background = [UIImage imageNamed:@"blueBox.png"];
    _numTF.keyboardType = UIKeyboardTypeNumberPad;
    _numTF.delegate = self;
    
    [v1 addSubview:_numTF];
    
    [_numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(140);
        make.left.equalTo(numLable.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
//    UILabel *stateLable = [self createdLableWithText:@"状态:" textColor:[UIColor darkGrayColor]];
//    stateLable.textAlignment = NSTextAlignmentRight;
//    [v1 addSubview:stateLable];
//    [stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(v1.mas_top).offset(200);
//        make.left.equalTo(v1.mas_left).offset(10);
//        make.width.equalTo(@(kScreenWidth / 4 - 30));
//        make.height.equalTo(@40);
//    }];
//    
//    
//    _selectStateBtn = [[GYSelectedButton alloc]init];
//    [_selectStateBtn dataSourceArr:[NSMutableArray arrayWithObjects:@"启用",@"禁用", nil]];
//    _selectStateBtn.delegate = self;
//    _selectStateBtn.tag = 102;
//    
//    [v1 addSubview:_selectStateBtn];
//    [_selectStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(v1.mas_top).offset(200);
//        make.left.equalTo(stateLable.mas_right).offset(10);
//        make.width.equalTo(@(kScreenWidth / 3 - 30));
//        make.height.equalTo(@40);
//    }];
//    NSString *stateStr = @"启用";
//    if (stateStr.length > 0) {
//        [_selectStateBtn setTitle:@"启用" forState:UIControlStateNormal];
//    }
    
    UILabel *remarkLable = [self createdLableWithText:kLocalizedAddParams(kLocalized(@"Remark"), @":") textColor:[UIColor darkGrayColor]];
    remarkLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:remarkLable];
    [remarkLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(200);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    _remarkTF = [[UITextField alloc]init];
    _remarkTF.background = [UIImage imageNamed:@"blueBox.png"];
    _remarkTF.keyboardType = UIKeyboardTypeDefault;
    _remarkTF.delegate = self;
    
    [v1 addSubview:_remarkTF];
    
    [_remarkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(200);
        make.left.equalTo(numLable.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    
    UILabel *photoLable = [self createdLableWithText:kLocalizedAddParams(kLocalized(@"Photo"), @":") textColor:[UIColor darkGrayColor]];
    photoLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:photoLable];
    [photoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(260);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    
    
    _selectPhotoBtn = [self createdButtonTitle:nil titleColor:[UIColor darkGrayColor] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0] fontSize:20.0];
    [_selectPhotoBtn setBackgroundImage:[UIImage imageNamed:@"name"] forState:UIControlStateNormal];
    _selectPhotoBtn.tag = 103;
    [v1 addSubview:_selectPhotoBtn];
    [_selectPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(260);
        make.left.equalTo(photoLable.mas_right).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    UILabel *desLable = [self createdLableWithText:kLocalized(@"NoMoreThan 1M,Support jpg, png Format.") textColor:[UIColor darkGrayColor]];
    desLable.font = [UIFont systemFontOfSize:14];
    desLable.textAlignment = NSTextAlignmentLeft;
    [v1 addSubview:desLable];
    [desLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(260);
        make.left.equalTo(_selectPhotoBtn.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    
    UILabel *shopLable = [self createdLableWithText:kLocalizedAddParams(kLocalized(@"IncludeOfBusiness"), @":") textColor:[UIColor darkGrayColor]];
    shopLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:shopLable];
    [shopLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(380);
        make.left.equalTo(v1.mas_left).offset(10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    
    _shopNameTextField = [[UITextField alloc] init];
   _shopNameTextField.background = [UIImage imageNamed:@"blueBox.png"];
    _shopNameTextField.userInteractionEnabled = NO;
     [v1 addSubview:_shopNameTextField];
    
    [_shopNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(380);
        make.left.equalTo(shopLable.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    _shopNameTextField.text = kGetNSUser(@"shopName");
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"dottedline.png"];
    [v1 addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopLable.mas_top).offset(100);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@2);
    }];
    
    UIButton *cancelBtn = [self createdButtonTitle:kLocalized(@"Cancel") titleColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:30.0];
    cancelBtn.tag = 105;
    [cancelBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_top).offset(30);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 350)/2.0);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    
    UIButton *confirmBtn = [self createdButtonTitle:kLocalized(@"Determine") titleColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:30.0];
    [confirmBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.tag = 106;
    [v1 addSubview:confirmBtn];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_top).offset(30);
        make.left.equalTo(cancelBtn.mas_right).offset(50);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];
    
}

#pragma mark -----点击事件
- (void)select:(UIButton *)btn
{
    if (btn.tag == 105) {
        [self popBack];
    }
//    else if(btn.tag == 104){
//        
//     //   [self httpGetShopList];
//        
//    }
    else if (btn.tag == 103){
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:kLocalized(@"PleaseSelectPhotoUploads") delegate:self cancelButtonTitle:nil destructiveButtonTitle:kLocalized(@"Photograph") otherButtonTitles:kLocalized(@"PhotoGallery"), nil];
        
        [actionSheet showFromRect:CGRectMake(CGRectGetMaxX(_selectPhotoBtn.frame)-140, CGRectGetMaxY(_selectPhotoBtn.frame)-70, 150, 100) inView:self.view animated:YES];
        
    }else if (btn.tag == 106){
        
        [self httpRequestDeliver: btn];
        
    }else if (btn.tag == 100){
        
        [self httpRequestRoleIdIsNull];
        
        
    }
}
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
-(NSMutableArray *)dataArr{
    
    if (_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
-(NSMutableArray *)resDataArr{
    if (!_resDataArr) {
        _resDataArr = [[NSMutableArray alloc] init];
    }
    
    return _resDataArr;
}
-(NSMutableArray *)shopArr{
    if (!_shopArr) {
        _shopArr = [[NSMutableArray alloc] init];
    }
    return _shopArr;
}

#pragma mark - 网络请求
/**
 *  添加送餐员请求
 */
-(void)httpRequestDeliver: (UIButton *)button{
    
    if ([_selectSexBtn.titleLabel.text isEqualToString:kLocalized(@"Male")]) {
        [_selectSexBtn setTitle:@"1" forState:UIControlStateNormal];
    }else if ([_selectSexBtn.titleLabel.text isEqualToString:kLocalized(@"Female")]) {
        [_selectSexBtn setTitle:@"0" forState:UIControlStateNormal];
        
    }
    NSString *str;
    if (_employeeID.length > 0) {
        str = _employeeID;
    }else{
        str = @"";
        
    }
    if (_picUrlStr.length == 0) {
        _picUrlStr = @"";
    }
    if (!kGetNSUser(@"shopId")) {
        return;
    }
    if (!kGetNSUser(@"shopName")) {
        return;
    }
   
    
    if (_staffNameTF.text.length == 0) {
        [self notifyWithText:kLocalized(@"DeliveryStaffNameCanNotBeEmpty")];
    }else if (_sexStr.length == 0 && _staffNameTF.text.length > 0) {
        [self notifyWithText:kLocalized(@"DeliveryStaffSexCanNotBeEmpty")];
    }else if (_numTF.text.length == 0 && _staffNameTF.text.length > 0 && _sexStr.length > 0){
       [self notifyWithText:kLocalized(@"DeliveryStaffPhoneNumCanNotBeEmpty")];
    }if(_numTF.text.length != 11 && _staffNameTF.text > 0 && _sexStr.length > 0 && _numTF.text.length > 0){
        [self notifyWithText:kLocalized(@"PhoneNumberYouEnteredShouldBe11Bits!")];
    }else if(_staffNameTF.text > 0 && _sexStr.length > 0 && _numTF.text.length == 11){
      
        
        GYSystemSettingViewModel *viewModel=[[GYSystemSettingViewModel alloc] init];
        [button controlTimeOut];
        [self modelRequestNetwork:viewModel :^(id resultDic) {
            
            _dataArr = resultDic;
        } isIndicator:YES];
        
        [viewModel postAddDeliverWithKey:globalData.loginModel.token andName:_staffNameTF.text andPicUrl:_picUrlStr andPhone:_numTF.text andShopName:kGetNSUser(@"shopName") andRemark:_remarkTF.text andSex:_selectSexBtn.titleLabel.text andStatus:@"1" andShopId:kGetNSUser(@"shopId")  andVShopId:globalData.loginModel.vshopId andCustId:str];
        if ([_sexStr isEqualToString:@"0"]) {
            [_selectSexBtn setTitle:kLocalized(@"Female") forState:UIControlStateNormal];
        }else if ([_sexStr isEqualToString:@"1"]) {
            [_selectSexBtn setTitle:kLocalized(@"Male") forState:UIControlStateNormal];
        }
        [self performSelector:@selector(popBack) withObject:nil afterDelay:1.0f];
    }
    
}

/**
 *  查询企业用户roleID为空的列表请求
 */
-(void)httpRequestRoleIdIsNull{
    
    GYSystemSettingViewModel *viewModel=[[GYSystemSettingViewModel alloc] init];

    [self modelRequestNetwork:viewModel :^(id resultDic) {
        NSMutableArray *array = [NSMutableArray array];
        for (GYDeliverModel *model in resultDic) {
            [array addObject:model.realName];
            
        }
        [_selectCompanyUserBtn dataSourceArr:array];
        
        _resDataArr = resultDic;
  
    } isIndicator:YES];
    
    [viewModel getEmployeeRoleIdIsNullWithKey:globalData.loginModel.token andEResNo:globalData.loginModel.entCustId vShopId:globalData.loginModel.vshopId];
    
}


#pragma mark - UIActionSheet的代理方法

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *pickerCtl = [[UIImagePickerController alloc] init];
    pickerCtl.delegate = self;
    
    switch (buttonIndex) {
        case 0:{
            
            [self pickImageFromCamera];
            
        }
            break;
            
        case 1:{
            
            [self pickImageFromAlbum];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


#pragma mark - 从相册选取照片上传
-(void)pickImageFromAlbum{
    
    UIImagePickerController *pickCtl = [[UIImagePickerController alloc] init];
    [pickCtl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [pickCtl setDelegate:self];
    [pickCtl setAllowsEditing:YES];
    
    pickCtl.modalPresentationStyle  = UIModalPresentationPopover;
    pickCtl.popoverPresentationController.sourceView = self.view;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:103];
    pickCtl.popoverPresentationController.sourceRect = ((UIButton *)btn).frame;
    
    [self presentViewController:pickCtl animated:YES completion:nil];
    
}

#pragma mark - 从摄像头获取照片上传
- (void)pickImageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickCtl = [[UIImagePickerController alloc] init];
        pickCtl.delegate = self;
        pickCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickCtl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        pickCtl.allowsEditing = YES;
        
        [self presentViewController:pickCtl animated:YES completion:nil];
    }
    else {
         [[UIApplication sharedApplication].delegate.window  makeToast:kLocalized(@"DeviceDoesNotSupportCameraFunctions") duration:1.f position:CSToastPositionBottom ];
    }
}

#pragma mark - UIImagePickerControllerDelegate的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 获取图片名称
    NSURL * Url =[info objectForKey:UIImagePickerControllerReferenceURL];
    NSString * strUrl = [Url absoluteString];
    
    // 得到文件名称
    NSRange one = [strUrl rangeOfString:@"="];
    NSRange two = [strUrl rangeOfString:@"&"];
    NSString * name = [strUrl substringWithRange:NSMakeRange(one.location+1, two.location - one.location-1)];
    NSString * strType = [strUrl substringFromIndex:strUrl.length - 3];
    DDLogCInfo(@"%@,%@,%@",strType,strUrl,name);
    NSString * imageName = [NSString stringWithFormat:@"%@.%@",name,strType];
    //换成二进制数据
    NSData *imageData = UIImageJPEGRepresentation(image1, 0.75);
    // 获取沙盒目录
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    // 检查文件大小 不能大于1M
    NSFileManager * fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    if (fSize >  1024 * 1024) {
        [self notifyWithText:kLocalized(@"UploadImageCanNotBeGreaterThan 1M,UploadFailed,PleaseRe-selectPicture")];
      
 
        [fm removeItemAtPath:fullPath error:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIImage *image = info[@"UIImagePickerControllerEditedImage"];
        [_selectPhotoBtn setBackgroundImage:image forState:UIControlStateNormal ];

        [self saveImage:image1 withName:imageName];

        NSString *upUrl = [NSString stringWithFormat:@"%@/userc/upload?type=%@&fileType=%@",[GYGlobalData sharedInstant].loginModel.hsecFoodPadUrl,@"headPic",@"image"];
        GYNetRequest *uploadRequest = [[GYNetRequest alloc] initWithUploadDelegate:self baseURL:nil URLString:upUrl parameters:nil constructingBlock:^(id<AFMultipartFormData> formData) {
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
                if ((float)data.length/1024 > 1000) {
                        data = UIImageJPEGRepresentation(image, 1024*1000.0/(float)data.length);
                        }
                [formData appendPartWithFileData:data name:@"1" fileName:@"1.jpg" mimeType:@"image/jpeg"];
            
        }];
        [uploadRequest start];
   
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
/**
 *  点击取消销毁控制器
 *
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GYNetRequestDelegate

- (void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject {
    DDLogCInfo(@"打印结果 ======= %@",responseObject);
    if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
        kNotice(kLocalized(@"UploadSuccessful"));
        NSString *url = responseObject[@"data"];
        NSRange range  = [url rangeOfString:@"//" options:NSBackwardsSearch];
        NSRange subRange = {range.location + range.length, url.length - range.location - range.length};
        _picUrlStr = [url substringWithRange:subRange];
    }else{
        kNotice(kLocalized(@"UploadFailed"));
    }
    
}

- (void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
   
    kNotice(kLocalized(@"UploadFailed"));
}

//保存图片至沙盒
#pragma mark - save
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}



//#pragma mark - 请求查询营业点列表
//- (void)httpGetShopList
//{
//    GYSystemSettingViewModel *setting = [[GYSystemSettingViewModel alloc]init];
//    
//    [self modelRequestNetwork:setting :^(id resultDic) {
//        
//        NSMutableArray *array = [NSMutableArray array];
//        for (GYSystemSettingModel *model in resultDic) {
//            [array addObject:model.shopName];
//        }
//        [_selectShopBtn dataSourceArr:array];
//        _shopArr = resultDic;
//        
//    } isIndicator:YES];
//    
//    [setting getShopList];
//    
//}

#pragma mark-------创建lab
- (UILabel *)createdLableWithText:(NSString *)text
                        textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:20.0];
    return label;
}


#pragma mark-------创建btn
/**
 *	@param 	title           标题
 *	@param 	titleColor      标题颜色
 *	@param 	backgroundColor btn背景颜色
 *	@param 	fontSize        标题字体大小
 */
- (UIButton *)createdButtonTitle:(NSString *)title
                      titleColor:(UIColor *)titleColor
                 backgroundColor:(UIColor *)backgroundColor
                        fontSize:(CGFloat)fontSize

{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [button addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark － 创建一个View
/**
 *	@param 	x           x点坐标
 *	@param 	y           y点坐标
 *	@param 	width       view宽度
 *	@param 	height      view的高度
 */

- (UIView *)createdViewWithX:(int)x
                           y:(int)y
                       width:(int)width
                      height:(int)height
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(x, y, width, height);
    [_svBackView addSubview:view];
    return view;
}

#pragma mark -GYSelectedButtonDelegate
- (void)GYSelectedButtonDidClick:(GYSelectedButton *) btn withContent :(NSString *)content
{
    if (btn == _selectSexBtn) {
        _sexStr = content;
        if ([_sexStr isEqualToString:kLocalized(@"Male")]) {
            _sexStr = @"1";
            [_selectSexBtn setTitle:kLocalized(@"Male") forState:UIControlStateNormal];
        }else{
            _sexStr = @"2";
            [_selectSexBtn setTitle:kLocalized(@"Female") forState:UIControlStateNormal];
        }
    }
//    else if(btn == _selectStateBtn){
//        
//        _statusStr = content;
//        if ([_statusStr isEqualToString:@"禁用"]) {
//            _statusStr = @"0";
//        }else{
//            
//            _statusStr = @"1";
//        }
//        
//    }
   else if (btn == _selectCompanyUserBtn){
        
        _userStr = content;
        
        for (int i = 0; i < _resDataArr.count; i++) {
            _deliverModel = _resDataArr[i];
        }
        
        for (_deliverModel in _resDataArr) {
            if ([_userStr isEqualToString:_deliverModel.realName]) {
                _staffNameTF.text = _userStr ;
                _numTF.text = _deliverModel.mobile;
                _remarkTF.text = _deliverModel.remark;
                _picUrlStr = _deliverModel.pic;
                _employeeID = _deliverModel.operCustId;
                _shopID = _deliverModel.shopId;
               
                if ([_deliverModel.sex isEqualToString:@""] || !_deliverModel.sex) {
                    [_selectSexBtn setTitle:kLocalized(@"PleaseSelect") forState:UIControlStateNormal];
                }else{
                    [_selectSexBtn setTitle:_deliverModel.sex forState:UIControlStateNormal];
                }
   
                _shopNameStr = _deliverModel.shopName;
                [_selectPhotoBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picUrlStr]]] forState:UIControlStateNormal];
            }
        }


    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _numTF) {
        if (toBeString.length > 11) {
            [textField resignFirstResponder];
            [self notifyWithText:kLocalized(@"PhoneNumberYouEnteredCanNotBeMoreThan11Bits!")];
        }else{
            return YES;
        }
    }
    return YES;
}

@end
