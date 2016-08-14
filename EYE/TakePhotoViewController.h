//
//  TakePhotoViewController.h
//  EYE
//
//  Created by Evren Yortuçboylu on 15/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>

@interface

TakePhotoViewController : ViewController<CvPhotoCameraDelegate> {
    CvPhotoCamera* photoCamera;
    UIImageView* resultView;
    int photoCount;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(UIButton *)sender;

@end
