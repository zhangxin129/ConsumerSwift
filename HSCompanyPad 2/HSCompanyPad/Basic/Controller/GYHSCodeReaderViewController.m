//
//  GYQRCodeReaderViewController.h
//  HSCompanyPad
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYHSCodeReaderViewController.h"
#import "GYHSCodeReaderView.h"
#import <GYKit/UIColor+HEX.h>
#import <GYKit/UIView+Extension.h>
#define mainHeight [[UIScreen mainScreen] bounds].size.height
#define mainWidth [[UIScreen mainScreen] bounds].size.width
#define navBarHeight self.navigationController.navigationBar.frame.size.height

@interface GYHSCodeReaderViewController () <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) GYHSCodeReaderView* cameraView;
@property (strong, nonatomic) AVAudioPlayer* beepPlayer;
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UILabel* tipLabel;
@property (strong, nonatomic) UIButton* lightButton;

@property (strong, nonatomic) NSTimer* timerScan;

@property (strong, nonatomic) AVCaptureDevice* defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput* defaultDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput* metadataOutput;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;

//相册时用的。
@property (strong, nonatomic) CIDetector* detector;

@property (copy, nonatomic) void (^completionBlock)(NSString*);

@end

@implementation GYHSCodeReaderViewController

- (id)init
{
    if ((self = [super init])) {
        
        NSString* wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
        NSData* data = [[NSData alloc] initWithContentsOfFile:wavPath];
        _beepPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        
        [self setupAVComponents];
        [self configureDefaultComponents];
        [self setupUIComponentsWithCancelButtonTitle];
        [self setupAutoLayoutConstraints];
        
        [_cameraView.layer insertSublayer:self.previewLayer atIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"扫描二维码");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhs_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhs_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000"];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopScanning];
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _previewLayer.frame = self.view.frame;
}

- (void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    float top = kOffRect / mainHeight;
    float left = (mainWidth - (mainHeight - 2 * kOffRect)) / 2 / mainWidth;
    [self.metadataOutput setRectOfInterest:CGRectMake(top, left, 0.7, 0.7)];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - Managing the Orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [_cameraView setNeedsDisplay];
    
    if (self.previewLayer.connection.isVideoOrientationSupported) {
        self.previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:toInterfaceOrientation];
    }
}

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^)(NSString* resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithCancelButtonTitle
{
    self.cameraView = [[GYHSCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds = YES;
    [self.view addSubview:_cameraView];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    UIImage* image = [UIImage imageNamed:@"gyhs_scan_cap"];
    attachment.image = image;
    attachment.bounds = CGRectMake(-10, -4, image.size.width, image.size.height);
    NSMutableAttributedString* imageText = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
    NSAttributedString* text = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"对准消费者二维码进行扫描") attributes:@{ NSFontAttributeName : kFont42, NSAttachmentAttributeName : attachment, NSForegroundColorAttributeName : kWhiteFFFFFF }];
    [imageText appendAttributedString:text];
    _tipLabel.attributedText = imageText;
    [_cameraView addSubview:_tipLabel];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.animationImages = @[ [UIImage imageNamed:@"gyhs_scan_loading8"],
                                    [UIImage imageNamed:@"gyhs_scan_loading7"],
                                    [UIImage imageNamed:@"gyhs_scan_loading6"],
                                    [UIImage imageNamed:@"gyhs_scan_loading5"],
                                    [UIImage imageNamed:@"gyhs_scan_loading4"],
                                    [UIImage imageNamed:@"gyhs_scan_loading3"],
                                    [UIImage imageNamed:@"gyhs_scan_loading2"],
                                    [UIImage imageNamed:@"gyhs_scan_loading1"] ];
    _imageView.animationDuration = 0.5;
    _imageView.animationRepeatCount = 0;
    [_cameraView addSubview:_imageView];
    
    _lightButton = [[UIButton alloc] init];
    [_lightButton setImage:[UIImage imageNamed:@"gyhs_btn_light_on"] forState:UIControlStateSelected];
    [_lightButton setImage:[UIImage imageNamed:@"gyhs_btn_light_off"] forState:UIControlStateNormal];
    [_lightButton addTarget:self action:@selector(lightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraView addSubview:_lightButton];
}

- (void)setupAutoLayoutConstraints
{
    _cameraView.frame = self.view.frame;
    _tipLabel.frame = CGRectMake(0, kOffRect - 40, mainWidth, 44);
    
    _imageView.frame = CGRectMake(self.view.center.x, self.view.bounds.size.height - kOffRect + 40, 26, 26);
    _lightButton.frame = CGRectMake(mainWidth - kOffRect / 2, self.view.bounds.size.height - kOffRect + 40, 36, 36);
}

- (void)setupAVComponents
{
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (_defaultDevice) {
        self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        self.session = [[AVCaptureSession alloc] init];
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
}

- (void)configureDefaultComponents
{
    [_session addOutput:_metadataOutput];
    
    if (_defaultDeviceInput) {
        [_session addInput:_defaultDeviceInput];
    }
    
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
//        [_metadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode ]];
//    }
    _metadataOutput.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];

    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if ([_previewLayer.connection isVideoOrientationSupported]) {
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        _previewLayer.connection.videoOrientation = [self.class videoOrientationFromInterfaceOrientation:
                                                     orientation];
    }
}

#pragma mark - Catching Button Events

- (void)lightButtonAction:(UIButton*)button
{
    if (_defaultDevice.hasTorch) {
        NSError* error = nil;
        
        [_defaultDevice lockForConfiguration:&error];
        
        if (error == nil) {
            AVCaptureTorchMode mode = _defaultDevice.torchMode;
            
            _defaultDevice.torchMode = mode == AVCaptureTorchModeOn ? AVCaptureTorchModeOff : AVCaptureTorchModeOn;
        }
        
        [_defaultDevice unlockForConfiguration];
    } else {
        DDLogInfo(@"设备没有灯");
    }
}

#pragma mark - Controlling Reader

- (void)startScanning;
{
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
    
    if (!_imageView.isAnimating) {
        [_imageView startAnimating];
    }
}

- (void)stopScanning;
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    
    if (_imageView.isAnimating) {
        _imageView.animationImages = nil;
        [_imageView stopAnimating];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
        [_delegate readerDidCancel:self];
    }
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputMetadataObjects:(NSArray*)metadataObjects fromConnection:(AVCaptureConnection*)connection
{
    for (AVMetadataObject* current in metadataObjects) {
//        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
//            && [current.type isEqualToString:AVMetadataObjectTypeQRCode]) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString* scannedResult = [(AVMetadataMachineReadableCodeObject*)current stringValue];
            
            [self stopScanning];
            
            if (_completionBlock) {
                [_beepPlayer play];
                _completionBlock(scannedResult);
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)]) {
                [_delegate reader:self didScanResult:scannedResult];
            }
            
            break;
        }
    }
}

#pragma mark - Checking the Metadata Items Types

+ (BOOL)isAvailable
{
    @autoreleasepool {
        AVCaptureDevice* captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (!captureDevice) {
            return NO;
        }
        
        NSError* error;
        AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
//        AVCaptureMetadataOutput* output = [[AVCaptureMetadataOutput alloc] init];
//        
//        if (![output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
//            return NO;
//        }
        
        return YES;
    }
}

//以下是从相册取图片识别二维码， 需求没有实现。
#pragma mark - Checking RightBarButtonItem
- (void)clickRightBarButton:(UIBarButtonItem*)item
{
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSArray* features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature* feature = [features objectAtIndex:0];
        NSString* scannedResult = feature.messageString;
        if (_completionBlock) {
            [_beepPlayer play];
            _completionBlock(scannedResult);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)]) {
            [_delegate reader:self didScanResult:scannedResult];
        }
    }
}

@end
