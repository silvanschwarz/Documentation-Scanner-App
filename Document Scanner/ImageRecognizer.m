//
//  ImageRecognizer.m
//  Document Scanner
//
//  Created by CoDesign on 8/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//

#import "ImageRecognizer.h"
#import "DefaultValues.h"

@implementation ImageRecognizer


-(id)init{
    
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

+(ImageRecognizer *)sharedRecognizer{
    
    static ImageRecognizer *sharedInstance = nil;
    
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    
    return sharedInstance;
}

-(void)recognizeImage:(UIImage *)image completion:(void (^)(NSString *))completion{
    
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] init];

    operation.tesseract.engineMode = G8OCREngineModeCubeOnly;
    operation.tesseract.language = [DefaultValues languageToRecognize];
    
//    operation.tesseract.charWhitelist =  @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,./!?:#()[]"; //whitelist allows character to recognize
    operation.tesseract.charBlacklist = @"!@#$%^&*()<>/';:\"][{}\\|_-'"; //blacklist passes character to recognize
    operation.tesseract.image = [image g8_blackAndWhite]; //converting image to g8_blackAndWhite type is getting better to recognize
    
    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
        // Retrieve the recognized text upon completion
        completion([recognizedTesseract recognizedText]);
    };
    
    // Add operation to queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

@end
