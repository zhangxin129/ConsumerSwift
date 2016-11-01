//
//  GYHDUserInfoViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDUserInfoViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDUserInfoCell.h"
#import "GYHDUserInfoModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GYHDPopAddTeamView.h"
#import "GYHDPopView.h"
#import "GYHDSearchAgeView.h"
#import "GYHDAddressView.h"
//#import "GYFMDBCityManager.h"
#import "GYAddressData.h"
#import "GYHDPopMessageTopView.h"
#import "GYHDUserInfoDetailCell.h"
#import "GYHDSetingViewController.h"

@interface GYHDUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, weak)UITableView *userDetalTableView;
@property(nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong) GYCityAddressModel* cityModel;
@property(nonatomic, strong)GYHDUserInfoDetailModel *detailModel;
@end

@implementation GYHDUserInfoViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_personal_information"];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_save"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(rightbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UITableView* userDetalTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    userDetalTableView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    userDetalTableView.delegate = self;
    userDetalTableView.dataSource = self;

    [userDetalTableView registerClass:[GYHDUserInfoCell class] forCellReuseIdentifier:@"GYHDUserInfoCellID"];
    [userDetalTableView registerClass:[GYHDUserInfoDetailCell class] forCellReuseIdentifier:@"GYHDUserInfoDetailCellID"];
        userDetalTableView.tableFooterView = [[UIView alloc ] initWithFrame: CGRectZero];
    [self.view addSubview:userDetalTableView];
    _userDetalTableView = userDetalTableView;
    [userDetalTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(0);
        make.left.bottom.right.mas_equalTo(0);
    }];

    [self loadData];
}

- (void)loadData
{

    WS(weakSelf);
    NSDictionary* DBdict = [[GYHDMessageCenter sharedInstance] searchFriendWithCustId:_custID RequetResult:^(NSDictionary* resultDict) {
        NSMutableDictionary *friendDetailDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:resultDict[GYHDDataBaseCenterFriendDetailed]]];
        [[GYHDMessageCenter sharedInstance] checkDict:friendDetailDict];
        weakSelf.dataArray = [weakSelf detialArrayWithDict:friendDetailDict];
        [weakSelf.userDetalTableView reloadData];

    }];
    NSMutableDictionary* friendDetailDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:DBdict[GYHDDataBaseCenterFriendDetailed]]];
    [[GYHDMessageCenter sharedInstance] checkDict:friendDetailDict];
    self.dataArray = [self detialArrayWithDict:friendDetailDict];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.userDetalTableView reloadData];
    });
}
- (void)rightbuttonClick:(UIButton*)button
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSData* data;
    GYHDUserInfoModel* imageModel = self.dataArray[1][0];
    UIImage *image = [UIImage imageWithContentsOfFile:imageModel.userInfo];
