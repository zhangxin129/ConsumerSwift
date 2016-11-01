//
//  GYHDRecordVideoTool.m
//  HSConsumer
//
//  Created by shiang on 16/2/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRecordVideoTool.h"
#import "GYHDMessageCenter.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^PropertyChangeBlock)(AVCaptureDevice* captureDevice);
@interface GYHDRecordVideoTool () <AVCaptureFileOutputRecordingDelegate>

@property (strong, nonatomic) AVCaptureSession* captureSession; //负责输入和输出设置之间的数据传递
@property (strong, nonatomic) AVCaptureDeviceInput* captureDeviceInput; //负责从AVCaptureDevice获得输入数据
@property (strong, nonatomic) AVCaptureMovieFileOutput* captureMovieFileOutput; //视频输出流
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* captureVideoPreviewLayer; //相机拍摄预览图层
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier; //后台任务标识
@property (strong, nonatomic) AVCaptureStillImageOutput* captureStillImageOutput; //照片输出流
@property (nonatomic, copy) NSString* movPath;
@property (nonatomic, copy) NSString* mp4Path;
/**录音总时长*/
@property (nonatomic, assign) NSTimeInterval recordTimeCount;
/**当前录音时长*/
@property (nonatomic, assign) NSTimeInterval currentCecordTime;
/**录音定时器*/
@property (nonatomic, strong) NSTimer* recordtimer;
/**播放录像*/
@property (nonatomic, strong) AVPlayer* playerRecordVideo;
/**相片*/
@property (nonatomic, strong) NSData* photoData;
@end

@implementation GYHDRecordVideoTool

- (NSString*)movPath
{
    if (!_movPath) {
        _movPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/downloadFileMov.mov"];
    }
    return _movPath;
}

/**初始化相机*/
- (instancetype)initWithCameraView:(UIView*)view
{
    self = [super init];
    if (!self)
        return self;

    //初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    //获得输入设备
    AVCaptureDevice* captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack]; //取得后置摄像头
    if (!captureDevice) {
    }

    NSError* error = nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
    }
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary* outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG };
    [_captureStillImageOutput setOutputSettings:outputSettings]; //输出设置

    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }

    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }

    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];

    CALayer* layer = view.layer;
    layer.masksToBounds = YES;

    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; //填充模式
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    //        [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];

    [self addNotificationToCaptureDevice:captureDevice];
    //        [self addGenstureRecognizer];
    //        [self setFlashModeButtonStatus];
    [self.captureSession startRunning];
    return self;
}

/**初始化*/
- (instancetype)initWithView:(UIView*)view
{
    self = [super init];
    if (!self)
        return self;
    //初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) { //设置分辨率
        _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    }
    //获得输入设备
    AVCaptureDevice* captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack]; //取得后置摄像头
    if (!captureDevice) {
    }
    //添加一个音频输入设备
    AVCaptureDevice* audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];

    NSError* error = nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
    }
    AVCaptureDeviceInput* audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
    }
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];

    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection* captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }

    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }

    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];

    CALayer* layer = view.layer;
    layer.masksToBounds = YES;

    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; //填充模式
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    //    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];

    //    _enableRotation=YES;
    [self addNotificationToCaptureDevice:captureDevice];
    //    [self addGenstureRecognizer];
    [self.captureSession startRunning];
    return self;
}

/**开始录制照片*/
- (void)startRecordCamera
{

    AVCaptureConnection* captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError* error) {
        if (imageDataSampleBuffer) {
            self.photoData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//

//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }

    }];
}

