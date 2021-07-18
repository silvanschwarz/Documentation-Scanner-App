//
//  OCRViewController.h
//  Document Scanner
//
//  Created by CoDesign on 8/25/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@import GoogleMobileAds;

@interface OCRViewController : UIViewController{
    
    UIView* _headerView;
    UITextView* _resultView;
    UIButton* _shareButton;
    
    NSLayoutConstraint* _resultBtm;
    NSLayoutConstraint* _bannerHeight;
}
@property(nonatomic, strong) GADBannerView* bannerView;
@property(nonatomic, strong) UIImage* rawImage;

@end
