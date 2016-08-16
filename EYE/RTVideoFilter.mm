//
//  RTVideoFilter.m
//  EYE
//
//  Created by Evren Yortuçboylu on 16/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import "RTVideoFilter.h"
#import "AppDelegate.h"

@implementation RTVideoFilter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // setup GLKView
    UIView *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    eaglContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
    videoPreviewView = [[GLKView alloc] initWithFrame:window.bounds context:eaglContext];
    videoPreviewView.enableSetNeedsDisplay = NO;
    
    // make portrait
    videoPreviewView.transform = CGAffineTransformMakeRotation(M_PI_2);
    videoPreviewView.frame = window.bounds;
    
    [window addSubview: videoPreviewView];
    [window sendSubviewToBack: videoPreviewView];
    [videoPreviewView bindDrawable];
    
    videoPreviewBounds = CGRectZero;
    videoPreviewBounds.size.width = videoPreviewView.drawableWidth;
    videoPreviewBounds.size.height = videoPreviewView.drawableHeight;
    
    // create ci context
    ciContext = [CIContext
                 contextWithEAGLContext:eaglContext
                 options: @{ kCIContextWorkingColorSpace: [NSNull null] }];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    // camera output to ciimage
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *sourceImage = [CIImage imageWithCVPixelBuffer: (CVPixelBufferRef)imageBuffer options: nil];
    CGRect sourceExtent = sourceImage.extent;
    
    // display ciimage
    CGFloat sourceAspect = sourceExtent.size.width / sourceExtent.size.height;
    CGFloat previewAspect = videoPreviewBounds.size.width / videoPreviewBounds.size.height;
    
    // filter image
    CIFilter *vignetteFilter = [CIFilter filterWithName:@"CIVignetteEffect"];
    [vignetteFilter setValue:sourceImage forKey:kCIInputImageKey];
    [vignetteFilter setValue:[CIVector vectorWithX:sourceExtent.size.width/2 Y:sourceExtent.size.height/2] forKey:kCIInputCenterKey];
    [vignetteFilter setValue: @(sourceExtent.size.width/2) forKey: kCIInputRadiusKey];
    CIImage *filteredImage = [vignetteFilter outputImage];
    
    
    CIFilter *effectFilter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    [effectFilter setValue: filteredImage forKey:kCIInputImageKey];
    filteredImage = [effectFilter outputImage];
    
    
    // maintain video aspect ratio
    CGRect drawRect = sourceExtent;
    if (sourceAspect > previewAspect) {
        // use full height of the video and center crop the width
        drawRect.origin.x += (drawRect.size.width - drawRect.size.height * previewAspect) / 2.0;
        drawRect.size.width = drawRect.size.height * previewAspect;
    }
    else{
        // use full width of the video image, and center crop the height
        drawRect.origin.y += (drawRect.size.height - drawRect.size.width / previewAspect) / 2.0;
        drawRect.size.height = drawRect.size.width / previewAspect;
    }
    
    [videoPreviewView bindDrawable];
    
    if (eaglContext != [EAGLContext currentContext]){
        [EAGLContext setCurrentContext: eaglContext];
    }
    
    // clear eaglview to gray
    glClearColor(0.5, 0.5, 0.5, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // set blend mode to "source over" so that CI will use that
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    if (sourceImage) {
        [ciContext drawImage: filteredImage inRect:videoPreviewBounds fromRect:drawRect];
    }
    
    [videoPreviewView display];
}

//- (CIImage *)filterSephia:(CIImage *)source {
//
//}


- (IBAction)startCamera:(UIButton *)sender {
    
    // get cameras
    NSArray* videoDevices = [AVCaptureDevice devicesWithMediaType: AVMediaTypeVideo];
 
    // back camera position
    AVCaptureDevicePosition position = AVCaptureDevicePositionBack;
    
    // find back camera
    for(AVCaptureDevice *device in videoDevices){
        if (device.position == position) {
            videoDevice = device;
            
            NSLog(@"found back camera");
        }
    }
    
    // start camera
    NSError *error = nil;
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput
                                              deviceInputWithDevice:videoDevice
                                              error: &error];
    
    if (!videoDeviceInput) {
        NSLog(@"cant start camera");
    }
    
    // capture session
    captureSession = [[AVCaptureSession alloc] init];
    captureSession.sessionPreset =AVCaptureSessionPresetMedium;
    
    // output should be BGRA to use in CoreImage
    NSDictionary *outputSettings = @{
                                     (id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInteger: kCVPixelFormatType_32BGRA]
                                     };
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    videoDataOutput.videoSettings = outputSettings;
    
    // delegate output via sessionQueue
    captureSessionQueue = dispatch_queue_create("capture_session_queue", NULL);
    [videoDataOutput setSampleBufferDelegate:self queue:captureSessionQueue];
    videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // conf and begin capture session
    [captureSession beginConfiguration];
    
    if(![captureSession canAddOutput: videoDataOutput]) {
        captureSession = nil;
        return;
    }
    
    [captureSession addInput: videoDeviceInput];
    [captureSession addOutput: videoDataOutput];
    [captureSession commitConfiguration];
    [captureSession startRunning];
}
@end
