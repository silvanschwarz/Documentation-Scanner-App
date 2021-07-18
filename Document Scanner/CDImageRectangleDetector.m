//
//  CDImageRectangleDetector.m
//  Document Scanner
//
//  Created by CoDesign on 7/23/15.
//  Copyright (c) 2015 codesign2015. All rights reserved.
//


#import "CDImageRectangleDetector.h"

@implementation CDImageRectangleDetector


-(id)init{
    
    self = [super init];
    if (self) {
        
        
    }
    
    return self;
}

+(CDImageRectangleDetector *)sharedDetector{

    static CDImageRectangleDetector *sharedInstance = nil;
    
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    
    return sharedInstance;
}

- (CIDetector *)highAccuracyRectangleDetector
{
    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
                  });
    return detector;
}


- (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles
{
    if (![rectangles count]) return nil;
    
    float halfPerimiterValue = 0;
    
    CIRectangleFeature *biggestRectangle = [rectangles firstObject];
    
    for (CIRectangleFeature *rect in rectangles)
    {
        CGPoint p1 = rect.topLeft;
        CGPoint p2 = rect.topRight;
        CGFloat width = hypotf(p1.x - p2.x, p1.y - p2.y);
        
        CGPoint p3 = rect.topLeft;
        CGPoint p4 = rect.bottomLeft;
        CGFloat height = hypotf(p3.x - p4.x, p3.y - p4.y);
        
        CGFloat currentHalfPerimiterValue = height + width;
        
        if (halfPerimiterValue < currentHalfPerimiterValue)
        {
            halfPerimiterValue = currentHalfPerimiterValue;
            biggestRectangle = rect;
        }
    }
    
    return biggestRectangle;
}

- (CIImage *)drawHighlightOverlayForPoints:(CIImage *)image topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight
{
    
    CIImage* overlay = [CIImage imageWithColor:[CIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:0.6]];
    overlay = [overlay imageByCroppingToRect:image.extent];
    overlay = [overlay imageByApplyingFilter:@"CIPerspectiveTransformWithExtent" withInputParameters:@{@"inputExtent":[CIVector vectorWithCGRect:image.extent],
                                                                                                       @"inputTopLeft":[CIVector vectorWithCGPoint:topLeft],
                                                                                                       @"inputTopRight":[CIVector vectorWithCGPoint:topRight],
                                                                                                       @"inputBottomLeft":[CIVector vectorWithCGPoint:bottomLeft],
                                                                                                       @"inputBottomRight":[CIVector vectorWithCGPoint:bottomRight]}];

    return [overlay imageByCompositingOverImage:image];
}

-(UIImage *)imageFilter:(UIImage *) image type:(ImageFilterType)type{
    
    switch (type) {
        case ImageFilterTypeGrayScale:
            
            return [self filteredImageWithImage:image brithtness:0.0 contrast:1.0 saturaction:0.0];
            
            break;
            
        case ImageFilterTypeBlackAndWhite:
            
            return [self filteredImageWithImage:image brithtness:0.0 contrast:2.0 saturaction:0.0];
            
            break;
            
        default:
            return [self filteredImageWithImage:image brithtness:0.0 contrast:1.0 saturaction:1.0];
            
            break;
    }
    
}

-(UIImage *)filteredImageWithImage:(UIImage *)image brithtness:(float)britntness contrast:(float)contrast saturaction:(float)saturaction{
    
    CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage,
                              @"inputBrightness", [NSNumber numberWithFloat:britntness],
                              @"inputContrast", [NSNumber numberWithFloat:contrast],
                              @"inputSaturation", [NSNumber numberWithFloat:saturaction], nil].outputImage;
    
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    //UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(cgiimage);

    return newImage;
}

- (UIImage *)rotatedImageWithDegree:(double)degree image:(UIImage *)image{
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degree * M_PI / 180.0);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degree * M_PI/ 180.0));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}





@end
