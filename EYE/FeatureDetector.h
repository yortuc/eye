//
//  FeatureDetector.h
//  EYE
//
//  Created by Evren Yortuçboylu on 14/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@interface FeatureDetector : NSObject

+(UIImage *) detectFeature: (UIImage*)image withDetectorName: (NSString* ) detectorName;

@end
