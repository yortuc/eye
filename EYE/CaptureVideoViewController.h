//
//  CaptureVideoViewController.h
//  EYE
//
//  Created by Evren Yortuçboylu on 15/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>

@interface CaptureVideoViewController : ViewController<CvVideoCameraDelegate> {
    CvVideoCamera* videoCamera;
    BOOL isCapturing;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)record:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;


@end