//    UIImage* image = [GYUtils imageCompressForWidth:self.userIconImageView.image targetWidth:100];
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    }
    else {
        data = UIImagePNGRepresentation(image);
    }
    GYHDUserInfoModel* nameModel = self.dataArray[1][1];
    dict[@"nickname"] = nameModel.userInfo;
    if (data) {
        dict[@"imageData"] = data;
    }
    dict[@"headShot"] = @"";
    GYHDUserInfoModel* ageModel = self.dataArray[1][2];
    dict[@"age"] = ageModel.userInfo;

    GYHDUserInfoModel* sexModel = self.dataArray[1][3];

    if ([sexModel.userInfo isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_Man"]]) {
        dict[@"sex"] = @1;
    }
    else if ([sexModel.userInfo isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_Woman"]]) {
        dict[@"sex"] = @0;
    }

    dict[@"countryNo"] = self.cityModel.countryNo;
    dict[@"provinceNo"] = self.cityModel.provinceNo;
    dict[@"cityNo"] = self.cityModel.cityNo;
    dict[@"area"] = self.cityModel.cityFullName;
    GYHDUserInfoModel* indModel = self.dataArray[1][5];
    dict[@"hobby"] = indModel.userInfo;
    GYHDUserInfoModel* hobbyModel = self.dataArray[1][6];
    dict[@"individualSign"] = hobbyModel.userInfo;

    [[GYHDMessageCenter sharedInstance] updateSelfInfoWith:dict RequetResult:^(NSDictionary* resultDict) {

        if ([resultDict[@"retCode"] integerValue] == 200) {

//            sleep(0.1);
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (NSArray*)detialArrayWithDict:(NSDictionary*)friendDict
{
    NSMutableArray *userinfoArray = [NSMutableArray array];
    self.detailModel = [[GYHDUserInfoDetailModel alloc] init];
    [userinfoArray addObject:self.detailModel];
    
    
    NSMutableArray* friendDetailArray = [NSMutableArray array];

    GYHDUserInfoModel* iconModel = [[GYHDUserInfoModel alloc] init];

    if ([friendDict[@"headImage"] hasPrefix:@"http"]) {
        iconModel.userInfo = friendDict[@"headImage"];
    }
    else {
        iconModel.userInfo = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, friendDict[@"headImage"]];
    }

    iconModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_avatar"];
    [friendDetailArray addObject:iconModel];

    GYHDUserInfoModel* nameMode = [[GYHDUserInfoModel alloc] init];
    nameMode.userInfo = friendDict[@"nickName"];
    nameMode.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_nickname"];
    [friendDetailArray addObject:nameMode];

    GYHDUserInfoModel* ageMode = [[GYHDUserInfoModel alloc] init];
    ageMode.userInfo = friendDict[@"age"];
    ageMode.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_age"];
    [friendDetailArray addObject:ageMode];

    GYHDUserInfoModel* sexMode = [[GYHDUserInfoModel alloc] init];

    if ([friendDict[@"sex"] isEqualToString:@"1"]) {
        sexMode.userInfo = [GYUtils localizedStringWithKey:@"GYHD_Man"];
    }
    else if ([friendDict[@"sex"] isEqualToString:@"0"]) {
        sexMode.userInfo = [GYUtils localizedStringWithKey:@"GYHD_Woman"];
    }
    else {
        sexMode.userInfo = @"";
    }
    sexMode.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_sex"];
    [friendDetailArray addObject:sexMode];

    GYHDUserInfoModel* mode1 = [[GYHDUserInfoModel alloc] init];
    mode1.userInfo = friendDict[@"area"];
    mode1.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_area"];
    [friendDetailArray addObject:mode1];

    GYHDUserInfoModel* mode2 = [[GYHDUserInfoModel alloc] init];
    mode2.userInfo = friendDict[@"hobby"];
    mode2.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_hobby"];
    [friendDetailArray addObject:mode2];

    GYHDUserInfoModel* mode3 = [[GYHDUserInfoModel alloc] init];
    mode3.userInfo = friendDict[@"sign"];
    mode3.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_sign"];
    [friendDetailArray addObject:mode3];
    
    
    NSMutableArray *setArray = [NSMutableArray array];
    GYHDUserInfoModel *setModel = [[GYHDUserInfoModel alloc] init];
    setModel.userInfo = @"";
    setModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_seting"] ;
    [setArray addObject: setModel];
    
    self.detailModel.iconString = iconModel.userInfo;
    self.detailModel.nikeNameString = nameMode.userInfo;
    self.detailModel.huShengString =  [NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_hushengCard"], [[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:friendDict[@"resNo"]] ];
    self.detailModel.sexString = sexMode.userInfo;
    return @[userinfoArray,friendDetailArray,setArray];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (!indexPath.section) {
        GYHDUserInfoDetailCell *detialCell = [tableView dequeueReusableCellWithIdentifier:@"GYHDUserInfoDetailCellID"];
        detialCell.model = self.detailModel;
        cell = detialCell;
    }else {
        GYHDUserInfoCell *userInfocell = [tableView dequeueReusableCellWithIdentifier:@"GYHDUserInfoCellID"];
        userInfocell.selectionStyle = UITableViewCellSelectionStyleNone;
        GYHDUserInfoModel* model = self.dataArray[indexPath.section][indexPath.row];
        userInfocell.model = model;
        cell = userInfocell;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (!indexPath.section) {
//        return [tableView fd_heightForCellWithIdentifier:@"GYHDUserInfoDetailCellID" cacheByIndexPath:indexPath configuration:^(GYHDUserInfoCell* cell) {
//          
//        }];
        return  68.0f;
    }else {
        GYHDUserInfoModel* model = self.dataArray[indexPath.section][indexPath.row];
        return [tableView fd_heightForCellWithIdentifier:@"GYHDUserInfoCellID" cacheByIndexPath:indexPath configuration:^(GYHDUserInfoCell* cell) {
            cell.model = model;
        }];
    }
    

}

- (void)imageTap
{
    WS(weakSelf)
    NSArray* messageArray = @[ [GYUtils localizedStringWithKey:@"GYHD_choose_Image"], [GYUtils localizedStringWithKey:@"GYHD_take_photos"], [GYUtils localizedStringWithKey:@"GYHD_my_ablum"] ];
    GYHDPopMessageTopView* messageTopView = [[GYHDPopMessageTopView alloc] initWithMessageArray:messageArray];
    [messageTopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(230, 137.0f));
    }];
    GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:messageTopView];
    messageTopView.block = ^(NSString* messageString) {
//        NSLog(@"%@", messageString);
        if ([messageString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_take_photos"]]) {
            [weakSelf photocamera];
        } else if ([messageString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_my_ablum"]]) {
            [weakSelf photoalbumr];
        }
        [topView disMiss];
    };
    [topView showToView:self.navigationController.view];
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
        [[[UIAlertView alloc] initWithTitle:nil message: [GYUtils localizedStringWithKey:@"GYHD_setPrivacyCamera"] delegate:nil cancelButtonTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"] otherButtonTitles:nil] show];
    }
}

//进入拍照
- (void)photocamera
{

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];

        imagepicker.delegate = self;
        //        imagepicker.showsCameraControls=YES;
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
        [[[UIAlertView alloc] initWithTitle:nil message: [GYUtils localizedStringWithKey:@"GYHD_setPrivacyCamera"] delegate:nil cancelButtonTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"] otherButtonTitles:nil] show];
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSData* imageData = UIImagePNGRepresentation(image);
        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"useriCon%d.png",arc4random()]];

        [imageData writeToFile:fullPath atomically:NO];
        
        GYHDUserInfoModel *model = self.dataArray[1][0];
        [[NSFileManager defaultManager] removeItemAtPath:model.userInfo error:nil];
        model.userInfo = fullPath;
        self.detailModel.iconString = fullPath;
        [weakSelf.userDetalTableView reloadData];
    }];
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (!indexPath.section) {
        return;
    }
    GYHDUserInfoModel* model = self.dataArray[indexPath.section][indexPath.row];

    if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_avatar"]]) {
        [self imageTap];
//        _imageCell = [tableView cellForRowAtIndexPath:indexPath];
    }else if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_age"]]) {
        GYHDPopAddTeamView* popAddteamView = [[GYHDPopAddTeamView alloc] init];
        [popAddteamView setTitle: [GYUtils localizedStringWithKey:@"GYHD_age"]];
        [popAddteamView setPlaceholder:[NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_inptu"], [GYUtils localizedStringWithKey:@"GYHD_age"]]];
        [popAddteamView setDefaulText:model.userInfo];
        [popAddteamView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.size.mas_equalTo(CGSizeMake(270, 147.0f));
        }];

        GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:popAddteamView];
        [popView  showToView:self.navigationController.view];
        WS(weakSelf);
        popAddteamView.block = ^(NSString* message) {
            [popView disMiss];
            if (message) {
                if ([message integerValue] != 0) {
                    model.userInfo = [NSString stringWithFormat:@"%ld", (long)[message integerValue]];
                    [weakSelf.userDetalTableView reloadData];
                    [popView disMiss];
                }

            }
        };
    }else if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_sex"]]) {
        NSArray* array = [ [GYUtils localizedStringWithKey:@"GYHD_choose_sex"] componentsSeparatedByString:@"|"];
        GYHDSearchAgeView* ageView = [[GYHDSearchAgeView alloc] init];
        ageView.chooseAgeArray = array;
        ageView.chooseTips = [GYUtils localizedStringWithKey:@"GYHD_sex"];
        [ageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.size.mas_equalTo(CGSizeMake(274, 229));
        }];

        GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:ageView];

        [popView  showToView:self.navigationController.view];
        WS(weakSelf);
        ageView.block = ^(NSString* chooseString) {
            UIImage *sexImgae = nil;
            if ([chooseString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Man"]]) {
                sexImgae = [UIImage imageNamed:@"gyhd_man_icon"];
            } else if ([chooseString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Woman"]]) {
                sexImgae = [UIImage imageNamed:@"gyhd_girl_icon"];
            }

            model.userInfo = chooseString;
            weakSelf.detailModel.sexString = chooseString;
            [weakSelf.userDetalTableView reloadData];
            [popView disMiss];
        };
    }else if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_hobby"]] ||
        [model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_sign"]] ||
        [model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_nickname"]]) {

        GYHDPopAddTeamView* popAddteamView = [[GYHDPopAddTeamView alloc] init];
        [popAddteamView setTitle:model.userInfoName];
        [popAddteamView setPlaceholder:[NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_inptu"], model.userInfoName]];
        [popAddteamView setDefaulText:model.userInfo];
        [popAddteamView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.size.mas_equalTo(CGSizeMake(270, 147.0f));
        }];
        if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_hobby"]]) {
            popAddteamView.maxCharCount = 40;
        }
        else if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_sign"]]) {
            popAddteamView.maxCharCount = 25;
        }
        else if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_nickname"]]) {
            popAddteamView.maxCharCount = 11;
        }
        GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:popAddteamView];
        [popView showToView:self.navigationController.view];
        WS(weakSelf);
        popAddteamView.block = ^(NSString* message) {
            [popView disMiss];
            if (![message isEqualToString:@""] && message != nil) {
                model.userInfo = message;
                weakSelf.detailModel.nikeNameString = message;
                [weakSelf.userDetalTableView reloadData];
                [popView disMiss];
            }
        };
    }else if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_area"]]) {
        GYHDAddressView* addressView = [[GYHDAddressView alloc] init];

        addressView.cityFullName = model.userInfo;
        [addressView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.size.mas_equalTo(CGSizeMake(270, 276));
        }];

        GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:addressView];

        [popView  showToView:self.navigationController.view];
        WS(weakSelf);

        addressView.block = ^(NSString* cityNo) {
//            self.cityModel = [[GYFMDBCityManager shareInstance] selectCity:cityNo];
            weakSelf.cityModel = [[GYAddressData shareInstance] queryCityNo:cityNo];
            model.userInfo = weakSelf.cityModel.cityFullName;
            [weakSelf.userDetalTableView reloadData];
            [popView disMiss];
        };
    }else if ([model.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_seting"]]) {
        GYHDSetingViewController *setingViewController = [[GYHDSetingViewController alloc] init];
        [self.navigationController pushViewController:setingViewController animated:YES];
    }
}


@end