- (NSDictionary*)imagePathDict
{

    //get save path

    NSString* timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
    NSString* imageName = [NSString stringWithFormat:@"originalImage%@.jpg", timeNumber];
    NSString* imagePath = [NSString pathWithComponents:@[ [[GYHDMessageCenter sharedInstance] imagefolderNameString], imageName ]];

    UIImage* tempimage = [UIImage imageWithData:self.photoData];
    UIImage* image = [self fixOrientation:tempimage];
    self.photoData = UIImagePNGRepresentation(image);
    [self.photoData writeToFile:imagePath atomically:YES];

    //    [self.photoData writeToFile:imagePath atomically:YES];
    //    UIImage *image = [UIImage imageWithData:self.photoData];

    UIImage* thumbnailsImage = [GYUtils imageCompressForWidth:image targetWidth:300];
    NSData* thumbnailsImageData = nil;
    if (UIImageJPEGRepresentation(thumbnailsImage, 1)) {
        thumbnailsImageData = UIImageJPEGRepresentation(thumbnailsImage, 1);
    }
    else {
        thumbnailsImageData = UIImagePNGRepresentation(thumbnailsImage);
    }

    NSString* thumbnailsImageName = [NSString stringWithFormat:@"thumbnailsImage%@.jpg", timeNumber];
    NSString* thumbnailsImageNamePath = [NSString pathWithComponents:@[ [[GYHDMessageCenter sharedInstance] imagefolderNameString], thumbnailsImageName ]];
    [thumbnailsImageData writeToFile:thumbnailsImageNamePath atomically:YES];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"originalName"] = imageName;
    dict[@"thumbnailsName"] = thumbnailsImageName;
    return dict;
}

/**开始录制*/
- (void)startRecordVideo
{
    //根据设备输出获得连接
    AVCaptureConnection* captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //如果支持多任务则则开始多任务
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    //预览图层和视频方向保持一致
    captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
    NSURL* fileUrl = [NSURL fileURLWithPath:self.movPath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:self.movPath error:nil];
    [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
}

/**开始录制30秒*/
- (void)startRecordVideoForDuration:(NSTimeInterval)duration
{
    if (!self.captureMovieFileOutput.recording) {
        _recordTimeCount = duration;
        _currentCecordTime = 0.0f;
        [_recordtimer invalidate];
        _recordtimer = nil;
        _recordtimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(listenRecordTime:) userInfo:nil repeats:YES];
        [self startRecordVideo];
    }
}

- (void)listenRecordTime:(NSTimer*)timer
{
    //    NSLog(@"%f", _currentCecordTime);
    _currentCecordTime++;
    if (_currentCecordTime >= _recordTimeCount) {
        [self stopRecordVideo];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(recordViewTimeInterval:)]) {
                [self.delegate recordViewTimeInterval:_currentCecordTime];
            }
        });
    }
}

/**停止录制*/
- (void)stopRecordVideo
{
    if (self.captureMovieFileOutput.recording) {
        [_recordtimer invalidate];
        _recordtimer = nil;
        [self.captureMovieFileOutput stopRecording];
    }
}

///**切换相机*/
//- (void)changeCamera {
//    // Assume the session is already running
//
//    NSArray *inputs = self.captureSession.inputs;
//    for ( AVCaptureDeviceInput *input in inputs ) {
//        AVCaptureDevice *device = input.device;
//        if ( [device hasMediaType:AVMediaTypeVideo] ) {
//            AVCaptureDevicePosition position = device.position;
//            AVCaptureDevice *newCamera = nil;
//            AVCaptureDeviceInput *newInput = nil;
//
//            if (position == AVCaptureDevicePositionFront)
//                newCamera = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
//            else
//                newCamera = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
//            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
//            [newCamera supportsAVCaptureSessionPreset:nil];
//            // beginConfiguration ensures that pending changes are not applied immediately
//            [self.captureSession beginConfiguration];
//
//            [self.captureSession removeInput:input];
//            [self.captureSession addInput:newInput];
//
//            // Changes take effect once the outermost commitConfiguration is invoked.
//            [self.captureSession commitConfiguration];
//            break;
//        }
//    }
//}
- (void)changeCamera
{
    AVCaptureDevice* currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice* toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput* toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];

    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
}

