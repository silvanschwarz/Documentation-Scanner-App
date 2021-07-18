//
//  CropperConstantValues.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "CropperConstantValues.h"

@implementation CropperConstantValues


+(UIColor *)themeColor{
    
    return [UIColor colorWithRed:43.0/255.0 green:106.0/255.0 blue:221.0/255.0 alpha:1.0f];
}

+(UIColor *)standartBackgroundColor{
    
    return [UIColor blackColor];
}

+(UIColor *)doneButtonColor{
    
    return [UIColor colorWithRed:255.0/255.0 green:194.0/255.0 blue:24.0/255.0 alpha:1.0f];
}
+(CGFloat)pictureSelectorHeaderViewHeight{
    
    return 64.0f;
}

+(CGFloat)pictureSelectorFooterViewHeight{
    
    return 74.0f;
}

+(CGFloat)processFooterViewHeight{
    
    return 49.0f;
}

+(BOOL)canRectangleDetect{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) return YES;
    else return NO;
}
@end
