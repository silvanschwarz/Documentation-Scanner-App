//
//  CropViewController.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDImageRectangleDetector.h"
#import "CDZoomView.h"
#import "CDOverlayView.h"

@class CropViewController;

@protocol CropDelegate <NSObject>

-(void)cropperViewdidCropped:(UIImage *)croppedImage cropVC:(CropViewController *)cropVC;

@end

@interface CropViewController : UIViewController{
    
    CIImage* croppedImage;
    UIImageView* _detectedImage;
    
    UIView* _headerView;
    UIView* _footerView;
    
    UIButton* _magnetButton;
    BOOL _magnetEnabled;
    
    CDOverlayView* _overlayView;
    CIRectangleFeature *_detectedRectangleFeature;
    CDImageRectangleDetector* _sharedDetector;
    
    CGFloat _rotatedDegree;
}

@property(nonatomic, strong) UIImage* originalImage;
@property(nonatomic, weak) id<CropDelegate> delegate;

@end