- (void)dealloc
{
    [self.captureSession stopRunning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice*)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position
{
    NSArray* cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice* camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  给输入设备添加通知
 */
- (void)addNotificationToCaptureDevice:(AVCaptureDevice*)captureDevice
{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice* captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    //捕获区域发生改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice*)captureDevice
{
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    AVCaptureDevice* captureDevice = [self.captureDeviceInput device];
    NSError* error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }
    else {
    }
}

#pragma mark - 通知
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
- (void)areaChange:(NSNotification*)notification
{
}

#pragma mark - 视频输出代理
- (void)captureOutput:(AVCaptureFileOutput*)captureOutput didStartRecordingToOutputFileAtURL:(NSURL*)fileURL fromConnections:(NSArray*)connections
{
}

- (void)captureOutput:(AVCaptureFileOutput*)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL*)outputFileURL fromConnections:(NSArray*)connections error:(NSError*)error
{

    [self mergeAndExportVideosAtFileURLs:@[ outputFileURL ]];
}

/**视频截取*/
- (void)mergeAndExportVideosAtFileURLs:(NSArray*)fileURLArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;

        CGSize renderSize = CGSizeMake(0, 0);

        NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];

        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];

        CMTime totalDuration = kCMTimeZero;

        //先去assetTrack 也为了取renderSize
        NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
        NSMutableArray *assetArray = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileURLArray) {
            AVAsset *asset = [AVAsset assetWithURL:fileURL];

            if (!asset) {
                continue;
            }

            [assetArray addObject:asset];

            AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            [assetTrackArray addObject:assetTrack];

            renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
            renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
        }

        CGFloat renderW = MIN(renderSize.width, renderSize.height);

        for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {

            AVAsset *asset = [assetArray objectAtIndex:i];
            AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];

            AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                 atTime:totalDuration
                                  error:nil];

            AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];

            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetTrack
                                 atTime:totalDuration
                                  error:&error];

            //fix orientationissue
            AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

            totalDuration = CMTimeAdd(totalDuration, asset.duration);

            CGFloat rate;
            rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);

            CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);

            CGFloat y = 160;
            layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -y));//向上移动取中部影响

            [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
            [layerInstruciton setOpacity:0.0 atTime:totalDuration];

            //data
            [layerInstructionArray addObject:layerInstruciton];
        }

        //get save path
        NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];

        NSString *mp4Name = [NSString stringWithFormat:@"%@.mp4", timeNumber];
        NSString *mp4Path = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp4folderNameString], mp4Name]];

        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", timeNumber];
        NSString *imagePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] imagefolderNameString], imageName]];

        [[self VideofristFrameData] writeToFile:imagePath atomically:YES];
        NSURL *mergeFileURL = [NSURL fileURLWithPath:mp4Path];
        self.mp4Path = mp4Path;
        //export
        AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
        mainInstruciton.layerInstructions = layerInstructionArray;
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = @[mainInstruciton];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        mainCompositionInst.renderSize = CGSizeMake(480, 320); CGSizeMake(renderW, renderW);

        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
        exporter.videoComposition = mainCompositionInst;
        exporter.outputURL = mergeFileURL;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{

            dispatch_async(dispatch_get_main_queue(), ^{

//                if ([self.delegate respondsToSelector:@selector(GYHDRecordVideoTool:mp4Path:VideofristFramePath:)]) {
//                    [self.delegate GYHDRecordVideoTool:self mp4Path:mp4Path VideofristFramePath:imagePath];
//                }
                if ([self.delegate respondsToSelector:@selector(GYHDRecordVideoTool:sendDict:)]) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"mp4Name"] = mp4Name;
                    dict[@"thumbnailsName"] = imageName;

                    [self.delegate GYHDRecordVideoTool:self sendDict:dict];
                }

            });
        }];
    });
}

- (NSString*)mp4pathString;
{
    return self.mp4Path;
}

- (void)playRecordVideoWithView:(UIView*)view Data:(NSData*)data
{
    NSString* urlStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/playerMp4.mp4"];
    [data writeToFile:urlStr atomically:YES];
    NSURL* movieUrl = [NSURL fileURLWithPath:urlStr];
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:movieUrl];
    self.playerRecordVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];

    AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.playerRecordVideo];
    playerLayer.frame = view.bounds;
    [view.layer addSublayer:playerLayer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerRecordVideo.currentItem];
}

- (void)playVideoWithView:(UIView*)view Url:(NSURL*)url
{

    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url];
    self.playerRecordVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];

    AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.playerRecordVideo];
    playerLayer.frame = view.bounds;
    [view.layer addSublayer:playerLayer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerRecordVideo.currentItem];
}

/**暂停*/
- (void)pauseVideo
{
    if (self.playerRecordVideo.rate != 0) {
        [self.playerRecordVideo pause];
    }
}

/**播放*/
- (void)playerVideo
{
    if (self.playerRecordVideo.rate == 0) {
        [self.playerRecordVideo play];
    }
}

