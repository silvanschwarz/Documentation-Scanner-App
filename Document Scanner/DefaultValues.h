//
//  DefaultValues.h
//  Document Scanner
//
//  Created by CoDesign on 8/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAdmobAdsenseFullScreenUnitID @"ca-app-pub-6667938037156432/7343395106"
#define kAdmobAdsenseBannerUnitID @"ca-app-pub-6667938037156432/4529529509"

@import GoogleMobileAds;

@interface DefaultValues : NSObject

+(NSString *)languageToRecognize;
+(NSArray *)adsenseTestDevices;
+(BOOL)isAdmobActive;


@end
