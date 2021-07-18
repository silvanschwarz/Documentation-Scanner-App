//
//  PictureSelectorViewController.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropperConstantValues.h"
#import "CropViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "FlashButton.h"

#import "CDCameraView.h"

@interface PictureSelectorViewController : UIViewController<UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropDelegate>{
    
    UIImage* _selectedImage;
    
    UIView* _headerView;
    UIButton* cameraRollBtn;

    FlashButton* _flashButton;
    UIView* _footerView;
    
    UIView* _contentView;
    CDCameraOverlayView* _cameraOverlayView;
}
@property (strong, nonatomic) CDCameraView *cameraViewController;
@property (nonatomic, strong) UIImageView* focusImageView;

@property(nonatomic,strong)UIImagePickerController *picker;

@end