- (NSData*)movData
{
    return [NSData dataWithContentsOfFile:self.movPath];
}

/**视频第一帧*/
- (NSData*)VideofristFrameData
{
    AVURLAsset* asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.movPath] options:nil];
    AVAssetImageGenerator* gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:nil error:nil];
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(image, CGRectMake(0, 160, 240, 160));
    UIImage* retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(image);
    UIImage* maskImage = [UIImage imageNamed:@"gyhd_video_play_Image_bg"];
    UIGraphicsBeginImageContext(retImg.size);
    [retImg drawInRect:CGRectMake(0, 0, retImg.size.width, retImg.size.height)];

    //四个参数为水印图片的位置
    [maskImage drawInRect:CGRectMake((240 / 2) - (58 / 2), (160 / 2) - (58 / 2), 58.5, 58.5f)];
    UIImage* resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return UIImagePNGRepresentation(resultingImage);
}

- (NSData*)mp4Data
{
    return [NSData dataWithContentsOfFile:self.mp4Path];
}

- (NSData*)imageData
{
    return self.photoData;
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
- (void)playbackFinished:(NSNotification*)notification
{

    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [self.playerRecordVideo seekToTime:kCMTimeZero];
    [self.playerRecordVideo.currentItem seekToTime:kCMTimeZero];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self playerVideo];
    });
}

+ (BOOL)CameraAvailable
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        return NO;
    return YES;
}

- (UIImage*)fixOrientation:(UIImage*)aImage
{

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        break;

    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;

    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        break;
    default:
        break;
    }

    switch (aImage.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;

    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
    default:
        break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
        CGImageGetBitsPerComponent(aImage.CGImage), 0,
        CGImageGetColorSpace(aImage.CGImage),
        CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        // Grr...
        CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
        break;

    default:
        CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
        break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage* img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

//                if ([self.delegate respondsToSelector:@selector(GYHDRecordVideoTool:mp4Path:)]) {
//                    [self.delegate GYHDRecordVideoTool:self mp4Path:mp4Path];
//                }
//                if ([self.delegate respondsToSelector:@selector(recordFishWithMp4Data:)]) {
//
//                    [self.delegate recordFishWithMp4Data:[NSData dataWithContentsOfFile:self.mp4Path]];
//                }
///**
// * mov 转MP4
// */
//- (void)videoUrl:(NSString *)movFilePath toMP4:(NSString *)mp4FilePath
//{
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:movFilePath] options:nil];
//    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//    if ([compatiblePresets containsObject:AVAssetExportPreset640x480])
//    {
//        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
//        [[NSFileManager defaultManager] removeItemAtPath:mp4FilePath error:nil];
//        exportSession.outputURL = [NSURL fileURLWithPath:mp4FilePath];
//        exportSession.outputFileType = AVFileTypeMPEG4;
//        // 是否对网络进行优化
//        exportSession.shouldOptimizeForNetworkUse = true;
//        [exportSession exportAsynchronouslyWithCompletionHandler:^{
//            // 如果导出的状态为完成
//            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
//                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.mp4Path)) {
//                    //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//                    UISaveVideoAtPathToSavedPhotosAlbum(self.mp4Path, nil, nil, nil);//保存视频到相簿
//                }
//            }
//        }];
//    }
//}
//视频录入完成之后在后台将视频存储到相簿

//    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier=self.backgroundTaskIdentifier;
//    self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
//
//            layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
//

//    [self videoUrl:self.movPath toMP4:self.mp4Path];
//    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
//        if (error) {
//            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
//        }
//        NSLog(@"outputUrl:%@",outputFileURL);
//        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
//        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
//            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
//        }
//        NSLog(@"成功保存视频到相簿.");
//    }];

//            CGFloat y = (kScreenHeight / 2)  - ((kScreenWidth *3 / 4) / 2) - 30;

//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mp4Path)) {
//                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//                UISaveVideoAtPathToSavedPhotosAlbum(mp4Path, nil, nil, nil);//保存视频到相簿
//            }
//            UIImage *image =  [UIImage imageWithContentsOfFile:imagePath];
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.movPath)) {
//                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//                UISaveVideoAtPathToSavedPhotosAlbum(self.movPath, nil, nil, nil);//保存视频到相簿
//            }