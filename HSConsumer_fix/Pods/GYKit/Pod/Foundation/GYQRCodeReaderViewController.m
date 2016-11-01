/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "GYQRCodeReaderViewController.h"
#import "GYQRCodeReaderView.h"
#import "UIView+Extension.h"

#define mainHeight [[UIScreen mainScreen] bounds].size.height
#define mainWidth [[UIScreen mainScreen] bounds].size.width
#define navBarHeight self.navigationController.navigationBar.frame.size.height

@interface GYQRCodeReaderViewController () <AVCaptureMetadataOutputObjectsDelegate, QRCodeReaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) GYQRCodeReaderView* cameraView;
@property (strong, nonatomic) UILabel* lblTip;
/**
 *计时器
 */
@property (strong, nonatomic) CADisplayLink *link;
/**
 *有效扫描区域循环往返的一条线（这里用的是一个背景图）
 */
@property (strong, nonatomic) UIImageView *scrollLine;
/**
 *用于记录scrollLine的上下循环状态
 */
@property (assign, nonatomic) BOOL up;

@property (strong, nonatomic) AVCaptureDevice* defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput* defaultDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput* metadataOutput;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;

@property (strong, nonatomic) CIDetector* detector;

@property (copy, nonatomic) void (^completionBlock)(NSString*);

@end

@implementation GYQRCodeReaderViewController

- (id)init
{
    
    return [self initView];
}

- (id)initView
{
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor blackColor];
        
        [self setupAVComponents];
        [self configureDefaultComponents];
        [self setupUIComponents];
        [_cameraView.layer insertSublayer:self.previewLayer atIndex:0];
    }
    return self;
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
    
    _previewLayer.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.metadataOutput setRectOfInterest:CGRectMake(self.cameraView.innerViewRect.origin.y / (mainHeight - navBarHeight), self.cameraView.innerViewRect.origin.x / mainWidth , self.cameraView.innerViewRect.size.height /(mainHeight - navBarHeight), self.cameraView.innerViewRect.size.width / mainWidth)];
    
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(LineAnimation)];
    }
    return _link;
}

- (UIImageView *)scrollLine {
    if (!_scrollLine) {
        _scrollLine = [[UIImageView alloc]initWithFrame:CGRectMake( 40, self.cameraView.innerViewRect.origin.y, mainWidth - 80 , 2)];
        _scrollLine.image = [UIImage imageNamed:@"GYFoundation.bundle/QRCodeScanLine"];
    }
    return _scrollLine;
}

#pragma mark - 线条运动的动画
- (void)LineAnimation {
    if (_up == YES) {
        CGFloat y = self.scrollLine.frame.origin.y;
        y += 2;
        self.scrollLine.y = y;
        if (y >= (CGRectGetMaxY(self.cameraView.innerViewRect) - 2)) {
            _up = NO;
        }
    }else{
        CGFloat y = self.scrollLine.frame.origin.y;
        y -= 2;
        self.scrollLine.y = y;
        if (y <= self.cameraView.innerViewRect.origin.y) {
            _up = YES;
        }
    }
}


- (void)loadView:(CGRect)rect
{
    [self.view addSubview:self.scrollLine];
    
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

- (void)setupUIComponents
{
    self.cameraView = [[GYQRCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cameraView.frame = self.view.bounds;
    _cameraView.clipsToBounds = YES;
    _cameraView.delegate = self;
    [self.view addSubview:_cameraView];
    
    
    CGFloat c_width = mainWidth - 100;
    CGFloat s_height = mainHeight - 40;
    CGFloat y = (s_height - c_width) / 2 - s_height / 6;
    
    _lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, y + 90 + c_width, mainWidth, 15)];
    _lblTip.text = @"将二维码放入框内 即可自动扫描";
    _lblTip.textColor = [UIColor whiteColor];
    _lblTip.font = [UIFont systemFontOfSize:13];
    _lblTip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lblTip];
    
    
    self.up = YES;
    
    
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
    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
        [_metadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode ]];
    }
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if ([_previewLayer.connection isVideoOrientationSupported]) {
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        _previewLayer.connection.videoOrientation = [self.class videoOrientationFromInterfaceOrientation:
                                                     orientation];
    }
}



#pragma mark - Controlling Reader

- (void)startScanning;
{
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
    
    //计时器添加到循环中去
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
}

- (void)stopScanning;
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    
    [self.link invalidate];
    self.link = nil;
    
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputMetadataObjects:(NSArray*)metadataObjects fromConnection:(AVCaptureConnection*)connection
{
    for (AVMetadataObject* current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [current.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString* scannedResult = [(AVMetadataMachineReadableCodeObject*)current stringValue];
            
            [self stopScanning];
            
            if (_completionBlock) {
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
    @autoreleasepool
    {
        AVCaptureDevice* captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (!captureDevice) {
            return NO;
        }
        
        NSError* error;
        AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
        AVCaptureMetadataOutput* output = [[AVCaptureMetadataOutput alloc] init];
        
        if (![output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            return NO;
        }
        
        return YES;
    }
}

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
            _completionBlock(scannedResult);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)]) {
            [_delegate reader:self didScanResult:scannedResult];
        }
    }
}

#pragma mark - Controlling the Reader

@end
