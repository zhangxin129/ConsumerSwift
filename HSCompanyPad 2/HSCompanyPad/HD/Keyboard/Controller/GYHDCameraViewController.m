//
//  GYHDCameraViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDCameraViewController.h"
#import "GYHDRecordVideoTool.h"
#import "GYHDCameraShowView.h"
@interface GYHDCameraViewController()<GYHDCameraShowViewDelegate>
/**录制照片*/
@property(nonatomic, strong)GYHDRecordVideoTool *recordCamera;
@property(nonatomic, strong)UIView *showCameraView;

@end
@implementation GYHDCameraViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

    self.recordCamera = [[GYHDRecordVideoTool alloc] initWithCameraView:self.view];
}


#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHD_Photograph");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
    self.view.backgroundColor=[UIColor blackColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
}

- (void)setup
{
    //3. 显示界面
    self.showCameraView = [[UIView alloc] init];
    [self.view addSubview:self.showCameraView];
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[ UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
    bgView.userInteractionEnabled=YES;
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.mas_equalTo(0);
        
        make.width.mas_equalTo(80);
    }];
    
    //2. 切换相机
    UIButton *changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_change_camera_btn_normal"] forState:UIControlStateNormal];
    [changeCameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_change_camera_btn_highlighted"] forState:UIControlStateHighlighted];
    [changeCameraButton addTarget:self action:@selector(changeCameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:changeCameraButton];
    [changeCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(bgView.centerY);
    }];
    
    //4 拍照按钮
    UIView *recordPhotoView = [[UIView alloc] init];
    recordPhotoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    [self.view addSubview:recordPhotoView];
    [recordPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.right.mas_equalTo(0);
        make.width.mas_equalTo(150);
        
    }];

    UIButton *recordPhotoButton = [[UIButton alloc] init];
    [recordPhotoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_photograph_btn_normal"] forState:UIControlStateNormal];
    [recordPhotoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_photograph_btn_highlighted"] forState:UIControlStateHighlighted];
    [recordPhotoButton addTarget:self action:@selector(recordPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [recordPhotoView addSubview:recordPhotoButton];
    [recordPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(recordPhotoView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.showCameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
}

- (void)recordPhotoButtonClick
{
    DDLogCInfo(@"拍照");
    [self.recordCamera startRecordCamera];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GYHDCameraShowView *showView = [[GYHDCameraShowView alloc] init];
        showView.delegate = self;
        showView.object=self;
        [showView show];
        UIImage *image = [UIImage imageWithData:[self.recordCamera imageData]];
        
        [showView setImage: image];
    });
}
- (void)changeCameraButtonClick
{
    [self.recordCamera changeCamera];
}

- (void)GYHDCameraShowView:(UIView *)cameraShowView SendImageData:(NSData *)imageData
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.block) {
        
        self.block([self.recordCamera imagePathDict]);
    }
}
@end
