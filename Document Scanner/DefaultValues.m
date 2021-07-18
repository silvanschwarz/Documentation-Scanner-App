//
//  DefaultValues.m
//  Document Scanner
//
//  Created by CoDesign on 8/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "DefaultValues.h"


@implementation DefaultValues

+(NSString *)languageToRecognize{
    
    return @"eng";
//    return @"jpn+kor+ita+eng+por+rus+chi";
//    return @"chi_sim+jpn+kor+ita+eng+por+rus";
}

+(NSArray *)adsenseTestDevices{
    
    return @[kGADSimulatorID];
}
+(BOOL)isAdmobActive{
    
    return NO;
}
@end
