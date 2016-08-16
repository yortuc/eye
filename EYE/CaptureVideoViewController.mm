//
//  CaptureVideoViewController.m
//  EYE
//
//  Created by Evren Yortuçboylu on 15/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import "CaptureVideoViewController.h"

@implementation CaptureVideoViewController

- (void)processImage:(cv::Mat &)image {
    //
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isCapturing = NO;
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView: _imageView];
    videoCamera.delegate = self;
    
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    videoCamera.defaultFPS = 30;
    
    videoCamera.recordVideo = YES;
    
    NSLog(@"camera is set");
}

- (IBAction)record:(UIButton *)sender {
    NSLog(@"record response");
    
    if(isCapturing) {
        [videoCamera stop];
        isCapturing = false;
        
        NSString* relativePath = [videoCamera.videoFileURL relativePath];
        UISaveVideoAtPathToSavedPhotosAlbum(relativePath, nil, NULL, NULL);
        
        NSLog(@"video saved");
    }
    else {
        [videoCamera start];
        isCapturing = YES;
        
        NSLog(@"record started");

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // shut down the camera before app exits
    
    [super viewWillDisappear:animated];
    
    if(isCapturing){
        [videoCamera stop];
    }
}

@end
