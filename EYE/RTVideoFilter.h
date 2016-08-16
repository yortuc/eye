//
//  RTVideoFilter.h
//  EYE
//
//  Created by Evren Yortuçboylu on 16/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <GLKit/GLKit.h>
#import "ViewController.h"


@interface RTVideoFilter : ViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureDevice *videoDevice;
    AVCaptureSession *captureSession;
    dispatch_queue_t captureSessionQueue;
    
    GLKView *videoPreviewView;
    EAGLContext *eaglContext;
    CGRect videoPreviewBounds;
    CIContext *ciContext;
}


- (IBAction)startCamera:(UIButton *)sender;

@end
