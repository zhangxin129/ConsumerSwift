//
//  GYShowBtDevicesVC.m
//  company
//
//  Created by liangzm on 15-4-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCardReaderView.h"
#import "GYPOSCardReaderShowCell.h"
#import "GYCardReaderModel.h"
#import "GYPOSService.h"
#import "GYGIFHUD.h"

static NSString* const GYTableViewCellID = @"GYShowBtDevicesVC";

@interface GYCardReaderView () <UITableViewDelegate, UITableViewDataSource, GYPOSServiceDelegate>

@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* arrResult;
@property (nonatomic, strong) GYPOSService* posService;
@property (nonatomic, assign) BOOL isScan;
@property (nonatomic, weak) UIView* tipView;

@end

@implementation GYCardReaderView

- (NSMutableArray*)arrResult
{
    if (!_arrResult) {
        _arrResult = @[].mutableCopy;
    }
    return _arrResult;
}


#pragma mark - 系统方法
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
      
            self.posService = [GYPOSService sharedInstance];
            self.posService.delegate = self;
            UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            [self addSubview:tableView];
            tableView.backgroundColor = [UIColor whiteColor];
            self.tableView = tableView;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.tableFooterView = [[UIView alloc]init];
            [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYPOSCardReaderShowCell class]) bundle:kDefaultBundle]
                 forCellReuseIdentifier:GYTableViewCellID];
            self.isScan = YES;
            [self.posService scanBluetooth];
        UIView* view = [self createNoDataUI];
        
        self.tipView = view;
    }


    return self;

}


- (void)layoutSubviews
{

    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0,0,320,320);
    self.tableView.center = self.center;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrResult.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    GYPOSCardReaderShowCell* cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (!cell) {
        cell = [[GYPOSCardReaderShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GYTableViewCellID];
    }
    GYCardReaderModel* model = self.arrResult[row];
    cell.lbCellLabel.text = model.posName;
    // 显示未连接上图片
    [cell.ivCellImage setImage:[UIImage imageNamed:@"pos_unconnect.png"]];
    if (self.posService.isConnect) {
        if (model.isConnected) {
            cell.lbCellStateLabel.text = kLocalized(@"GYBasic_Connected");
            // 显示连接上图片
            [cell.ivCellImage setImage:[UIImage imageNamed:@"pos_connect.png"]];
        }
        else
            cell.lbCellStateLabel.text = @"";
    }
    else //用于断开连接时刷新
    {
        cell.lbCellStateLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

        NSInteger row = indexPath.row;
        __block GYCardReaderModel* posInfo = self.arrResult[row];
        if (posInfo.isConnected) {
      
        }
        else {
            [self.posService stopScanBluetooth];
            @weakify(self);
            [GYGIFHUD show];
            [self.posService connectionPOS:posInfo.posName callbackBlock:^(BOOL connected, id posDevice) {
                @strongify(self);
                 [GYGIFHUD dismiss];
             
                if(connected){
                    [GYUtils showToast:@"连接成功"];
                    [self removeFromSuperview];
                    [kDefaultNotificationCenter postNotificationName:GYPosDeviceInfoNotification object:posDevice];
                   
                }else  {
                  
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }];
        }
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewRowAction* rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:kLocalized(@"GYBasic_Delete")
                                                                       handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull indexPath) {
    [self.arrResult removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                       }];
                                                                       
    //    rowAction.backgroundColor = kNavigationBarColor;
    
    NSArray* arr = @[ rowAction ];
    return arr;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
    
        [self.posService disConnectionPOS];
        
        @weakify(self);
        self.posService.disconnectionPOSBlock = ^() {
            @strongify(self);
            self.arrResult = [NSMutableArray arrayWithArray:self.posService.arrPosDevices];
            [self.tableView reloadData];
            
        };
        
        [kDefaultNotificationCenter postNotificationName:GYPosDeviceInfoNotification object:nil];
    }
    else if (buttonIndex == 1) {
        
    }
}

#pragma mark - GYPOSServiceDelegate
- (void)getOnePosDevice:(GYCardReaderModel*)posModel isScanning:(BOOL)isScanning
{

    self.arrResult = [NSMutableArray arrayWithArray:self.posService.arrPosDevices];
    [self.tableView reloadData];
    
    if (isScanning) {
    }
    else {
        [self.tipView removeFromSuperview];
        if (self.arrResult.count == 0) {
  
        }
    }
}

#pragma mark - 无设备的提示信息
- (UIView*)createNoDataUI
{

    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,320)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 70) / 2, 200, 70, 70)];
    [imageView setImage:[UIImage imageNamed:@"gyhs_nodata"]];
    [backView addSubview:imageView];
    
    UILabel* tipLable = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 280, 200, 20)];
    tipLable.textAlignment = NSTextAlignmentCenter;
    tipLable.font = [UIFont systemFontOfSize:13];
    tipLable.textColor = [UIColor colorWithRed:158 / 255.0 green:209 / 255.0 blue:228 / 255.0 alpha:1.0f];
    tipLable.text = kLocalized(@"GYBasic_NotSearchDevice");
    [backView addSubview:tipLable];
    
    UIButton* tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tipBtn.frame = CGRectMake((kScreenWidth - 180) / 2, 310, 180, 30);
    [tipBtn setTitle:kLocalized(@"GYBasic_AgainSearch") forState:UIControlStateNormal];
    [tipBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:172 / 255.0 blue:214 / 255.0 alpha:1.0f] forState:UIControlStateNormal];
    [tipBtn setBackgroundColor:[UIColor whiteColor]];
    [tipBtn.layer setMasksToBounds:YES];
    [tipBtn.layer setBorderWidth:1.0f];
    [tipBtn.layer setBorderColor:[UIColor colorWithRed:69 / 255.0 green:172 / 255.0 blue:214 / 255.0 alpha:1.0f].CGColor];
    [tipBtn addTarget:self action:@selector(fresh) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:tipBtn];
    [self.tableView addSubview:backView];
    
    return backView;
    
}

- (void)fresh{
     [self.tipView removeFromSuperview];
     
}


@end
