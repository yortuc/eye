//
//  TakePhotoViewController.m
//  EYE
//
//  Created by Evren Yortuçboylu on 15/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import "TakePhotoViewController.h"


@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    photoCamera = [[CvPhotoCamera alloc] initWithParentView: _imageView];
    photoCamera.delegate = self;
    photoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    photoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetPhoto;            // largest possible resolution
    photoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    
    [photoCamera start];
    
    photoCount = 0;
}

- (void)photoCamera:(CvPhotoCamera *)photoCamera capturedImage:(UIImage *)image {
    
    NSLog(@"photo taken");
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + photoCount * 100, 50, 100, 100)];
    imgView.image = image;
    
    [self.view addSubview:imgView];
    
    photoCount++;
}

- (void)photoCameraCancel:(CvPhotoCamera *)photoCamera {
    //
}

- (IBAction)takePhoto:(UIButton *)sender {
    [photoCamera takePicture];
    
    NSLog(@"taking picture");
}
@end
