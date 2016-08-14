//
//  ViewController.m
//  EYE
//
//  Created by Evren Yortuçboylu on 14/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

#import "ViewController.h"
#import "FeatureDetector.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage* image = [UIImage imageNamed: @"taylor"];
    
    image = [FeatureDetector detectFeature:image withDetectorName: @"haarcascade_frontalface_alt2"];
    
    image = [FeatureDetector detectFeature:image withDetectorName: @"eyes_45_11"];
    
    image = [FeatureDetector detectFeature:image withDetectorName: @"haarcascade_mcs_nose"];
    
    self.imageView.image = image;
}

@end
