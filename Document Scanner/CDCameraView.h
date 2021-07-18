//
//  CDCameraView.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropperConstantValues.h"

#import "CDImageRectangleDetector.h"
#import "CDCameraOverlayView.h"

typedef NS_ENUM(NSInteger,CDCameraViewType)
{
    CDCameraViewTypeGray,
    CDCameraViewTypeColorful,
    CDCameraViewTypeSepiaTone
};

@interface CDCameraView : UIView{
    
    CDCameraOverlayView* _cameraOverlayView;
}

- (void)initializeCameraScreen;

- (void)start;
- (void)stop;

@property (nonatomic,assign,getter=isBorderDetectionEnabled) BOOL enableBorderDetection;
@property (nonatomic,assign) CDCameraViewType cameraViewType;

- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)())completionHandler;

-(void)setCaptureFlashType:(BOOL )isOn;

- (void)captureImageWithCompletionHander:(void(^)(id data))completionHandler;

@end
