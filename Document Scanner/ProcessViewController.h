//
//  ProcessViewController.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDImageRectangleDetector.h"
#import "CropViewController.h"

@interface ProcessViewController : UIViewController<UIActionSheetDelegate, UIAlertViewDelegate,CropDelegate>{
    
    UIImageView* _imageViewer;
    
    UIView* _headerView;
    UIView* _footerView;
    
    UIButton* _editBtn;
    UIButton* _saveBtn;
    UIButton* _deleteBtn;
    
    UIButton* _cancelBtn;
    UIButton* _cropBtn;
    UIButton* _rotateBtn;
    UIButton* _filterBtn;
    UIButton* _doneBtn;
    
    UIView* _filterView;
    
    UIImage* _editedImage;
    CGFloat _rotatedDegree;
    ImageFilterType _filterType;
    
    CDImageRectangleDetector * _sharedHelper;
}

@property(nonatomic, strong) UIImage* orignalImage;
@property(nonatomic, strong) UIImage* croppedImage;

@end
