//
//  ShareViewController.h
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@import GoogleMobileAds;


@interface ShareViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,GADInterstitialDelegate>{
    
    UIView* _headerView;
    UITableView* _shareListView;
    UIImageView* _thumbnailImageView;
    
    NSArray* _contentArray;
    
    NSLayoutConstraint* _bannerHeight;
}
@property(nonatomic, strong) UIImage* savedImage;
@property(nonatomic,strong) GADInterstitial* interstitial;
@property(nonatomic, strong) GADBannerView* bannerView;
@end
