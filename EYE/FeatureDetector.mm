//
//  FeatureDetector.m
//  EYE
//
//  Created by Evren Yortuçboylu on 14/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import "FeatureDetector.h"

@implementation FeatureDetector

+(UIImage*) detectFeature:(UIImage*)image withDetectorName: (NSString *) detectorName{
    
    cv::CascadeClassifier faceDetector;

    // load cascade classifier file
    
    NSString* cascadePath = [[NSBundle mainBundle]
                             pathForResource: detectorName
                             ofType:@"xml"];
    
    faceDetector.load([cascadePath UTF8String]);
    
    // convert to mat
    cv::Mat faceMat;
    UIImageToMat(image, faceMat);
    
    // convert grayscale
    cv::Mat grayMat;
    cv::cvtColor(faceMat, grayMat, CV_BGR2GRAY);
    
    // detect features
    std::vector<cv::Rect> faces;
    
    faceDetector.detectMultiScale(grayMat, faces, 1.1,
                                  2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30,30));
    
    // draw detected features
    for(unsigned int i = 0; i < faces.size(); i++){
        const cv::Rect& face = faces[i];
        
        // get top-left, bottom-right coordinates
        cv::Point tl(face.x, face.y);
        cv::Point br = tl + cv::Point(face.width, face.height);
        
        // draw rect around face
        cv::Scalar magenta = cv::Scalar(0, 0, 0);
        cv::rectangle(faceMat, tl, br, magenta, 4);
    }
    
    // show result
    return MatToUIImage(faceMat);
}


@end
