//
//  ImageRecognizer.h
//  Document Scanner
//
//  Created by CoDesign on 8/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <TesseractOCR/TesseractOCR.h>

@interface ImageRecognizer : NSObject

+(ImageRecognizer *)sharedRecognizer;

-(void)recognizeImage:(UIImage *)image completion:(void (^) (NSString* result))completion;
                                                          
@end
